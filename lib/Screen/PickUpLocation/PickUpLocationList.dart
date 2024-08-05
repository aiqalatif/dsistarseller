import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sellermultivendor/Helper/Color.dart';
import 'package:sellermultivendor/Model/PickUpLocationModel/PickUpLocationModel.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../Helper/Constant.dart';

import '../../Provider/pickUpLocationProvider.dart';
import '../../Provider/settingProvider.dart';

import '../../Widget/desing.dart';
import '../../Widget/networkAvailablity.dart';
import '../../Widget/routes.dart';
import '../../Widget/simmerEffect.dart';

import '../../Widget/systemChromeSettings.dart';
import '../../Widget/validation.dart';
import '../../Widget/noNetwork.dart';

class PickUpLocationList extends StatefulWidget {
  const PickUpLocationList({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => StatePickUpLocation();
}

PickUpLocationProvider? pickUpLocationListProvider;

class StatePickUpLocation extends State<PickUpLocationList>
    with TickerProviderStateMixin {
  bool serachIsEnable = false;

  setStateNow() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    SystemChromeSettings.setSystemButtomNavigationBarithTopAndButtom();
    SystemChromeSettings.setSystemUIOverlayStyleWithLightBrightNessStyle();
    pickUpLocationListProvider =
        Provider.of<PickUpLocationProvider>(context, listen: false);
    pickUpLocationListProvider!.freshInitializationOfAddPickUpLocation();

    pickUpLocationListProvider!.pickUpLocationScrollController
        .addListener(_pickUpLocationScrollListener);

    pickUpLocationListProvider!.getPickUpLocations(context, 3,update: setStateNow);
    pickUpLocationListProvider!.buttonController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    pickUpLocationListProvider!.controllerForText.addListener(
      () {
        if (pickUpLocationListProvider!.controllerForText.text.isEmpty) {
          pickUpLocationListProvider!.pickUpLocationList.clear();

          if (mounted) {
            setState(
              () {
                pickUpLocationListProvider!.searchText = "";
              },
            );
          }
        } else {
          if (mounted) {
            setState(
              () {
                pickUpLocationListProvider!.searchText =
                    pickUpLocationListProvider!.controllerForText.text;
              },
            );
          }
        }

        if (pickUpLocationListProvider!.lastsearch !=
                pickUpLocationListProvider!.searchText &&
            (pickUpLocationListProvider!.searchText == '' ||
                pickUpLocationListProvider!.searchText.isNotEmpty)) {
          pickUpLocationListProvider!.lastsearch =
              pickUpLocationListProvider!.searchText;
          pickUpLocationListProvider!.locationLoading = true;
          pickUpLocationListProvider!.locationOffset = 0;
          pickUpLocationListProvider!.pickUpLocationList.clear();
          pickUpLocationListProvider!.getPickUpLocations(
            context,
            3,
            update: setStateNow
          );
        }
      },
    );
    pickUpLocationListProvider!.buttonSqueezeanimation = Tween(
      begin: width * 0.7,
      end: 50.0,
    ).animate(
      CurvedAnimation(
        parent: pickUpLocationListProvider!.buttonController!,
        curve: const Interval(
          0.0,
          0.150,
        ),
      ),
    );
  }

  Future<void> _playAnimation() async {
    try {
      await pickUpLocationListProvider!.buttonController!.forward();
    } on TickerCanceled {}
  }

  @override
  void dispose() {
    pickUpLocationListProvider!.pickUpLocationScrollController
        .removeListener(() {});
    pickUpLocationListProvider!.buttonController!.dispose();

    super.dispose();
  }

  floatingBtn(BuildContext context) {
    return SizedBox(
      height: 40.0,
      width: 40.0,
      child: FittedBox(
        child: FloatingActionButton(
          backgroundColor: newPrimary,
          child: const Icon(
            Icons.add,
            size: 32,
            color: white,
          ),
          onPressed: () {
            Routes.navigateToAddPickUpLocation(context);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: lightWhite,
      floatingActionButton: floatingBtn(context),
      body: isNetworkAvail
          ? Column(
              children: [
                Container(
                  padding: const EdgeInsets.only(bottom: 10),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [grad1Color, grad2Color],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      stops: [0, 1],
                      tileMode: TileMode.clamp,
                    ),
                  ),
                  width: MediaQuery.of(context).size.width,
                  child: SafeArea(
                    child: Column(
                      children: [
                        Opacity(
                          opacity: 0.17000000178813934,
                          child: Container(
                              width: width * 0.9,
                              height: 1,
                              decoration:  const BoxDecoration(
                                  color: white)),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap: () => Navigator.of(context).pop(),
                              child: const Padding(
                                padding:
                                    EdgeInsetsDirectional.only(start: 15.0),
                                child: Icon(
                                  Icons.arrow_back,
                                  color: white,
                                  size: 25,
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                serachIsEnable
                                    ? Padding(
                                        padding:
                                            const EdgeInsetsDirectional.only(
                                                end: 50.0),
                                        child: SizedBox(
                                          height: 60,
                                          width: width * 0.7,
                                          child: TextField(
                                            controller:
                                                pickUpLocationListProvider!
                                                    .controllerForText,
                                            autofocus: true,
                                            style: const TextStyle(
                                              color: white,
                                            ),
                                            decoration: InputDecoration(
                                              prefixIcon: const Icon(
                                                  Icons.search,
                                                  color: white),
                                              hintText: getTranslated(
                                                  context, "Search"),
                                              hintStyle:
                                                  const TextStyle(color: white),
                                              disabledBorder:
                                                  const UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: white,
                                                ),
                                              ),
                                              enabledBorder:
                                                  const UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: white,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    : SizedBox(
                                        height: 36,
                                        child: Padding(
                                          padding:
                                              const EdgeInsetsDirectional.only(
                                            top: 9.0,
                                            start: 15,
                                            end: 15,
                                          ),
                                          child: Text(
                                            getTranslated(
                                                context, 'PickUp Location')!,
                                            style:  const TextStyle(
                                              fontFamily: 'PlusJakartaSans',
                                              color: white,
                                              fontSize: textFontSize16,
                                              fontWeight: FontWeight.w400,
                                              fontStyle: FontStyle.normal,
                                            ),
                                          ),
                                        ),
                                      ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsetsDirectional.only(end: 15),
                              child: InkWell(
                                onTap: () {
                                  if (!mounted) return;
                                  setState(
                                    () {
                                      if (serachIsEnable == false) {
                                        serachIsEnable = true;
                                        _handleSearchStart();
                                      } else {
                                        serachIsEnable = false;
                                        _handleSearchEnd();
                                      }
                                    },
                                  );
                                  // Routes.navigateToSearch(context);
                                },
                                child: Icon(
                                  serachIsEnable ? Icons.close : Icons.search,
                                  color: white,
                                  size: 18,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Flexible(child: _showForm()),
              ],
            )
          : noInternet(
              context,
              setStateNoInternate,
              pickUpLocationListProvider!.buttonSqueezeanimation,
              pickUpLocationListProvider!.buttonController,
            ),
    );
  }

  setStateNoInternate() async {
    _playAnimation();
    Future.delayed(const Duration(seconds: 2)).then(
      (_) async {
        isNetworkAvail = await isNetworkAvailable();
        if (isNetworkAvail) {
          pickUpLocationListProvider!.locationOffset = 0;
          pickUpLocationListProvider!.total = 0;
          pickUpLocationListProvider!.pickUpLocationList.clear();
          pickUpLocationListProvider!.getPickUpLocations(context, 3, update: setStateNow);
        } else {
          await pickUpLocationListProvider!.buttonController!.reverse();
          if (mounted) setState(() {});
        }
      },
    );
  }

  Widget listItem(int index) {
    PickUpLocationModel model =
        pickUpLocationListProvider!.pickUpLocationList[index];

    if (index < pickUpLocationListProvider!.pickUpLocationList.length) {
      return Padding(
          padding: const EdgeInsets.only(
            right: 15.0,
            left: 15.0,
            bottom: 13,
          ),
          child: Container(
              decoration: const BoxDecoration(
                boxShadow: [
                  BoxShadow(
                      color: blarColor,
                      offset: Offset(0, 0),
                      blurRadius: 4,
                      spreadRadius: 0),
                ],
                color: white,
                borderRadius: BorderRadius.all(
                  Radius.circular(circularBorderRadius10),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                    right: 15.0, left: 15.0, bottom: 13, top: 13),
                child: Column(children: [
                  Row(
                    children: [
                      Text(
                        "${getTranslated(context, "PickUp Location")!} : ",
                        style: const TextStyle(
                            color: grey, fontSize: textFontSize14),
                      ),
                      Text(
                        model.pickupLoc!,
                        style: const TextStyle(color: black),
                      ),
                    ],
                  ),
                  const Divider(),
                  Row(children: [
                    Flexible(
                      child: Row(
                        children: [
                          const Icon(
                            Icons.person,
                            size: 20,
                            color: black,
                          ),
                          const SizedBox(width: 08),
                          Expanded(
                            child: Text(
                              model.name != null && model.name!.isNotEmpty
                                  ? " ${StringValidation.capitalize(model.name!)}"
                                  : " ",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(color: black),
                            ),
                          ),
                        ],
                      ),
                    ),
                    InkWell(
                      child: Row(
                        children: [
                          const Icon(
                            Icons.call,
                            size: 20,
                            color: black,
                          ),
                          const SizedBox(width: 08),
                          Text(
                            " ${model.phone!}",
                            style: const TextStyle(
                                color: black,
                                decoration: TextDecoration.underline),
                          ),
                        ],
                      ),
                      onTap: () {
                        _launchCaller(model.phone!);
                      },
                    )
                  ]),
                  Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.email,
                          size: 20,
                          color: black,
                        ),
                        const SizedBox(width: 08),
                        Expanded(
                          child: Text(
                            model.email!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(color: black),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: Row(
                      children: [
                        Text(
                          "${getTranslated(context, "City")!} : ",
                          style: const TextStyle(
                              color: grey, fontSize: textFontSize14),
                        ),
                        Text(
                          model.city!,
                          style: const TextStyle(color: black),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: Row(
                      children: [
                        Text(
                          "${getTranslated(context, "Pincode")!} : ",
                          style: const TextStyle(
                              color: grey, fontSize: textFontSize14),
                        ),
                        Text(
                          model.pinCode!,
                          style: const TextStyle(color: black),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: Row(
                      children: [
                        Text(
                          "${getTranslated(context, "Addresh")!} : ",
                          style: const TextStyle(
                              color: grey, fontSize: textFontSize14),
                        ),
                        Text(
                          model.address!,
                          style: const TextStyle(color: black),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: Row(
                      children: [
                        Text(
                          "${getTranslated(context, "Additional Address")!} : ",
                          style: const TextStyle(
                              color: grey, fontSize: textFontSize14),
                        ),
                        Text(
                          model.address2!,
                          style: const TextStyle(color: black),
                        ),
                      ],
                    ),
                  ),
                ]),
              )));
    } else {
      return const SizedBox.shrink();
    }
  }

  _launchCaller(String phone) async {
    var url = "tel:$phone";
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }

  void _handleSearchEnd() {
    if (!mounted) return;
    setState(
      () {
        serachIsEnable = false;
        pickUpLocationListProvider!.controllerForText.clear();
      },
    );
  }

  void _handleSearchStart() {
    if (!mounted) return;
    setState(
      () {},
    );
  }

/*  _pickUpLocationScrollListener() async {
    if (pickUpLocationListProvider!.pickUpLocationScrollController.offset >=
            pickUpLocationListProvider!
                .pickUpLocationScrollController.position.maxScrollExtent &&
        !pickUpLocationListProvider!
            .pickUpLocationScrollController.position.outOfRange) {
      if (mounted) {
        pickUpLocationListProvider!.isLoadingMoreLocation = true;
        setState(() {});

        await context
            .read<PickUpLocationProvider>()
            .getPickUpLocations(context, 3)
            .then((value) {
          if (value == true) {
            setSnackbar(
                context.read<PickUpLocationProvider>().errorMessage, context);
          }
        });

        if (mounted) setState(() {});
      }
    }
  }*/

  _pickUpLocationScrollListener() {
    if (pickUpLocationListProvider!.pickUpLocationScrollController.offset >=
            pickUpLocationListProvider!
                .pickUpLocationScrollController.position.maxScrollExtent &&
        !pickUpLocationListProvider!
            .pickUpLocationScrollController.position.outOfRange) {
      if (mounted) {
        if (mounted) {
          setState(
            () {
              pickUpLocationListProvider!.isLoadingMoreLocation = true;

              if (pickUpLocationListProvider!.locationOffset <
                  pickUpLocationListProvider!.total) {
                context
                    .read<PickUpLocationProvider>()
                    .getPickUpLocations(context, 3, update: setStateNow);
              }
            },
          );
        }
      }
    }
  }

  Future<void> _refresh() {
    if (mounted) {
      setState(
        () {
          pickUpLocationListProvider!.locationLoading = true;
          pickUpLocationListProvider!.isLoadingMoreLocation = true;
          pickUpLocationListProvider!.locationOffset = 0;
          pickUpLocationListProvider!.total = 0;
          pickUpLocationListProvider!.pickUpLocationList.clear();
        },
      );
    }
    return pickUpLocationListProvider!.getPickUpLocations(context, 3, update: setStateNow);
  }

  _showForm() {
    return pickUpLocationListProvider!.locationLoading
        ? const ShimmerEffect()
        : pickUpLocationListProvider!.pickUpLocationList.isEmpty
            ? DesignConfiguration.getNoItem(context)
            : RefreshIndicator(
                key: pickUpLocationListProvider!.refreshIndicatorKey,
                onRefresh: _refresh,
                child: MediaQuery.removePadding(
                  context: context,
                  removeTop: true,
                  child: ListView.builder(
                    padding: const EdgeInsets.only(top: 15),
                    shrinkWrap: true,
                    controller: pickUpLocationListProvider!
                        .pickUpLocationScrollController,
                    itemCount: (pickUpLocationListProvider!.locationOffset <
                            pickUpLocationListProvider!.total)
                        ? pickUpLocationListProvider!
                                .pickUpLocationList.length +
                            1
                        : pickUpLocationListProvider!.pickUpLocationList.length,
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return (index ==
                                  pickUpLocationListProvider!
                                      .pickUpLocationList.length &&
                              pickUpLocationListProvider!
                                  .isLoadingMoreLocation!)
                          ? const Center(
                              child: CircularProgressIndicator(),
                            )
                          : listItem(index);
                    },
                  ),
                ),
              );
  }
}
