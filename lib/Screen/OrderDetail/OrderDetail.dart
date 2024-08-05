import 'dart:async';
import 'dart:io';
import 'package:external_path/external_path.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:sellermultivendor/Helper/Color.dart';
import 'package:sellermultivendor/Screen/OrderDetail/Widget/ParcelBreadth.dart';
import 'package:sellermultivendor/Screen/OrderDetail/Widget/ParcelHeight.dart';
import 'package:sellermultivendor/Screen/OrderDetail/Widget/ParcelLength.dart';
import 'package:sellermultivendor/Screen/OrderDetail/Widget/ParcelWeight.dart';
import 'package:sellermultivendor/Screen/OrderDetail/Widget/commonAlertDialogue.dart';
import 'package:sellermultivendor/Screen/OrderDetail/Widget/commonRowBtn.dart';
import 'package:sellermultivendor/Widget/parameterString.dart';
import 'package:sellermultivendor/Model/OrdersModel/OrderItemsModel.dart';
import 'package:sellermultivendor/Model/OrdersModel/OrderModel.dart';
import 'package:sellermultivendor/Model/Person/PersonModel.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../Helper/ApiBaseHelper.dart';
import '../../Helper/Constant.dart';
import '../../Model/OrderTrackingModel.dart';
import '../../Provider/settingProvider.dart';
import '../../Widget/api.dart';
import '../../Widget/appBar.dart';
import '../../Widget/desing.dart';
import '../../Widget/networkAvailablity.dart';
import '../../Widget/routes.dart';
import '../../Widget/sharedPreferances.dart';
import '../../Widget/simmerEffect.dart';
import '../../Widget/snackbar.dart';
import '../../Widget/validation.dart';
import '../EmailSend/email.dart';
import '../HomePage/home.dart';
import '../../Widget/noNetwork.dart';
import 'Widget/PriceDetail.dart';
import 'Widget/bankProff.dart';
import 'Widget/orderBasicDetail.dart';
import 'Widget/shippingDetail.dart';
import 'package:collection/src/iterable_extensions.dart';

class OrderDetail extends StatefulWidget {
  final String? id;
  final Function? update;
  const OrderDetail({
    Key? key,
    this.id,
    this.update,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return StateOrder();
  }
}

List<PersonModel> delBoyList = [];

class StateOrder extends State<OrderDetail> with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  ScrollController controller = ScrollController();
  Animation? buttonSqueezeanimation;
  AnimationController? buttonController;
  TextEditingController emailController = TextEditingController();
  TextEditingController messageController = TextEditingController();
  TextEditingController? courierAgencyController, urlController;
  Order_Model? model;
  List<String> pickUpLocationList = [];
  List<String> orderItemIds = [];
  String? selectPickUpLocation;
  String? pDate,
      prDate,
      sDate,
      dDate,
      cDate,
      rDate,
      url,
      courierAgency,
      trackingId;
  List<String> statusList = [
    PLACED,
    PROCESSED,
    SHIPED,
    DELIVERD,
    CANCLED,
    RETURNED,
  ];

  List<String> digitalList = [
    PLACED,
    DELIVERD,
  ];
  bool isLoading = true;
  bool btnEnabledTrack = false;
  List<Order_Model> tempList = [];
  bool isProgress = false;
  String? curStatus;
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  TextEditingController? otpC;
  final List<DropdownMenuItem> items = [];
  List<PersonModel> searchList = [];
  int? selectedDelBoy;
  final TextEditingController _controller = TextEditingController();
  late StateSetter delBoyState;
  bool fabIsVisible = true;
  String? curSelectedStatus;
  String? curSelectedDeliveryBoy;

  double? heightC, weightC, lengthC, breadthC;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  List<OrderTrackingModel> orderTrackingList = [];
  String? pickUpStatus;

  @override
  void initState() {
    getDeliveryBoy();
    Future.delayed(Duration.zero, getOrderDetail);
    getOrderTrackingData();
    super.initState();
    controller = ScrollController();
    controller.addListener(
      () {
        setState(
          () {
            fabIsVisible = controller.position.userScrollDirection ==
                ScrollDirection.forward;
          },
        );
      },
    );
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
    _controller.addListener(
      () {
        searchOperation(_controller.text);
      },
    );
  }

//==============================================================================
//========================= getDeliveryBoy API =================================

  Future<void> getDeliveryBoy() async {
    context.read<SettingProvider>().CUR_USERID = await getPrefrence(Id);
    var parameter = {
    };

    ApiBaseHelper().postAPICall(getDeliveryBoysApi, parameter).then(
      (getdata) async {
        bool error = getdata["error"];
        String? msg = getdata["message"];

        if (!error) {
          delBoyList.clear();
          var data = getdata["data"];
          delBoyList =
              (data as List).map((data) => PersonModel.fromJson(data)).toList();
        } else {
          setSnackbar(
            msg!,
            context,
          );
        }
      },
      onError: (error) {
        setSnackbar(
          error.toString(),
          context,
        );
      },
    );
  }

  Future<void> getOrderDetail() async {
    isNetworkAvail = await isNetworkAvailable();
    if (isNetworkAvail) {
      context.read<SettingProvider>().CUR_USERID = await getPrefrence(Id);
      var parameter = {
        Id: widget.id,
      };
      ApiBaseHelper().postAPICall(getOrdersApi, parameter).then(
        (getdata) async {
          bool error = getdata["error"];
          if (!error) {
            var data = getdata["data"];
            tempList.clear();
            model = null;
            pickUpLocationList.clear();
            if (data.length != 0) {
              tempList = (data as List)
                  .map((data) => Order_Model.fromJson(data))
                  .toList();

              for (int i = 0; i < tempList[0].itemList!.length; i++) {
                tempList[0].itemList![i].curSelected =
                    tempList[0].itemList![i].status;
              }
              searchList.clear();
              searchList.addAll(delBoyList);
              if (tempList[0].itemList![0].deliveryBoyId != null) {
                selectedDelBoy = delBoyList.indexWhere(
                    (f) => f.id == tempList[0].itemList![0].deliveryBoyId);
              }
              if (selectedDelBoy == -1) selectedDelBoy = null;

              if (tempList[0].payMethod == "Bank Transfer") {
                statusList.removeWhere((element) => element == PLACED);
              }
              curStatus = tempList[0].itemList![0].activeStatus!;
              if (tempList[0].listStatus!.contains(PLACED)) {
                pDate = tempList[0]
                    .listDate![tempList[0].listStatus!.indexOf(PLACED)];

                if (pDate != null) {
                  List d = pDate!.split(" ");
                  pDate = d[0] + "\n" + d[1];
                }
              }
              if (tempList[0].listStatus!.contains(PROCESSED)) {
                prDate = tempList[0]
                    .listDate![tempList[0].listStatus!.indexOf(PROCESSED)];
                if (prDate != null) {
                  List d = prDate!.split(" ");
                  prDate = d[0] + "\n" + d[1];
                }
              }
              if (tempList[0].listStatus!.contains(SHIPED)) {
                sDate = tempList[0]
                    .listDate![tempList[0].listStatus!.indexOf(SHIPED)];
                if (sDate != null) {
                  List d = sDate!.split(" ");
                  sDate = d[0] + "\n" + d[1];
                }
              }
              if (tempList[0].listStatus!.contains(DELIVERD)) {
                dDate = tempList[0]
                    .listDate![tempList[0].listStatus!.indexOf(DELIVERD)];
                if (dDate != null) {
                  List d = dDate!.split(" ");
                  dDate = d[0] + "\n" + d[1];
                }
              }
              if (tempList[0].listStatus!.contains(CANCLED)) {
                cDate = tempList[0]
                    .listDate![tempList[0].listStatus!.indexOf(CANCLED)];
                if (cDate != null) {
                  List d = cDate!.split(" ");
                  cDate = d[0] + "\n" + d[1];
                }
              }
              if (tempList[0].listStatus!.contains(RETURNED)) {
                rDate = tempList[0]
                    .listDate![tempList[0].listStatus!.indexOf(RETURNED)];
                if (rDate != null) {
                  List d = rDate!.split(" ");
                  rDate = d[0] + "\n" + d[1];
                }
              }
              model = tempList[0];
              pickUpLocationList.addAll(model!.itemList!
                  .map((itemList) => itemList.pickUpLocation!)
                  .toSet()
                  .toList());

              emailController.text = tempList[0].email ?? '';
              messageController.text =
                  'Hello Dear ${tempList[0].username},\nYou have purchase our digital product and we are happy to share the product with you, you can get product with this mail attachment.\nThank You ...!';
            } else {}
            setState(
              () {
                isLoading = false;
              },
            );
          } else {}
        },
        onError: (error) {
          setSnackbar(
            error.toString(),
            context,
          );
        },
      );
    } else {
      if (mounted) {
        setState(
          () {
            isNetworkAvail = false;
          },
        );
      }
    }

    return;
  }

  Future<void> getOrderTrackingData() async {
    isNetworkAvail = await isNetworkAvailable();
    if (isNetworkAvail) {
      context.read<SettingProvider>().CUR_USERID = await getPrefrence(Id);
      var parameter = {
        ORDER_ID: widget.id!,
      };
      ApiBaseHelper().postAPICall(getOrderTrackingApi, parameter).then(
        (getdata) async {
          List data = getdata["rows"];
          print("data tracking****$data");
          if (data.isNotEmpty) {
            orderTrackingList = (data)
                .map((data) => OrderTrackingModel.fromJson(data))
                .toList();
            setState(() {
              btnEnabledTrack = true;
            });
          }
        },
        onError: (error) {
          setSnackbar(
            error.toString(),
            context,
          );
        },
      );
    } else {
      if (mounted) {
        setState(
          () {
            isNetworkAvail = false;
          },
        );
      }
    }

    return;
  }

  @override
  void dispose() {
    buttonController!.dispose();
    super.dispose();
  }

  Future<void> _playAnimation() async {
    try {
      await buttonController!.forward();
    } on TickerCanceled {}
  }

  setStateNoInternate() async {
    _playAnimation();
    Future.delayed(const Duration(seconds: 2)).then(
      (_) async {
        isNetworkAvail = await isNetworkAvailable();
        if (isNetworkAvail) {
          Navigator.pushReplacement(
              context,
              CupertinoPageRoute(
                  builder: (BuildContext context) => super.widget));
        } else {
          await buttonController!.reverse();
          setState(
            () {},
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    if (delPermission != "1") {
      statusList.remove(SHIPED);
    }

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: lightWhite,
      floatingActionButton: AnimatedOpacity(
        duration: const Duration(milliseconds: 100),
        opacity: fabIsVisible ? 1 : 0,
        child: customerViewPermission
            ? Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  FloatingActionButton.small(
                    backgroundColor: white,
                    onPressed: () async {
                      String text =
                          '${getTranslated(context, "Hello")!} ${tempList[0].name},\n${getTranslated(context, "Your order with id")!} : ${tempList[0].id} ${getTranslated(context, "is")!} ${tempList[0].itemList![0].activeStatus}. ${getTranslated(context, "If you have further query feel free to contact us.Thank you")!}';
                      var androiduri = 'sms:${tempList[0].mobile}?body=$text';
                      var iosuri = 'sms:${tempList[0].mobile}&body=$text';
                      var androidencoded = Uri.encodeFull(androiduri);
                      var iosencoded = Uri.encodeFull(iosuri);

                      if (Platform.isIOS) {
                        // for iOS phone only
                        if (await canLaunchUrl(
                            Uri.parse(iosencoded.toString()))) {
                          await launchUrl(
                            Uri.parse(iosencoded.toString()),
                            mode: LaunchMode.externalApplication,
                          );
                        } else {
                          launchUrl(
                            Uri.parse(iosencoded.toString()),
                            mode: LaunchMode.externalApplication,
                          );
                        }
                      } else {
                        // android , web
                        if (await canLaunchUrl(
                            Uri.parse(androidencoded.toString()))) {
                          await launchUrl(
                            Uri.parse(androidencoded.toString()),
                            mode: LaunchMode.externalApplication,
                          );
                        } else {
                          launchUrl(
                            Uri.parse(androidencoded.toString()),
                            mode: LaunchMode.externalApplication,
                          );
                        }
                      }
                      //await launch(uri);
                    },
                    heroTag: null,
                    child: const Icon(
                      Icons.message,
                      color: primary,
                      size: 20,
                    ),
                  ),
                  const SizedBox(
                    height: 05,
                  ),
                  FloatingActionButton.small(
                    backgroundColor: white,
                    onPressed: () async {
                      String text =
                          '${getTranslated(context, "Hello")!} ${tempList[0].name} \n${getTranslated(context, "Your order with id")!} : ${tempList[0].id} ${getTranslated(context, "is")!} ${tempList[0].itemList![0].activeStatus}. ${getTranslated(context, "If you have further query feel free to contact us.Thank you")!}.';

                      var whatsapp =
                          ("${tempList[0].countryCode!}${tempList[0].mobile!}");
                      // var whatsappURlAndroid =
                      //     "https://wa.me/$whatsapp?text=$text";
                      var whatappURLIos = "https://wa.me/$whatsapp?text=$text";
                      var encoded = Uri.encodeFull(whatappURLIos);

                      if (Platform.isIOS) {
                        // for iOS phone only
                        if (await canLaunchUrl(Uri.parse(encoded.toString()))) {
                          await launchUrl(
                            Uri.parse(
                              encoded.toString(),
                            ),
                            mode: LaunchMode.externalApplication,
                          );
                        } else {
                          launchUrl(
                            Uri.parse(
                              encoded.toString(),
                            ),
                            mode: LaunchMode.externalApplication,
                          );
                        }
                      } else {
                        // android , web
                        if (await canLaunchUrl(Uri.parse(encoded.toString()))) {
                          await launchUrl(
                            Uri.parse(encoded.toString()),
                            mode: LaunchMode.externalApplication,
                          );
                        } else {
                          launchUrl(
                            Uri.parse(encoded.toString()),
                            mode: LaunchMode.externalApplication,
                          );
                        }
                      }
                    },
                    heroTag: null,
                    child: Image.asset(
                      DesignConfiguration.setPngPath('whatsapp'),
                      width: 20,
                      height: 20,
                      color: primary,
                    ),
                  ),
                ],
              )
            : Container(),
      ),
      body: isNetworkAvail
          ? Stack(
              children: [
                isLoading
                    ? const ShimmerEffect()
                    : Column(
                        children: [
                          GradientAppBar(
                            getTranslated(context, "ORDER_DETAIL")!,
                          ),
                          Expanded(
                            child: SingleChildScrollView(
                              controller: controller,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  top: 15.0,
                                  bottom: 15.0,
                                  left: 15.0,
                                  right: 15.0,
                                ),
                                child: Column(
                                  children: [
                                    OrderBasicDetail(model: model),
                                    model!.delDate != null &&
                                            model!.delDate!.isNotEmpty
                                        ? Padding(
                                            padding: const EdgeInsets.only(
                                              top: 10.0,
                                            ),
                                            child: Container(
                                              decoration: const BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(
                                                        circularBorderRadius5)),
                                                color: white,
                                                boxShadow: [
                                                  BoxShadow(
                                                      color: blarColor,
                                                      offset: Offset(0, 0),
                                                      blurRadius: 4,
                                                      spreadRadius: 0),
                                                ],
                                              ),
                                              height: 52,
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                  top: 6.0,
                                                  left: 10.0,
                                                  right: 10.0,
                                                  bottom: 6.0,
                                                ),
                                                child: Text(
                                                  "${getTranslated(context, "PREFER_DATE_TIME")!}: ${model!.delDate!} - ${model!.delTime!}",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleSmall!
                                                      .copyWith(
                                                        fontFamily:
                                                            'PlusJakartaSans',
                                                        color: grey3,
                                                        fontSize:
                                                            textFontSize13,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontStyle:
                                                            FontStyle.normal,
                                                      ),
                                                ),
                                              ),
                                            ),
                                          )
                                        : Container(),

                                    if (model!.itemList![0].productType !=
                                        'digital_product')
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10),
                                        child: Padding(
                                          padding:
                                              const EdgeInsetsDirectional.only(
                                                  top: 10),
                                          child: InkWell(
                                            child: Container(
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: selectPickUpLocation !=
                                                          null
                                                      ? primary
                                                      : grey,
                                                ),
                                                borderRadius:
                                                    const BorderRadius.all(
                                                  Radius.circular(
                                                      circularBorderRadius5),
                                                ),
                                              ),
                                              padding: const EdgeInsets.all(10),
                                              child: Text(
                                                getTranslated(
                                                  context,
                                                  'Create Shiprocket Order',
                                                )!,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleSmall!
                                                    .copyWith(
                                                      color:
                                                          selectPickUpLocation !=
                                                                  null
                                                              ? primary
                                                              : grey,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                              ),
                                            ),
                                            onTap: () {
                                              if (selectPickUpLocation !=
                                                  null) {
                                                createShipRocketParcelDialog();
                                              }
                                            },
                                          ),
                                        ),
                                      ),

                                    //item's here
                                    model!.itemList![0].productType ==
                                            'digital_product'
                                        ? Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 10.0),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 8.0),
                                                    child:
                                                        DropdownButtonFormField(
                                                      dropdownColor: lightWhite,
                                                      isDense: true,
                                                      iconEnabledColor: primary,
                                                      hint: Text(
                                                        getTranslated(context,
                                                            "UpdateStatus")!,
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .titleSmall!
                                                            .copyWith(
                                                                color: primary,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                      ),
                                                      decoration:
                                                          const InputDecoration(
                                                        filled: true,
                                                        isDense: true,
                                                        fillColor: white,
                                                        contentPadding:
                                                            EdgeInsets
                                                                .symmetric(
                                                                    vertical:
                                                                        10,
                                                                    horizontal:
                                                                        10),
                                                        enabledBorder:
                                                            OutlineInputBorder(
                                                          borderSide:
                                                              BorderSide(
                                                                  color:
                                                                      primary),
                                                        ),
                                                      ),
                                                      value: curSelectedStatus,
                                                      onChanged:
                                                          (dynamic newValue) {
                                                        setState(
                                                          () {
                                                            curSelectedStatus =
                                                                newValue;
                                                            // orderItem.curSelected = newValue;
                                                            /*updateOrder(
                                                              orderItem
                                                                  .curSelected,
                                                              updateOrderItemApi,
                                                              model.id,
                                                              true,
                                                              i,
                                                            );*/
                                                          },
                                                        );
                                                      },
                                                      items: digitalList.map(
                                                        (String st) {
                                                          return DropdownMenuItem<
                                                              String>(
                                                            value: st,
                                                            child: Text(
                                                              () {
                                                                if (StringValidation
                                                                        .capitalize(
                                                                            st) ==
                                                                    "Received") {
                                                                  return getTranslated(
                                                                      context,
                                                                      "RECEIVED_LBL")!;
                                                                } else if (StringValidation
                                                                        .capitalize(
                                                                            st) ==
                                                                    "Delivered") {
                                                                  return getTranslated(
                                                                      context,
                                                                      "DELIVERED_LBL")!;
                                                                }
                                                                return StringValidation
                                                                    .capitalize(
                                                                        st);
                                                              }(),
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .titleSmall!
                                                                  .copyWith(
                                                                      color:
                                                                          primary,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                            ),
                                                          );
                                                        },
                                                      ).toList(),
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 8.0),
                                                  child: InkWell(
                                                    onTap: () {
                                                      if (curSelectedStatus !=
                                                          null) {
                                                        if ((curSelectedStatus ==
                                                                    "cancelled" ||
                                                                curSelectedStatus ==
                                                                    "returned") &&
                                                            orderItemIds
                                                                .isEmpty) {
                                                          setSnackbar(
                                                              getTranslated(
                                                                  context,
                                                                  'Select square box of item only when you want to update it as cancelled or returned.')!,
                                                              context);
                                                        } else {
                                                          updateOrder();
                                                        }
                                                      }
                                                    },
                                                    child: const Icon(
                                                      Icons.send,
                                                      size: 30,
                                                      color: primary,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        : Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 10.0),
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 8.0),
                                              child: DropdownButtonFormField(
                                                dropdownColor: lightWhite,
                                                isDense: true,
                                                iconEnabledColor: primary,
                                                hint: Text(
                                                  getTranslated(
                                                      context, "UpdateStatus")!,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleSmall!
                                                      .copyWith(
                                                          color: primary,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                ),
                                                decoration:
                                                    const InputDecoration(
                                                  filled: true,
                                                  isDense: true,
                                                  fillColor: white,
                                                  contentPadding:
                                                      EdgeInsets.symmetric(
                                                          vertical: 10,
                                                          horizontal: 10),
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: primary),
                                                  ),
                                                ),
                                                value: curSelectedStatus,
                                                onChanged: (dynamic newValue) {
                                                  setState(
                                                    () {
                                                      curSelectedStatus =
                                                          newValue;
                                                      /* orderItem
                                                              .curSelected =
                                                          newValue;
                                                      updateOrder(
                                                        orderItem
                                                            .curSelected,
                                                        updateOrderItemApi,
                                                        model.id,
                                                        true,
                                                        i,
                                                      );*/
                                                    },
                                                  );
                                                },
                                                items: statusList.map(
                                                  (String st) {
                                                    return DropdownMenuItem<
                                                        String>(
                                                      value: st,
                                                      child: Text(
                                                        () {
                                                          if (StringValidation
                                                                  .capitalize(
                                                                      st) ==
                                                              "Received") {
                                                            return getTranslated(
                                                                context,
                                                                "RECEIVED_LBL")!;
                                                          } else if (StringValidation
                                                                  .capitalize(
                                                                      st) ==
                                                              "Processed") {
                                                            return getTranslated(
                                                                context,
                                                                "PROCESSED_LBL")!;
                                                          } else if (StringValidation
                                                                  .capitalize(
                                                                      st) ==
                                                              "Shipped") {
                                                            return getTranslated(
                                                                context,
                                                                "SHIPED_LBL")!;
                                                          } else if (StringValidation
                                                                  .capitalize(
                                                                      st) ==
                                                              "Delivered") {
                                                            return getTranslated(
                                                                context,
                                                                "DELIVERED_LBL")!;
                                                          } else if (StringValidation
                                                                  .capitalize(
                                                                      st) ==
                                                              "Awaiting") {
                                                            return getTranslated(
                                                                context,
                                                                "AWAITING_LBL")!;
                                                          } else if (StringValidation
                                                                  .capitalize(
                                                                      st) ==
                                                              "Returned") {
                                                            return getTranslated(
                                                                context,
                                                                "RETURNED_LBL")!;
                                                          } else if (StringValidation
                                                                  .capitalize(
                                                                      st) ==
                                                              "Cancelled") {
                                                            return getTranslated(
                                                                context,
                                                                "CANCELLED_LBL")!;
                                                          } else if (StringValidation
                                                                  .capitalize(
                                                                      st) ==
                                                              "return_request_pending") {
                                                            return getTranslated(
                                                                context,
                                                                "RETURN_REQUEST_PENDING_LBL")!;
                                                          } else if (StringValidation
                                                                  .capitalize(
                                                                      st) ==
                                                              "return_request_approved") {
                                                            return getTranslated(
                                                                context,
                                                                "RETURN_REQUEST_APPROVE_LBL")!;
                                                          } else if (StringValidation
                                                                  .capitalize(
                                                                      st) ==
                                                              "return_request_decline") {
                                                            return getTranslated(
                                                                context,
                                                                "RETURN_REQUEST_DECLINE_LBL")!;
                                                          }
                                                          return StringValidation
                                                              .capitalize(st);
                                                        }(),
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .titleSmall!
                                                            .copyWith(
                                                                color: primary,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                      ),
                                                    );
                                                  },
                                                ).toList(),
                                              ),
                                            ),
                                          ),

//==============================================================================
//============================ Select Delivery Boy =============================
                                    model!.itemList![0].productType ==
                                            'digital_product'
                                        ? Container()
                                        : Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 5.0),
                                            child: Row(
                                              children: [
                                                delPermission == '1'
                                                    ? Expanded(
                                                        flex: 1,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  right: 8.0),
                                                          child: InkWell(
                                                            child: Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                border:
                                                                    Border.all(
                                                                  color:
                                                                      primary,
                                                                ),
                                                                borderRadius:
                                                                    const BorderRadius
                                                                        .all(
                                                                  Radius.circular(
                                                                      circularBorderRadius5),
                                                                ),
                                                              ),
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(10),
                                                              child: Row(
                                                                children: [
                                                                  Expanded(
                                                                    child: Text(
                                                                      curSelectedDeliveryBoy !=
                                                                              null
                                                                          ? curSelectedDeliveryBoy!
                                                                          : getTranslated(
                                                                              context,
                                                                              "SELECTDELBOY",
                                                                            )!,
                                                                      maxLines:
                                                                          1,
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                      style: Theme.of(
                                                                              context)
                                                                          .textTheme
                                                                          .titleSmall!
                                                                          .copyWith(
                                                                            color:
                                                                                primary,
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                          ),
                                                                    ),
                                                                  ),
                                                                  const Icon(
                                                                    Icons
                                                                        .arrow_drop_down,
                                                                    color:
                                                                        primary,
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                            onTap: () {
                                                              delboyDialog();
                                                            },
                                                          ),
                                                        ),
                                                      )
                                                    : const SizedBox.shrink(),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 8.0),
                                                  child: InkWell(
                                                    onTap: () {
                                                      if (curSelectedStatus !=
                                                          null) {
                                                        if (curSelectedStatus ==
                                                            "shipped") {
                                                          if (selectedDelBoy ==
                                                              null) {
                                                            setSnackbar(
                                                                getTranslated(
                                                                    context,
                                                                    'Please select any update order status or select delivery boy')!,
                                                                context);
                                                            return;
                                                          }
                                                        }

                                                        if ((curSelectedStatus ==
                                                                    "cancelled" ||
                                                                curSelectedStatus ==
                                                                    "returned") &&
                                                            orderItemIds
                                                                .isEmpty) {
                                                          setSnackbar(
                                                              getTranslated(
                                                                  context,
                                                                  'Select square box of item only when you want to update it as cancelled or returned.')!,
                                                              context);
                                                        } else {
                                                          updateOrder();
                                                        }
                                                      } else {
                                                        setSnackbar(
                                                            "Select any order status for update order.",
                                                            context);
                                                      }
                                                    },
                                                    child: const Icon(
                                                      Icons.send,
                                                      size: 30,
                                                      color: primary,
                                                    ),
                                                  ),
                                                ),
                                                delPermission == '1'
                                                    ? Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                right: 8.0),
                                                        child: InkWell(
                                                          onTap: () {
                                                            showTrackingDialog(
                                                                model!.itemList![
                                                                    0]);
                                                          },
                                                          child: const Icon(
                                                            Icons
                                                                .add_location_alt_sharp,
                                                            size: 30,
                                                            color: primary,
                                                          ),
                                                        ),
                                                      )
                                                    : const SizedBox.shrink(),
                                              ],
                                            ),
                                          ),

                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                          "Note : Select square box of item only when you want to update it as cancelled or returned.",
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelSmall!
                                              .copyWith(
                                                  fontWeight: FontWeight.w700)),
                                    ),
                                    MediaQuery.removePadding(
                                        context: context,
                                        removeTop: true,
                                        child: ListView.builder(
                                            shrinkWrap: true,
                                            itemCount:
                                                pickUpLocationList.length,
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            itemBuilder: (context, j) {
                                              List<String> pickUpOrderItemsIds =
                                                  [];
                                              for (int p = 0;
                                                  p < model!.itemList!.length;
                                                  p++) {
                                                if (model!.itemList![p]
                                                        .pickUpLocation ==
                                                    pickUpLocationList[j]) {
                                                  pickUpOrderItemsIds.add(
                                                      model!.itemList![p].id!);
                                                }
                                              }
                                              print(
                                                  "pickup location ids****$pickUpOrderItemsIds");
                                              OrderTrackingModel? trackingModel;
                                              if (btnEnabledTrack == true) {
                                                trackingModel = orderTrackingList
                                                    .firstWhereOrNull((cp) =>
                                                        cp.orderItemId ==
                                                        pickUpOrderItemsIds[0]);
                                                /* if (trackingModel != null) {
                                                  if (pickUpStatus == null) {
                                                    getShipRocketOrder(
                                                        trackingModel
                                                            .shiprocketOrderId!);
                                                  }
                                                }*/
                                              }

                                              return Column(
                                                children: [
                                                  if (pickUpLocationList[j] !=
                                                      "")
                                                    if (model!.itemList![0]
                                                            .productType !=
                                                        'digital_product')
                                                      Row(
                                                        children: [
                                                          trackingModel == null
                                                              ? IconButton(
                                                                  onPressed:
                                                                      () {
                                                                    setState(
                                                                        () {
                                                                      selectPickUpLocation =
                                                                          pickUpLocationList[
                                                                              j];
                                                                    });
                                                                  },
                                                                  icon: selectPickUpLocation ==
                                                                          pickUpLocationList[
                                                                              j]
                                                                      ? const Icon(
                                                                          Icons
                                                                              .check_circle_sharp,
                                                                        )
                                                                      : const Icon(
                                                                          Icons
                                                                              .circle_outlined,
                                                                        ))
                                                              : Container(
                                                                  height: 40,
                                                                ),
                                                          Text(
                                                              "${getTranslated(context, 'PickUp Location')} : ",
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .labelMedium!
                                                                  .copyWith(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w700)),
                                                          Text(
                                                              pickUpLocationList[
                                                                  j]),
                                                        ],
                                                      ),
                                                  if (model!.itemList![0]
                                                          .productType !=
                                                      'digital_product')
                                                    trackingModel != null
                                                        ? SingleChildScrollView(
                                                            scrollDirection:
                                                                Axis.horizontal,
                                                            child: Row(
                                                                children: [
                                                                  Container(
                                                                      decoration: BoxDecoration(
                                                                          borderRadius: BorderRadius.circular(
                                                                              5),
                                                                          color:
                                                                              primary),
                                                                      padding:
                                                                          const EdgeInsets
                                                                              .all(
                                                                              7),
                                                                      child: Text(
                                                                          trackingModel.isCanceled == "1"
                                                                              ? getTranslated(context,
                                                                                  'Order Canceled')!
                                                                              : getTranslated(context,
                                                                                  'Order Created')!,
                                                                          style: Theme.of(context)
                                                                              .textTheme
                                                                              .bodySmall!
                                                                              .copyWith(color: white))),
                                                                  if (trackingModel
                                                                              .shipmentId !=
                                                                          "" &&
                                                                      trackingModel
                                                                              .awbCode ==
                                                                          "")
                                                                    Padding(
                                                                      padding: const EdgeInsetsDirectional
                                                                          .only(
                                                                          start:
                                                                              10.0),
                                                                      child: CommonRowBtn(
                                                                          title: 'awb',
                                                                          onBtnSelected: () {
                                                                            commonDialogue(context,
                                                                                getTranslated(context, 'Do you want to generate AWB code?')!,
                                                                                () {
                                                                              generateAWB(trackingModel!.shipmentId!, trackingModel);
                                                                              Routes.pop(context);
                                                                            });
                                                                          }),
                                                                    ),
                                                                  if (trackingModel
                                                                              .pickUpScheduleDate !=
                                                                          "" &&
                                                                      trackingModel
                                                                              .awbCode !=
                                                                          "")
                                                                    Padding(
                                                                      padding: const EdgeInsetsDirectional
                                                                          .only(
                                                                          start:
                                                                              10.0),
                                                                      child: CommonRowBtn(
                                                                          title: 'pick up request',
                                                                          onBtnSelected: () {
                                                                            commonDialogue(context,
                                                                                getTranslated(context, 'Do you want to send pick up request?')!,
                                                                                () {
                                                                              sendPickUpRequest(trackingModel!.shipmentId!);

                                                                              Routes.pop(context);
                                                                            });
                                                                          }),
                                                                    ),
                                                                  if (trackingModel
                                                                              .isCanceled ==
                                                                          "0" &&
                                                                      trackingModel
                                                                              .awbCode !=
                                                                          "")
                                                                    Padding(
                                                                      padding: const EdgeInsetsDirectional
                                                                          .only(
                                                                          start:
                                                                              10.0),
                                                                      child: CommonRowBtn(
                                                                          title: 'Cancel order',
                                                                          onBtnSelected: () {
                                                                            commonDialogue(context,
                                                                                getTranslated(context, 'Do you want to cancel order?')!,
                                                                                () {
                                                                              cancelShipRocketOrder(trackingModel!.shiprocketOrderId!, pickUpOrderItemsIds);

                                                                              Routes.pop(context);
                                                                            });
                                                                          }),
                                                                    ),
                                                                  if (trackingModel
                                                                              .labelUrl ==
                                                                          "" &&
                                                                      trackingModel
                                                                              .awbCode !=
                                                                          "")
                                                                    Padding(
                                                                      padding: const EdgeInsetsDirectional
                                                                          .only(
                                                                          start:
                                                                              10.0),
                                                                      child: CommonRowBtn(
                                                                          title: 'Generate label',
                                                                          onBtnSelected: () {
                                                                            commonDialogue(context,
                                                                                getTranslated(context, 'Do you want to generate label?')!,
                                                                                () {
                                                                              generateLabel(trackingModel!.shipmentId!);

                                                                              Routes.pop(context);
                                                                            });
                                                                          }),
                                                                    ),
                                                                  if (trackingModel
                                                                              .labelUrl !=
                                                                          "" &&
                                                                      trackingModel
                                                                              .awbCode !=
                                                                          "")
                                                                    Padding(
                                                                      padding: const EdgeInsetsDirectional
                                                                          .only(
                                                                          start:
                                                                              10.0),
                                                                      child: CommonRowBtn(
                                                                          title: 'Download label',
                                                                          onBtnSelected: () {
                                                                            downloadLabel(trackingModel!.shipmentId!);
                                                                          }),
                                                                    ),
                                                                  if (trackingModel
                                                                              .invoiceUrl ==
                                                                          "" &&
                                                                      trackingModel
                                                                              .awbCode !=
                                                                          "")
                                                                    Padding(
                                                                      padding: const EdgeInsetsDirectional
                                                                          .only(
                                                                          start:
                                                                              10.0),
                                                                      child: CommonRowBtn(
                                                                          title: 'Generate invoice',
                                                                          onBtnSelected: () {
                                                                            commonDialogue(context,
                                                                                getTranslated(context, 'Do you want to generate invoice?')!,
                                                                                () {
                                                                              generateInvoice(trackingModel!.shiprocketOrderId!);

                                                                              Routes.pop(context);
                                                                            });
                                                                          }),
                                                                    ),
                                                                  if (trackingModel
                                                                              .invoiceUrl !=
                                                                          "" &&
                                                                      trackingModel
                                                                              .awbCode !=
                                                                          "")
                                                                    Padding(
                                                                      padding: const EdgeInsetsDirectional
                                                                          .only(
                                                                          start:
                                                                              10.0),
                                                                      child: CommonRowBtn(
                                                                          title: 'Download invoice',
                                                                          onBtnSelected: () {
                                                                            downloadInvoice(trackingModel!.shipmentId!);
                                                                          }),
                                                                    ),
                                                                  if (trackingModel
                                                                              .shipmentId !=
                                                                          "" &&
                                                                      trackingModel
                                                                              .awbCode !=
                                                                          "")
                                                                    Padding(
                                                                      padding: const EdgeInsetsDirectional
                                                                          .only(
                                                                          start:
                                                                              10.0),
                                                                      child: CommonRowBtn(
                                                                          title: 'Tracking',
                                                                          onBtnSelected: () {
                                                                            shipRocketOrderTracking(trackingModel!.awbCode!);
                                                                          }),
                                                                    ),
                                                                ]),
                                                          )
                                                        : Align(
                                                            alignment: Alignment
                                                                .centerLeft,
                                                            child: Container(
                                                                decoration: BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(
                                                                                5),
                                                                    color:
                                                                        primary),
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(5),
                                                                child: Text(
                                                                  getTranslated(
                                                                      context,
                                                                      'Order Not Created')!,
                                                                  style: Theme.of(
                                                                          context)
                                                                      .textTheme
                                                                      .bodySmall!
                                                                      .copyWith(
                                                                          color:
                                                                              white),
                                                                )),
                                                          ),
                                                  Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 10.0),
                                                      child: Container(
                                                          width: MediaQuery.of(
                                                                  context)
                                                              .size
                                                              .width,
                                                          decoration:
                                                              const BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius.all(
                                                                    Radius.circular(
                                                                        circularBorderRadius5)),
                                                            color: white,
                                                            boxShadow: [
                                                              BoxShadow(
                                                                color:
                                                                    blarColor,
                                                                offset: Offset(
                                                                    0, 0),
                                                                blurRadius: 4,
                                                                spreadRadius: 0,
                                                              ),
                                                            ],
                                                          ),
                                                          child:
                                                              ListView.builder(
                                                            shrinkWrap: true,
                                                            itemCount: model!
                                                                .itemList!
                                                                .length,
                                                            physics:
                                                                const NeverScrollableScrollPhysics(),
                                                            itemBuilder:
                                                                (context, i) {
                                                              OrderItem
                                                                  orderItem =
                                                                  model!.itemList![
                                                                      i];
                                                              if (pickUpLocationList[
                                                                      j] ==
                                                                  orderItem
                                                                      .pickUpLocation) {
                                                                return Padding(
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .all(
                                                                            10.0),
                                                                    child:
                                                                        Column(
                                                                      children: [
                                                                        productItem(
                                                                          orderItem,
                                                                          model!,
                                                                          i,
                                                                        ),
                                                                        const Divider(),
                                                                      ],
                                                                    ));
                                                              } else {
                                                                return const SizedBox
                                                                    .shrink();
                                                              }
                                                            },
                                                          ))),
                                                ],
                                              );
                                            })),
                                    //complete
                                    model!.payMethod == "Bank Transfer"
                                        ? BankProof(model: model!)
                                        : Container(),
                                    model!.itemList![0].productType ==
                                            'digital_product'
                                        ? Container()
                                        : ShippingDetail(tempList: tempList),

                                    PriceDetail(tempList: tempList),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                DesignConfiguration.showCircularProgress(isProgress, primary),
              ],
            )
          : noInternet(
              context,
              setStateNoInternate,
              buttonSqueezeanimation,
              buttonController,
            ),
    );
  }

  Future<void> createShipRocketParcelDialog() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setStater) {
            delBoyState = setStater;
            return AlertDialog(
              backgroundColor: lightWhite,
              contentPadding: const EdgeInsets.all(0.0),
              title: Center(
                child: Text(
                  getTranslated(context, "Create ShipRocket Order Parcel")!,
                  style: Theme.of(this.context)
                      .textTheme
                      .titleMedium!
                      .copyWith(color: primary),
                ),
              ),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(
                    circularBorderRadius5,
                  ),
                ),
              ),
              content: Padding(
                padding: const EdgeInsets.all(12.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 10.0, 0, 0),
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(color: primary)),
                          child: Text(
                            getTranslated(context,
                                "Note: Make your pickup location associated with the order is verified from Shiprocket Dashboard and then in admin panel . If it is not verified you will not be able to generate AWB later on.")!,
                            style: Theme.of(this.context)
                                .textTheme
                                .titleSmall!
                                .copyWith(),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Row(
                          children: [
                            Text(
                              "${getTranslated(context, "PickUp Location")!} : ",
                              style: Theme.of(this.context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(fontWeight: FontWeight.w600),
                            ),
                            Text(
                              selectPickUpLocation!,
                              style: Theme.of(this.context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Form(
                          key: _formkey,
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Text(
                                  getTranslated(
                                      context, "Total Weight of Box")!,
                                  style: Theme.of(this.context)
                                      .textTheme
                                      .titleMedium!
                                      .copyWith(fontWeight: FontWeight.w600),
                                ),
                              ),
                              ParcelHeight(
                                  heightC: (heightC ?? '').toString(),
                                  update: updateHeight),
                              ParcelWeight(
                                  weight: (weightC ?? '').toString(),
                                  update: updateWeight),
                              ParcelLength(
                                  lengthC: (lengthC ?? '').toString(),
                                  update: updateLength),
                              ParcelBreadth(
                                  breadth: (breadthC ?? '').toString(),
                                  update: updateBreadth)
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                    child: Text(
                      getTranslated(context, "LOGOUTNO")!,
                      style: Theme.of(this.context)
                          .textTheme
                          .titleSmall!
                          .copyWith(
                              color: lightBlack, fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    }),
                TextButton(
                  child: Text(
                    getTranslated(context, "Create Order")!,
                    style: Theme.of(this.context)
                        .textTheme
                        .titleSmall!
                        .copyWith(color: primary, fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                    final form = _formkey.currentState!;
                    form.save();
                    if (form.validate()) {
                      createShipRocketOrder();
                      Routes.pop(context);
                    }
                  },
                )
              ],
            );
          },
        );
      },
    );
  }

  Future<void> createShipRocketOrder() async {
    isNetworkAvail = await isNetworkAvailable();

    if (isNetworkAvail) {
      try {
        setState(() {
          isProgress = true;
        });
        var parameter = {
          UserId: model!.userId,
          ORDER_ID: model!.id,
          PICKUP_LOCATION: selectPickUpLocation,
          PARCEL_WEIGHT: weightC.toString(),
          PARCEL_HEIGHT: heightC.toString(),
          PARCEL_BREADTH: breadthC.toString(),
          PARCEL_LENGTH: lengthC.toString()
        };

        ApiBaseHelper().postAPICall(createShipRocketOrderApi, parameter).then(
          (getdata) async {
            bool error = getdata["error"];
            String msg = getdata["message"];
            setSnackbar(
              msg,
              context,
            );
            if (!error) {
              Navigator.pushReplacement(
                context,
                CupertinoPageRoute(
                    builder: (BuildContext context) => super.widget),
              );
              // getOrderTrackingData();
            } else {}
            setState(() {
              isProgress = false;
            });
          },
          onError: (error) {
            setSnackbar(
              error.toString(),
              context,
            );
          },
        );
      } on TimeoutException catch (_) {
        setSnackbar(
          getTranslated(context, "somethingMSg")!,
          context,
        );
      }
    } else {
      setState(
        () {
          isNetworkAvail = false;
        },
      );
    }
  }

  Future<void> generateAWB(String shipmentId, OrderTrackingModel model) async {
    isNetworkAvail = await isNetworkAvailable();

    if (isNetworkAvail) {
      try {
        setState(() {
          isProgress = true;
        });
        var parameter = {
          SHIPMENT_ID: shipmentId,
        };

        ApiBaseHelper().postAPICall(generateAWBApi, parameter).then(
          (getdata) async {
            bool error = getdata["error"];
            String msg = getdata["message"];
            setSnackbar(
              msg,
              context,
            );
            if (!error) {
              Navigator.pushReplacement(
                context,
                CupertinoPageRoute(
                    builder: (BuildContext context) => super.widget),
              );
            } else {}
            setState(() {
              isProgress = false;
            });
          },
          onError: (error) {
            setSnackbar(
              error.toString(),
              context,
            );
          },
        );
      } on TimeoutException catch (_) {
        setSnackbar(
          getTranslated(context, "somethingMSg")!,
          context,
        );
      }
    } else {
      setState(
        () {
          isNetworkAvail = false;
        },
      );
    }
  }

  Future<void> getShipRocketOrder(String shipRocketOrderId) async {
    isNetworkAvail = await isNetworkAvailable();

    if (isNetworkAvail) {
      try {
        setState(() {
          isProgress = true;
        });
        var parameter = {
          SHIPROCKET_ORDER_ID: shipRocketOrderId,
        };

        ApiBaseHelper().postAPICall(getShipRocketOrderApi, parameter).then(
          (getdata) async {
            bool error = getdata["error"];
            String msg = getdata["message"];

            setSnackbar(
              msg,
              context,
            );
            if (!error) {
              if (getdata["data"]["status"] != null) {
                setState(() {
                  pickUpStatus = getdata["data"]["status"];
                });
              } else {
                setState(() {
                  pickUpStatus = '';
                });
              }
            } else {
              setState(() {
                pickUpStatus = '';
              });
            }
            setState(() {
              isProgress = false;
            });
          },
          onError: (error) {
            setSnackbar(
              error.toString(),
              context,
            );
          },
        );
      } on TimeoutException catch (_) {
        setSnackbar(
          getTranslated(context, "somethingMSg")!,
          context,
        );
      }
    } else {
      setState(
        () {
          isNetworkAvail = false;
        },
      );
    }
  }

  Future<void> sendPickUpRequest(String shipmentId) async {
    isNetworkAvail = await isNetworkAvailable();

    if (isNetworkAvail) {
      try {
        setState(() {
          isProgress = true;
        });
        var parameter = {
          SHIPMENT_ID: shipmentId,
        };

        ApiBaseHelper().postAPICall(sendPickUpRequestApi, parameter).then(
          (getdata) async {
            bool error = getdata["error"];
            String msg = getdata["message"];
            setSnackbar(
              msg,
              context,
            );
            if (!error) {
              Navigator.pushReplacement(
                context,
                CupertinoPageRoute(
                    builder: (BuildContext context) => super.widget),
              );
            } else {}
            setState(() {
              isProgress = false;
            });
          },
          onError: (error) {
            setSnackbar(
              error.toString(),
              context,
            );
          },
        );
      } on TimeoutException catch (_) {
        setSnackbar(
          getTranslated(context, "somethingMSg")!,
          context,
        );
      }
    } else {
      setState(
        () {
          isNetworkAvail = false;
        },
      );
    }
  }

  Future<void> cancelShipRocketOrder(
      String shipmentOrderId, List<String> ids) async {
    isNetworkAvail = await isNetworkAvailable();

    if (isNetworkAvail) {
      try {
        setState(() {
          isProgress = true;
        });
        var parameter = {
          SHIPROCKET_ORDER_ID: shipmentOrderId,
        };

        ApiBaseHelper().postAPICall(cancelShipRocketOrderApi, parameter).then(
          (getdata) async {
            bool error = getdata["error"];
            String msg = getdata["message"];
            setSnackbar(
              msg,
              context,
            );
            if (!error) {
              Navigator.pushReplacement(
                context,
                CupertinoPageRoute(
                    builder: (BuildContext context) => super.widget),
              );
              /*for (int i = 0; i < tempList[0].itemList!.length; i++) {
                if (ids.contains(tempList[0].itemList![i].id)) {
                  setState(() {
                    tempList[0].itemList![i].status = 'cancelled';
                  });
                }
              }*/
            } else {}
            setState(() {
              isProgress = false;
            });
          },
          onError: (error) {
            setSnackbar(
              error.toString(),
              context,
            );
          },
        );
      } on TimeoutException catch (_) {
        setSnackbar(
          getTranslated(context, "somethingMSg")!,
          context,
        );
      }
    } else {
      setState(
        () {
          isNetworkAvail = false;
        },
      );
    }
  }

  Future<void> generateLabel(String shipmentId) async {
    isNetworkAvail = await isNetworkAvailable();

    if (isNetworkAvail) {
      try {
        setState(() {
          isProgress = true;
        });
        var parameter = {
          SHIPMENT_ID: shipmentId,
        };

        ApiBaseHelper().postAPICall(generateLabelApi, parameter).then(
          (getdata) async {
            bool error = getdata["error"];
            String msg = getdata["message"];
            setSnackbar(
              msg,
              context,
            );
            if (!error) {
              // var data = getdata["data"];

              Navigator.pushReplacement(
                context,
                CupertinoPageRoute(
                    builder: (BuildContext context) => super.widget),
              );

              /* setState(() {
                model.labelUrl = data[LABEL_URL];
              });*/
              //String labelUrl = data[LABEL_URL];
            } else {}
            setState(() {
              isProgress = false;
            });
          },
          onError: (error) {
            setSnackbar(
              error.toString(),
              context,
            );
          },
        );
      } on TimeoutException catch (_) {
        setSnackbar(
          getTranslated(context, "somethingMSg")!,
          context,
        );
      }
    } else {
      setState(
        () {
          isNetworkAvail = false;
        },
      );
    }
  }

  Future<void> downloadLabel(String shipmentId) async {
    isNetworkAvail = await isNetworkAvailable();

    if (isNetworkAvail) {
      try {
        setState(() {
          isProgress = true;
        });
        var parameter = {
          SHIPMENT_ID: shipmentId,
        };

        ApiBaseHelper().postAPICall(downloadLabelApi, parameter).then(
          (getdata) async {
            bool error = getdata["error"];
            String msg = getdata["message"];
            setSnackbar(
              msg,
              context,
            );
            if (!error) {
              var data = getdata["data"];

              final response = await get(
                Uri.parse(data),
              );
              Uint8List urldata = response.bodyBytes;
              downloadLabelCode(urldata);
            } else {}
            setState(() {
              isProgress = false;
            });
          },
          onError: (error) {
            setSnackbar(
              error.toString(),
              context,
            );
          },
        );
      } on TimeoutException catch (_) {
        setSnackbar(
          getTranslated(context, "somethingMSg")!,
          context,
        );
      }
    } else {
      setState(
        () {
          isNetworkAvail = false;
        },
      );
    }
  }

  downloadLabelCode(Uint8List url) async {
    try {
      final appDocDirPath = Platform.isAndroid
          ? (await ExternalPath.getExternalStoragePublicDirectory(
              ExternalPath.DIRECTORY_DOWNLOADS))
          : (await getApplicationDocumentsDirectory()).path;

      final targetFileName =
          "${getTranslated(context, "app_name")}-${getTranslated(context, "Label")}#${model!.id.toString()}.pdf";

      File file = File("$appDocDirPath/$targetFileName");

      // Write down the file as bytes from the bytes got from the HTTP request.
      await file.writeAsBytes(url, flush: false);
      await file.writeAsBytes(url);

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        action: SnackBarAction(
          label: getTranslated(context, "Download Label")!,
          onPressed: () {
            OpenFilex.open(file.path);
          },
        ),
        content: Text(
          getTranslated(context, "Download Label Successfully")!,
          softWrap: true,
          style: const TextStyle(color: black),
        ),
        duration: const Duration(seconds: 5),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ));
    } catch (_) {}
  }

  Future<void> generateInvoice(String shiprockerOrderId) async {
    isNetworkAvail = await isNetworkAvailable();

    if (isNetworkAvail) {
      try {
        setState(() {
          isProgress = true;
        });
        var parameter = {
          SHIPROCKET_ORDER_ID: shiprockerOrderId,
        };

        ApiBaseHelper().postAPICall(generateInvoiceApi, parameter).then(
          (getdata) async {
            bool error = getdata["error"];
            String msg = getdata["message"];
            setSnackbar(
              msg,
              context,
            );
            if (!error) {
              // var data = getdata["data"];
              Navigator.pushReplacement(
                context,
                CupertinoPageRoute(
                    builder: (BuildContext context) => super.widget),
              );
              /* setState(() {
                model.invoiceUrl = data[INVOICE_URL];
              });*/
              //String invoiceUrl = data[INVOICE_URL];
            } else {}
            setState(() {
              isProgress = false;
            });
          },
          onError: (error) {
            setSnackbar(
              error.toString(),
              context,
            );
          },
        );
      } on TimeoutException catch (_) {
        setSnackbar(
          getTranslated(context, "somethingMSg")!,
          context,
        );
      }
    } else {
      setState(
        () {
          isNetworkAvail = false;
        },
      );
    }
  }

  Future<void> downloadInvoice(String shipmentId) async {
    isNetworkAvail = await isNetworkAvailable();

    if (isNetworkAvail) {
      try {
        setState(() {
          isProgress = true;
        });
        var parameter = {
          SHIPMENT_ID: shipmentId,
        };

        ApiBaseHelper().postAPICall(downloadInvoiceApi, parameter).then(
          (getdata) async {
            bool error = getdata["error"];
            String msg = getdata["message"];
            setSnackbar(
              msg,
              context,
            );
            if (!error) {
              var data = getdata["data"];

              final response = await get(
                Uri.parse(data),
              );
              print("response invoice****${response.bodyBytes.toString()}");
              Uint8List urldata = response.bodyBytes;
              downloadInvoiceCode(urldata);
            } else {}
            setState(() {
              isProgress = false;
            });
          },
          onError: (error) {
            setSnackbar(
              error.toString(),
              context,
            );
          },
        );
      } on TimeoutException catch (_) {
        setSnackbar(
          getTranslated(context, "somethingMSg")!,
          context,
        );
      }
    } else {
      setState(
        () {
          isNetworkAvail = false;
        },
      );
    }
  }

  downloadInvoiceCode(Uint8List url) async {
    try {
      final appDocDirPath = Platform.isAndroid
          ? (await ExternalPath.getExternalStoragePublicDirectory(
              ExternalPath.DIRECTORY_DOWNLOADS))
          : (await getApplicationDocumentsDirectory()).path;

      final targetFileName =
          "${getTranslated(context, "app_name")}-${getTranslated(context, "Invoice")}#${model!.id.toString()}.pdf";

      File file = File("$appDocDirPath/$targetFileName");

      // Write down the file as bytes from the bytes got from the HTTP request.
      await file.writeAsBytes(url, flush: false);
      await file.writeAsBytes(url);

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        action: SnackBarAction(
          label: getTranslated(context, "Download Invoice")!,
          onPressed: () {
            OpenFilex.open(file.path);
          },
        ),
        content: Text(
          getTranslated(context, "Download Invoice Successfully")!,
          softWrap: true,
          style: const TextStyle(color: black),
        ),
        duration: const Duration(seconds: 5),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ));
    } catch (_) {}
  }

  Future<void> shipRocketOrderTracking(String awbCode) async {
    isNetworkAvail = await isNetworkAvailable();

    if (isNetworkAvail) {
      try {
        setState(() {
          isProgress = true;
        });
        var parameter = {
          AWB_CODE: awbCode,
        };

        ApiBaseHelper().postAPICall(shipRocketOrderTrackingApi, parameter).then(
          (getdata) async {
            bool error = getdata["error"];
            String msg = getdata["message"];
            setSnackbar(
              msg,
              context,
            );
            if (!error) {
              /* setState(() {
                model.orderTrackingUrl = getdata["data"];
              });*/
              if (await canLaunchUrl(Uri.parse(getdata["data"]))) {
                await launchUrl(Uri.parse(getdata["data"]));
              } else {
                throw 'Could not launch $url';
              }
              //var orderTrackingUrl = getdata["data"];
            } else {}
            setState(() {
              isProgress = false;
            });
          },
          onError: (error) {
            setSnackbar(
              error.toString(),
              context,
            );
          },
        );
      } on TimeoutException catch (_) {
        setSnackbar(
          getTranslated(context, "somethingMSg")!,
          context,
        );
      }
    } else {
      setState(
        () {
          isNetworkAvail = false;
        },
      );
    }
  }

  updateHeight(String height) {
    setState(() {
      heightC = double.parse(height);
    });
  }

  updateWeight(String weight) {
    setState(() {
      weightC = double.parse(weight);
    });
  }

  updateLength(String length) {
    setState(() {
      lengthC = double.parse(length);
    });
  }

  updateBreadth(String breadth) {
    setState(() {
      breadthC = double.parse(breadth);
    });
  }

  Future<void> searchOperation(String searchText) async {
    searchList.clear();
    for (int i = 0; i < delBoyList.length; i++) {
      PersonModel map = delBoyList[i];
      if (map.name!.toLowerCase().contains(searchText)) {
        searchList.add(map);
      }
    }
    if (mounted) delBoyState(() {});
  }

  Future<void> delboyDialog() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setStater) {
            delBoyState = setStater;
            return AlertDialog(
              contentPadding: const EdgeInsets.all(0.0),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(
                    circularBorderRadius5,
                  ),
                ),
              ),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20.0, 20.0, 0, 0),
                    child: Text(
                      getTranslated(context, "SELECTDELBOY")!,
                      style: Theme.of(this.context)
                          .textTheme
                          .titleMedium!
                          .copyWith(color: primary),
                    ),
                  ),
                  TextField(
                    controller: _controller,
                    autofocus: false,
                    decoration: InputDecoration(
                      contentPadding:
                          const EdgeInsets.fromLTRB(0, 15.0, 0, 15.0),
                      prefixIcon:
                          const Icon(Icons.search, color: primary, size: 17),
                      hintText: getTranslated(context, "Search")!,
                      hintStyle: TextStyle(color: primary.withOpacity(0.5)),
                      enabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: white),
                      ),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: white),
                      ),
                    ),
                  ),
                  const Divider(color: lightBlack),
                  Flexible(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: () {
                          return searchList
                              .asMap()
                              .map(
                                (index, element) => MapEntry(
                                  index,
                                  InkWell(
                                    onTap: () {
                                      if (mounted) {
                                        selectedDelBoy = index;
                                        curSelectedDeliveryBoy =
                                            searchList[index].name;
                                        /* updateOrder(updateOrderItemApi, true);*/
                                        setState(
                                          () {},
                                        );
                                      }
                                      Navigator.of(context).pop();
                                    },
                                    child: SizedBox(
                                      width: double.maxFinite,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          searchList[index].name!,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                              .values
                              .toList();
                        }(),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  List<Widget> getLngList() {
    return searchList
        .asMap()
        .map(
          (index, element) => MapEntry(
            index,
            InkWell(
              onTap: () {
                if (mounted) {
                  setState(
                    () {
                      selectedDelBoy = index;
                      Navigator.of(context).pop();
                    },
                  );
                }
              },
              child: SizedBox(
                width: double.maxFinite,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    searchList[index].name!,
                  ),
                ),
              ),
            ),
          ),
        )
        .values
        .toList();
  }

  productItem(
    OrderItem orderItem,
    Order_Model model,
    int i,
  ) {
    List att = [], val = [];
    if (orderItem.attr_name!.isNotEmpty) {
      att = orderItem.attr_name!.split(',');
      val = orderItem.varient_values!.split(',');
    }
/*    final index1 = searchList
        .indexWhere((element) => element.id == orderItem.deliveryBoyId);*/
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                  alignment: Alignment.topLeft,
                  onPressed: () {
                    if (orderItemIds.contains(orderItem.id)) {
                      setState(() {
                        orderItemIds.remove(orderItem.id);
                      });
                    } else {
                      setState(() {
                        orderItemIds.add(orderItem.id!);
                      });
                    }
                  },
                  icon: orderItemIds.contains(orderItem.id)
                      ? const Icon(
                          Icons.check_box,
                          color: primary,
                        )
                      : const Icon(
                          Icons.check_box_outline_blank,
                          color: primary,
                        )),
              ClipRRect(
                child: DesignConfiguration.getCacheNotworkImage(
                  boxFit: BoxFit.cover,
                  context: context,
                  heightvalue: 94,
                  widthvalue: 64,
                  imageurlString: orderItem.image!,
                  placeHolderSize: 150,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: Text(
                          orderItem.name ?? '',
                          style:
                              Theme.of(context).textTheme.titleMedium!.copyWith(
                                    color: black,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: "PlusJakartaSans",
                                    fontStyle: FontStyle.normal,
                                    fontSize: textFontSize13,
                                  ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      orderItem.attr_name!.isNotEmpty
                          ? ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: att.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: Row(
                                    children: [
                                      Flexible(
                                        child: Text(
                                          att[index].trim() + ":",
                                          overflow: TextOverflow.ellipsis,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleSmall!
                                              .copyWith(
                                                color: grey3,
                                                fontWeight: FontWeight.w400,
                                                fontFamily: "PlusJakartaSans",
                                                fontStyle: FontStyle.normal,
                                                fontSize: textFontSize13,
                                              ),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 5.0),
                                        child: Text(
                                          val[index],
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleSmall!
                                              .copyWith(
                                                color: black,
                                                fontWeight: FontWeight.w400,
                                                fontFamily: "PlusJakartaSans",
                                                fontStyle: FontStyle.normal,
                                                fontSize: textFontSize13,
                                              ),
                                        ),
                                      )
                                    ],
                                  ),
                                );
                              },
                            )
                          : Container(),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Row(
                          children: [
                            Text(
                              "${getTranslated(context, "QUANTITY_LBL")!}:",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall!
                                  .copyWith(color: lightBlack2),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 5.0),
                              child: Text(
                                orderItem.qty!,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall!
                                    .copyWith(color: lightBlack),
                              ),
                            )
                          ],
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Row(
                          children: [
                            Text(
                              "${getTranslated(context, "Active Status")!}:",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall!
                                  .copyWith(color: lightBlack2),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 5.0),
                                child: Text(
                                  orderItem.activeStatus!.replaceAll('_', ' '),
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall!
                                      .copyWith(color: lightBlack),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 3,
                                  softWrap: true,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      if (orderItem.activeStatus == 'Delivered')
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Row(
                            children: [
                              Text(
                                "${getTranslated(context, "Delivered By")!}:",
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall!
                                    .copyWith(color: lightBlack2),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 5.0),
                                child: Text(
                                  orderItem.deliverBy!,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall!
                                      .copyWith(color: lightBlack),
                                ),
                              )
                            ],
                          ),
                        ),
                      Text(
                        "${DesignConfiguration.getPriceFormat(
                          context,
                          double.parse(orderItem.price!),
                        )!}  (${getTranslated(context, "INCLUDE_TAXLBL")} ${orderItem.taxamount.toString()}) ",
                        style: const TextStyle(
                          color: primary,
                          fontWeight: FontWeight.w700,
                          fontFamily: "PlusJakartaSans",
                          fontStyle: FontStyle.normal,
                          fontSize: textFontSize13,
                        ),
                      ),
                      orderItem.productType == 'digital_product'
                          ? orderItem.downloadAllowed == "0"
                              ? Padding(
                                  padding: const EdgeInsets.only(
                                    top: 15.0,
                                  ),
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        CupertinoPageRoute(
                                          builder: (context) => SendMail(
                                            email: tempList[0].email ?? '',
                                            productName: orderItem.name ?? '',
                                            orderId: model.id ?? '',
                                            orderIteamId: orderItem.id ?? '',
                                            userName: model.username ?? '',
                                          ),
                                        ),
                                      );
                                      // emailSendButtomSheet(context,
                                      //     setState, orderItem.name);
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: primary,
                                        ),
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(
                                              circularBorderRadius5),
                                        ),
                                      ),
                                      height: 40,
                                      width: MediaQuery.of(context).size.width,
                                      child: const Center(
                                        child: Text(
                                          "Send Mail",
                                          style: TextStyle(
                                            color: primary,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              : Container()
                          : Container(),
//==============================================================================
//============================ Status of Order =================================
                    ],
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  showTrackingDialog(OrderItem model) async {
    String? urlDetails, couriourDetails, trackingDetails;
    if (model.trackingId != "") {
      urlDetails = model.url;
      couriourDetails = model.courierAgency;
      trackingDetails = model.trackingId;
    }
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setStater) {
            return AlertDialog(
              contentPadding: const EdgeInsets.all(0.0),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(
                    circularBorderRadius5,
                  ),
                ),
              ),
              content: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                        padding: const EdgeInsets.fromLTRB(20.0, 20.0, 0, 2.0),
                        child: Text(
                          getTranslated(context, "Tracking Detail")!,
                          style: Theme.of(this.context)
                              .textTheme
                              .titleMedium!
                              .copyWith(color: primary),
                        )),
                    const Divider(color: lightBlack),
                    Form(
                      key: _formkey,
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding:
                                const EdgeInsets.fromLTRB(20.0, 0, 20.0, 0),
                            child: TextFormField(
                              keyboardType: TextInputType.text,
                              validator: validateField,
                              initialValue: couriourDetails,
                              decoration: InputDecoration(
                                hintText:
                                    getTranslated(context, "Courier Agency"),
                                hintStyle: Theme.of(this.context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(
                                      color: lightBlack,
                                      fontWeight: FontWeight.normal,
                                    ),
                              ),
                              controller: courierAgencyController,
                              onSaved: (value) {
                                courierAgency = value;
                              },
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.fromLTRB(20.0, 0, 20.0, 0),
                            child: TextFormField(
                              keyboardType: TextInputType.text,
                              validator: validateField,
                              initialValue: trackingDetails,
                              decoration: InputDecoration(
                                hintText: getTranslated(context, "Tracking ID"),
                                hintStyle: Theme.of(this.context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(
                                      color: lightBlack,
                                      fontWeight: FontWeight.normal,
                                    ),
                              ),
                              onSaved: (value) {
                                trackingId = value;
                              },
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.fromLTRB(20.0, 0, 20.0, 0),
                            child: TextFormField(
                              keyboardType: TextInputType.text,
                              validator: validateField,
                              initialValue: urlDetails,
                              decoration: InputDecoration(
                                hintText: "URL",
                                hintStyle: Theme.of(this.context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(
                                      color: lightBlack,
                                      fontWeight: FontWeight.normal,
                                    ),
                              ),
                              controller: urlController,
                              onSaved: (value) {
                                url = value;
                              },
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: Text(
                    getTranslated(context, 'CANCEL')!,
                    style:
                        Theme.of(this.context).textTheme.titleSmall!.copyWith(
                              color: lightBlack,
                              fontWeight: FontWeight.bold,
                            ),
                  ),
                  onPressed: () {
                    Routes.pop(context);
                  },
                ),
                TextButton(
                  child: Text(
                    getTranslated(context, "SAVE_LBL")!,
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                          color: primary,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  onPressed: () {
                    final form = _formkey.currentState!;
                    if (form.validate()) {
                      form.save();
                      setState(
                        () {
                          isProgress = true;
                          Routes.pop(context);
                        },
                      );
                      editTrackingDetails(
                          model, courierAgency, trackingId, url);
                    }
                  },
                )
              ],
            );
          },
        );
      },
    );
  }

  Future<void> editTrackingDetails(
    OrderItem model,
    String? courierAgency,
    String? trackingId,
    String? url,
  ) async {
    isNetworkAvail = await isNetworkAvailable();

    if (isNetworkAvail) {
      try {
        var parameter = {
          "order_item_id": model.id,
          courier_agency: courierAgency,
          tracking_id: trackingId,
          Url: url,
        };
        ApiBaseHelper().postAPICall(editOrderTrackingApi, parameter).then(
          (getdata) async {
            bool error = getdata["error"];
            String msg = getdata["message"];
            setSnackbar(
              msg,
              context,
            );
            if (!error) {
              getOrderDetail();
            } else {
              getOrderDetail();
            }
            setState(() {
              isProgress = false;
            });
          },
          onError: (error) {
            setSnackbar(
              error.toString(),
              context,
            );
          },
        );
      } on TimeoutException catch (_) {
        setSnackbar(
          getTranslated(
            context,
            "somethingMSg",
          )!,
          context,
        );
      }
    } else {
      setState(
        () {
          isNetworkAvail = false;
        },
      );
    }
  }

  String? validateField(
    String? value,
  ) {
    if (value!.isEmpty) {
      return getTranslated(context, "This Field is required");
    } else {
      return null;
    }
  }

  Future<void> updateOrder() async {
    isNetworkAvail = await isNetworkAvailable();
    if (true) {
      if (isNetworkAvail) {
        try {
          setState(() {
            isProgress = true;
          });
          var parameter = {
            STATUS: curSelectedStatus,
          };
          if ((curSelectedStatus == "cancelled" ||
                  curSelectedStatus == "returned") &&
              orderItemIds.isNotEmpty) {
            parameter[ORDERITEMID] = orderItemIds.join(",");
          }

          // if (orderItemIds.isEmpty) {
          parameter[ORDER_ID] = model!.id!;
          // }
          if (selectedDelBoy != null) {
            parameter[DEL_BOY_ID] = searchList[selectedDelBoy!].id;
          }
          ApiBaseHelper().postAPICall(updateOrderItemApi, parameter).then(
            (getdata) async {
              bool error = getdata["error"];
              String msg = getdata["message"];
              setSnackbar(
                msg,
                context,
              );
              if (!error) {
                if (orderItemIds.isNotEmpty) {
                  for (int i = 0; i < tempList[0].itemList!.length; i++) {
                    if (orderItemIds.contains(tempList[0].itemList![i].id)) {
                      tempList[0].itemList![i].status = curSelectedStatus;
                    }
                  }
                } else {
                  tempList[0].itemList![0].activeStatus = curSelectedStatus;
                }
                /*     if (item) {
                  tempList[0].itemList![index].status = status;
                } else {
                  tempList[0].itemList![0].activeStatus = status;
                }*/
                if (selectedDelBoy != null) {
                  tempList[0].itemList![0].deliveryBoyId =
                      searchList[selectedDelBoy!].id;
                }
                orderItemIds.clear();
                getOrderDetail();
                if (widget.update != null) {
                  widget.update!();
                }
              } else {
                orderItemIds.clear();
                getOrderDetail();
              }
              setState(() {
                isProgress = false;
              });
            },
            onError: (error) {
              setSnackbar(
                error.toString(),
                context,
              );
            },
          );
        } on TimeoutException catch (_) {
          setSnackbar(
            getTranslated(context, "somethingMSg")!,
            context,
          );
        }
      } else {
        setState(
          () {
            isNetworkAvail = false;
          },
        );
      }
    }
  }
}
