import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sellermultivendor/Provider/addPickUpLocationProvider.dart';
import 'package:sellermultivendor/Screen/AddPickUpLocation/Widget/getCommanInputTextFieldWidget.dart';
import 'package:sellermultivendor/Widget/ButtonDesing.dart';

import '../../Helper/Color.dart';
import '../../Helper/Constant.dart';
import '../../Provider/settingProvider.dart';
import '../../Widget/snackbar.dart';
import '../../Widget/validation.dart';

class AddPickUpLocation extends StatefulWidget {
  const AddPickUpLocation({Key? key}) : super(key: key);

  @override
  _AddPickUpLocationState createState() => _AddPickUpLocationState();
}

AddPickUpLocationProvider? addPickUpLocationProvider;

class _AddPickUpLocationState extends State<AddPickUpLocation>
    with TickerProviderStateMixin {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  @override
  void initState() {
    addPickUpLocationProvider =
        Provider.of<AddPickUpLocationProvider>(context, listen: false);
    addPickUpLocationProvider!.freshInitializationOfAddPickUpLocation();
    addPickUpLocationProvider!.buttonController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    addPickUpLocationProvider!.buttonSqueezeanimation = Tween(
      begin: width,
      end: 50.0,
    ).animate(
      CurvedAnimation(
        parent: addPickUpLocationProvider!.buttonController!,
        curve: const Interval(
          0.0,
          0.150,
        ),
      ),
    );
    super.initState();
  }

  Widget addAllData() {
    return SingleChildScrollView(
        child: Form(
            key: _formkey,
            child: Padding(
                padding: const EdgeInsets.only(
                  top: 25.0,
                  bottom: 20,
                  right: 20.0,
                  left: 20.0,
                ),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      getPrimaryCommanText(
                          getTranslated(context, "PickUp Location")!, false),
                      getCommanSizedBox(),
                      getCommanInputTextField(
                        getTranslated(context, "Add PickUp Location")!,
                        1,
                        0.06,
                        1,
                        1,
                        context,
                      ),
                      getCommanSizedBox(),
                      getPrimaryCommanText(
                          getTranslated(context, "Name")!, false),
                      getCommanSizedBox(),
                      getCommanInputTextField(
                        getTranslated(context, "Shipper's Name")!,
                        2,
                        0.06,
                        1,
                        2,
                        context,
                      ),
                      getCommanSizedBox(),
                      getPrimaryCommanText(
                          getTranslated(context, "Email")!, false),
                      getCommanSizedBox(),
                      getCommanInputTextField(
                        getTranslated(context, "Shipper's Email Address")!,
                        3,
                        0.06,
                        1,
                        5,
                        context,
                      ),
                      getCommanSizedBox(),
                      getPrimaryCommanText(
                          getTranslated(context, "Phone")!, false),
                      getCommanSizedBox(),
                      getCommanInputTextField(
                        getTranslated(context, "Shipper's Phone Number")!,
                        4,
                        0.06,
                        1,
                        4,
                        context,
                      ),
                      getCommanSizedBox(),
                      getPrimaryCommanText(
                          getTranslated(context, "City")!, false),
                      getCommanSizedBox(),
                      getCommanInputTextField(
                        getTranslated(context, "PickUp Location City Name")!,
                        5,
                        0.06,
                        1,
                        2,
                        context,
                      ),
                      getCommanSizedBox(),
                      getPrimaryCommanText(
                          getTranslated(context, "State")!, false),
                      getCommanSizedBox(),
                      getCommanInputTextField(
                        getTranslated(context, "PickUp Location State Name")!,
                        6,
                        0.06,
                        1,
                        2,
                        context,
                      ),
                      getCommanSizedBox(),
                      getPrimaryCommanText(
                          getTranslated(context, "Country")!, false),
                      getCommanSizedBox(),
                      getCommanInputTextField(
                        getTranslated(context, "PickUp Location Country Name")!,
                        7,
                        0.06,
                        1,
                        2,
                        context,
                      ),
                      getCommanSizedBox(),
                      getPrimaryCommanText(
                          getTranslated(context, "Pincode")!, false),
                      getCommanSizedBox(),
                      getCommanInputTextField(
                        getTranslated(context, "PickUp Location Pincode")!,
                        8,
                        0.06,
                        1,
                        2,
                        context,
                      ),
                      getCommanSizedBox(),
                      getPrimaryCommanText(
                          getTranslated(context, "Addresh")!, false),
                      getCommanSizedBox(),
                      getCommanInputTextField(
                        getTranslated(context,
                            "Shipper's Primary Address Max 80 Characters")!,
                        9,
                        0.11,
                        1,
                        1,
                        context,
                      ),
                      getCommanSizedBox(),
                      getPrimaryCommanText(
                          getTranslated(context, "Additional Address")!, false),
                      getCommanSizedBox(),
                      getCommanInputTextField(
                        getTranslated(context, "Additional Address Details")!,
                        10,
                        0.11,
                        1,
                        1,
                        context,
                      ),
                      getCommanSizedBox(),
                      getPrimaryCommanText(
                          getTranslated(context, "Latitude")!, false),
                      getCommanSizedBox(),
                      getCommanInputTextField(
                        getTranslated(context, "PickUp Location Latitude")!,
                        11,
                        0.06,
                        1,
                        3,
                        context,
                      ),
                      getCommanSizedBox(),
                      getPrimaryCommanText(
                          getTranslated(context, "Longitude")!, false),
                      getCommanSizedBox(),
                      getCommanInputTextField(
                        getTranslated(context, "PickUp Location Longitude")!,
                        12,
                        0.06,
                        1,
                        3,
                        context,
                      ),
                    ]))));
  }

  Widget getBottomBarButton() {
    return AppBtn(
      onBtnSelected: () async {
        validateAndSubmit();
      },
      height: 45,
      title: getTranslated(context, "Add PickUp Location")!,
      btnAnim: addPickUpLocationProvider!.buttonSqueezeanimation,
      btnCntrl: addPickUpLocationProvider!.buttonController,
      paddingRequired: false,
    );
  }

  update() {
    setState(
      () {},
    );
  }

  Future<void> _playAnimation() async {
    try {
      await addPickUpLocationProvider!.buttonController!.forward();
    } on TickerCanceled {}
  }

  void validateAndSubmit() async {
    if (validateAndSave()) {
      _playAnimation();
      addPickUpLocationProvider!.addPickUpLocationAPI(context, update);
    }
  }

  bool validateAndSave() {
    final form = _formkey.currentState!;
    form.save();
    if (form.validate()) {
      if (addPickUpLocationProvider!.pickUpLocation == null ||
          addPickUpLocationProvider!.pickUpLocation!.isEmpty) {
        setSnackbar(
          getTranslated(context, "Please Add PickUp Location")!,
          context,
        );
        return false;
      } else if (addPickUpLocationProvider!.name == null ||
          addPickUpLocationProvider!.name!.isEmpty) {
        setSnackbar(
          getTranslated(context, "Please Add Shipper's Name")!,
          context,
        );
        return false;
      } else if (addPickUpLocationProvider!.email == null ||
          addPickUpLocationProvider!.email!.isEmpty) {
        setSnackbar(
          getTranslated(context, "Please Add Shipper's Email Address")!,
          context,
        );
        return false;
      } else if (addPickUpLocationProvider!.phone == null ||
          addPickUpLocationProvider!.phone!.isEmpty) {
        setSnackbar(
          getTranslated(context, "Please Add Shipper's Phone")!,
          context,
        );
        return false;
      } else if (addPickUpLocationProvider!.city == null ||
          addPickUpLocationProvider!.city!.isEmpty) {
        setSnackbar(
          getTranslated(context, "Please Add PickUp Location City Name")!,
          context,
        );
        return false;
      } else if (addPickUpLocationProvider!.state == null ||
          addPickUpLocationProvider!.state!.isEmpty) {
        setSnackbar(
          getTranslated(context, "Please Add PickUp Location State Name")!,
          context,
        );
        return false;
      } else if (addPickUpLocationProvider!.country == null ||
          addPickUpLocationProvider!.country!.isEmpty) {
        setSnackbar(
          getTranslated(context, "Please Add PickUp Location Country Name")!,
          context,
        );
        return false;
      } else if (addPickUpLocationProvider!.pinCode == null ||
          addPickUpLocationProvider!.pinCode!.isEmpty) {
        setSnackbar(
          getTranslated(context, "Please Add PickUp Location Pincode")!,
          context,
        );
        return false;
      } else if (addPickUpLocationProvider!.address == null ||
          addPickUpLocationProvider!.address!.isEmpty) {
        setSnackbar(
          getTranslated(context, "Please Add Shipper's Primary Address")!,
          context,
        );
        return false;
      } else if (addPickUpLocationProvider!.address2 == null ||
          addPickUpLocationProvider!.address2!.isEmpty) {
        setSnackbar(
          getTranslated(context, "Please Add Address Additional Details")!,
          context,
        );
        return false;
      } else if (addPickUpLocationProvider!.longitude == null ||
          addPickUpLocationProvider!.longitude!.isEmpty) {
        setSnackbar(
          getTranslated(context, "Please Add PickUp Location Latitude")!,
          context,
        );
        return false;
      } else if (addPickUpLocationProvider!.latitude == null ||
          addPickUpLocationProvider!.latitude!.isEmpty) {
        setSnackbar(
          getTranslated(context, "Please Add PickUp Location Longitude")!,
          context,
        );
        return false;
      } else {
        return true;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      // resizeToAvoidBottomInset: true,
      bottomNavigationBar: getBottomBarButton(),
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [grad1Color, grad2Color],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              stops: [0, 1],
              tileMode: TileMode.clamp,
            ),
          ),
        ),
        titleSpacing: 0,
        backgroundColor: white,
        leading: Builder(
          builder: (BuildContext context) {
            return Container(
              color: Colors.transparent,
              margin: const EdgeInsets.all(10),
              // decoration: DesignConfiguration.shadow(),
              child: InkWell(
                borderRadius: BorderRadius.circular(circularBorderRadius5),
                onTap: () => Navigator.of(context).pop(),
                child: const Center(
                  child: Icon(
                    Icons.arrow_back,
                    color: white,
                    size: 25,
                  ),
                ),
              ),
            );
          },
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              getTranslated(context, "Add PickUp Location")!,
              style: const TextStyle(
                color: white,
                fontSize: textFontSize16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      body: addAllData(),
    );
  }
}
