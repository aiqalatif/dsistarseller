import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Helper/Color.dart';
import '../../Helper/Constant.dart';
import '../../Provider/ProfileProvider.dart';
import '../../Provider/settingProvider.dart';
import '../../Widget/ButtonDesing.dart';
import '../../Widget/appBar.dart';
import '../../Widget/desing.dart';
import '../../Widget/networkAvailablity.dart';
import '../../Widget/routes.dart';
import '../../Widget/validation.dart';
import '../../Widget/noNetwork.dart';
import 'Widget/getFirstHeader.dart';
import 'Widget/getFourthHeader.dart';
import 'Widget/getProfileImage.dart';
import 'Widget/getSecondHeader.dart';
import 'Widget/getThirdHeader.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => StateProfile();
}

String? lat, long;
ProfileProvider? profileProvider;

class StateProfile extends State<Profile> with TickerProviderStateMixin {
  setStateNow() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    profileProvider = Provider.of<ProfileProvider>(context, listen: false);
    profileProvider!.initializeVariable();
    profileProvider!.mobileC = TextEditingController();
    profileProvider!.nameC = TextEditingController();
    profileProvider!.emailC = TextEditingController();
    profileProvider!.addressC = TextEditingController();
    profileProvider!.storenameC = TextEditingController();
    profileProvider!.storeurlC = TextEditingController();
    profileProvider!.storeDescC = TextEditingController();
    profileProvider!.accnameC = TextEditingController();
    profileProvider!.accnumberC = TextEditingController();
    profileProvider!.bankcodeC = TextEditingController();
    profileProvider!.banknameC = TextEditingController();
    profileProvider!.latitututeC = TextEditingController();
    profileProvider!.longituteC = TextEditingController();
    profileProvider!.taxnameC = TextEditingController();
    profileProvider!.pannumberC = TextEditingController();
    profileProvider!.taxnumberC = TextEditingController();
    profileProvider!.getSallerDetail(context, setStateNow);

    profileProvider!.buttonController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);

    profileProvider!.buttonSqueezeanimation = Tween(
      begin: width * 0.7,
      end: 50.0,
    ).animate(
      CurvedAnimation(
        parent: profileProvider!.buttonController!,
        curve: const Interval(
          0.0,
          0.150,
        ),
      ),
    );
  }
//==============================================================================
//============================= dispose method =================================

  @override
  void dispose() {
    profileProvider!.buttonController!.dispose();
    profileProvider!.mobileC?.dispose();
    profileProvider!.nameC?.dispose();
    profileProvider!.addressC!.dispose();
    profileProvider!.emailC!.dispose();
    profileProvider!.storenameC!.dispose();
    profileProvider!.storeurlC!.dispose();
    profileProvider!.storeDescC!.dispose();
    profileProvider!.accnameC!.dispose();
    profileProvider!.accnumberC!.dispose();
    profileProvider!.bankcodeC!.dispose();
    profileProvider!.banknameC!.dispose();
    profileProvider!.latitututeC!.dispose();
    profileProvider!.longituteC!.dispose();
    profileProvider!.taxnameC!.dispose();
    profileProvider!.pannumberC!.dispose();
    profileProvider!.taxnumberC!.dispose();
    super.dispose();
  }

  Future<void> _playAnimation() async {
    try {
      await profileProvider!.buttonController!.forward();
    } on TickerCanceled {}
  }

  setStateNoInternate() async {
    _playAnimation();

    Future.delayed(
      const Duration(seconds: 2),
    ).then(
      (_) async {
        isNetworkAvail = await isNetworkAvailable();
        if (isNetworkAvail) {
          Navigator.pushReplacement(
            context,
            CupertinoPageRoute(
              builder: (BuildContext context) => super.widget,
            ),
          );
        } else {
          await profileProvider!.buttonController!.reverse();
          setState(
            () {},
          );
        }
      },
    );
  }

//==============================================================================
//========================== build Method ======================================

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
        key: profileProvider!.scaffoldKey,
        backgroundColor: lightWhite,
        body: Stack(
          children: <Widget>[
            bodyPart(),
            DesignConfiguration.showCircularProgress(
              profileProvider!.isLoading,
              primary,
            )
          ],
        ),
        bottomNavigationBar: AppBtn(
          title: getTranslated(context, "Update Profile")!,
          btnAnim: profileProvider!.buttonSqueezeanimation,
          btnCntrl: profileProvider!.buttonController,
          paddingRequired: true,
          onBtnSelected: () async {
            _playAnimation();
            checkNetwork();
          },
        ));
  }

//==============================================================================
//========================== build Method ======================================
  bodyPart() {
    return Column(
      children: [
        GradientAppBar(
          getTranslated(context, "EDIT_PROFILE_LBL")!,
        ),
        Flexible(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 10,
              ),
              child: isNetworkAvail
                  ? Column(
                      children: <Widget>[
                        GetProfileImage(update: setStateNow),
                        GetFirstHeader(setStateNow: setStateNow),
                        GetSecondHeader(setStateNow: setStateNow),
                        GetThirdHeader(setStateNow: setStateNow),
                        GetFurthHeader(setStateNow: setStateNow),
                        changePass(),
                        // updateBtn(),
                      ],
                    )
                  : noInternet(
                      context,
                      setStateNoInternate,
                      profileProvider!.buttonSqueezeanimation,
                      profileProvider!.buttonController,
                    ),
            ),
          ),
        ),
      ],
    );
  }

//==============================================================================
//============================ Change Pass =====================================

  changePass() {
    return Container(
      width: width,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(circularBorderRadius10),
        ),
        color: white,
      ),
      child: InkWell(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 20.0,
            top: 15.0,
            bottom: 15.0,
            right: 20.0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                getTranslated(context, "CHANGE_PASS_LBL")!,
                style: Theme.of(context)
                    .textTheme
                    .titleSmall!
                    .copyWith(color: primary, fontWeight: FontWeight.bold),
              ),
              InkWell(
                onTap: () {
                  _showDialog(context);
                },
                child: const Padding(
                  padding: EdgeInsets.only(right: 12.0),
                  child: Icon(
                    Icons.edit,
                    color: black,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _showDialog(BuildContext ctx) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setStater) {
            return AlertDialog(
              contentPadding: const EdgeInsets.all(0.0),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(circularBorderRadius5),
                ),
              ),
              content: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20.0, 20.0, 0, 2.0),
                      child: Text(
                        getTranslated(context, "CHANGE_PASS_LBL")!,
                        style: Theme.of(this.context)
                            .textTheme
                            .titleMedium!
                            .copyWith(color: primary),
                      ),
                    ),
                    const Divider(color: lightBlack),
                    Form(
                      key: profileProvider!.formKey,
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding:
                                const EdgeInsets.fromLTRB(20.0, 0, 20.0, 0),
                            child: TextFormField(
                              onChanged: (value) =>
                                  {profileProvider!.curPass = value},
                              onSaved: (value) =>
                                  {profileProvider!.curPass = value},
                              keyboardType: TextInputType.text,
                              validator: (val) => StringValidation.validatePass(
                                  val, context,
                                  onlyRequired: true),
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              decoration: InputDecoration(
                                hintText:
                                    getTranslated(context, "CUR_PASS_LBL")!,
                                hintStyle: Theme.of(this.context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(
                                      color: lightBlack,
                                      fontWeight: FontWeight.normal,
                                    ),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    profileProvider!.showCurPassword
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                  ),
                                  iconSize: 20,
                                  color: lightBlack,
                                  onPressed: () {
                                    setStater(
                                      () {
                                        profileProvider!.showCurPassword =
                                            !profileProvider!.showCurPassword;
                                      },
                                    );
                                  },
                                ),
                              ),
                              obscureText: !profileProvider!.showCurPassword,
                              controller: profileProvider!.curPassC,
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.fromLTRB(20.0, 0, 20.0, 0),
                            child: TextFormField(
                              onChanged: (value) =>
                                  {profileProvider!.newPass = value},
                              onSaved: (value) =>
                                  {profileProvider!.newPass = value},
                              keyboardType: TextInputType.text,
                              validator: (val) => StringValidation.validatePass(
                                  val, context,
                                  onlyRequired: false),
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              decoration: InputDecoration(
                                  hintText:
                                      getTranslated(context, "NEW_PASS_LBL")!,
                                  hintStyle: Theme.of(this.context)
                                      .textTheme
                                      .titleMedium!
                                      .copyWith(
                                          color: lightBlack,
                                          fontWeight: FontWeight.normal),
                                  suffixIcon: IconButton(
                                    icon: Icon(profileProvider!.showPassword
                                        ? Icons.visibility
                                        : Icons.visibility_off),
                                    iconSize: 20,
                                    color: lightBlack,
                                    onPressed: () {
                                      setStater(
                                        () {
                                          profileProvider!.showPassword =
                                              !profileProvider!.showPassword;
                                        },
                                      );
                                    },
                                  ),
                                  errorMaxLines: 4),
                              obscureText: !profileProvider!.showPassword,
                              controller: profileProvider!.newPassC,
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.fromLTRB(20.0, 0, 20.0, 0),
                            child: TextFormField(
                              keyboardType: TextInputType.text,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return getTranslated(
                                      context, "CON_PASS_REQUIRED_MSG")!;
                                }
                                if (value != profileProvider!.newPass) {
                                  return getTranslated(
                                      context, "CON_PASS_NOT_MATCH_MSG")!;
                                } else {
                                  return null;
                                }
                              },
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              decoration: InputDecoration(
                                hintText: getTranslated(
                                    context, "CONFIRMPASSHINT_LBL")!,
                                hintStyle: Theme.of(this.context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(
                                        color: lightBlack,
                                        fontWeight: FontWeight.normal),
                                suffixIcon: IconButton(
                                  icon: Icon(profileProvider!.showCmPassword
                                      ? Icons.visibility
                                      : Icons.visibility_off),
                                  iconSize: 20,
                                  color: lightBlack,
                                  onPressed: () {
                                    setStater(
                                      () {
                                        profileProvider!.showCmPassword =
                                            !profileProvider!.showCmPassword;
                                      },
                                    );
                                  },
                                ),
                              ),
                              obscureText: !profileProvider!.showCmPassword,
                              controller: profileProvider!.confPassC,
                              onChanged: (v) => setState(
                                () {
                                  profileProvider!.confPass = v;
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: Text(
                    getTranslated(context, "CANCEL")!,
                    style: Theme.of(this.context)
                        .textTheme
                        .titleSmall!
                        .copyWith(
                            color: lightBlack, fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                    Routes.pop(context);
                  },
                ),
                TextButton(
                  child: Text(
                    getTranslated(context, "SAVE_LBL")!,
                    style: Theme.of(this.context)
                        .textTheme
                        .titleSmall!
                        .copyWith(color: primary, fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                    final form = profileProvider!.formKey.currentState!;
                    if (form.validate()) {
                      setState(
                        () {
                          Routes.pop(context);
                        },
                      );
                      profileProvider!.changePassWord(ctx, setStateNow);
                    }
                  },
                )
              ],
            );
          },
        );
      },
    );
  }

  Future<void> checkNetwork() async {
    isNetworkAvail = await isNetworkAvailable();
    if (isNetworkAvail) {
      await profileProvider!.buttonController!.reverse();
      profileProvider!.isLoading = true;
      profileProvider!.updateProfilePic(context, setStateNow);
    } else {
      Future.delayed(const Duration(seconds: 2)).then(
        (_) async {
          await profileProvider!.buttonController!.reverse();
          setState(
            () {
              isNetworkAvail = false;
            },
          );
        },
      );
    }
  }
}
