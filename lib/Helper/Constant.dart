// add your constant file's

//Your application title
import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:external_path/external_path.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sellermultivendor/Helper/Color.dart';
import 'package:sellermultivendor/Screen/conversationListScreen.dart';
import 'package:sellermultivendor/Screen/conversationScreen.dart';
import 'package:sellermultivendor/Widget/validation.dart';

const String title = 'DsiStars Multi-Vendor - Seller';

//Your application name
const String appName = 'Seller App DsiStars';

//please add your panel's API base URL here (you can find from settings->client APIs)
const String baseUrl = 'https://admin.dsistars.com/seller/app/v1/api/'; //demo
const String chatBaseUrl =
    'https://admin.dsistars.com/seller/app/v1/Chat_Api/'; //demo

//this is for codecanyon demo mode, please do not change
const bool isDemoApp = false;

//Your package name
const String packageName = 'wrteam.seller.multivendor';
const String iosPackage = 'wrteam.seller.multivendor';

//Set labguage
String defaultLanguage = 'en';

//Set country code
String defaultCountryCode = 'IN';

const double allowableTotalFileSizesInChatMediaInMB = 15.0;

//Time settings
const int timeOut = 50;

//loading page value
const int perPage = 10;

//Bank detail hint text
const String BANK_DETAIL = 'Bank Details:';

//Radius
const double circularBorderRadius3 = 3;
const double circularBorderRadius5 = 5;
const double circularBorderRadius7 = 7;
const double circularBorderRadius8 = 8;
const double circularBorderRadius10 = 10;
const double circularBorderRadius12 = 12;
const double circularBorderRadius13 = 13;
const double circularBorderRadius15 = 15;
const double circularBorderRadius25 = 25;
const double circularBorderRadius30 = 30;
const double circularBorderRadius50 = 50;
const double circularBorderRadius100 = 100;

//FontSize
const double textFontSize9 = 9;
const double textFontSize10 = 10;
const double textFontSize12 = 12;
const double textFontSize13 = 13;
const double textFontSize14 = 14;
const double textFontSize15 = 15;
const double textFontSize16 = 16;
const double textFontSize18 = 18;
const double textFontSize20 = 20;
const double textFontSize23 = 23;
const double textFontSize25 = 25;
const double textFontSize30 = 30;

String personalChatLabelKey = 'PERSONAL_CHAT';

String groupChatLabelKey = 'GROUP_CHAT';

String tryAgainLabelKey = 'TRY_AGAIN';

String noMessagesKey = "noMessages";

bool isSameDay(
    {required DateTime dateTime,
    required bool takeCurrentDate,
    DateTime? givenDate}) {
  final dateToCompare = takeCurrentDate ? DateTime.now() : givenDate!;
  return (dateToCompare.day == dateTime.day) &&
      (dateToCompare.month == dateTime.month) &&
      (dateToCompare.year == dateTime.year);
}

String formatDateYYMMDD({required DateTime dateTime}) {
  return "${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}";
}

String formatDate(DateTime dateTime) {
  return "${dateTime.day.toString().padLeft(2, '0')}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.year}";
}

GlobalKey<ConversationScreenState> conversationScreenStateKey =
    GlobalKey<ConversationScreenState>();

GlobalKey<ConversationListScreenState> conversationListScreenStateKey =
    GlobalKey<ConversationListScreenState>();
const String messagesLoadLimit = '30';

//Key to store all queue notifications of chat messages in shared pref.
const String queueNotificationOfChatMessagesSharedPrefKey =
    'queueNotificationOfChatMessages';

Future<bool> hasStoragePermissionGiven() async {
  if (Platform.isIOS) {
    bool permissionGiven = await Permission.storage.isGranted;
    if (!permissionGiven) {
      permissionGiven = (await Permission.storage.request()).isGranted;
      return permissionGiven;
    }
    return permissionGiven;
  }
  final deviceInfoPlugin = DeviceInfoPlugin();
  final androidDeviceInfo = await deviceInfoPlugin.androidInfo;
  if (androidDeviceInfo.version.sdkInt < 33) {
    bool permissionGiven = await Permission.storage.isGranted;
    if (!permissionGiven) {
      permissionGiven = (await Permission.storage.request()).isGranted;
      return permissionGiven;
    }
    return permissionGiven;
  } else {
    bool permissionGiven = await Permission.photos.isGranted;
    if (!permissionGiven) {
      permissionGiven = (await Permission.photos.request()).isGranted;
      return permissionGiven;
    }
    return permissionGiven;
  }
}

Future<String> getExternalStoragePath() async {
  return Platform.isAndroid
      ? (await ExternalPath.getExternalStoragePublicDirectory(
          ExternalPath.DIRECTORY_DOWNLOADS))
      : (await getApplicationDocumentsDirectory()).path;
}

Future<String> getTempStoragePath() async {
  return (await getTemporaryDirectory()).path;
}

Future<String> checkIfFileAlreadyDownloaded(
    {required String fileName,
    required String fileExtension,
    required bool downloadedInExternalStorage}) async {
  final filePath = downloadedInExternalStorage
      ? await getExternalStoragePath()
      : await getTempStoragePath();
  final File file = File('$filePath/$fileName.$fileExtension');

  return (await file.exists()) ? file.path : '';
}

getSimpleAppBar(String title, BuildContext context,
    {Function? onTapBackButton}) {
  return AppBar(
    titleSpacing: 0,
    backgroundColor: white,
    leading: Builder(
      builder: (BuildContext context) {
        return Container(
          margin: const EdgeInsets.all(10),
          child: InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: () {
              if (onTapBackButton == null) {
                Navigator.of(context).pop();
              } else {
                onTapBackButton.call();
              }
            },
            child: const Center(
              child: Icon(
                Icons.arrow_back_ios_rounded,
                color: primary,
              ),
            ),
          ),
        );
      },
    ),
    title: Text(
      getTranslated(context, title) ?? title,
      style: const TextStyle(
        color: primary,
        fontWeight: FontWeight.normal,
        fontFamily: 'ubuntu',
      ),
    ),
  );
}
