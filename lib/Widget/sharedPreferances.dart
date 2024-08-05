//=======================  Shared Preference List ==============================
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Localization/Language_Constant.dart';
import '../Provider/settingProvider.dart';
import 'parameterString.dart';

Future<String?> getPrefrence(String key) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString(key);
}

setPrefrence(String key, String value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString(key, value);
}

//1. for Login -----------------------------------------------------------------
setPrefrenceBool(String key, bool value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setBool(key, value);
}

Future<bool> getPrefrenceBool(String key) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getBool(key) ?? false;
}

Future<void> saveUserDetail(
  String userId,
  String name,
  String mobile,
  String? token,
) async {
  final waitList = <Future<void>>[];
  SharedPreferences prefs = await SharedPreferences.getInstance();
  waitList.add(prefs.setString(Id, userId));
  waitList.add(prefs.setString(Username, name));
  waitList.add(prefs.setString(Mobile, mobile));
  if (token != null) {
    waitList.add(prefs.setString(TOKEN, token));
  }
  await Future.wait(waitList);
}

Future<void> clearUserSession(BuildContext context) async {
  final waitList = <Future<void>>[];

  SharedPreferences prefs = await SharedPreferences.getInstance();

  String? getLanguage = await getPrefrence(LAGUAGE_CODE);

  waitList.add(prefs.remove(Id));
  waitList.add(prefs.remove(Mobile));
  waitList.add(prefs.remove(EmailText));
  context.read<SettingProvider>().CUR_USERID = '';
  CUR_USERNAME = "";

  await prefs.clear();

  setPrefrence(LAGUAGE_CODE, getLanguage!);
}
