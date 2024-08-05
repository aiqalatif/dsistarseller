import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sellermultivendor/Provider/settingProvider.dart';
import 'package:sellermultivendor/Repository/NotificationRepository.dart';
import '../../../Helper/Color.dart';
import '../../../Helper/Constant.dart';
import '../../../Widget/sharedPreferances.dart';
import '../../../Widget/validation.dart';
import '../../Authentication/Login.dart';

logOutDailog(BuildContext context) async {
  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setStater) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(circularBorderRadius5),
              ),
            ),
            content: Text(
              getTranslated(context, "LOGOUTTXT")!,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(color: primary),
            ),
            actions: <Widget>[
              TextButton(
                child: Text(
                  getTranslated(context, "LOGOUTNO")!,
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall!
                      .copyWith(color: lightBlack, fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),
              TextButton(
                child: Text(
                  getTranslated(context, "LOGOUTYES")!,
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall!
                      .copyWith(color: primary, fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  clearUserSession(context);
                  NotificationRepository.updateFcmId(
                      userId:
                          context.read<SettingProvider>().currentUerID ?? '',
                      fcmId: "-");
                  Navigator.of(context).pushAndRemoveUntil(
                      CupertinoPageRoute(
                        builder: (context) => const Login(),
                      ),
                      (Route<dynamic> route) => false);
                },
              ),
            ],
          );
        },
      );
    },
  );
}
