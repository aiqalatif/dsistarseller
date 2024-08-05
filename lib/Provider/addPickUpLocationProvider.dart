import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sellermultivendor/Provider/settingProvider.dart';
import '../Widget/api.dart';
import '../Widget/security.dart';
import '../Widget/networkAvailablity.dart';
import 'package:http/http.dart' as http;
import '../Widget/parameterString.dart';
import '../Widget/routes.dart';
import '../Widget/snackbar.dart';
import '../Widget/validation.dart';

enum AddPickUpLocationStatus {
  initial,
  inProgress,
  isSuccsess,
  isFailure,
}

class AddPickUpLocationProvider extends ChangeNotifier {
// update status

  AddPickUpLocationStatus addPickUpLocationStatus =
      AddPickUpLocationStatus.initial;

  changeStatus(AddPickUpLocationStatus status) {
    addPickUpLocationStatus = status;
    notifyListeners();
  }

  freshInitializationOfAddPickUpLocation() {
    pickUpLocationController.clear();
    shipperNameController.clear();
    shipperPhoneController.clear();
    shipperEmailController.clear();
    cityController.clear();
    stateController.clear();
    countryController.clear();
    pinCodeController.clear();
    addressController.clear();
    address2Controller.clear();
    latitudeController.clear();
    longitudeController.clear();
    pickUpLocation = null;
    name = null;
    email = null;
    phone = null;
    city = null;
    state = null;
    country = null;
    pinCode = null;
    address = null;
    address2 = null;
    latitude = null;
    longitude = null;
  }

  FocusNode? pickUpLocationFocus,
      shipperNameFocus,
      shipperEmailFocus,
      shipperPhoneFocus,
      cityFocus,
      stateFocus,
      countryFocus,
      pinCodeFocus,
      addressFocus,
      address2Focus,
      latitudeFocus,
      longitudeFocus = FocusNode();

//------------------------------------------------------------------------------
//======================= TextEditingController ================================

  TextEditingController pickUpLocationController = TextEditingController();
  TextEditingController shipperNameController = TextEditingController();
  TextEditingController shipperEmailController = TextEditingController();
  TextEditingController shipperPhoneController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController pinCodeController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController address2Controller = TextEditingController();
  TextEditingController latitudeController = TextEditingController();
  TextEditingController longitudeController = TextEditingController();
  AnimationController? buttonController;
  Animation? buttonSqueezeanimation;

// <===  add pick up location data ===>
  String? pickUpLocation;
  String? name;
  String? email;
  String? phone;
  String? city;
  String? state;
  String? country;
  String? pinCode;
  String? address;
  String? address2;
  String? latitude;
  String? longitude;

  Future<void> addPickUpLocationAPI(
    BuildContext context,
    Function update,
  ) async {
    isNetworkAvail = await isNetworkAvailable();
    if (isNetworkAvail) {
      try {
        var request = http.MultipartRequest("POST", addPickUpLocationApi);

        request.headers.addAll(headers);
        // request.fields[SellerId] = context.read<SettingProvider>().currentUerID;
        request.fields[PICKUP_LOCATION] = pickUpLocation!;
        request.fields[Name] = name!;
        request.fields[EmailText] = email!;
        request.fields[PHONE] = phone!;
        request.fields[City] = city!;
        request.fields[STATE] = state!;
        request.fields[COUNTRY] = country!;
        request.fields[Pincode] = pinCode!;
        request.fields[Address] = address!;

        request.fields[Name] = name!;

        request.fields[Address2] = address2!;

        request.fields[Latitude] = latitude!;

        request.fields[Longitude] = longitude!;

        print("request field****${request.fields}");
        var response = await request.send();
        var responseData = await response.stream.toBytes();
        var responseString = String.fromCharCodes(responseData);
        var getdata = json.decode(responseString);
        print("getdata****add pickup location****$getdata");
        bool error = getdata["error"];
        String msg = getdata['message'];
        if (!error) {
          await buttonController!.reverse();
          setSnackbar(msg, context);

          freshInitializationOfAddPickUpLocation();
          update();
          Routes.navigateToPickUpLocationList(context);
        } else {
          await buttonController!.reverse();
          setSnackbar(msg, context);
        }
      } on TimeoutException catch (_) {
        setSnackbar(
          getTranslated(context, 'somethingMSg')!,
          context,
        );
      }
    } else {
      Future.delayed(const Duration(seconds: 2)).then(
        (_) async {
          await buttonController!.reverse();
          isNetworkAvail = false;
          update();
        },
      );
    }
  }
}
