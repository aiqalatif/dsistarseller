import 'dart:core';
import 'package:sellermultivendor/Helper/ApiBaseHelper.dart';
import 'package:sellermultivendor/Widget/api.dart';
import 'package:sellermultivendor/Widget/parameterString.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Helper/Constant.dart';

class NotificationRepository {
  static void addChatNotification({required String message}) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    await sharedPreferences.reload();
    List<String> notificationMessages = sharedPreferences
            .getStringList(queueNotificationOfChatMessagesSharedPrefKey) ??
        List.from([]);

    notificationMessages.add(message);

    await sharedPreferences.setStringList(
        queueNotificationOfChatMessagesSharedPrefKey, notificationMessages);
  }

  static void clearChatNotifications() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    await sharedPreferences.reload();
    sharedPreferences
        .setStringList(queueNotificationOfChatMessagesSharedPrefKey, []);
  }

  static Future<List<String>> getChatNotifications() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    await sharedPreferences.reload();
    List<String> notificationMessages = sharedPreferences
            .getStringList(queueNotificationOfChatMessagesSharedPrefKey) ??
        List.from([]);
    return notificationMessages;
  }

  static Future<void> updateFcmId(
      {required String userId, required String fcmId}) async {
    var parameter = {
      // 'user_id': userId,
      FCMID: fcmId,
    };
    ApiBaseHelper().postAPICall(updateFcmApi, parameter).then(
          (getdata) async {},
          onError: (error) {},
        );
  }
}
