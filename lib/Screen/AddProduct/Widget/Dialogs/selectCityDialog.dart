//------------------------------------------------------------------------------
//============================ Selected Pin codes Type =========================
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:sellermultivendor/Provider/cityProvider.dart';
import 'package:sellermultivendor/Screen/AddProduct/Add_Product.dart';
import 'package:sellermultivendor/Widget/desing.dart';
import '../../../../Helper/Color.dart';
import '../../../../Helper/Constant.dart';
import '../../../../Widget/routes.dart';
import '../../../../Widget/validation.dart';

cityDialog(BuildContext context, Function setState) async {
  final cityProvider = Provider.of<CityProvider>(context, listen: false);
  if (cityProvider.searchString.isNotEmpty) {
    cityProvider.searchString = "";
    cityProvider.getCities();
  } else if (cityProvider.cityList.isEmpty) {
    context.read<CityProvider>().getCities();
  }
  await showModalBottomSheet(
    isScrollControlled: true,
    context: context,
    backgroundColor: Colors.transparent,
    builder: (BuildContext context) {
      return Container(
        height: 500,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(circularBorderRadius25),
            topRight: Radius.circular(circularBorderRadius25),
          ),
        ),
        child: Consumer<CityProvider>(
          builder: (context, cityData, child) {
            Timer? debounce;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20.0, 20.0, 0, 0),
                  child: Text(
                    getTranslated(context, "SELECT_CITY")!,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(color: primary),
                  ),
                ),
                const Divider(color: lightBlack),
                const SizedBox(
                  height: 5,
                ),
                Container(
                  margin: const EdgeInsets.fromLTRB(20.0, 0, 20, 0),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(
                        Radius.circular(circularBorderRadius5)),
                    boxShadow: [
                      BoxShadow(
                        color: blarColor,
                        offset: Offset(0, 0),
                        blurRadius: 4,
                        spreadRadius: 0,
                      ),
                    ],
                    color: white,
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      filled: true,
                      isDense: true,
                      fillColor: white,
                      prefixIconConstraints: const BoxConstraints(
                        minWidth: 40,
                        maxHeight: 20,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 10,
                      ),
                      prefixIcon: const Icon(Icons.search),
                      hintText: getTranslated(context, "SEARCH"),
                      hintStyle: TextStyle(
                          color: black.withOpacity(0.3),
                          fontWeight: FontWeight.normal),
                      border: const OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 0,
                          style: BorderStyle.none,
                        ),
                      ),
                    ),
                    onChanged: (value) {
                      if (debounce?.isActive ?? false) debounce?.cancel();
                      //auto search after 1 second of typing
                      debounce = Timer(const Duration(milliseconds: 1000), () {
                        cityData.searchString = value;
                        context.read<CityProvider>().getCities();
                      });
                    },
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Expanded(
                  child: cityData.isLoading
                      ? const Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 50.0),
                            child: CircularProgressIndicator(),
                          ),
                        )
                      : StatefulBuilder(builder: (context, setStater) {
                          ScrollController scrollController =
                              ScrollController();
                          scrollController.addListener(() async {
                            if (scrollController.offset >=
                                    scrollController.position.maxScrollExtent &&
                                !scrollController.position.outOfRange) {
                              if (context.mounted) {
                                await context
                                    .read<CityProvider>()
                                    .getCities(isReload: false);
                              }
                            }
                          });
                          return SingleChildScrollView(
                            controller: scrollController,
                            child: Column(
                              children: [
                                if (cityData.cityList.isEmpty) ...[
                                  Center(
                                    child: Text(
                                      getTranslated(context, "NO_DATA_FOUND")!,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium!
                                          .copyWith(color: primary),
                                    ),
                                  ),
                                ] else ...[
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: () {
                                      return cityData.cityList
                                          .asMap()
                                          .map(
                                            (index, element) => MapEntry(
                                              index,
                                              InkWell(
                                                onTap: () {
                                                  if (addProvider!
                                                      .deliverableCities
                                                      .contains(element)) {
                                                    addProvider!
                                                        .deliverableCities
                                                        .remove(element);
                                                  } else {
                                                    addProvider!
                                                        .deliverableCities
                                                        .add(element);
                                                  }
                                                  setState();
                                                  setStater(() {});
                                                  setState();
                                                },
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                      flex: 2,
                                                      child: addProvider!
                                                              .deliverableCities
                                                              .contains(element)
                                                          ? Container(
                                                              height: 20,
                                                              width: 20,
                                                              decoration:
                                                                  const BoxDecoration(
                                                                color: grey2,
                                                                shape: BoxShape
                                                                    .circle,
                                                              ),
                                                              child: Center(
                                                                child:
                                                                    Container(
                                                                  height: 16,
                                                                  width: 16,
                                                                  decoration:
                                                                      const BoxDecoration(
                                                                    color:
                                                                        primary,
                                                                    shape: BoxShape
                                                                        .circle,
                                                                  ),
                                                                ),
                                                              ),
                                                            )
                                                          : Container(
                                                              height: 20,
                                                              width: 20,
                                                              decoration:
                                                                  const BoxDecoration(
                                                                color: grey2,
                                                                shape: BoxShape
                                                                    .circle,
                                                              ),
                                                              child: Center(
                                                                child:
                                                                    Container(
                                                                  height: 16,
                                                                  width: 16,
                                                                  decoration:
                                                                      const BoxDecoration(
                                                                    color:
                                                                        white,
                                                                    shape: BoxShape
                                                                        .circle,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                    ),
                                                    Expanded(
                                                      flex: 8,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Text(
                                                          cityData
                                                              .cityList[index]
                                                              .name,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          )
                                          .values
                                          .toList();
                                    }(),
                                  ),
                                ],
                                DesignConfiguration.showCircularProgress(
                                  cityData.isLoadingmore,
                                  primary,
                                ),
                              ],
                            ),
                          );
                        }),
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      child: Text(
                        getTranslated(context, "CANCEL")!,
                        style: const TextStyle(
                          color: Colors.black,
                        ),
                      ),
                      onPressed: () {
                        addProvider!.deliverableCities.clear();
                        setState();
                        Routes.pop(context);
                      },
                    ),
                    TextButton(
                      child: Text(
                        getTranslated(context, "Ok")!,
                      ),
                      onPressed: () {
                        Routes.pop(context);
                      },
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      );
    },
  );
}
