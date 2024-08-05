// Comman Input Text Field
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../Helper/Color.dart';
import '../../../Helper/Constant.dart';
import '../../../Widget/validation.dart';
import '../addPickUpLocation.dart';

getPrimaryCommanText(String title, bool isMultipleLine) {
  return Text(
    title,
    style: const TextStyle(
      fontSize: textFontSize16,
      color: black,
    ),
    overflow: isMultipleLine ? TextOverflow.ellipsis : null,
    softWrap: true,
    maxLines: isMultipleLine ? 2 : 1,
  );
}

// get command sized Box

getCommanSizedBox() {
  return const SizedBox(
    height: 10,
  );
}

// Comman Secondary Text Field :-

getSecondaryCommanText(String title) {
  return Text(
    title,
    style: const TextStyle(
      color: Colors.grey,
    ),
    softWrap: false,
    overflow: TextOverflow.ellipsis,
    maxLines: 1,
  );
}

getCommanInputTextField(
  String title,
  int index,
  double heightvalue,
  double widthvalue,
  int textType,
  BuildContext context,
) {
  return SizedBox(
    //height: height * heightvalue,
    child: TextFormField(
      onFieldSubmitted: (v) {
        FocusScope.of(context).requestFocus(
          () {
            if (index == 1) {
              return addPickUpLocationProvider!.pickUpLocationFocus;
            } else if (index == 2) {
              return addPickUpLocationProvider!.shipperNameFocus;
            } else if (index == 3) {
              return addPickUpLocationProvider!.shipperEmailFocus;
            } else if (index == 4) {
              return addPickUpLocationProvider!.shipperPhoneFocus;
            } else if (index == 5) {
              return addPickUpLocationProvider!.cityFocus;
            } else if (index == 6) {
              return addPickUpLocationProvider!.stateFocus;
            } else if (index == 7) {
              return addPickUpLocationProvider!.countryFocus;
            } else if (index == 8) {
              return addPickUpLocationProvider!.pinCodeFocus;
            } else if (index == 9) {
              return addPickUpLocationProvider!.addressFocus;
            } else if (index == 10) {
              return addPickUpLocationProvider!.address2Focus;
            } else if (index == 11) {
              return addPickUpLocationProvider!.latitudeFocus;
            } else if (index == 12) {
              return addPickUpLocationProvider!.longitudeFocus;
            }
          }(),
        );
      },
      focusNode: () {
        if (index == 1) {
          return addPickUpLocationProvider!.pickUpLocationFocus;
        } else if (index == 2) {
          return addPickUpLocationProvider!.shipperNameFocus;
        } else if (index == 3) {
          return addPickUpLocationProvider!.shipperEmailFocus;
        } else if (index == 4) {
          return addPickUpLocationProvider!.shipperPhoneFocus;
        } else if (index == 5) {
          return addPickUpLocationProvider!.cityFocus;
        } else if (index == 6) {
          return addPickUpLocationProvider!.stateFocus;
        } else if (index == 7) {
          return addPickUpLocationProvider!.countryFocus;
        } else if (index == 8) {
          return addPickUpLocationProvider!.pinCodeFocus;
        } else if (index == 9) {
          return addPickUpLocationProvider!.addressFocus;
        } else if (index == 10) {
          return addPickUpLocationProvider!.address2Focus;
        } else if (index == 11) {
          return addPickUpLocationProvider!.latitudeFocus;
        } else if (index == 12) {
          return addPickUpLocationProvider!.longitudeFocus;
        }
      }(),
      readOnly: false,
      textInputAction: index == 12
          ? TextInputAction.done
          : (index == 9 || index == 10)
              ? TextInputAction.newline
              : TextInputAction.next,
      style: const TextStyle(
        color: black,
        fontWeight: FontWeight.normal,
      ),
      controller: () {
        if (index == 1) {
          return addPickUpLocationProvider!.pickUpLocationController;
        } else if (index == 2) {
          return addPickUpLocationProvider!.shipperNameController;
        } else if (index == 3) {
          return addPickUpLocationProvider!.shipperEmailController;
        } else if (index == 4) {
          return addPickUpLocationProvider!.shipperPhoneController;
        } else if (index == 5) {
          return addPickUpLocationProvider!.cityController;
        } else if (index == 6) {
          return addPickUpLocationProvider!.stateController;
        } else if (index == 7) {
          return addPickUpLocationProvider!.countryController;
        } else if (index == 8) {
          return addPickUpLocationProvider!.pinCodeController;
        } else if (index == 9) {
          return addPickUpLocationProvider!.addressController;
        } else if (index == 10) {
          return addPickUpLocationProvider!.address2Controller;
        } else if (index == 11) {
          return addPickUpLocationProvider!.latitudeController;
        } else if (index == 12) {
          return addPickUpLocationProvider!.longitudeController;
        }
      }(),
      /*inputFormatters: [FilteringTextInputFormatter.singleLineFormatter],*/
      keyboardType: textType == 1
          ? TextInputType.multiline
          : textType == 2
              ? TextInputType.text
              : textType == 3
                  ? TextInputType.number
                  : textType == 4
                      ? TextInputType.phone
                      : TextInputType.emailAddress,
      inputFormatters:
          textType == 4 ? [FilteringTextInputFormatter.digitsOnly] : null,
      onChanged: (value) {
        if (index == 1) {
          addPickUpLocationProvider!.pickUpLocation = value;
        } else if (index == 2) {
          addPickUpLocationProvider!.name = value;
        } else if (index == 3) {
          addPickUpLocationProvider!.email = value;
        } else if (index == 4) {
          addPickUpLocationProvider!.phone = value;
        } else if (index == 5) {
          addPickUpLocationProvider!.city = value;
        } else if (index == 6) {
          addPickUpLocationProvider!.state = value;
        } else if (index == 7) {
          addPickUpLocationProvider!.country = value;
        } else if (index == 8) {
          addPickUpLocationProvider!.pinCode = value;
        } else if (index == 9) {
          addPickUpLocationProvider!.address = value;
        } else if (index == 10) {
          addPickUpLocationProvider!.address2 = value;
        } else if (index == 11) {
          addPickUpLocationProvider!.latitude = value;
        } else if (index == 12) {
          addPickUpLocationProvider!.longitude = value;
        }
      },
      validator: (val) => () {
        if (index == 3) {
          return StringValidation.validateEmail(val!, context);
        }
      }(),
      decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 13,
            vertical: 5,
          ),
          fillColor: grey1,
          filled: true,
          border: OutlineInputBorder(
            borderSide: BorderSide(color: grey2, width: 2),
            borderRadius: BorderRadius.circular(circularBorderRadius10),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: grey2, width: 2),
            borderRadius: BorderRadius.circular(circularBorderRadius10),
          ),
          hintStyle: const TextStyle(
            color: Colors.grey,
            fontSize: textFontSize14,
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: grey2, width: 2),
            borderRadius: BorderRadius.circular(circularBorderRadius10),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: grey2, width: 2),
            borderRadius: BorderRadius.circular(circularBorderRadius10),
          ),
          disabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: grey2, width: 2),
            borderRadius: BorderRadius.circular(circularBorderRadius10),
          ),
          hintText: title,
          errorMaxLines: 2,
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: grey2, width: 2),
            borderRadius: BorderRadius.circular(circularBorderRadius10),
          )),
      maxLength: index == 9 ? 80 : null,
      minLines: null,
      maxLines: index == 9 || index == 10 ? null : 1,
      //expands: false,
      //expands: index == 9 || index == 10 ? true : false,
    ),
  );
}
