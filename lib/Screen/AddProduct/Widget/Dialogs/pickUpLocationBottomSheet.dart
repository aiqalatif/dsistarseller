import 'package:flutter/material.dart';
import 'package:sellermultivendor/Widget/validation.dart';
import '../../../../Helper/Color.dart';
import '../../../../Helper/Constant.dart';
import '../../../../Provider/settingProvider.dart';
import '../../../../Widget/desing.dart';
import '../../Add_Product.dart';

pickUpLocationSelectButtomSheet(
  BuildContext context,
  Function setState,
) {
  showModalBottomSheet(
    isScrollControlled: true,
    context: context,
    backgroundColor: Colors.transparent,
    builder: (BuildContext context) {
      return SizedBox(
        height: 400,
        child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setStater) {
          addProvider!.pickUpLocationState = setStater;
          return Container(
            padding: const EdgeInsets.only(right: 20, left: 20, top: 20),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(circularBorderRadius25),
                topRight: Radius.circular(circularBorderRadius25),
              ),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, left: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        child: const Icon(Icons.arrow_back),
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      Text(
                        getTranslated(context, "Select PickUp Location")!,
                        style: const TextStyle(
                          fontSize: textFontSize18,
                          color: primary,
                        ),
                      ),
                      Container(width: 2),
                    ],
                  ),
                ),
                addProvider!.locationLoading
                    ? const Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 50.0),
                          child: CircularProgressIndicator(),
                        ),
                      )
                    : (addProvider!.pickUpLocationList.isNotEmpty)
                        ? Flexible(
                            child: SingleChildScrollView(
                              controller:
                                  addProvider!.pickUpLocationScrollController,
                              child: Stack(
                                children: [
                                  Column(
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: getpickUpLocations(
                                            context, setState),
                                      ),
                                      Center(
                                        child: DesignConfiguration
                                            .showCircularProgress(
                                          addProvider!.isLoadingMoreLocation!,
                                          primary,
                                        ),
                                      ),
                                    ],
                                  ),
                                  DesignConfiguration.showCircularProgress(
                                    addProvider!.isProgress,
                                    primary,
                                  ),
                                ],
                              ),
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20.0),
                            child: DesignConfiguration.getNoItem(context),
                          ),
              ],
            ),
          );
        }),
      );
    },
  );
}

getpickUpLocations(BuildContext context, Function setState) {
  return addProvider!.pickUpLocationList
      .asMap()
      .map(
        (index, element) => MapEntry(
          index,
          InkWell(
            onTap: () {
              Navigator.pop(context);
              addProvider!.selectedPickUpLocation =
                  addProvider!.pickUpLocationList[index].pickupLoc;
              setState();
            },
            child: Column(
              children: [
                const Divider(),
                Row(
                  children: [
                    addProvider!.selectedPickUpLocation ==
                            addProvider!.pickUpLocationList[index].pickupLoc
                        ? Container(
                            height: 20,
                            width: 20,
                            decoration: const BoxDecoration(
                              color: grey2,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Container(
                                height: 16,
                                width: 16,
                                decoration: const BoxDecoration(
                                  color: primary,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          )
                        : Container(
                            height: 20,
                            width: 20,
                            decoration: const BoxDecoration(
                              color: grey2,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Container(
                                height: 16,
                                width: 16,
                                decoration: const BoxDecoration(
                                  color: white,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          ),
                    const SizedBox(
                      width: 10,
                    ),
                    SizedBox(
                      width: width * 0.6,
                      child: Text(
                        addProvider!.pickUpLocationList[index].pickupLoc!,
                        style: const TextStyle(
                          fontSize: textFontSize18,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      )
      .values
      .toList();
}
