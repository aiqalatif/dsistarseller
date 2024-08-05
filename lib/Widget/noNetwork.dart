import 'package:flutter/material.dart';
import 'package:sellermultivendor/Widget/validation.dart';
import '../Helper/Color.dart';
import 'ButtonDesing.dart';
import 'desing.dart';

Widget noInternet(
  BuildContext context,
  setStateNoInternate,
  Animation<dynamic>? buttonSqueezeanimation,
  AnimationController? buttonController,
) {
  return Center(
    child: SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          noIntImage(),
          noIntText(context),
          noIntDec(context),
          AppBtn(
            title: getTranslated(context, "TRY_AGAIN_INT_LBL")!,
            btnAnim: buttonSqueezeanimation,
            btnCntrl: buttonController,
            onBtnSelected: setStateNoInternate,
          )
        ],
      ),
    ),
  );
}

noIntImage() {
  return Image.asset(
    DesignConfiguration.setPngPath('no_internet'),
    fit: BoxFit.contain,
    color: primary,
  );
}

noIntText(BuildContext context) {
  return Text(
    getTranslated(context, "NO_INTERNET")!,
    style: Theme.of(context).textTheme.headlineSmall!.copyWith(
          color: primary,
          fontWeight: FontWeight.normal,
        ),
  );
}

noIntDec(BuildContext context) {
  return Container(
    padding: const EdgeInsets.only(top: 30.0, left: 30.0, right: 30.0),
    child: Text(
      getTranslated(context, "NO_INTERNET_DISC")!,
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.titleLarge!.copyWith(
            color: lightBlack2,
            fontWeight: FontWeight.normal,
          ),
    ),
  );
}
