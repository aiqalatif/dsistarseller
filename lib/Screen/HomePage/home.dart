import 'dart:async';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sellermultivendor/Helper/ApiBaseHelper.dart';
import 'package:sellermultivendor/Helper/Color.dart';
import 'package:sellermultivendor/Helper/Constant.dart';
import 'package:sellermultivendor/Widget/desing.dart';
import 'package:sellermultivendor/Widget/parameterString.dart';
import 'package:sellermultivendor/Localization/Language_Constant.dart';
import '../../Model/OrdersModel/OrderModel.dart';
import '../../Provider/homeProvider.dart';
import '../../Provider/privacyProvider.dart';
import '../../Provider/settingProvider.dart';
import '../../Widget/api.dart';
import '../../Widget/networkAvailablity.dart';
import '../../Widget/noNetwork.dart';
import '../../Widget/routes.dart';
import '../../Widget/sharedPreferances.dart';
import '../../Widget/simmerEffect.dart';
import '../../Widget/snackbar.dart';
import '../../Widget/systemChromeSettings.dart';
import '../../Widget/validation.dart';
import '../Authentication/Login.dart';
import 'Widget/Charts/categoryChart.dart';
import 'Widget/Charts/dayLineChart.dart';
import 'Widget/Charts/monthDataChart.dart';
import 'Widget/Charts/weekDataChart.dart';
import 'Widget/appMaintanceDialog.dart';
import 'Widget/boxesDesingHome.dart';
import 'Widget/randomColorWidget.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

ApiBaseHelper apiBaseHelper = ApiBaseHelper();
bool _isLoading = true;
bool isLoadingmore = true;
String? delPermission;
bool customerViewPermission = false;
Map<int, LineChartData>? chartList;
List colorList = [];
int? selectLan;
int? touchedIndex;
List<String> langCode = [
  ENGLISH,
  HINDI,
  CHINESE,
  SPANISH,
  ARABIC,
  RUSSIAN,
  JAPANESE,
  DEUTSCH
];

class _HomeState extends State<Home>
    with AutomaticKeepAliveClientMixin<Home>, TickerProviderStateMixin {
//==============================================================================
//============================= Variables Declaration ==========================

  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<Order_Model> tempList = [];

  @override
  bool get wantKeepAlive => true;

  setStateProfile() {
    providerRequiestForData();
    getSallerDetail();
    providerRequiestForData();
    setState(() {});
    Routes.pop(context);
  }

  String? all,
      received,
      processed,
      shipped,
      delivered,
      cancelled,
      returned,
      awaiting;
  String? mobile;

  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();
  ScrollController? controller;

  String? activeStatus;
  Animation? buttonSqueezeanimation;
  AnimationController? buttonController;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  List<String> statusList = [
    ALL,
    PLACED,
    PROCESSED,
    SHIPED,
    DELIVERD,
    CANCLED,
    RETURNED,
    awaitingPayment
  ];

//===================================== For Chart ==============================
  int curChart = 0;

//============================= initState Method ===============================
  @override
  void initState() {
    callApi();
    context.read<HomeProvider>().getSalesReportRequest(context);
    SystemChromeSettings.setSystemButtomNavigationBarithTopAndButtom();
    SystemChromeSettings.setSystemUIOverlayStyleWithLightBrightNessStyle();

    providerRequiestForData();
    getSallerDetail();
    buttonController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

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
    controller = ScrollController(keepScrollOffset: true);

    super.initState();
  }

//==============================================================================
//============================= For Animation ==================================

  Future<void> _playAnimation() async {
    try {
      await buttonController!.forward();
    } on TickerCanceled {}
  }

//==============================================================================
//============================= Build Method ===================================

  @override
  Widget build(BuildContext context) {
    super.build(context);
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return ScaffoldMessenger(
      key: scaffoldMessengerKey,
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: lightWhite,
        body: getBodyPart(),
      ),
    );
  }

//==============================================================================
//=============================== chart coding  ================================

  getChart() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(circularBorderRadius15),
          color: Colors.white,
          boxShadow: const [
            BoxShadow(
              color: blarColor,
              offset: Offset(0, 0),
              blurRadius: 4,
              spreadRadius: 0,
            ),
          ],
        ),
        height: 250,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0, top: 8),
                  child: Text(
                    getTranslated(context, "ProductSales")!,
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(color: primary),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    style: curChart == 0
                        ? TextButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: primary,
                            disabledForegroundColor: Colors.grey,
                          )
                        : null,
                    onPressed: () {
                      setState(
                        () {
                          curChart = 0;
                        },
                      );
                    },
                    child: Text(
                      getTranslated(context, "Day")!,
                    ),
                  ),
                  TextButton(
                    style: curChart == 1
                        ? TextButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: primary,
                            disabledForegroundColor: Colors.grey,
                          )
                        : null,
                    onPressed: () {
                      setState(
                        () {
                          curChart = 1;
                        },
                      );
                    },
                    child: Text(
                      getTranslated(context, "Week")!,
                    ),
                  ),
                  TextButton(
                    style: curChart == 2
                        ? TextButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: primary,
                            disabledForegroundColor: Colors.grey,
                          )
                        : null,
                    onPressed: () {
                      setState(
                        () {
                          curChart = 2;
                        },
                      );
                    },
                    child: Text(
                      getTranslated(context, "Month")!,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Expanded(
                child: LineChart(
                  chartList![curChart]!,
                  duration: const Duration(milliseconds: 250),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }

//==============================================================================
//========================= get_seller_details API =============================

  Future<void> getSallerDetail() async {
    isNetworkAvail = await isNetworkAvailable();
    if (isNetworkAvail) {
      context.read<SettingProvider>().CUR_USERID = await getPrefrence(Id);
      var parameter = {
        // Id: context.read<SettingProvider>().CUR_USERID
        };
      ApiBaseHelper().postAPICall(getSellerDetailsApi, parameter).then(
        (getdata) async {
          bool error = getdata["error"];
          if (!error) {
            var data = getdata["data"][0];
            if (data["status"] != "1") {
              clearUserSession(context);
              Navigator.of(context).pushAndRemoveUntil(
                  CupertinoPageRoute(
                    builder: (context) => const Login(),
                  ),
                  (Route<dynamic> route) => false);
              return;
            }
            CUR_BALANCE = double.parse(data[BALANCE]).toStringAsFixed(2);
            LOGO = data["logo"].toString();
            RATTING = data[Rating] ?? "";
            NO_OFF_RATTING = data[NoOfRatings] ?? "";
            var id = data[UserId];
            var username = data[Username];
            mobile = data[Mobile];
            context.read<SettingProvider>().CUR_USERID = id!;
            CUR_USERNAME = username!;
            await saveUserDetail(
              id!,
              username!,
              mobile!,
              getdata[TOKEN],
            );
          }
          setState(
            () {
              _isLoading = false;
            },
          );
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
            _isLoading = false;
          },
        );
      }
    }
    return;
  }

  setStateNow() {
    setState(() {});
  }

//==============================================================================
//=========================== Body Part Implimentation =========================

  getBodyPart() {
    return isNetworkAvail
        ? Consumer<HomeProvider>(
            builder: (context, value, child) {
              chartList = {
                0: dayData(value),
                1: weekData(value),
                2: monthData(value)
              };
              if (value.getCurrentStatus == HomeProviderStatus.isSuccsess) {
                return _isLoading || supportedLocale == null
                    ? const ShimmerEffect()
                    : RefreshIndicator(
                        key: _refreshIndicatorKey,
                        onRefresh: _refresh,
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              Container(
                                decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [grad1Color, grad2Color],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    stops: [0, 1],
                                    tileMode: TileMode.clamp,
                                  ),
                                ),
                                height:
                                    MediaQuery.of(context).padding.top + 169,
                                padding: EdgeInsets.only(
                                    top: MediaQuery.of(context).padding.top),
                                width: MediaQuery.of(context).size.width,
                                child: Stack(
                                  children: [
                                    Opacity(
                                      opacity: 0.17000000178813934,
                                      child: Container(
                                        width: width,
                                        height: 1,
                                        decoration: const BoxDecoration(
                                          color: white,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 155,
                                      child: Padding(
                                        padding:
                                            const EdgeInsetsDirectional.only(
                                          top: 9.0,
                                          start: 15,
                                          end: 15,
                                        ),
                                        child: Text(
                                          "${getTranslated(context, 'Welcome')}, $CUR_USERNAME",
                                          style: const TextStyle(
                                            fontFamily: 'PlusJakartaSans',
                                            color: white,
                                            fontSize: textFontSize20,
                                            fontWeight: FontWeight.w400,
                                            fontStyle: FontStyle.normal,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Positioned.directional(
                                      textDirection: Directionality.of(context),
                                      top: 64,
                                      end: 0,
                                      child: Container(
                                        decoration: const BoxDecoration(
                                          color: lightWhite,
                                        ),
                                        height: 124,
                                        width:
                                            MediaQuery.of(context).size.width,
                                      ),
                                    ),
                                    Positioned.directional(
                                      textDirection: Directionality.of(context),
                                      top: 38,
                                      end: 15,
                                      start: 15,
                                      child: Container(
                                        decoration: const BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(
                                                  circularBorderRadius15)),
                                          color: white,
                                          boxShadow: [
                                            BoxShadow(
                                              color: blarColor,
                                              offset: Offset(0, 0),
                                              blurRadius: 4,
                                              spreadRadius: 0,
                                            ),
                                          ],
                                        ),
                                        height: 130,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                top: 8.0,
                                                bottom: 8.0,
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                      getTranslated(context,
                                                          "Total Sale")!,
                                                      style: const TextStyle(
                                                          color: primary,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          fontFamily: "Roboto",
                                                          fontStyle:
                                                              FontStyle.normal,
                                                          fontSize:
                                                              textFontSize12),
                                                      textAlign: TextAlign.left)
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                bottom: 8.0,
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                      DesignConfiguration
                                                              .getPriceFormat(
                                                            context,
                                                            double.parse(value
                                                                .overallSale!
                                                                .toString()),
                                                          ) ??
                                                          '0.0',
                                                      style: const TextStyle(
                                                          color: black,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          fontFamily: "Roboto",
                                                          fontStyle:
                                                              FontStyle.normal,
                                                          fontSize:
                                                              textFontSize14),
                                                      textAlign: TextAlign.left)
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8.0),
                                              child: Opacity(
                                                opacity: 0.05000000074505806,
                                                child: Container(
                                                    width: 327,
                                                    height: 1,
                                                    decoration:
                                                        const BoxDecoration(
                                                            color: grey)),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 10.0),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  gethomePageTextDesing(
                                                      RATTING, "Rating"),
                                                  Opacity(
                                                    opacity:
                                                        0.05000000074505806,
                                                    child: Container(
                                                        width: 1,
                                                        height: 40,
                                                        decoration:
                                                            const BoxDecoration(
                                                                color: grey)),
                                                  ),
                                                  gethomePageTextDesing(
                                                      value.totalproductCount ??
                                                          '0',
                                                      getTranslated(context,
                                                          "Total Product")!),
                                                  Opacity(
                                                    opacity:
                                                        0.05000000074505806,
                                                    child: Container(
                                                        width: 1,
                                                        height: 40,
                                                        decoration:
                                                            const BoxDecoration(
                                                                color: grey)),
                                                  ),
                                                  gethomePageTextDesing(
                                                      value.totalorderCount ??
                                                          "0",
                                                      getTranslated(context,
                                                          "Total orders")!),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  right: 15,
                                  left: 15,
                                  top: 15,
                                ),
                                child: Row(
                                  children: [
                                    boxesDesingHome(
                                      'Balance',
                                      getTranslated(context, 'BALANCE_LBL')!,
                                      DesignConfiguration.getPriceFormat(
                                          context, double.parse(CUR_BALANCE))!,
                                      0,
                                      context,
                                    ),
                                    boxesDesingHome(
                                      'Report',
                                      getTranslated(context, 'Sales Report')!,
                                      DesignConfiguration.getPriceFormat(
                                          context,
                                          double.parse(
                                              value.grandFinalTotalOfSales)),
                                      1,
                                      context,
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 15),
                                child: Row(
                                  children: [
                                    boxesDesingHome(
                                      'SoldOutProduct',
                                      getTranslated(
                                          context, "Sold Out Products")!,
                                      value.totalsoldOutCount,
                                      2,
                                      context,
                                    ),
                                    boxesDesingHome(
                                      'LowStockProduct',
                                      getTranslated(
                                          context, 'Low Stock Products')!,
                                      value.totallowStockCount,
                                      3,
                                      context,
                                    ),
                                  ],
                                ),
                              ),
                              getChart(),
                              catChart(value, context, setStateNow),
                            ],
                          ),
                        ),
                      );
              } else if (value.getCurrentStatus ==
                  SystemProviderPolicyStatus.isFailure) {
                return const ShimmerEffect();
              }
              return const ShimmerEffect();
            },
          )
        : noInternet(context, setStateNoInternate, buttonSqueezeanimation,
            buttonController);
  }

  setStateNoInternate() async {
    _playAnimation();
    Future.delayed(const Duration(seconds: 2)).then(
      (_) async {
        isNetworkAvail = await isNetworkAvailable();
        if (isNetworkAvail) {
          providerRequiestForData();
          getSallerDetail();
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
//============================ Refresh Implimentation ==========================

  Future<void> _refresh() async {
    Completer<void> completer = Completer<void>();
    await Future.delayed(const Duration(seconds: 3)).then(
      (onvalue) {
        completer.complete();
        providerRequiestForData();
        getSallerDetail();
        setState(
          () {
            _isLoading = true;
          },
        );
      },
    );
    return completer.future;
  }

  @override
  void dispose() {
    buttonController!.dispose();
    super.dispose();
  }

  Future<void> callApi() async {
    isNetworkAvail = await isNetworkAvailable();
    if (isNetworkAvail) {
      await getSetting();
    } else {
      if (mounted) {
        setState(() {
          isNetworkAvail = false;
        });
      }
    }
    return;
  }

  Future<void> providerRequiestForData() async {
    String getlng = await getPrefrence(LAGUAGE_CODE) ?? '';

    selectLan = langCode.indexOf(getlng == '' ? "en" : getlng);

    await context.read<HomeProvider>().allocateAllData(context);
  }

  Future<void> getSetting() async {
    Map parameter = {};
    ApiBaseHelper().postAPICall(getSettingsApi, parameter).then(
      (getdata) async {
        bool error = getdata['error'];
        String? msg = getdata['message'];

        if (!error) {
          var data = getdata['data']['system_settings'][0];
          supportedLocale = data["supported_locals"];
          Is_APP_IN_MAINTANCE = data['is_seller_app_under_maintenance'];
          MAINTENANCE_MESSAGE = data['message_for_seller_app'];
          Decimal_Digits = data['decimal_point']; // Painding
          setState(
            () {},
          );
          if (Is_APP_IN_MAINTANCE == "1") {
            appMaintenanceDialog(context);
          }
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
}
//==============================================================================
//==============================================================================
