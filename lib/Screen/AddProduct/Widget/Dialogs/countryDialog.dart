//------------------------------------------------------------------------------
//=================================== Made In ==================================

import 'package:flutter/material.dart';
import 'package:sellermultivendor/Widget/desing.dart';
import '../../../../Helper/Color.dart';
import '../../../../Helper/Constant.dart';
import '../../../../Widget/validation.dart';
import '../../Add_Product.dart';

countryDialog(
  BuildContext context,
  Function setState,
  Function updateCity,
) {
  showModalBottomSheet(
    isScrollControlled: true,
    context: context,
    backgroundColor: Colors.transparent,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setStater) {
          addProvider!.countryState = setStater;
          return Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(circularBorderRadius25),
                topRight: Radius.circular(circularBorderRadius25),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20.0, 20.0, 0, 0),
                  child: Text(
                    getTranslated(context, "Made In")!,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(color: primary),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: TextField(
                          controller: addProvider!.countryController,
                          autofocus: false,
                          style: const TextStyle(
                            color: black,
                          ),
                          decoration: InputDecoration(
                            contentPadding:
                                const EdgeInsets.fromLTRB(0, 15.0, 0, 15.0),
                            hintText: getTranslated(context, 'SEARCH_LBL'),
                            hintStyle:
                                TextStyle(color: primary.withOpacity(0.5)),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context).colorScheme.primary),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context).colorScheme.primary),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: IconButton(
                        onPressed: () async {
                          addProvider!.isLoadingMoreCity = true;
                          setStater;
                          updateCity();
                        },
                        icon: const Icon(
                          Icons.search,
                          size: 20,
                        ),
                      ),
                    )
                  ],
                ),
                const Divider(),
                addProvider!.countryLoading
                    ? const Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 50.0),
                          child: CircularProgressIndicator(),
                        ),
                      )
                    : (addProvider!.countrySearchLIst.isNotEmpty)
                        ? Flexible(
                            child: SizedBox(
                              height: MediaQuery.of(context).size.height * 0.4,
                              child: SingleChildScrollView(
                                controller:
                                    addProvider!.countryScrollController,
                                child: Stack(
                                  children: [
                                    Column(
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children:
                                              getCityList(setState, context),
                                        ),
                                        Center(
                                          child: DesignConfiguration
                                              .showCircularProgress(
                                            addProvider!.isLoadingMoreCity!,
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
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20.0),
                            child: DesignConfiguration.getNoItem(context),
                          )
              ],
            ),
          );
        },
      );
    },
  );
}

getCityList(Function setState, BuildContext context) {
  return addProvider!.countrySearchLIst
      .asMap()
      .map(
        (index, element) => MapEntry(
          index,
          InkWell(
            onTap: () {
              addProvider!.madeIn = addProvider!.countrySearchLIst[index].name;

              addProvider!.selCityPos = index;

              Navigator.of(context).pop();
              setState();
              addProvider!.country =
                  addProvider!.countrySearchLIst[addProvider!.selCityPos!].id;
            },
            child: SizedBox(
              width: double.maxFinite,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  addProvider!.countrySearchLIst[index].name!,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
            ),
          ),
        ),
      )
      .values
      .toList();
}
