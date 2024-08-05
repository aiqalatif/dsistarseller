import 'package:flutter/material.dart';
import '../../../../Helper/Color.dart';
import '../../../../Helper/Constant.dart';
import '../../../../Widget/validation.dart';
import '../../Add_Product.dart';

productTypeDialog(
  BuildContext context,
  Function setState,
) async {
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
                        addProvider!.currentSellectedProductIsPysical
                            ? InkWell(
                                onTap: () {
                                  addProvider!
                                          .variantProductVariableLevelSaveSettings =
                                      false;
                                  addProvider!
                                          .variantProductProductLevelSaveSettings =
                                      false;
                                  addProvider!.simpleProductSaveSettings =
                                      false;
                                  addProvider!.digitalProductSaveSettings =
                                      false;
                                  addProvider!.productType = 'simple_product';
                                  Navigator.of(context).pop();
                                  setState(() {});
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
                                          getTranslated(
                                              context, "Simple Product")!,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            : Container(),
                        addProvider!.currentSellectedProductIsPysical
                            ? InkWell(
                                onTap: () {
                                  //----reset----
                                  addProvider!
                                      .simpleProductPriceController.text = '';
                                  addProvider!
                                      .simpleProductSpecialPriceController
                                      .text = '';
                                  addProvider!.isStockSelected = false;

                                  //--------------set
                                  addProvider!
                                          .variantProductVariableLevelSaveSettings =
                                      false;
                                  addProvider!
                                          .variantProductProductLevelSaveSettings =
                                      false;
                                  addProvider!.simpleProductSaveSettings =
                                      false;
                                  addProvider!.digitalProductSaveSettings =
                                      false;
                                  addProvider!.productType = 'variable_product';
                                  Navigator.of(context).pop();
                                  setState(() {});
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
                                          getTranslated(
                                              context, "Variable Product")!,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            : Container(),
                        addProvider!.currentSellectedProductIsPysical
                            ? Container()
                            : InkWell(
                                onTap: () {
                                  addProvider!.productType = 'digital_product';
                                  addProvider!.digitalProductSaveSettings =
                                      false;
                                  addProvider!
                                          .variantProductVariableLevelSaveSettings =
                                      false;
                                  addProvider!
                                          .variantProductProductLevelSaveSettings =
                                      false;
                                  addProvider!.simpleProductSaveSettings =
                                      false;
                                  Navigator.of(context).pop();
                                  setState(() {});
                                },
                                child: SizedBox(
                                  width: double.maxFinite,
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        20.0, 20.0, 20.0, 20.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: const [
                                        Text(
                                          'Digital Product',
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
