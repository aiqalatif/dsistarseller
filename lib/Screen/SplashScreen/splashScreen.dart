import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sellermultivendor/Model/appSettingsModel.dart';
import 'package:sellermultivendor/Repository/appSettingsRepository.dart';
import 'package:sellermultivendor/Repository/getSettingRepositry.dart';
import 'package:sellermultivendor/Widget/errorContainer.dart';
import 'package:sellermultivendor/Widget/parameterString.dart';
import '../../Provider/settingProvider.dart';
import '../../Widget/desing.dart';
import '../../Widget/sharedPreferances.dart';
import '../../Widget/systemChromeSettings.dart';
import '../Authentication/Login.dart';
import '../DeshBord/dashboard.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool isError = false;
  String errorMessage = '';

  @override
  void initState() {
    SystemChromeSettings.setSystemButtomNavigationonlyTop();
    SystemChromeSettings.setSystemUIOverlayStyleWithLightBrightNessStyle();
    super.initState();
    getSettings();
  }

//==============================================================================
//============================= Build Method ===================================
  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return Scaffold(
      key: _scaffoldKey,
      body: isError
          ? Center(
              child: ErrorContainer(
                  onTapRetry: () {
                    getSettings();
                  },
                  errorMessage: errorMessage),
            )
          : Stack(
              children: <Widget>[
                Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: DesignConfiguration.back(),
                  child: Center(
                    child: Image.asset(
                     'assets/images/PNG/homelogo.png',
                      height: 250,
                      width: 150,
                    ),
                  ),
                ),
                Image.asset(
                  DesignConfiguration.setPngPath('doodle'),
                  fit: BoxFit.fill,
                  width: double.infinity,
                  height: double.infinity,
                ),
              ],
            ),
    );
  }

  getSettings() async {
    if (isError) {
      isError = false;
      setState(() {});
    }
    try {
      final data = await SystemRepository.fetchSystemSettings();
      AppSettingsRepository.appSettings = AppSettingsModel.fromMap(data);
      navigationPage();
    } catch (e) {
      isError = true;
      errorMessage = e.toString();
      setState(() {});
    }
  }

  Future<void> navigationPage() async {
    bool isFirstTime = await getPrefrenceBool(isLogin);

    if (isFirstTime) {
      Navigator.pushReplacement(
        context,
        CupertinoPageRoute(
          builder: (context) => const Dashboard(),
        ),
      );
    } else {
      Navigator.pushReplacement(
        context,
        CupertinoPageRoute(
          builder: (context) => const Login(),
        ),
      );
    }
  }

  @override
  void dispose() async {
    super.dispose();
    bool isFirstTime = await getPrefrenceBool(isLogin);
    SystemChromeSettings.setSystemButtomNavigationBarithTopAndButtom();

    if (isFirstTime) {
      SystemChromeSettings.setSystemUIOverlayStyleWithLightBrightNessStyle();
    } else {
      SystemChromeSettings.setSystemUIOverlayStyleWithDarkBrightNessStyle();
    }
  }
}
