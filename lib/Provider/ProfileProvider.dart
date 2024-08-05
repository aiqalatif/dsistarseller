import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mime/mime.dart';
import 'package:provider/provider.dart';
import 'package:sellermultivendor/Provider/settingProvider.dart';
import 'package:sellermultivendor/Widget/api.dart';
import '../Repository/profileRepositry.dart';
import '../Widget/security.dart';
import '../Widget/networkAvailablity.dart';
import '../Widget/parameterString.dart';
import '../Widget/sharedPreferances.dart';
import '../Widget/snackbar.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import '../Widget/validation.dart';

class ProfileProvider extends ChangeNotifier {
  String? name,
      email,
      mobile,
      address,
      curPass,
      newPass,
      confPass,
      loaction,
      accNo,
      storename,
      storeurl,
      storeDesc,
      accname,
      bankname,
      bankcode,
      latitutute,
      longitude,
      taxname,
      taxnumber,
      pannumber,
      status,
      storelogo,
      authSign;

  var selectedImageFromGellery, selectedAuthSign;
  bool isLoading = true;
  GlobalKey<FormState> sellernameKey = GlobalKey<FormState>();
  GlobalKey<FormState> mobilenumberKey = GlobalKey<FormState>();
  GlobalKey<FormState> emailKey = GlobalKey<FormState>();
  GlobalKey<FormState> addressKey = GlobalKey<FormState>();
  GlobalKey<FormState> storenameKey = GlobalKey<FormState>();
  GlobalKey<FormState> storeurlKey = GlobalKey<FormState>();
  GlobalKey<FormState> storeDescKey = GlobalKey<FormState>();
  GlobalKey<FormState> accnameKey = GlobalKey<FormState>();
  GlobalKey<FormState> accnumberKey = GlobalKey<FormState>();
  GlobalKey<FormState> bankcodeKey = GlobalKey<FormState>();
  GlobalKey<FormState> banknameKey = GlobalKey<FormState>();
  GlobalKey<FormState> latitututeKey = GlobalKey<FormState>();
  GlobalKey<FormState> longituteKey = GlobalKey<FormState>();
  GlobalKey<FormState> taxnameKey = GlobalKey<FormState>();
  GlobalKey<FormState> taxnumberKey = GlobalKey<FormState>();
  GlobalKey<FormState> pannumberKey = GlobalKey<FormState>();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController? nameC,
      emailC,
      mobileC,
      addressC,
      storenameC,
      storeurlC,
      storeDescC,
      accnameC,
      accnumberC,
      bankcodeC,
      banknameC,
      latitututeC,
      longituteC,
      taxnameC,
      taxnumberC,
      pannumberC,
      curPassC,
      newPassC,
      confPassC,
      unusedC;

  bool isSelected = false, isArea = true;
  bool showCurPassword = false, showPassword = false, showCmPassword = false;
  Animation? buttonSqueezeanimation;
  AnimationController? buttonController;

  initializeVariable() {
    name = null;
    email = null;
    mobile = null;
    address = null;
    curPass = null;
    newPass = null;
    confPass = null;
    loaction = null;
    accNo = null;
    storename = null;
    storeurl = null;
    storeDesc = null;
    accname = null;
    bankname = null;
    bankcode = null;
    latitutute = null;
    longitude = null;
    taxname = null;
    taxnumber = null;
    pannumber = null;
    status = null;
    storelogo = null;
    authSign = null;
    selectedImageFromGellery = null;
    selectedAuthSign = null;
    isLoading = true;
    isSelected = false;
    isArea = true;
    showCurPassword = false;
    showPassword = false;
    showCmPassword = false;
  }

  Future<void> getSallerDetail(
    BuildContext context,
    Function update,
  ) async {
    isNetworkAvail = await isNetworkAvailable();
    if (isNetworkAvail) {
      context.read<SettingProvider>().CUR_USERID = await getPrefrence(Id);
      var parameter = { };
      var result =
          await ProfileRepository.getSallerDetail(parameter: parameter);
      bool error = result["error"];
      if (!error) {
        var data = result["data"][0];
        CUR_BALANCE = double.parse(data[BALANCE]).toStringAsFixed(2);
        LOGO = data["logo"].toString();
        RATTING = data[Rating] ?? "";
        NO_OFF_RATTING = data[NoOfRatings] ?? "";
        name = data[Username];
        email = data[EmailText];
        mobile = data[Mobile];
        address = data[Address];
        storename = data[StoreName];
        storeurl = data[Storeurl];
        storeDesc = data[storeDescription];
        accNo = data[accountNumber];
        accname = data[accountName];
        bankcode = data[BankCOde];
        bankname = data[bankNAme];
        latitutute = data[Latitude];
        longitude = data[Longitude];
        taxname = data[taxName];
        taxnumber = data[taxNumber];
        pannumber = data[panNumber];
        status = data[STATUS];
        storelogo = data[StoreLogo];
        authSign = data[AuthSign];
        mobileC!.text = mobile ?? "";
        nameC!.text = name ?? "";
        emailC!.text = email ?? "";
        addressC!.text = address ?? "";
        storenameC!.text = storename ?? "";
        storeurlC!.text = storeurl ?? "";
        storeDescC!.text = storeDesc ?? "";
        accnameC!.text = accname ?? "";
        accnumberC!.text = accNo ?? "";
        bankcodeC!.text = bankcode ?? "";
        banknameC!.text = bankname ?? "";
        latitututeC!.text = latitutute ?? "";
        longituteC!.text = longitude ?? "";
        taxnameC!.text = taxname ?? "";
        taxnumberC!.text = taxnumber ?? "";
        pannumberC!.text = pannumber ?? "";
      }
      isLoading = false;
      update();
    } else {
      isNetworkAvail = false;
      isLoading = false;
      update();
    }
    return;
  }

  Future<void> setUpdateUser(
    BuildContext context,
    Function update,
  ) async {
    var parameter = {
      // Id: context.read<SettingProvider>().CUR_USERID,
      Name: name ?? "",
      Mobile: mobile ?? "",
      EmailText: email ?? "",
      Address: address ?? "",
      StoreName: storename ?? "",
      Storeurl: storeurl ?? "",
      storeDescription: storeDesc ?? "",
      accountNumber: accNo ?? "",
      accountName: accname ?? "",
      bankCode: bankcode ?? "",
      bankName: bankname ?? "",
      Latitude: latitutute ?? "",
      Longitude: longitude ?? "",
      taxName: taxname ?? "",
      taxNumber: taxnumber ?? "",
      panNumber: pannumber ?? "",
      STATUS: status ?? "1",
      //AuthSign: selectedAuthSign ?? (authSign ?? "")
    };
    var result = await ProfileRepository.updateUser(parameter: parameter);

    bool error = result["error"];
    String? msg = result["message"];
    if (!error) {
      await buttonController!.reverse();
      setSnackbar(msg!, context);
    } else {
      await buttonController!.reverse();
      setSnackbar(msg!, context);
      update();
    }
  }

  Future<void> updateProfilePic(
    BuildContext context,
    Function update,
  ) async {
    isNetworkAvail = await isNetworkAvailable();
    if (isNetworkAvail) {
      try {
        var request = http.MultipartRequest("POST", updateUserApi);
        request.headers.addAll(headers);
        // request.fields[Id] = context.read<SettingProvider>().CUR_USERID!;
        request.fields[Name] = name ?? "";
        request.fields[Mobile] = mobile ?? "";
        request.fields[EmailText] = email ?? "";
        request.fields[Address] = address ?? "";
        request.fields[StoreName] = storename ?? "";
        request.fields[Storeurl] = storeurl ?? "";
        request.fields[storeDescription] = storeDesc ?? "";
        request.fields[accountNumber] = accNo ?? "";
        request.fields[accountName] = accname ?? "";
        request.fields[bankCode] = bankcode ?? "";
        request.fields[bankName] = bankname ?? "";
        request.fields[Latitude] = latitutute ?? "";
        request.fields[Longitude] = longitude ?? "";
        request.fields[taxName] = taxname ?? "";
        request.fields[taxNumber] = taxnumber ?? "";
        request.fields[panNumber] = pannumber ?? "";
        request.fields[STATUS] = status ?? "1";
        if (selectedImageFromGellery != null) {
          final mimeType = lookupMimeType(selectedImageFromGellery.path);
          var extension = mimeType!.split("/");
          var storelogo = await http.MultipartFile.fromPath(
            "store_logo",
            selectedImageFromGellery.path,
            contentType: MediaType('image', extension[1]),
          );
          request.files.add(storelogo);
        }
        print("authorized sign****$selectedAuthSign");
        if (selectedAuthSign != null) {
          final mimeType = lookupMimeType(selectedAuthSign.path);
          var extension = mimeType!.split("/");
          var authSign = await http.MultipartFile.fromPath(
            AuthSign,
            selectedAuthSign.path,
            contentType: MediaType('image', extension[1]),
          );
          request.files.add(authSign);
        }
        var response = await request.send();
        var responseData = await response.stream.toBytes();
        var responseString = String.fromCharCodes(responseData);
        var getdata = json.decode(responseString);
        print("image getdata****$getdata");
        bool error = getdata["error"];
        String msg = getdata['message'];
        if (!error) {
          setSnackbar(msg, context);
          getSallerDetail(context, update);
        } else {
          setSnackbar(msg, context);
          isLoading = false;
        }
      } on TimeoutException catch (_) {
        setSnackbar(
          getTranslated(context, 'somethingMSg')!,
          context,
        );
      }
    } else {
      Future.delayed(
        const Duration(seconds: 2),
      ).then(
        (_) async {
          isNetworkAvail = false;
          update();
        },
      );
    }
  }

  Future<void> changePassWord(
    BuildContext context,
    Function update,
  ) async {
    isNetworkAvail = await isNetworkAvailable();
    if (isNetworkAvail) {
      var parameter = {
        // Id: context.read<SettingProvider>().CUR_USERID,
        Name: name ?? "",
        Mobile: mobile ?? "",
        EmailText: email ?? "",
        Address: address ?? "",
        StoreName: storename ?? "",
        Storeurl: storeurl ?? "",
        storeDescription: storeDesc ?? "",
        accountNumber: accNo ?? "",
        accountName: accname ?? "",
        bankCode: bankcode ?? "",
        bankName: bankname ?? "",
        Latitude: latitutute ?? "",
        Longitude: longitude ?? "",
        taxName: taxname ?? "",
        taxNumber: taxnumber ?? "",
        panNumber: pannumber ?? "",
        STATUS: status ?? "1",
        OLDPASS: curPass,
        NEWPASS: newPass,
      };
      var result = await ProfileRepository.updateUser(parameter: parameter);

      bool error = result["error"];
      String? msg = result["message"];
      if (!error) {
        setSnackbar(msg!, context);
      } else {
        setSnackbar(msg!, context);
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
