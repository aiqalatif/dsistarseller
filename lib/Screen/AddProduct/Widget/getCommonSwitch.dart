// Get Comman Switch :-     .
import 'package:flutter/material.dart';
import '../Add_Product.dart';

getCommanSwitch(
  int index,
  Function setState,
) {
  return Switch(
    onChanged: (value) {
      if (index == 1) {
        addProvider!.isreturnable = value;
        if (value) {
          addProvider!.isReturnable = "1";
        } else {
          addProvider!.isReturnable = "0";
        }
        setState();
      } else if (index == 2) {
        addProvider!.isCODallow = value;
        if (value) {
          addProvider!.isCODAllow = "1";
        } else {
          addProvider!.isCODAllow = "0";
        }

        setState();
      } else if (index == 3) {
        addProvider!.taxincludedInPrice = value;
        if (value) {
          addProvider!.taxincludedinPrice = "1";
        } else {
          addProvider!.taxincludedinPrice = "0";
        }
        setState();
      } else if (index == 4) {
        addProvider!.iscancelable = value;
        if (value) {
          addProvider!.isCancelable = "1";
        } else {
          addProvider!.isCancelable = "0";
        }
        setState();
      } else if (index == 5) {
        addProvider!.digitalProductDownloaded = value;
        if (value) {
          addProvider!.idDigitalProductDownladable = "1";
        } else {
          addProvider!.idDigitalProductDownladable = "0";
        }
        setState(() {});
      }
    },
    value: () {
      if (index == 1) {
        return addProvider!.isreturnable;
      } else if (index == 2) {
        return addProvider!.isCODallow;
      } else if (index == 3) {
        return addProvider!.taxincludedInPrice;
      } else if (index == 4) {
        return addProvider!.iscancelable;
      } else if (index == 5) {
        return addProvider!.digitalProductDownloaded;
      }
      return true;
    }(),
  );
}
