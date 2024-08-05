import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sellermultivendor/Helper/Color.dart';
import 'package:sellermultivendor/Widget/parameterString.dart';
import '../../Helper/ApiBaseHelper.dart';
import '../../Helper/Constant.dart';
import '../../Widget/ButtonDesing.dart';
import '../../Widget/ContainerDesing.dart';
import '../../Provider/settingProvider.dart';
import '../../Widget/api.dart';
import '../../Widget/desing.dart';
import '../../Widget/networkAvailablity.dart';
import '../../Widget/scrollBehavior.dart';
import '../../Widget/snackbar.dart';
import '../../Widget/validation.dart';
import '../../Widget/noNetwork.dart';
import 'Login.dart';

class SetPass extends StatefulWidget {
  final String mobileNumber;

  const SetPass({
    Key? key,
    required this.mobileNumber,
  }) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<SetPass> with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final confirmpassController = TextEditingController();
  final passwordController = TextEditingController();
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  String? password, comfirmpass;
  Animation? buttonSqueezeanimation;
  ApiBaseHelper apiBaseHelper = ApiBaseHelper();
  AnimationController? buttonController;

  void validateAndSubmit() async {
    if (validateAndSave()) {
      _playAnimation();
      checkNetwork();
    }
  }

  Future<void> checkNetwork() async {
    bool avail = await isNetworkAvailable();
    if (avail) {
      getResetPass();
    } else {
      Future.delayed(const Duration(seconds: 2)).then(
        (_) async {
          setState(
            () {
              isNetworkAvail = false;
            },
          );
          await buttonController!.reverse();
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
          await buttonController!.reverse();
          setState(
            () {},
          );
        }
      },
    );
  }

  bool _showNewPass = false, _showCnfmPass = false;

  Future<void> getResetPass() async {
    var data = {
      mobileno: widget.mobileNumber,
      NEWPASS: password,
    };
    apiBaseHelper.postAPICall(forgotPasswordApi, data).then(
      (getdata) async {
        bool error = getdata["error"];
        String? msg = getdata["message"];
        await buttonController!.reverse();
        if (!error) {
          setSnackbar(
            getTranslated(context, "PASS_SUCCESS_MSG")!,
            context,
          );
          Future.delayed(
            const Duration(seconds: 1),
          ).then(
            (_) {
              Navigator.of(context).pushReplacement(
                CupertinoPageRoute(
                  builder: (BuildContext context) => const Login(),
                ),
              );
            },
          );
        } else {
          setSnackbar(
            msg!,
            context,
          );
        }
      },
      onError: (error) {
        setSnackbar(
          error.toString(),
          context,
        );
      },
    );
  }

  forgotpassTxt() {
    return Padding(
      padding: const EdgeInsetsDirectional.only(
        top: 40.0,
      ),
      child: Align(
        alignment: Alignment.topLeft,
        child: Text(
          getTranslated(context, 'FORGOT_PASSWORDTITILE')!,
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                color: black,
                fontWeight: FontWeight.bold,
                fontSize: textFontSize23,
                letterSpacing: 0.8,
                fontFamily: 'ubuntu',
              ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    buttonController!.dispose();
    super.dispose();
  }

  setPass() {
    return Padding(
      padding: const EdgeInsets.only(top: 40),
      child: TextFormField(
        style: TextStyle(
            color: black.withOpacity(0.7),
            fontWeight: FontWeight.bold,
            fontSize: textFontSize13),
        keyboardType: TextInputType.text,
        obscureText: !_showNewPass,
        controller: passwordController,
        textInputAction: TextInputAction.next,
        validator: (val) =>
            StringValidation.validatePass(val, context, onlyRequired: false),
        onSaved: (String? value) {
          password = value;
        },
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 13,
            vertical: 12,
          ),
          suffixIcon: IconButton(
            icon: Icon(_showNewPass ? Icons.visibility : Icons.visibility_off),
            iconSize: 20,
            color: lightBlack,
            onPressed: () {
              setState(() {
                _showNewPass = !_showNewPass;
              });
            },
          ),
          hintText: getTranslated(context, 'PASSHINT_LBL')!,
          hintStyle: TextStyle(
              color: black.withOpacity(0.3),
              fontWeight: FontWeight.bold,
              fontSize: textFontSize13),
          errorMaxLines: 4,
          fillColor: lightWhite,
          filled: true,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(circularBorderRadius10),
              borderSide: BorderSide.none),
        ),
      ),
    );
  }

  setConfirmpss() {
    return Padding(
      padding: const EdgeInsets.only(top: 18),
      child:TextFormField(
          style: TextStyle(
              color: black.withOpacity(0.7),
              fontWeight: FontWeight.bold,
              fontSize: textFontSize13),
          keyboardType: TextInputType.text,
          obscureText: !_showCnfmPass,
          controller: confirmpassController,
          validator: (value) {
            if (value!.isEmpty) {
              return getTranslated(context, "CON_PASS_REQUIRED_MSG")!;
            }
            if (value != password) {
              return getTranslated(context, "CON_PASS_NOT_MATCH_MSG")!;
            } else {
              return null;
            }
          },
          onSaved: (String? value) {
            comfirmpass = value;
          },
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 13,
              vertical: 12,
            ),
            suffixIcon: IconButton(
              icon:
                  Icon(_showCnfmPass ? Icons.visibility : Icons.visibility_off),
              iconSize: 20,
              color: lightBlack,
              onPressed: () {
                setState(() {
                  _showCnfmPass = !_showCnfmPass;
                });
              },
            ),
            hintText: getTranslated(context, 'CONFIRMPASSHINT_LBL')!,
            hintStyle: TextStyle(
                color: black.withOpacity(0.3),
                fontWeight: FontWeight.bold,
                fontSize: textFontSize13),
            fillColor: lightWhite,
            filled: true,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(circularBorderRadius10),
                borderSide: BorderSide.none),

        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    buttonController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    buttonSqueezeanimation = Tween(
      begin: width * 0.7,
      end: 50.0,
    ).animate(
      CurvedAnimation(
        parent: buttonController!,
        curve: const Interval(
          0.0,
          0.150,
        ),
      ),
    );
  }

  Future<void> _playAnimation() async {
    try {
      await buttonController!.forward();
    } on TickerCanceled {}
  }

  setPassBtn() {
    return Center(
      child: Padding(
        padding: const EdgeInsetsDirectional.only(top: 20.0, bottom: 20.0),
        child: AppBtn(
          title: getTranslated(context, 'SET_PASSWORD'),
          btnAnim: buttonSqueezeanimation,
          btnCntrl: buttonController,
          onBtnSelected: () async {
            validateAndSubmit();
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      key: _scaffoldKey,
      body: isNetworkAvail
          ? Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.only(
                    top: 23,
                    left: 23,
                    right: 23,
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Form(
                  key: _formkey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      getLogo(),
                      forgotpassTxt(),
                      setPass(),
                      setConfirmpss(),
                      setPassBtn(),
                    ],
                  ),
                ),
              ),
            )
          : noInternet(context, setStateNoInternate, buttonSqueezeanimation,
              buttonController),
    );
  }

  getLoginContainer() {
    return Positioned.directional(
      start: MediaQuery.of(context).size.width * 0.025,
      top: MediaQuery.of(context).size.height * 0.2, //original
      textDirection: Directionality.of(context),
      child: ClipPath(
        clipper: ContainerClipper(),
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom * 0.8),
          height: MediaQuery.of(context).size.height * 0.7,
          width: MediaQuery.of(context).size.width * 0.95,
          color: white,
          child: Form(
            key: _formkey,
            child: ScrollConfiguration(
              behavior: MyBehavior(),
              child: SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 2,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.10,
                      ),
                      forgotpassTxt(),
                      setPass(),
                      setConfirmpss(),
                      setPassBtn(),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.10,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget getLogo() {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.only(top: 60),
      child: SvgPicture.asset(
        DesignConfiguration.setSvgPath('loginlogo'),
        alignment: Alignment.center,
        height: 90,
        width: 90,
        fit: BoxFit.contain,
      ),
    );
  }
}
