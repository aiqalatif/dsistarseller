import 'package:flutter/material.dart';
import 'package:sellermultivendor/Widget/validation.dart';
import '../../../../Helper/Color.dart';
import '../../../../Helper/Constant.dart';
import '../../../../Provider/settingProvider.dart';
import '../../../../Widget/desing.dart';
import '../../Add_Product.dart';

brandSelectButtomSheet(
  BuildContext context,
  Function setState,
) {
  showModalBottomSheet(
    isScrollControlled: true,
    context: context,
    backgroundColor: Colors.transparent,
    builder: (BuildContext context) {
      return StatefulBuilder(
          builder: (BuildContext context, StateSetter setStater) {
        addProvider!.brandState = setStater;
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
                      getTranslated(context, "Select Brand")!,
                      style: const TextStyle(
                        fontSize: textFontSize18,
                        color: primary,
                      ),
                    ),
                    Container(width: 2),
                  ],
                ),
              ),
              addProvider!.brandLoading
                  ? const Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 50.0),
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : (addProvider!.brandList.isNotEmpty)
                      ? Flexible(
                          child: SingleChildScrollView(
                            controller: addProvider!.brandScrollController,
                            child: Stack(
                              children: [
                                Column(
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: getBrands(context, setState),
                                    ),
                                    Center(
                                      child: DesignConfiguration
                                          .showCircularProgress(
                                        addProvider!.isLoadingMoreBrand!,
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
      });
    },
  );
}

getBrands(BuildContext context, Function setState) {
  return addProvider!.brandList
      .asMap()
      .map(
        (index, element) => MapEntry(
          index,
          InkWell(
            onTap: () {
              Navigator.pop(context);
              addProvider!.selectedBrandName =
                  addProvider!.brandList[index].name;
              addProvider!.selectedBrandId = addProvider!.brandList[index].id;
              setState();
            },
            child: Column(
              children: [
                const Divider(),
                Row(
                  children: [
                    addProvider!.selectedBrandId ==
                            addProvider!.brandList[index].id
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
                        addProvider!.brandList[index].name!,
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
