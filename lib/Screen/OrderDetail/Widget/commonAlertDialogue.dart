import 'package:flutter/material.dart';

import '../../../Helper/Color.dart';
import '../../../Helper/Constant.dart';
import '../../../Widget/validation.dart';

commonDialogue(BuildContext context, String title,
    VoidCallback onBtnSelected) async {
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
              title,
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
                  onBtnSelected();
                },
              ),
            ],
          );
        },
      );
    },
  );
}
