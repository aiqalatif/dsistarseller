import 'package:flutter/material.dart';
import 'package:sellermultivendor/Widget/validation.dart';
import '../../../../Helper/Color.dart';
import '../../../../Helper/Constant.dart';
import '../../../../Provider/settingProvider.dart';
import '../../../../Widget/desing.dart';
import '../../EditProduct.dart';

pickUpLocationSelectBottomSheet(
  BuildContext context,
  Function update,
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
          editProvider!.pickUpLocationState = setStater;
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
                      ),
                      Container(width: 2),
                    ],
                  ),
                ),
                editProvider!.locationLoading
                    ? const Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 50.0),
                          child: CircularProgressIndicator(),
                        ),
                      )
                    : (editProvider!.pickUpLocationList.isNotEmpty)
                        ? Flexible(
                            child: SingleChildScrollView(
                              controller:
                                  editProvider!.pickUpLocationScrollController,
                              child: Stack(
                                children: [
                                  Column(
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children:
                                            getpickUpLocations(context, update),
                                      ),
                                      Center(
                                        child: DesignConfiguration
                                            .showCircularProgress(
                                          editProvider!.isLoadingMoreLocation!,
                                          primary,
                                        ),
                                      ),
                                    ],
                                  ),
                                  DesignConfiguration.showCircularProgress(
                                    editProvider!.isProgress,
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

getpickUpLocations(BuildContext context, Function update) {
  return editProvider!.pickUpLocationList
      .asMap()
      .map((index, element) => MapEntry(
            index,
            InkWell(
              onTap: () {
                Navigator.pop(context);
                editProvider!.selectedPickUpLocation =
                    editProvider!.pickUpLocationList[index].pickupLoc;
                update();
              },
              child: Column(
                children: [
                  const Divider(),
                  Row(
                    children: [
                      editProvider!.selectedPickUpLocation ==
                              editProvider!.pickUpLocationList[index].pickupLoc
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
                          editProvider!.pickUpLocationList[index].pickupLoc!,
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
          ))
      .values
      .toList();
}
