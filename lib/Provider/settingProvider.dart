import 'package:flutter/material.dart';
import 'package:sellermultivendor/Widget/parameterString.dart';
import 'package:shared_preferences/shared_preferences.dart';

double height = 0;
double width = 0;

class SettingProvider extends ChangeNotifier {
  late SharedPreferences _sharedPreferences;

  SettingProvider(SharedPreferences sharedPreferences) {
    _sharedPreferences = sharedPreferences;
  }

  String? CUR_USERID = '';

  get currentUerID => CUR_USERID;

  String? get token => _sharedPreferences.getString(TOKEN);
}
