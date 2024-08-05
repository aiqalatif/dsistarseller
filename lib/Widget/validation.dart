import 'package:flutter/material.dart';
import '../Localization/Demo_Localization.dart';

class StringValidation {
// product name velidatation

  static String? validateThisFieldRequered(
      String? value, BuildContext context) {
    if (value!.isEmpty) {
      return getTranslated(context, "This Field is Required!");
    }
    return null;
  }

// password verification

  static String? validatePass(String? value, BuildContext context,
      {required bool onlyRequired}) {
    if (onlyRequired) {
      if (value!.isEmpty) {
        return getTranslated(context, "PWD_REQUIRED")!;
      } else {
        return null;
      }
    } else {
      if (value!.isEmpty) {
        return getTranslated(context, "PWD_REQUIRED")!;
      } else if (!RegExp(
              r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~_.?=^`-]).{8,}$')
          .hasMatch(value)) {
        return getTranslated(context, 'PASSWORD_VALIDATION')!;
      } else {
        return null;
      }
    }
  }

//email validation
  static String? validateEmail(String value, BuildContext context) {
    if (value.isEmpty) {
      return "Email Is Required";
    } else if (!RegExp(
            r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)"
            r'*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+'
            r'[a-z0-9](?:[a-z0-9-]*[a-z0-9])?')
        .hasMatch(value)) {
      return "Please Enter Valid Email Address";
    } else {
      return null;
    }
  }

// sort detail velidatation

  static String? sortdescriptionvalidate(String? value, BuildContext context) {
    if (value!.isEmpty) {
      return getTranslated(context, "Sort Description is required");
    }
    if (value.length < 3) {
      return getTranslated(context, "minimam 5 character is required ");
    }
    return null;
  }

// product name velidatation

  static String? validateProduct(String? value, BuildContext context) {
    if (value!.isEmpty) {
      return getTranslated(context, "ProductNameRequired")!;
    }
    if (value.length < 3) {
      return getTranslated(context, 'Please Add Valid Product name');
    }
    return null;
  }

//mobile verification

  static String? validateMob(String? value, BuildContext context) {
    if (value!.isEmpty) {
      return getTranslated(context, "MOB_REQUIRED")!;
    }
    /* if (value.length < 5) {
      return getTranslated(context, "VALID_MOB");
    }*/
    return null;
  }

// command for many fields

  static String? validateField(String? value, BuildContext context) {
    if (value!.isEmpty) {
      return getTranslated(context, "FIELD_REQUIRED")!;
    } else {
      return null;
    }
  }

// name validation

  static String? validateUserName(String? value, BuildContext context) {
    if (value!.isEmpty) {
      return getTranslated(context, "USER_REQUIRED")!;
    }
    if (value.length <= 1) {
      return getTranslated(context, "USER_LENGTH")!;
    }
    return null;
  }

  static String capitalize(String s) {
    if (s == "") {
      return "";
    } else {
      return s[0].toUpperCase() + s.substring(1);
    }
  }
}

// for the translation of string
String? getTranslated(BuildContext context, String key) {
  return DemoLocalization.of(context)!.translate(key) ?? key;
}
