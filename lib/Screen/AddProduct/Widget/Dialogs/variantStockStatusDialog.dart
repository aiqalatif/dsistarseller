import 'package:flutter/material.dart';
import '../../../../Helper/Color.dart';
import '../../../../Helper/Constant.dart';
import '../../../../Widget/validation.dart';
import '../../Add_Product.dart';

variantStockStatusDialog(
    String from, int pos, BuildContext context, Function setState) async {
  await showModalBottomSheet(
    isScrollControlled: true,
    context: context,
    backgroundColor: Colors.transparent,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setStater) {
          addProvider!.taxesState = setStater;
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
                  padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        getTranslated(context, "Select Type")!,
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(color: primary),
                      ),
                    ],
                  ),
                ),
                const Divider(color: lightBlack),
                Flexible(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: () {
                            if (from == 'variable') {
                              addProvider!.variationList[pos].stockStatus = "1";
                            } else {
                              addProvider!.stockStatus = '1';
                            }
                            Navigator.of(context).pop();
                            setState();
                          },
                          child: SizedBox(
                            width: double.maxFinite,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  20.0, 20.0, 20.0, 20.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    getTranslated(context, "In Stock")!,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            if (from == 'variable') {
                              addProvider!.variationList[pos].stockStatus = "0";
                            } else {
                              addProvider!.stockStatus = '0';
                            }
                            Navigator.of(context).pop();
                            setState();
                          },
                          child: SizedBox(
                            width: double.maxFinite,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  20.0, 20.0, 20.0, 20.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    getTranslated(context, "Out Of Stock")!,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
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
