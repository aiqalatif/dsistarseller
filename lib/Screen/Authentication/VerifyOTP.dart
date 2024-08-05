import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sellermultivendor/Helper/ApiBaseHelper.dart';
import 'package:sellermultivendor/Helper/Color.dart';
import 'package:sellermultivendor/Repository/appSettingsRepository.dart';
import 'package:sellermultivendor/Screen/HomePage/home.dart';
import 'package:sellermultivendor/Widget/api.dart';
import 'package:sellermultivendor/Widget/parameterString.dart';
import 'package:sms_autofill/sms_autofill.dart';
import '../../Helper/Constant.dart';
import '../../Widget/ButtonDesing.dart';
import '../../Provider/settingProvider.dart';
import '../../Widget/desing.dart';
import '../../Widget/networkAvailablity.dart';
import '../../Widget/sharedPreferances.dart';
import '../../Widget/snackbar.dart';
import '../../Widget/validation.dart';
import 'SetNewPassword.dart';

class VerifyOtp extends StatefulWidget {
  final String? mobileNumber, countryCode, title;

  const VerifyOtp(
      {Key? key,
      required String this.mobileNumber,
      this.countryCode,
      this.title})
      : super(key: key);

  @override
  _MobileOTPState createState() => _MobileOTPState();
}

class _MobileOTPState extends State<VerifyOtp> with TickerProviderStateMixin {
  final dataKey = GlobalKey();
  String? password, mobile, countrycode;
  String? otp;
  bool isCodeSent = false;
  bool isSMSGatewayOn = false;
  late String _verificationId;
  String signature = "";
  bool isResendClickable = false;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Animation? buttonSqueezeanimation;
  AnimationController? buttonController;

  Future<void> verifyOtp({
    required String mobileNumber,
    required String otp,
  }) async {
    try {
      var response = await apiBaseHelper.postAPICall(getVerifyOtpApi,
          {"mobile": mobileNumber.replaceAll(' ', ''), "otp": otp});
      if (response['error'] == true) {
        throw ApiException(response['message']);
      }
    } on Exception catch (e) {
      throw ApiException(e.toString());
    }
  }

  Future<void> resendOtp({
    required String mobileNumber,
  }) async {
    try {
      var response = await apiBaseHelper.postAPICall(
          getResendOtpApi, {"mobile": mobileNumber.replaceAll(' ', '')});
      if (response['error'] == true) {
        throw ApiException(response['message']);
      }
    } on Exception catch (e) {
      throw ApiException(e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    getSingature();
    Future.delayed(Duration.zero, () {
      getUserDetails();
      isSMSGatewayOn = AppSettingsRepository.appSettings.isSMSGatewayOn;
      if (!isSMSGatewayOn) {
        _onVerifyCode();
      } else {
        isCodeSent = true;
      }
    });
    Future.delayed(const Duration(seconds: 60)).then(
      (_) {
        isResendClickable = true;
      },
    );
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

  Future<void> getSingature() async {
    signature = await SmsAutoFill().getAppSignature;
    SmsAutoFill().listenForCode;
  }

  getUserDetails() async {
    mobile = await getPrefrence(Mobile);
    countrycode = await getPrefrence(COUNTRY_CODE);
    setState(
      () {},
    );
  }

  Future<void> checkNetworkOtp() async {
    isNetworkAvail = await isNetworkAvailable();
    if (isNetworkAvail) {
      if (isResendClickable) {
        if (isSMSGatewayOn) {
          isResendClickable = false;
          if (isSMSGatewayOn) {
            bool didResend = false;
            try {
              await resendOtp(mobileNumber: widget.mobileNumber ?? '');
              didResend = true;
            } on ApiException catch (e) {
              setSnackbar(e.toString(), context);
            }
            if (didResend) {
              setSnackbar(getTranslated(context, 'OTP_RESENT')!, context);
              Future.delayed(const Duration(seconds: 60)).then(
                (_) {
                  isResendClickable = true;
                },
              );
            } else {
              isResendClickable = true;
            }
          }
        } else {
          _onVerifyCode();
        }
      } else {
        setSnackbar(
          getTranslated(context, "OTPWR")!,
          context,
        );
      }
    } else {
      setState(
        () {
          isNetworkAvail = false;
        },
      );
      if (!isSMSGatewayOn) {
        Future.delayed(const Duration(seconds: 60)).then(
          (_) async {
            bool avail = await isNetworkAvailable();
            if (avail) {
              if (isResendClickable) {
                _onVerifyCode();
              } else {
                setSnackbar(
                  getTranslated(context, "OTPWR")!,
                  context,
                );
              }
            } else {
              await buttonController!.reverse();
              setSnackbar(
                getTranslated(context, "somethingMSg")!,
                context,
              );
            }
          },
        );
      }
    }
  }

  verifyBtn() {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Center(
        child: AppBtn(
          title: getTranslated(context, 'VERIFY_AND_PROCEED'),
          btnAnim: buttonSqueezeanimation,
          btnCntrl: buttonController,
          onBtnSelected: () async {
            _onFormSubmitted();
          },
        ),
      ),
    );
  }

  void _onVerifyCode() async {
    setState(
      () {
        isCodeSent = true;
      },
    );
    verificationCompleted(AuthCredential phoneAuthCredential) {
      _firebaseAuth.signInWithCredential(phoneAuthCredential).then(
        (UserCredential value) {
          if (value.user != null) {
            setSnackbar(
              getTranslated(context, "OTPMSG")!,
              context,
            );
            setPrefrence(Mobile, mobile!);
            setPrefrence(COUNTRY_CODE, countrycode!);
            if (widget.title == getTranslated(context, "FORGOT_PASS_TITLE")!) {
              Navigator.pushReplacement(
                context,
                CupertinoPageRoute(
                  builder: (context) => SetPass(mobileNumber: mobile!),
                ),
              );
            }
          } else {
            setSnackbar(
              getTranslated(context, "OTPERROR")!,
              context,
            );
          }
        },
      ).catchError(
        (error) {
          setSnackbar(
            error.toString(),
            context,
          );
        },
      );
    }

    verificationFailed(FirebaseAuthException authException) {
      setSnackbar(
        authException.message!,
        context,
      );

      setState(
        () {
          isCodeSent = false;
        },
      );
    }

    codeSent(String verificationId, [int? forceResendingToken]) async {
      _verificationId = verificationId;
      setState(
        () {
          _verificationId = verificationId;
        },
      );
    }

    codeAutoRetrievalTimeout(String verificationId) {
      _verificationId = verificationId;
      setState(
        () {
          isResendClickable = true;
          _verificationId = verificationId;
        },
      );
    }

    await _firebaseAuth.verifyPhoneNumber(
        phoneNumber: "+${widget.countryCode}${widget.mobileNumber}",
        timeout: const Duration(seconds: 60),
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
  }

  void _onFormSubmitted() async {
    String code = otp!.trim();

    if (code.length == 6) {
      _playAnimation();
      try {
        bool wasOtpVerified = false;
        if (isSMSGatewayOn) {
          try {
            await verifyOtp(mobileNumber: widget.mobileNumber ?? '', otp: code);
            wasOtpVerified = true;
          } on ApiException catch (e) {
            setSnackbar(e.toString(), context);
            await buttonController!.reverse();
            return;
          }
        } else {
          AuthCredential authCredential = PhoneAuthProvider.credential(
              verificationId: _verificationId, smsCode: code);
          UserCredential value =
              await _firebaseAuth.signInWithCredential(authCredential);
          wasOtpVerified = value.user != null;
        }
        if (wasOtpVerified) {
          await buttonController!.reverse();
          setSnackbar(
            getTranslated(context, "OTPMSG")!,
            context,
          );
          setPrefrence(Mobile, mobile!);
          setPrefrence(COUNTRY_CODE, countrycode!);
          if (widget.title == getTranslated(context, "SEND_OTP_TITLE")) {
          } else if (widget.title ==
              getTranslated(context, "FORGOT_PASS_TITLE")) {
            Future.delayed(const Duration(seconds: 2)).then((_) {
              Navigator.pushReplacement(
                context,
                CupertinoPageRoute(
                  builder: (context) => SetPass(mobileNumber: mobile!),
                ),
              );
            });
          }
        } else {
          setSnackbar(
            getTranslated(context, "OTPERROR")!,
            context,
          );
          await buttonController!.reverse();
        }
      } catch (e) {
        setSnackbar(e.toString(), context);

        await buttonController!.reverse();
      }
    } else {
      setSnackbar(
        getTranslated(context, "ENTEROTP")!,
        context,
      );
    }
  }

  Future<void> _playAnimation() async {
    try {
      await buttonController!.forward();
    } on TickerCanceled {}
  }

  getImage() {
    return Expanded(
      flex: 4,
      child: Center(
        child: Image.asset(
          DesignConfiguration.setPngPath('loginlogo'),
          color: primary,
        ),
      ),
    );
  }

  @override
  void dispose() {
    buttonController!.dispose();
    super.dispose();
  }

  monoVarifyText() {
    return Padding(
      padding: const EdgeInsetsDirectional.only(
        top: 60.0,
      ),
      child: Text(
        getTranslated(context, 'MOBILE_NUMBER_VARIFICATION')!,
        style: Theme.of(context).textTheme.titleLarge!.copyWith(
              color: black,
              fontWeight: FontWeight.bold,
              fontSize: textFontSize23,
              letterSpacing: 0.8,
              fontFamily: 'ubuntu',
            ),
      ),
    );
  }

  otpText() {
    return Padding(
      padding: const EdgeInsetsDirectional.only(
        top: 13.0,
      ),
      child: Text(
        getTranslated(context, 'SENT_VERIFY_CODE_TO_NO_LBL')!,
        style: Theme.of(context).textTheme.titleSmall!.copyWith(
              color: black.withOpacity(0.5),
              fontWeight: FontWeight.bold,
              fontFamily: 'ubuntu',
            ),
      ),
    );
  }

  mobText() {
    return Padding(
      padding: const EdgeInsetsDirectional.only(top: 5.0),
      child: Text(
        '+${widget.countryCode}-${widget.mobileNumber}',
        style: Theme.of(context).textTheme.titleSmall!.copyWith(
              color: black.withOpacity(0.5),
              fontWeight: FontWeight.bold,
              fontFamily: 'ubuntu',
            ),
      ),
    );
  }

  otpLayout() {
    return Padding(
      padding: const EdgeInsetsDirectional.only(top: 30),
      child: PinFieldAutoFill(
        decoration: BoxLooseDecoration(
            textStyle:
                const TextStyle(fontSize: textFontSize20, color: fontColor),
            radius: const Radius.circular(circularBorderRadius5),
            gapSpace: 15,
            bgColorBuilder: FixedColorBuilder(lightWhite.withOpacity(0.4)),
            strokeColorBuilder: FixedColorBuilder(fontColor.withOpacity(0.2))),
        currentCode: otp,
        codeLength: 6,
        onCodeChanged: (String? code) {
          otp = code;
        },
        onCodeSubmitted: (String code) {
          otp = code;
        },
      ),
    );
  }

  resendText() {
    return Padding(
      padding: const EdgeInsetsDirectional.only(top: 30.0),
      child: Row(
        children: [
          Text(
            getTranslated(context, 'DIDNT_GET_THE_CODE')!,
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  color: black.withOpacity(0.5),
                  fontWeight: FontWeight.bold,
                  fontFamily: 'ubuntu',
                ),
          ),
          InkWell(
            onTap: () async {
              await buttonController!.reverse();
              checkNetworkOtp();
            },
            child: Text(
              getTranslated(context, 'RESEND_OTP')!,
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
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

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return Scaffold(
      key: _scaffoldKey,
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
              top: 23,
              left: 23,
              right: 23,
              bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Form(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                getLogo(),
                monoVarifyText(),
                otpText(),
                mobText(),
                otpLayout(),
                resendText(),
                verifyBtn(),
              ],
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
