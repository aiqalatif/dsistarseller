// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:sellermultivendor/Model/message.dart' as msg;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:sellermultivendor/Helper/Constant.dart';
import 'package:sellermultivendor/Model/personalChatHistory.dart';
import 'package:sellermultivendor/Repository/NotificationRepository.dart';
import 'package:sellermultivendor/Screen/HomePage/home.dart';
import 'package:sellermultivendor/cubits/groupConverstationsCubit.dart';
import 'package:sellermultivendor/cubits/personalConverstationsCubit.dart';
import '../Provider/settingProvider.dart';
import '../Screen/OrderDetail/OrderDetail.dart';
import '../Widget/api.dart';
import '../Widget/routes.dart';
import '../Widget/sharedPreferances.dart';
import '../Widget/parameterString.dart';

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
FirebaseMessaging messaging = FirebaseMessaging.instance;

@pragma('vm:entry-point')
Future<void> onBackgroundMessage(RemoteMessage message) async {
  if (message.data['type'].toString() == 'chat') {
    final messages = jsonDecode(message.data['message']) as List;
    NotificationRepository.addChatNotification(
        message: jsonEncode(messages.first));
  }
}

class PushNotificationService {
  final BuildContext context;

  PushNotificationService({required this.context});

  Future initialise() async {
    permission();
    messaging.getToken().then(
      (token) async {
        // SettingProvider settingProvider =
        //     Provider.of<SettingProvider>(context, listen: false);

        if (context.read<SettingProvider>().CUR_USERID != null &&
            context.read<SettingProvider>().CUR_USERID != "") {
          _registerToken(token);
        }
      },
    );
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings();
    const DarwinInitializationSettings initializationSettingsMacOS =
        DarwinInitializationSettings();
    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
      macOS: initializationSettingsMacOS,
    );

    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse:
            (NotificationResponse notificationResponse) async {
      if (notificationResponse.payload != null) {
        List<String> pay = notificationResponse.payload!.split(',');
        if (pay[0] == 'order' && pay[1] != '') {
          Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (context) => OrderDetail(
                id: pay[1],
              ),
            ),
          );
        } else if (pay[0] == 'chat') {
          String payload = notificationResponse.payload ?? "";
          payload = payload.replaceFirst("${pay[0]},", "");

          if (conversationScreenStateKey.currentState?.mounted ?? false) {
            Navigator.of(context).pop();
          }

          final message = msg.Message.fromJson(jsonDecode(payload));

          Routes.navigateToConversationScreen(
              context: context,
              isGroup: false,
              personalChatHistory: PersonalChatHistory(
                  unreadMsg: "1",
                  opponentUserId: message.fromId,
                  opponentUsername: message.sendersName,
                  image: message.picture));
        } else {
          Routes.navigateToMyApp(context);
        }
      }
    });

    FirebaseMessaging.onBackgroundMessage(onBackgroundMessage);

    FirebaseMessaging.onMessage.listen(
      (RemoteMessage message) async {
        await FirebaseMessaging.instance.getToken();
        var data = message.notification;

        var title = data?.title.toString() ?? "";
        var body = data?.body.toString() ?? "";
        var image = message.data['image'] ?? '';
        var type = '';
        var orderId = '';
        type = message.data['type'] ?? '';
        orderId = message.data['order_id'] ?? '';

        if (title.isEmpty) {
          return;
        }

        if (type == 'chat') {
          /*
              [{"id":"267","from_id":"2","to_id":"8","is_read":"1","message":"Geralt of rivia","type":"person","media":"","date_created":"2023-07-19 13:15:26","picture":"dikshita","senders_name":"dikshita","position":"right","media_files":"","text":"Geralt of rivia"}]
          */

          final messages = jsonDecode(message.data['message']) as List;

          String payload = '';
          if (messages.isNotEmpty) {
            payload = json.encode(messages.first);
          }

          if (conversationScreenStateKey.currentState?.mounted ?? false) {
            final state = conversationScreenStateKey.currentState!;
            if (state.widget.isGroup) {
            } else {

              if (messages.isNotEmpty) {
                if (state.widget.personalChatHistory?.opponentUserId! !=
                    messages.first['from_id']) {
                  generateSimpleNotication(title, body, 'chat', payload);

                  context
                      .read<PersonalConverstationsCubit>()
                      .updateUnreadMessageCounter(
                        userId: messages.first['from_id'].toString(),
                      );
                } else {
                  state.addMessage(
                      message: msg.Message.fromJson(Map.from(messages.first)));
                }
              }
            }
          } else {
            //senders_name

            generateSimpleNotication(title, body, 'chat', payload);

            //Update the unread message counter
            if (messages.isNotEmpty) {
              if (messages.first['type'] == 'person') {
                context
                    .read<PersonalConverstationsCubit>()
                    .updateUnreadMessageCounter(
                      userId: messages.first['from_id'].toString(),
                    );
              } else {
                context
                    .read<GroupConversationsCubit>()
                    .markNewMessageArrivedInGroup(
                        groupId: messages.first['to_id'].toString());
              }
            }
          }
        } else if (image != null && image != 'null' && image != '') {
          generateImageNotication(title, body, image, type, orderId);
        } else {
          generateSimpleNotication(title, body, type, orderId);
        }
      },
    );

    messaging.getInitialMessage().then((RemoteMessage? message) async {
      if (message != null) {
        var type = message.data['type'] ?? '';
        if (type == "chat") {
          //_onTapChatNotification(message: message);
        } else {
          var orderId = message.data['order_id'] ?? '';
          bool back = await getPrefrenceBool(iSFROMBACK);
          if (back) {
            if (orderId != '') {
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) => OrderDetail(
                    id: orderId,
                  ),
                ),
              );
            } else {
              Routes.navigateToMyApp(context);
            }
          }
        }
      }
    });

//==============================================================================
//========================= onMessageOpenedApp =================================
// when app is background

    FirebaseMessaging.onMessageOpenedApp.listen(
      (RemoteMessage message) async {
        var type = message.data['type'] ?? '';
        var orderId = message.data['order_id'] ?? '';

        if (type == "chat") {
          _onTapChatNotification(message: message);
        } else if (orderId != '') {
          Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (context) => OrderDetail(
                id: orderId,
              ),
            ),
          );
        } else {
          Routes.navigateToMyApp(context);
        }

        setPrefrenceBool(iSFROMBACK, false);
      },
    );
  }

  void _onTapChatNotification({required RemoteMessage message}) {
    if ((conversationScreenStateKey.currentState?.mounted) ?? false) {
      Navigator.of(context).pop();
    }
    final messages = jsonDecode(message.data['message']) as List;

    if (messages.isEmpty) {
      return;
    }

    final messageDetails =
        msg.Message.fromJson(jsonDecode(json.encode(messages.first)));

    Routes.navigateToConversationScreen(
        context: context,
        isGroup: false,
        personalChatHistory: PersonalChatHistory(
            unreadMsg: "1",
            opponentUserId: messageDetails.fromId,
            opponentUsername: messageDetails.sendersName,
            image: messageDetails.picture));
  }

  void permission() async {
    await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    // await messaging.setForegroundNotificationPresentationOptions(

    // );
  }

  void _registerToken(String? token) async {
    var parameter = {
      // 'user_id': context.read<SettingProvider>().CUR_USERID,
      FCMID: token,
    };
    apiBaseHelper.postAPICall(updateFcmApi, parameter).then(
          (getdata) async {},
          onError: (error) {},
        );
  }

  Future<String> _downloadAndSaveImage(String url, String fileName) async {
    var directory = await getApplicationDocumentsDirectory();
    var filePath = '${directory.path}/$fileName';
    var response = await get(Uri.parse(url));

    var file = File(filePath);
    await file.writeAsBytes(response.bodyBytes);
    return filePath;
  }

  Future<void> generateImageNotication(String title, String msg, String image,
      String type, String payload) async {
    var largeIconPath = await _downloadAndSaveImage(image, 'largeIcon');
    var bigPicturePath = await _downloadAndSaveImage(image, 'bigPicture');
    var bigPictureStyleInformation = BigPictureStyleInformation(
        FilePathAndroidBitmap(bigPicturePath),
        hideExpandedLargeIcon: true,
        contentTitle: title,
        htmlFormatContentTitle: true,
        summaryText: msg,
        htmlFormatSummaryText: true);
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'big text channel id', 'big text channel name',
        channelDescription: 'big text channel description',
        largeIcon: FilePathAndroidBitmap(largeIconPath),
        styleInformation: bigPictureStyleInformation);
    var platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        0, title, msg, platformChannelSpecifics,
        payload: '$type,$payload');
  }

  Future<void> generateSimpleNotication(
      String title, String msg, String type, String payload) async {
    late AndroidNotificationDetails androidPlatformChannelSpecifics =
        const AndroidNotificationDetails(
            'wrteam.seller.multivendor', //channel id
            'Local notification', //channel name
            importance: Importance.max,
            priority: Priority.high,
            ticker: 'ticker');

    DarwinNotificationDetails iosNotificationDetails =
        const DarwinNotificationDetails();

    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics, iOS: iosNotificationDetails);

    await flutterLocalNotificationsPlugin.show(
        0, title, msg, platformChannelSpecifics,
        payload: "$type,$payload"); //
  }
}
