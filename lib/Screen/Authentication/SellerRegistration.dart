import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mime/mime.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import '../../Helper/ApiBaseHelper.dart';
import '../../Helper/Color.dart';
import '../../Helper/Constant.dart';
import '../../Widget/ButtonDesing.dart';
import '../../Provider/settingProvider.dart';
import '../../Widget/security.dart';
import '../../Widget/networkAvailablity.dart';
import '../../Widget/overylay.dart';
import '../../Widget/parameterString.dart';
import '../../Widget/api.dart';
import '../../Widget/desing.dart';
import '../../Widget/validation.dart';
import '../../Widget/noNetwork.dart';

class SellerRegister extends StatefulWidget {
  const SellerRegister({Key? key}) : super(key: key);

  @override
  _SellerRegisterState createState() => _SellerRegisterState();
}

class _SellerRegisterState extends State<SellerRegister>
    with TickerProviderStateMixin {
//==============================================================================
//============================= Variables Declaration ==========================

  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController mobilenumberController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController storeController = TextEditingController();
  TextEditingController storeUrlController = TextEditingController();
  TextEditingController storeDescriptionController = TextEditingController();
  TextEditingController taxNameController = TextEditingController();
  TextEditingController taxNumberController = TextEditingController();
  TextEditingController panNumberController = TextEditingController();
  TextEditingController accountNumberController = TextEditingController();
  TextEditingController accountNameController = TextEditingController();
  TextEditingController bankCodeController = TextEditingController();
  TextEditingController bankNameController = TextEditingController();
  FocusNode? nameFocus,
      emailFocus,
      passFocus,
      confirmPassFocus,
      addressFocus,
      storeFocus,
      storeUrlFocus,
      storeDescriptionFocus,
      taxNameFocus,
      taxNumberFocus,
      panNumberFocus,
      accountNumberFocus,
      accountNameFocus,
      bankCodeFocus,
      bankNameFocus,
      monumberFocus = FocusNode();
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  Animation? buttonSqueezeanimation;
  AnimationController? buttonController;
  ApiBaseHelper apiBaseHelper = ApiBaseHelper();
  final mobileController = TextEditingController();
  var addressProfFile,
      nationalIdentityCardFile,
      storeLogoFile,
      authorizedSignFile;
  String? mobile,
      name,
      email,
      password,
      confirmpassword,
      address,
      addressproof,
      authorizedSign,
      nationalidentitycard,
      storename,
      storelogo,
      storeurl,
      storedescription,
      taxname,
      taxnumber,
      pannumber,
      accountnumber,
      accountname,
      bankcode,
      bankname;

//==============================================================================
//============================= INIT Method ====================================

  @override
  void initState() {
    super.initState();
    buttonController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);

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

//==============================================================================
//============================= For API Call ==================================

  Future<void> sellerRegisterAPI() async {
    isNetworkAvail = await isNetworkAvailable();
    if (isNetworkAvail) {
      try {
        var request = http.MultipartRequest("POST", registerApi);
        request.headers.addAll(headers);
        request.fields[Name] = name!;
        request.fields[Mobile] = mobile!;
        request.fields[Password] = password!;
        request.fields[EmailText] = email!;
        request.fields[ConfirmPassword] = confirmpassword!;
        request.fields[Address] = address!;
        if (addressProfFile != null) {
          final mimeType = lookupMimeType(addressProfFile.path);
          var extension = mimeType!.split("/");
          var addproff = await http.MultipartFile.fromPath(
            AddressProof,
            addressProfFile.path,
            contentType: MediaType('image', extension[1]),
          );
          request.files.add(addproff);
        }
        /* else {
          showOverlay(
              getTranslated(context, "please upload address prof")!, context);
          await buttonController!.reverse();
          return;
        }*/

        if (authorizedSignFile != null) {
          final mimeType = lookupMimeType(authorizedSignFile.path);
          var extension = mimeType!.split("/");
          var authSign = await http.MultipartFile.fromPath(
            AuthSign,
            authorizedSignFile.path,
            contentType: MediaType('image', extension[1]),
          );
          request.files.add(authSign);
        }
        if (nationalIdentityCardFile != null) {
          final mimeType = lookupMimeType(nationalIdentityCardFile.path);
          var extension = mimeType!.split("/");
          var nationalproff = await http.MultipartFile.fromPath(
            NationalIdentityCard,
            nationalIdentityCardFile.path,
            contentType: MediaType('image', extension[1]),
          );
          request.files.add(nationalproff);
        }
        /*else {
          showOverlay(
            getTranslated(context, "please upload natinal Identity Card")!,
            context,
          );
          await buttonController!.reverse();
          return;
        }*/
        if (storeLogoFile != null) {
          final mimeType = lookupMimeType(storeLogoFile.path);
          var extension = mimeType!.split("/");
          var storelogo = await http.MultipartFile.fromPath(
            "store_logo",
            storeLogoFile.path,
            contentType: MediaType('image', extension[1]),
          );
          request.files.add(storelogo);
        }
        /* else {
          showOverlay(
            getTranslated(context, "please upload store logo")!,
            context,
          );
          await buttonController!.reverse();
          return;
        }*/

        if (storeurl != null) {
          request.fields[Storeurl] = storeurl!;
        }

        request.fields[StoreName] = storename!;

        request.fields[storeDescription] = storedescription!;
        request.fields[tax_name] = taxname!;
        request.fields[tax_number] = taxnumber!;
        request.fields[pan_number] = pannumber!;
        request.fields[account_number] = accountnumber!;
        request.fields[account_name] = accountname!;
        request.fields[bank_name] = bankname!;
        request.fields["bank_code"] = bankcode!;

        var response = await request.send();
        var responseData = await response.stream.toBytes();
        var responseString = String.fromCharCodes(responseData);
        var getdata = json.decode(responseString);
        bool error = getdata["error"];
        String? msg = getdata['message'];
        if (!error) {
          await buttonController!.reverse();
          showMsgDialog(msg!, true);
        } else {
          await buttonController!.reverse();
          showMsgDialog(msg!, false);
        }
      } on TimeoutException catch (_) {
        showOverlay(
          getTranslated(context, 'somethingMSg')!,
          context,
        );
      }
    } else {
      if (mounted) {
        setState(
          () {
            isNetworkAvail = false;
          },
        );
      }
    }
  }

  showMsgDialog(String msg, bool goBack) async {
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
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            msg,
                            style: Theme.of(this.context)
                                .textTheme
                                .titleMedium!
                                .copyWith(color: fontColor),
                            maxLines: 5,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
    if (goBack == true && context.mounted) {
      Navigator.of(context).pop();
    }
  }

//==============================================================================
//============================= For Animation ==================================

  Future<void> _playAnimation() async {
    try {
      await buttonController!.forward();
    } on TickerCanceled {}
  }

  void validateAndSubmit() async {
    if (validateAndSave()) {
      _playAnimation();
      checkNetwork();
    }
  }

//==============================================================================
//============================= Network Checking ===============================

  Future<void> checkNetwork() async {
    isNetworkAvail = await isNetworkAvailable();
    if (isNetworkAvail) {
      sellerRegisterAPI();
    } else {
      Future.delayed(
        const Duration(seconds: 2),
      ).then(
        (_) async {
          await buttonController!.reverse();
          setState(
            () {
              isNetworkAvail = false;
            },
          );
        },
      );
    }
  }

  bool validateAndSave() {
    final form = _formkey.currentState!;
    form.save();
    if (form.validate()) {
      return true;
    }
    return false;
  }

//==============================================================================
//============================= Dispose Method =================================

  @override
  void dispose() {
    buttonController!.dispose();
    super.dispose();
  }

//==============================================================================
//============================= No Internet Widget =============================
  setStateNoInternate() async {
    _playAnimation();

    Future.delayed(const Duration(seconds: 2)).then(
      (_) async {
        isNetworkAvail = await isNetworkAvailable();
        if (isNetworkAvail) {
          Navigator.pushReplacement(
            context,
            CupertinoPageRoute(builder: (BuildContext context) => super.widget),
          );
        } else {
          await buttonController!.reverse();
          setState(
            () {},
          );
        }
      },
    );
  }

//==============================================================================
//============================= Build Method ===================================

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return ScaffoldMessenger(
      key: scaffoldMessengerKey,
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: white,
        body: isNetworkAvail
            ? getLoginContainer()
            : noInternet(
                context,
                setStateNoInternate,
                buttonSqueezeanimation,
                buttonController,
              ),
      ),
    );
  }

//==============================================================================
//============================= Login Container widget =========================

  getLoginContainer() {
    return Container(
      alignment: Alignment.center,
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      color: white,
      child: Form(
        key: _formkey,
        child: SingleChildScrollView(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  getLogo(),
                  setSignInLabel(),
                  setName(),
                  setEmail(),
                  setMobileNo(),
                  setPass(),
                  confirmPassword(),
                  setaddress(),
                  storeName(),
                  storeUrl(),
                  setStoreDescription(),
                  taxName(),
                  taxNumber(),
                  panNumber(),
                  accountNumber(),
                  accountName(),
                  bankCode(),
                  bankName(),
                  uploadStoreLogo(getTranslated(context, "Store Logo")!, 1),
                  selectedMainImageShow(storeLogoFile),
                  uploadStoreLogo(
                      getTranslated(context, "National Identity Card")!, 2),
                  selectedMainImageShow(nationalIdentityCardFile),
                  uploadStoreLogo(getTranslated(context, "Address Proof")!, 3),
                  selectedMainImageShow(addressProfFile),
                  uploadStoreLogo(
                      getTranslated(context, "Authorized Signature")!, 4),
                  selectedMainImageShow(authorizedSignFile),
                  loginBtn(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  uploadStoreLogo(String title, int number) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.90,
      padding: const EdgeInsets.only(
        top: 30.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
          ),
          InkWell(
            child: Container(
              decoration: BoxDecoration(
                color: primary,
                borderRadius: BorderRadius.circular(circularBorderRadius5),
              ),
              width: 90,
              height: 40,
              child: Center(
                child: Text(
                  getTranslated(context, "Upload")!,
                  style: const TextStyle(
                    color: white,
                  ),
                ),
              ),
            ),
            onTap: () {
              mainImageFromGallery(number);
            },
          ),
        ],
      ),
    );
  }

  mainImageFromGallery(int number) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'gif', 'bmp', 'eps'],
    );
    if (result != null) {
      File image = File(result.files.single.path!);

      setState(
        () {
          if (number == 1) {
            storeLogoFile = image;
          }
          if (number == 2) {
            nationalIdentityCardFile = image;
          }
          if (number == 3) {
            addressProfFile = image;
          }
          if (number == 4) {
            authorizedSignFile = image;
          }
        },
      );
    } else {
      // User canceled the picker
      return 'Required this filed';
    }
  }

  selectedMainImageShow(File? name) {
    return name == null
        ? Container()
        : Image.file(
            name,
            width: 100,
            height: 100,
          );
  }

  Widget setSignInLabel() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Align(
        alignment: Alignment.center,
        child: Text(
          getTranslated(context, "Seller Registration")!,
          style: const TextStyle(
            color: primary,
            fontSize: textFontSize30,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  setName() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.90,
      padding: const EdgeInsets.only(
        top: 30.0,
      ),
      child: TextFormField(
        onFieldSubmitted: (v) {
          FocusScope.of(context).requestFocus(nameFocus);
        },
        keyboardType: TextInputType.text,
        controller: nameController,
        style: const TextStyle(
          color: fontColor,
          fontWeight: FontWeight.normal,
        ),
        focusNode: nameFocus,
        textInputAction: TextInputAction.next,
        inputFormatters: [FilteringTextInputFormatter.singleLineFormatter],
        validator: (val) =>
            StringValidation.validateThisFieldRequered(val!, context),
        onSaved: (String? value) {
          name = value;
        },
        decoration: InputDecoration(
          focusedBorder: UnderlineInputBorder(
            borderSide: const BorderSide(color: primary),
            borderRadius: BorderRadius.circular(circularBorderRadius7),
          ),
          prefixIcon: const Icon(
            Icons.person,
            color: lightBlack2,
            size: 20,
          ),
          hintText: getTranslated(context, "Name")!,
          hintStyle: Theme.of(context).textTheme.titleSmall!.copyWith(
                color: lightBlack2,
                fontWeight: FontWeight.normal,
              ),
          filled: true,
          fillColor: white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 5,
          ),
          prefixIconConstraints: const BoxConstraints(
            minWidth: 40,
            maxHeight: 20,
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: const BorderSide(color: lightBlack2),
            borderRadius: BorderRadius.circular(circularBorderRadius7),
          ),
        ),
      ),
    );
  }

  bankCode() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.90,
      padding: const EdgeInsets.only(
        top: 30.0,
      ),
      child: TextFormField(
        onFieldSubmitted: (v) {
          FocusScope.of(context).requestFocus(bankCodeFocus);
        },
        keyboardType: TextInputType.text,
        controller: bankCodeController,
        style: const TextStyle(
          color: fontColor,
          fontWeight: FontWeight.normal,
        ),
        focusNode: bankCodeFocus,
        textInputAction: TextInputAction.next,
        inputFormatters: [FilteringTextInputFormatter.singleLineFormatter],
        validator: (val) =>
            StringValidation.validateThisFieldRequered(val!, context),
        onSaved: (String? value) {
          bankcode = value;
        },
        decoration: InputDecoration(
          focusedBorder: UnderlineInputBorder(
            borderSide: const BorderSide(color: primary),
            borderRadius: BorderRadius.circular(circularBorderRadius7),
          ),
          prefixIcon: const Icon(
            Icons.format_list_numbered,
            color: lightBlack2,
            size: 20,
          ),
          hintText: getTranslated(context, "BankCode")!,
          hintStyle: Theme.of(context).textTheme.titleSmall!.copyWith(
                color: lightBlack2,
                fontWeight: FontWeight.normal,
              ),
          filled: true,
          fillColor: white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 5,
          ),
          prefixIconConstraints: const BoxConstraints(
            minWidth: 40,
            maxHeight: 20,
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: const BorderSide(color: lightBlack2),
            borderRadius: BorderRadius.circular(circularBorderRadius7),
          ),
        ),
      ),
    );
  }

  bankName() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.90,
      padding: const EdgeInsets.only(
        top: 30.0,
      ),
      child: TextFormField(
        onFieldSubmitted: (v) {
          FocusScope.of(context).requestFocus(bankNameFocus);
        },
        keyboardType: TextInputType.text,
        controller: bankNameController,
        style: const TextStyle(
          color: fontColor,
          fontWeight: FontWeight.normal,
        ),
        focusNode: bankNameFocus,
        textInputAction: TextInputAction.next,
        inputFormatters: [FilteringTextInputFormatter.singleLineFormatter],
        validator: (val) =>
            StringValidation.validateThisFieldRequered(val!, context),
        onSaved: (String? value) {
          bankname = value;
        },
        decoration: InputDecoration(
          focusedBorder: UnderlineInputBorder(
            borderSide: const BorderSide(color: primary),
            borderRadius: BorderRadius.circular(circularBorderRadius7),
          ),
          prefixIcon: const Icon(
            Icons.account_balance,
            color: lightBlack2,
            size: 20,
          ),
          hintText: getTranslated(context, "BankName")!,
          hintStyle: Theme.of(context).textTheme.titleSmall!.copyWith(
                color: lightBlack2,
                fontWeight: FontWeight.normal,
              ),
          filled: true,
          fillColor: white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 5,
          ),
          prefixIconConstraints: const BoxConstraints(
            minWidth: 40,
            maxHeight: 20,
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: const BorderSide(color: lightBlack2),
            borderRadius: BorderRadius.circular(circularBorderRadius7),
          ),
        ),
      ),
    );
  }

  panNumber() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.90,
      padding: const EdgeInsets.only(
        top: 30.0,
      ),
      child: TextFormField(
        onFieldSubmitted: (v) {
          FocusScope.of(context).requestFocus(panNumberFocus);
        },
        keyboardType: TextInputType.text,
        controller: panNumberController,
        style: const TextStyle(
          color: fontColor,
          fontWeight: FontWeight.normal,
        ),
        focusNode: panNumberFocus,
        textInputAction: TextInputAction.next,
        inputFormatters: [FilteringTextInputFormatter.singleLineFormatter],
        validator: (val) =>
            StringValidation.validateThisFieldRequered(val!, context),
        onSaved: (String? value) {
          pannumber = value;
        },
        decoration: InputDecoration(
          focusedBorder: UnderlineInputBorder(
            borderSide: const BorderSide(color: primary),
            borderRadius: BorderRadius.circular(circularBorderRadius7),
          ),
          prefixIcon: const Icon(
            Icons.credit_card,
            color: lightBlack2,
            size: 20,
          ),
          hintText: getTranslated(context, "PanNumber")!,
          hintStyle: Theme.of(context).textTheme.titleSmall!.copyWith(
                color: lightBlack2,
                fontWeight: FontWeight.normal,
              ),
          filled: true,
          fillColor: white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 5,
          ),
          prefixIconConstraints: const BoxConstraints(
            minWidth: 40,
            maxHeight: 20,
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: const BorderSide(color: lightBlack2),
            borderRadius: BorderRadius.circular(circularBorderRadius7),
          ),
        ),
      ),
    );
  }

  accountNumber() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.90,
      padding: const EdgeInsets.only(
        top: 30.0,
      ),
      child: TextFormField(
        onFieldSubmitted: (v) {
          FocusScope.of(context).requestFocus(accountNumberFocus);
        },
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        controller: accountNumberController,
        style: const TextStyle(
          color: fontColor,
          fontWeight: FontWeight.normal,
        ),
        focusNode: accountNumberFocus,
        textInputAction: TextInputAction.next,
        //inputFormatters: [FilteringTextInputFormatter.singleLineFormatter],
        validator: (val) =>
            StringValidation.validateThisFieldRequered(val!, context),
        onSaved: (String? value) {
          accountnumber = value;
        },
        decoration: InputDecoration(
          focusedBorder: UnderlineInputBorder(
            borderSide: const BorderSide(color: primary),
            borderRadius: BorderRadius.circular(circularBorderRadius7),
          ),
          prefixIcon: const Icon(
            Icons.account_box_outlined,
            color: lightBlack2,
            size: 20,
          ),
          hintText: getTranslated(context, "AccountNumber")!,
          hintStyle: Theme.of(context).textTheme.titleSmall!.copyWith(
                color: lightBlack2,
                fontWeight: FontWeight.normal,
              ),
          filled: true,
          fillColor: white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 5,
          ),
          prefixIconConstraints: const BoxConstraints(
            minWidth: 40,
            maxHeight: 20,
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: const BorderSide(color: lightBlack2),
            borderRadius: BorderRadius.circular(circularBorderRadius7),
          ),
        ),
      ),
    );
  }

  accountName() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.90,
      padding: const EdgeInsets.only(
        top: 30.0,
      ),
      child: TextFormField(
        onFieldSubmitted: (v) {
          FocusScope.of(context).requestFocus(accountNameFocus);
        },
        keyboardType: TextInputType.text,
        controller: accountNameController,
        style: const TextStyle(
          color: fontColor,
          fontWeight: FontWeight.normal,
        ),
        focusNode: accountNameFocus,
        textInputAction: TextInputAction.next,
        inputFormatters: [FilteringTextInputFormatter.singleLineFormatter],
        validator: (val) =>
            StringValidation.validateThisFieldRequered(val!, context),
        onSaved: (String? value) {
          accountname = value;
        },
        decoration: InputDecoration(
          focusedBorder: UnderlineInputBorder(
            borderSide: const BorderSide(color: primary),
            borderRadius: BorderRadius.circular(circularBorderRadius7),
          ),
          prefixIcon: const Icon(
            Icons.account_box_rounded,
            color: lightBlack2,
            size: 20,
          ),
          hintText: getTranslated(context, "AccountName")!,
          hintStyle: Theme.of(context).textTheme.titleSmall!.copyWith(
                color: lightBlack2,
                fontWeight: FontWeight.normal,
              ),
          filled: true,
          fillColor: white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 5,
          ),
          prefixIconConstraints: const BoxConstraints(
            minWidth: 40,
            maxHeight: 20,
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: const BorderSide(color: lightBlack2),
            borderRadius: BorderRadius.circular(circularBorderRadius7),
          ),
        ),
      ),
    );
  }

  taxName() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.90,
      padding: const EdgeInsets.only(
        top: 30.0,
      ),
      child: TextFormField(
        onFieldSubmitted: (v) {
          FocusScope.of(context).requestFocus(taxNameFocus);
        },
        keyboardType: TextInputType.text,
        controller: taxNameController,
        style: const TextStyle(
          color: fontColor,
          fontWeight: FontWeight.normal,
        ),
        focusNode: taxNameFocus,
        textInputAction: TextInputAction.next,
        inputFormatters: [FilteringTextInputFormatter.singleLineFormatter],
        validator: (val) =>
            StringValidation.validateThisFieldRequered(val!, context),
        onSaved: (String? value) {
          taxname = value;
        },
        decoration: InputDecoration(
          focusedBorder: UnderlineInputBorder(
            borderSide: const BorderSide(color: primary),
            borderRadius: BorderRadius.circular(circularBorderRadius7),
          ),
          prefixIcon: const Icon(
            Icons.person,
            color: lightBlack2,
            size: 20,
          ),
          hintText: getTranslated(context, "TaxName"),
          hintStyle: Theme.of(context).textTheme.titleSmall!.copyWith(
                color: lightBlack2,
                fontWeight: FontWeight.normal,
              ),
          filled: true,
          fillColor: white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 5,
          ),
          prefixIconConstraints: const BoxConstraints(
            minWidth: 40,
            maxHeight: 20,
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: const BorderSide(color: lightBlack2),
            borderRadius: BorderRadius.circular(circularBorderRadius7),
          ),
        ),
      ),
    );
  }

  taxNumber() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.90,
      padding: const EdgeInsets.only(
        top: 30.0,
      ),
      child: TextFormField(
        onFieldSubmitted: (v) {
          FocusScope.of(context).requestFocus(taxNumberFocus);
        },
        keyboardType: TextInputType.text,
        controller: taxNumberController,
        style: const TextStyle(
          color: fontColor,
          fontWeight: FontWeight.normal,
        ),
        focusNode: taxNameFocus,
        textInputAction: TextInputAction.next,
        inputFormatters: [FilteringTextInputFormatter.singleLineFormatter],
        validator: (val) =>
            StringValidation.validateThisFieldRequered(val!, context),
        onSaved: (String? value) {
          taxnumber = value;
        },
        decoration: InputDecoration(
          focusedBorder: UnderlineInputBorder(
            borderSide: const BorderSide(color: primary),
            borderRadius: BorderRadius.circular(circularBorderRadius7),
          ),
          prefixIcon: const Icon(
            Icons.format_list_numbered_outlined,
            color: lightBlack2,
            size: 20,
          ),
          hintText: getTranslated(context, "TaxNumber")!,
          hintStyle: Theme.of(context).textTheme.titleSmall!.copyWith(
                color: lightBlack2,
                fontWeight: FontWeight.normal,
              ),
          filled: true,
          fillColor: white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 5,
          ),
          prefixIconConstraints: const BoxConstraints(
            minWidth: 40,
            maxHeight: 20,
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: const BorderSide(color: lightBlack2),
            borderRadius: BorderRadius.circular(circularBorderRadius7),
          ),
        ),
      ),
    );
  }

  setStoreDescription() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.90,
      padding: const EdgeInsets.only(
        top: 30.0,
      ),
      child: TextFormField(
        onFieldSubmitted: (v) {
          FocusScope.of(context).requestFocus(storeDescriptionFocus);
        },
        keyboardType: TextInputType.text,
        controller: storeDescriptionController,
        style: const TextStyle(
          color: fontColor,
          fontWeight: FontWeight.normal,
        ),
        focusNode: storeDescriptionFocus,
        textInputAction: TextInputAction.next,
        inputFormatters: [FilteringTextInputFormatter.singleLineFormatter],
        validator: (val) =>
            StringValidation.validateThisFieldRequered(val!, context),
        onSaved: (String? value) {
          storedescription = value;
        },
        decoration: InputDecoration(
          focusedBorder: UnderlineInputBorder(
            borderSide: const BorderSide(color: primary),
            borderRadius: BorderRadius.circular(circularBorderRadius7),
          ),
          prefixIcon: const Icon(
            Icons.description,
            color: lightBlack2,
            size: 20,
          ),
          hintText: getTranslated(context, "Store Description")!,
          hintStyle: Theme.of(context).textTheme.titleSmall!.copyWith(
                color: lightBlack2,
                fontWeight: FontWeight.normal,
              ),
          filled: true,
          fillColor: white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 5,
          ),
          prefixIconConstraints: const BoxConstraints(
            minWidth: 40,
            maxHeight: 20,
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: const BorderSide(color: lightBlack2),
            borderRadius: BorderRadius.circular(circularBorderRadius7),
          ),
        ),
      ),
    );
  }

  storeUrl() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.90,
      padding: const EdgeInsets.only(
        top: 30.0,
      ),
      child: TextFormField(
        onFieldSubmitted: (v) {
          FocusScope.of(context).requestFocus(storeUrlFocus);
        },
        keyboardType: TextInputType.text,
        controller: storeUrlController,
        style: const TextStyle(
          color: fontColor,
          fontWeight: FontWeight.normal,
        ),
        focusNode: storeUrlFocus,
        textInputAction: TextInputAction.next,
        inputFormatters: [FilteringTextInputFormatter.singleLineFormatter],
        /*validator: (val) =>
            StringValidation.validateThisFieldRequered(val!, context),*/
        onSaved: (String? value) {
          storeurl = value;
        },
        decoration: InputDecoration(
          focusedBorder: UnderlineInputBorder(
            borderSide: const BorderSide(color: primary),
            borderRadius: BorderRadius.circular(circularBorderRadius7),
          ),
          prefixIcon: const Icon(
            Icons.link,
            color: lightBlack2,
            size: 20,
          ),
          hintText: getTranslated(context, "StoreURL")!,
          hintStyle: Theme.of(context).textTheme.titleSmall!.copyWith(
                color: lightBlack2,
                fontWeight: FontWeight.normal,
              ),
          filled: true,
          fillColor: white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 5,
          ),
          prefixIconConstraints: const BoxConstraints(
            minWidth: 40,
            maxHeight: 20,
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: const BorderSide(color: lightBlack2),
            borderRadius: BorderRadius.circular(circularBorderRadius7),
          ),
        ),
      ),
    );
  }

  storeName() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.90,
      padding: const EdgeInsets.only(
        top: 30.0,
      ),
      child: TextFormField(
        onFieldSubmitted: (v) {
          FocusScope.of(context).requestFocus(storeFocus);
        },
        keyboardType: TextInputType.text,
        controller: storeController,
        style: const TextStyle(
          color: fontColor,
          fontWeight: FontWeight.normal,
        ),
        focusNode: storeFocus,
        textInputAction: TextInputAction.next,
        inputFormatters: [FilteringTextInputFormatter.singleLineFormatter],
        validator: (val) =>
            StringValidation.validateThisFieldRequered(val!, context),
        onSaved: (String? value) {
          storename = value;
        },
        decoration: InputDecoration(
          focusedBorder: UnderlineInputBorder(
            borderSide: const BorderSide(color: primary),
            borderRadius: BorderRadius.circular(circularBorderRadius7),
          ),
          prefixIcon: const Icon(
            Icons.store,
            color: lightBlack2,
            size: 20,
          ),
          hintText: getTranslated(context, "StoreName")!,
          hintStyle: Theme.of(context).textTheme.titleSmall!.copyWith(
                color: lightBlack2,
                fontWeight: FontWeight.normal,
              ),
          filled: true,
          fillColor: white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 5,
          ),
          prefixIconConstraints: const BoxConstraints(
            minWidth: 40,
            maxHeight: 20,
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: const BorderSide(color: lightBlack2),
            borderRadius: BorderRadius.circular(circularBorderRadius7),
          ),
        ),
      ),
    );
  }

  setaddress() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.90,
      padding: const EdgeInsets.only(
        top: 15.0,
      ),
      child: TextFormField(
        onFieldSubmitted: (v) {
          FocusScope.of(context).requestFocus(addressFocus);
        },
        keyboardType: TextInputType.text,
        controller: addressController,
        style: const TextStyle(
          color: fontColor,
          fontWeight: FontWeight.normal,
        ),
        focusNode: addressFocus,
        textInputAction: TextInputAction.next,
        inputFormatters: [FilteringTextInputFormatter.singleLineFormatter],
        validator: (val) =>
            StringValidation.validateThisFieldRequered(val!, context),
        onSaved: (String? value) {
          address = value;
        },
        decoration: InputDecoration(
          focusedBorder: UnderlineInputBorder(
            borderSide: const BorderSide(color: primary),
            borderRadius: BorderRadius.circular(circularBorderRadius7),
          ),
          prefixIcon: const Icon(
            Icons.location_city,
            color: lightBlack2,
            size: 20,
          ),
          hintText: getTranslated(context, "Addresh")!,
          hintStyle: Theme.of(context).textTheme.titleSmall!.copyWith(
                color: lightBlack2,
                fontWeight: FontWeight.normal,
              ),
          filled: true,
          fillColor: white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 5,
          ),
          prefixIconConstraints: const BoxConstraints(
            minWidth: 40,
            maxHeight: 20,
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: const BorderSide(color: lightBlack2),
            borderRadius: BorderRadius.circular(circularBorderRadius7),
          ),
        ),
      ),
    );
  }

  setEmail() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.90,
      padding: const EdgeInsets.only(
        top: 15.0,
      ),
      child: TextFormField(
        onFieldSubmitted: (v) {
          FocusScope.of(context).requestFocus(emailFocus);
        },
        keyboardType: TextInputType.text,
        controller: emailController,
        style: const TextStyle(
          color: fontColor,
          fontWeight: FontWeight.normal,
        ),
        focusNode: emailFocus,
        textInputAction: TextInputAction.next,
        inputFormatters: [FilteringTextInputFormatter.singleLineFormatter],
        validator: (val) => StringValidation.validateEmail(val!, context),
        onSaved: (String? value) {
          email = value;
        },
        decoration: InputDecoration(
          focusedBorder: UnderlineInputBorder(
            borderSide: const BorderSide(color: primary),
            borderRadius: BorderRadius.circular(circularBorderRadius7),
          ),
          prefixIcon: const Icon(
            Icons.email,
            color: lightBlack2,
            size: 20,
          ),
          hintText: getTranslated(context, "E-mail")!,
          hintStyle: Theme.of(context).textTheme.titleSmall!.copyWith(
                color: lightBlack2,
                fontWeight: FontWeight.normal,
              ),
          filled: true,
          fillColor: white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 5,
          ),
          prefixIconConstraints: const BoxConstraints(
            minWidth: 40,
            maxHeight: 20,
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: const BorderSide(color: lightBlack2),
            borderRadius: BorderRadius.circular(circularBorderRadius7),
          ),
        ),
      ),
    );
  }

  setMobileNo() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.90,
      padding: const EdgeInsets.only(
        top: 15.0,
      ),
      child: TextFormField(
        maxLength: 16,
        onFieldSubmitted: (v) {
          FocusScope.of(context).requestFocus(monumberFocus);
        },
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        controller: mobileController,
        style: const TextStyle(
          color: fontColor,
          fontWeight: FontWeight.normal,
        ),
        focusNode: monumberFocus,
        textInputAction: TextInputAction.next,
        //inputFormatters: [FilteringTextInputFormatter.singleLineFormatter],
        validator: (val) => StringValidation.validateMob(val!, context),
        onSaved: (String? value) {
          mobile = value;
        },
        decoration: InputDecoration(
          focusedBorder: UnderlineInputBorder(
            borderSide: const BorderSide(color: primary),
            borderRadius: BorderRadius.circular(circularBorderRadius7),
          ),
          prefixIcon: const Icon(
            Icons.phone_android,
            color: lightBlack2,
            size: 20,
          ),
          hintText: getTranslated(context, "Mobile Number")!,
          hintStyle: Theme.of(context).textTheme.titleSmall!.copyWith(
                color: lightBlack2,
                fontWeight: FontWeight.normal,
              ),
          filled: true,
          fillColor: white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 5,
          ),
          prefixIconConstraints: const BoxConstraints(
            minWidth: 40,
            maxHeight: 20,
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: const BorderSide(color: lightBlack2),
            borderRadius: BorderRadius.circular(circularBorderRadius7),
          ),
        ),
      ),
    );
  }

  setPass() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.90,
      padding: const EdgeInsets.only(
        top: 15.0,
      ),
      child: TextFormField(
        onFieldSubmitted: (v) {
          FocusScope.of(context).requestFocus(passFocus);
        },
        keyboardType: TextInputType.text,
        obscureText: true,
        controller: passwordController,
        style: const TextStyle(
          color: fontColor,
          fontWeight: FontWeight.normal,
        ),
        focusNode: passFocus,
        textInputAction: TextInputAction.next,
        validator: (val) =>
            StringValidation.validatePass(val!, context, onlyRequired: false),
        onSaved: (String? value) {
          password = value;
        },
        decoration: InputDecoration(
          focusedBorder: UnderlineInputBorder(
            borderSide: const BorderSide(color: primary),
            borderRadius: BorderRadius.circular(circularBorderRadius7),
          ),
          prefixIcon: SvgPicture.asset(
            DesignConfiguration.setSvgPath('password'),
          ),
          hintText: getTranslated(context, "PASSHINT_LBL"),
          hintStyle: Theme.of(context)
              .textTheme
              .titleSmall!
              .copyWith(color: lightBlack2, fontWeight: FontWeight.normal),
          fillColor: white,
          errorMaxLines: 3,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          suffixIconConstraints:
              const BoxConstraints(minWidth: 40, maxHeight: 20),
          prefixIconConstraints:
              const BoxConstraints(minWidth: 40, maxHeight: 20),
          enabledBorder: UnderlineInputBorder(
            borderSide: const BorderSide(color: lightBlack2),
            borderRadius: BorderRadius.circular(circularBorderRadius7),
          ),
        ),
      ),
    );
  }

  confirmPassword() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.90,
      padding: const EdgeInsets.only(
        top: 15.0,
      ),
      child: TextFormField(
        onFieldSubmitted: (v) {
          FocusScope.of(context).requestFocus(confirmPassFocus);
        },
        keyboardType: TextInputType.text,
        obscureText: true,
        controller: confirmPasswordController,
        style: const TextStyle(
          color: fontColor,
          fontWeight: FontWeight.normal,
        ),
        focusNode: confirmPassFocus,
        textInputAction: TextInputAction.next,
        validator: (val) =>
            StringValidation.validatePass(val!, context, onlyRequired: true),
        onSaved: (String? value) {
          confirmpassword = value;
        },
        decoration: InputDecoration(
          focusedBorder: UnderlineInputBorder(
            borderSide: const BorderSide(color: primary),
            borderRadius: BorderRadius.circular(circularBorderRadius7),
          ),
          prefixIcon: SvgPicture.asset(
            DesignConfiguration.setSvgPath('password'),
          ),
          hintText: getTranslated(context, "CONFIRMPASSHINT_LBL")!,
          hintStyle: Theme.of(context)
              .textTheme
              .titleSmall!
              .copyWith(color: lightBlack2, fontWeight: FontWeight.normal),
          fillColor: white,
          errorMaxLines: 3,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          suffixIconConstraints:
              const BoxConstraints(minWidth: 40, maxHeight: 20),
          prefixIconConstraints:
              const BoxConstraints(minWidth: 40, maxHeight: 20),
          enabledBorder: UnderlineInputBorder(
            borderSide: const BorderSide(color: lightBlack2),
            borderRadius: BorderRadius.circular(circularBorderRadius7),
          ),
        ),
      ),
    );
  }

  loginBtn() {
    return AppBtn(
      title: getTranslated(context, "Apply Now")!,
      btnAnim: buttonSqueezeanimation,
      btnCntrl: buttonController,
      onBtnSelected: () async {
        validateAndSubmit();
      },
    );
  }

  Widget getLogo() {
    return SizedBox(
      width: 100,
      height: 100,
      child: Image.asset(
                     'assets/images/PNG/homelogo.png',
                      
                    ),
    );
  }
}
