import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:sellermultivendor/Helper/Color.dart';
import 'package:sellermultivendor/Widget/desing.dart';
import 'package:sellermultivendor/Widget/routes.dart';
import '../../Helper/Constant.dart';
import '../../Provider/loginProvider.dart';
import '../../Widget/ButtonDesing.dart';
import '../../Provider/settingProvider.dart';
import '../../Widget/networkAvailablity.dart';
import '../../Provider/privacyProvider.dart';
import '../../Widget/systemChromeSettings.dart';
import '../../Widget/validation.dart';
import '../../Widget/noNetwork.dart';
import '../TermFeed/policys.dart';
import 'SendOtp.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> with TickerProviderStateMixin {
//==============================================================================
//============================= Variables Declaration ==========================

  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController passwordController =
      TextEditingController(text: isDemoApp ? '12345678' : "");
  FocusNode? passFocus, monoFocus = FocusNode();
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  Animation? buttonSqueezeanimation;
  final mobileController =
      TextEditingController(text: isDemoApp ? '9988776655' : "");

//==============================================================================
//============================= INIT Method ====================================
  setStateNow() {
    setState(() {});
  }

  bool isShowPass = true;

  @override
  void initState() {
    SystemChromeSettings.setSystemButtomNavigationBarithTopAndButtom();
    SystemChromeSettings.setSystemUIOverlayStyleWithDarkBrightNessStyle();
    super.initState();
    context.read<LoginProvider>().buttonController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);

    buttonSqueezeanimation = Tween(
      begin: width * 0.7,
      end: 50.0,
    ).animate(
      CurvedAnimation(
        parent: context.read<LoginProvider>().buttonController!,
        curve: const Interval(
          0.0,
          0.150,
        ),
      ),
    );
  }

//==============================================================================
//============================= For Animation ==================================

  Future<void> _playAnimation() async {
    try {
      await context.read<LoginProvider>().buttonController!.forward();
    } on TickerCanceled {}
  }

  void validateAndSubmit() async {
    if (validateAndSave()) {
      _playAnimation();
      checkNetwork();
    }
  }

//==============================================================================
//============================= Network Checking ===============================

  Future<void> checkNetwork() async {
    isNetworkAvail = await isNetworkAvailable();
    if (isNetworkAvail) {
      context.read<LoginProvider>().getLoginUser(
            context,
            scaffoldMessengerKey,
            setStateNow,
          );
    } else {
      Future.delayed(const Duration(seconds: 2)).then(
        (_) async {
          await context.read<LoginProvider>().buttonController!.reverse();
          setState(
            () {
              isNetworkAvail = false;
            },
          );
        },
      );
    }
  }

  bool validateAndSave() {
    final form = _formkey.currentState!;
    form.save();
    if (form.validate()) {
      return true;
    }
    return false;
  }

//==============================================================================
//============================= Dispose Method =================================

  @override
  void dispose() {
    SystemChromeSettings.setSystemButtomNavigationBarithTopAndButtom();
    SystemChromeSettings.setSystemUIOverlayStyleWithLightBrightNessStyle();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<LoginProvider>().buttonController!.dispose();
      }
    });
    super.dispose();
  }

//==============================================================================
//============================= No Internet Widget =============================
  setStateNoInternate() async {
    _playAnimation();

    Future.delayed(const Duration(seconds: 2)).then(
      (_) async {
        isNetworkAvail = await isNetworkAvailable();
        if (isNetworkAvail) {
          Navigator.pushReplacement(
            context,
            CupertinoPageRoute(builder: (BuildContext context) => super.widget),
          );
        } else {
          await context.read<LoginProvider>().buttonController!.reverse();
          setState(
            () {},
          );
        }
      },
    );
  }

//==============================================================================
//============================= Term And Policy ================================

  termAndPolicyTxt() {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 3.0,
        left: 25.0,
        right: 25.0,
        top: 20.0,
      ),
      child: Center(
        child: RichText(
                            text: TextSpan(
        text: '    ${getTranslated(context, "CONTINUE_AGREE_LBL")}',
        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            color: black,
                            fontWeight: FontWeight.normal,
                          ),
        children: [
          TextSpan(
            text:
                "\n${getTranslated(context, 'TERMS_SERVICE_LBL')}",
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
            color: black,
            decoration: TextDecoration.underline,
            fontWeight: FontWeight.normal),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (context) =>
                ChangeNotifierProvider<SystemProvider>(
              create: (context) => SystemProvider(),
              child: Policy(
                title: getTranslated(context, "TERM_CONDITIONS")!,
              ),
            ),
          ),
        );
              },
          ),
          TextSpan(
            text: "  ${getTranslated(context, 'AND_LBL')}  ",
            style: Theme.of(context)
        .textTheme
        .bodySmall!
        .copyWith(color: black, fontWeight: FontWeight.normal),
                        ),
          
          TextSpan(
              text: getTranslated(context, "PRIVACYPOLICY"),
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
            color: black,
            decoration: TextDecoration.underline,
            fontWeight: FontWeight.normal),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (context) =>
              ChangeNotifierProvider<SystemProvider>(
            create: (context) => SystemProvider(),
            child: Policy(
              title: getTranslated(context, "PRIVACYPOLICY")!,
            ),
          ),
        ),
                            );
                }),
        ],
                            ),
                          ),
      ),
             
      // child: Column(
      //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //   children: [
      //     Text(
      //       getTranslated(context, "CONTINUE_AGREE_LBL")!,
      //       style: Theme.of(context).textTheme.bodySmall!.copyWith(
      //             color: fontColor,
      //             fontWeight: FontWeight.normal,
      //           ),
      //     ),
      //     const SizedBox(
      //       height: 3.0,
      //     ),
      //     Row(
      //       mainAxisAlignment: MainAxisAlignment.center,
      //       children: [
      //         InkWell(
      //             onTap: () {
      //               Navigator.push(
      //                 context,
      //                 CupertinoPageRoute(
      //                   builder: (context) =>
      //                       ChangeNotifierProvider<SystemProvider>(
      //                     create: (context) => SystemProvider(),
      //                     child: Policy(
      //                       title: getTranslated(context, "TERM_CONDITIONS")!,
      //                     ),
      //                   ),
      //                 ),
      //               );
      //             },
      //             child: Text(
      //               getTranslated(context, 'TERMS_SERVICE_LBL')!,
      //               style: Theme.of(context).textTheme.bodySmall!.copyWith(
      //                   color: fontColor,
      //                   decoration: TextDecoration.underline,
      //                   fontWeight: FontWeight.normal),
      //             )),
      //         const SizedBox(
      //           width: 5.0,
      //         ),
      //         Text(
      //           getTranslated(context, "AND_LBL")!,
      //           style: Theme.of(context)
      //               .textTheme
      //               .bodySmall!
      //               .copyWith(color: fontColor, fontWeight: FontWeight.normal),
      //         ),
      //         const SizedBox(
      //           width: 5.0,
      //         ),
      //         InkWell(
      //           onTap: () {
      //             Navigator.push(
      //               context,
      //               CupertinoPageRoute(
      //                 builder: (context) =>
      //                     ChangeNotifierProvider<SystemProvider>(
      //                   create: (context) => SystemProvider(),
      //                   child: Policy(
      //                     title: getTranslated(context, "PRIVACYPOLICY")!,
      //                   ),
      //                 ),
      //               ),
      //             );
      //           },
      //           child: Text(
      //             getTranslated(context, "PRIVACYPOLICY")!,
      //             style: Theme.of(context).textTheme.bodySmall!.copyWith(
      //                   color: fontColor,
      //                   decoration: TextDecoration.underline,
      //                   fontWeight: FontWeight.normal,
      //                 ),
      //           ),
      //         ),
      //         Text(
      //           ",",
      //           style: Theme.of(context).textTheme.bodySmall!.copyWith(
      //                 color: fontColor,
      //                 fontWeight: FontWeight.normal,
      //               ),
      //         ),
      //       ],
      //     ),
      //   ],
      // ),
    
    );
  }

//==============================================================================
//============================= Seller Registration Text ===================================

//==============================================================================
//============================= Build Method ===================================

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return ScaffoldMessenger(
      key: scaffoldMessengerKey,
      child: Scaffold(
        key: _scaffoldKey,
        body: isNetworkAvail
            ? SingleChildScrollView(
                padding: EdgeInsets.only(
                  top: 23,
                  left: 23,
                  right: 23,
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: Form(
                  key: _formkey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      getLogo(),
                      signInTxt(),
                      signInSubTxt(),
                      setMobileNo(),
                      setPass(),
                      forgetPass(),
                      loginBtn(),
                      setDontHaveAcc(),
                      termAndPolicyTxt(),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              )
            : noInternet(context, setStateNoInternate, buttonSqueezeanimation,
                context.read<LoginProvider>().buttonController),
      ),
    );
  }

  Widget setSignInLabel() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Align(
        alignment: Alignment.center,
        child: Text(
          getTranslated(context, 'Login In')!,
          style: const TextStyle(
            color: primary,
            fontSize: textFontSize30,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  setDontHaveAcc() {
    return Padding(
      padding: const EdgeInsetsDirectional.only(top: 25.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "Don't have an account? ",
            style: Theme.of(context).textTheme.titleSmall!.copyWith(
                  color: black,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'ubuntu',
                ),
          ),
          InkWell(
            onTap: () {
              Routes.navigateToSellerRegister(context);
            },
            child: Text(
              'Sign Up',
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'ubuntu',
                  ),
            ),
          )
        ],
      ),
    );
  }

  setMobileNo() {
    return Padding(
      padding: const EdgeInsets.only(top: 40),
      child: Container(
        height: 53,
        width: double.maxFinite,
        decoration: BoxDecoration(
          color: lightWhite,
          borderRadius: BorderRadius.circular(circularBorderRadius10),
        ),
        alignment: Alignment.center,
        child: TextFormField(
          onFieldSubmitted: (v) {
            FocusScope.of(context).requestFocus(passFocus);
          },
          style: TextStyle(
              color: black.withOpacity(0.7),
              fontWeight: FontWeight.bold,
              fontSize: textFontSize13),
          keyboardType: TextInputType.number,
          controller: mobileController,
          focusNode: monoFocus,
          textInputAction: TextInputAction.next,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 13,
                vertical: 5,
              ),
              hintText: getTranslated(context, "Mobile Number")!,
              hintStyle: TextStyle(
                  color: black.withOpacity(0.3),
                  fontWeight: FontWeight.bold,
                  fontSize: textFontSize13),
              fillColor: lightWhite,
              border: InputBorder.none),
          validator: (val) => StringValidation.validateMob(val!, context),
          onSaved: (String? value) {
            context.read<LoginProvider>().mobile = value;
          },
        ),
      ),
    );
  }

  setPass() {
    return Padding(
      padding: const EdgeInsets.only(top: 18),
      child: Container(
        height: 53,
        width: double.maxFinite,
        decoration: BoxDecoration(
          color: lightWhite,
          borderRadius: BorderRadius.circular(circularBorderRadius10),
        ),
        alignment: Alignment.center,
        child: TextFormField(
          style: TextStyle(
              color: black.withOpacity(0.7),
              fontWeight: FontWeight.bold,
              fontSize: textFontSize13),
          onFieldSubmitted: (v) {
            passFocus!.unfocus();
          },
          keyboardType: TextInputType.text,
          obscureText: isShowPass,
          controller: passwordController,
          focusNode: passFocus,
          textInputAction: TextInputAction.next,
          validator: (val) =>
              StringValidation.validatePass(val!, context, onlyRequired: true),
          onSaved: (String? value) {
            context.read<LoginProvider>().password = value;
          },
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 13,
              vertical: 5,
            ),
            suffixIcon: InkWell(
              onTap: () {
                setState(
                  () {
                    isShowPass = !isShowPass;
                  },
                );
              },
              child: Padding(
                padding: const EdgeInsetsDirectional.only(end: 10.0),
                child: Icon(
                  !isShowPass ? Icons.visibility : Icons.visibility_off,
                  color: fontColor.withOpacity(0.4),
                  size: 22,
                ),
              ),
            ),
            suffixIconConstraints:
                const BoxConstraints(minWidth: 40, maxHeight: 20),
            hintText: getTranslated(context, "PASSHINT_LBL"),
            hintStyle: TextStyle(
              color: fontColor.withOpacity(0.3),
              fontWeight: FontWeight.bold,
              fontSize: textFontSize13,
            ),
            fillColor: lightWhite,
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }

  loginBtn() {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Center(
        child: AppBtn(
          title: getTranslated(context, "SIGNIN_LBL")!,
          btnAnim: buttonSqueezeanimation,
          btnCntrl: context.read<LoginProvider>().buttonController,
          onBtnSelected: () async {
            validateAndSubmit();
          },
        ),
      ),
    );
  }

  Widget getLogo() {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.only(top: 60),
      child: Image.asset(
                     'assets/images/PNG/homelogo.png',
                      height: 90,
                      width: 90,
                    ),
    );
  }

  signInSubTxt() {
    return Padding(
      padding: const EdgeInsetsDirectional.only(
        top: 13.0,
      ),
      child: Text(
        'Please enter your login details below to start using app.',
        style: Theme.of(context).textTheme.titleSmall!.copyWith(
              color: black.withOpacity(0.38),
              fontWeight: FontWeight.bold,
              fontFamily: 'ubuntu',
            ),
      ),
    );
  }

  signInTxt() {
    return Padding(
      padding: const EdgeInsetsDirectional.only(
        top: 40.0,
      ),
      child: Text(
        "Welcome to DsiStars Seller",
        style: Theme.of(context).textTheme.titleLarge!.copyWith(
              color: black,
              fontWeight: FontWeight.bold,
              fontSize: textFontSize20,
              letterSpacing: 0.8,
              fontFamily: 'ubuntu',
            ),
      ),
    );
  }

  forgetPass() {
    return Padding(
      padding: const EdgeInsetsDirectional.only(top: 30.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) => SendOtp(
                    title: getTranslated(context, 'FORGOT_PASS_TITLE'),
                  ),
                ),
              );
            },
            child: Text(
              getTranslated(context, 'FORGOT_PASSWORD_LBL')!,
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: textFontSize13,
                    fontFamily: 'ubuntu',
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

setSnackbarScafold(
    GlobalKey<ScaffoldMessengerState> scafoldkey, contex, String msg) {
  scafoldkey.currentState!.showSnackBar(
    SnackBar(
      content: Text(
        msg,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: fontColor,
        ),
      ),
      duration: const Duration(
        milliseconds: 3000,
      ),
      backgroundColor: lightWhite,
      elevation: 1.0,
    ),
  );
}
