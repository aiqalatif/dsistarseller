// Comman Input Text Field :-     .
import 'package:flutter/material.dart';
import 'package:sellermultivendor/Repository/appSettingsRepository.dart';
import 'package:sellermultivendor/Screen/EditProduct/widget/Dialogs/cityDialog.dart';
import 'package:sellermultivendor/Screen/EditProduct/widget/Dialogs/digitalProductVideoTypeButtomSheet.dart';
import 'package:sellermultivendor/Screen/EditProduct/widget/Dialogs/pickUpLocationBottomSheet.dart';
import 'package:sellermultivendor/Screen/EditProduct/widget/Dialogs/productPDEditDialog.dart';
import 'package:sellermultivendor/Screen/EditProduct/widget/getCommannWidget.dart';
import 'package:sellermultivendor/Screen/EditProduct/widget/Dialogs/IndicatorDialog.dart';
import 'package:sellermultivendor/Screen/EditProduct/widget/Dialogs/brandSelectButtomSheet.dart';
import 'package:sellermultivendor/Screen/EditProduct/widget/Dialogs/categorySelectButtomSheet.dart';
import 'package:sellermultivendor/Screen/EditProduct/widget/Dialogs/countryDialog.dart';
import 'package:sellermultivendor/Screen/EditProduct/widget/Dialogs/deliverableTypeDialog.dart';
import 'package:sellermultivendor/Screen/EditProduct/widget/Dialogs/selectZipcode.dart';
import 'package:sellermultivendor/Screen/EditProduct/widget/Dialogs/stockStatusDialog.dart';
import 'package:sellermultivendor/Screen/EditProduct/widget/Dialogs/taxesDialog.dart';
import 'package:sellermultivendor/Screen/EditProduct/widget/Dialogs/tillWhichStatusDialog.dart';
import 'package:sellermultivendor/Screen/EditProduct/widget/Dialogs/variantStockStatusDialog.dart';
// import 'package:sellermultivendor/Screen/EditProduct/widget/Dialogs/variountProductStockManagementTypeDialog.dart';
import 'package:sellermultivendor/Screen/EditProduct/widget/Dialogs/videoselectionDialog.dart';
import '../../../Helper/Color.dart';
import '../../../Helper/Constant.dart';
import '../../../Provider/settingProvider.dart';
import '../../../Widget/snackbar.dart';
import '../../../Widget/validation.dart';
import '../EditProduct.dart';

getIconSelectionDesing(
  String title,
  int index,
  BuildContext context,
  Function update,
) {
  return InkWell(
    onTap: () {
      if (index == 1) {
        taxesDialog(context, update);
      } else if (index == 2) {
        indicatorDialog(context, update);
      } else if (index == 3) {
        countryDialog(context, update);
      } else if (index == 4) {
        editProvider!.deliverableZipcodes = null;
        deliverableTypeDialog(context, update);
      } else if (index == 5) {
        categorySelectButtomSheet(context, update);
      } else if (index == 6) {
        if (AppSettingsRepository.appSettings.isCityWiseDeliveribility) {
          cityDialog(context, update);
        } else {
          zipcodeDialog(context, update);
        }
      } else if (index == 7) {
        tillWhichStatusDialog(context, update);
      } else if (index == 8) {
        videoselectionDialog(context, update);
      } else if (index == 9) {
        FocusScope.of(context).requestFocus(FocusNode());
        setSnackbar(
          getTranslated(context, "You can't Change Product Type")!,
          context,
        );
      } else if (index == 10) {
        FocusScope.of(context).requestFocus(FocusNode());
        stockStatusDialog(context, update);
      } else if (index == 11) {
        // variountProductStockManagementTypeDialog(context, update);
      } else if (index == 12) {
        variantStockStatusDialog("product", 0, context, update);
      } else if (index == 13) {
        brandSelectButtomSheet(context, update);
      } else if (index == 14) {
        digitalProductVideoTypeDialog(context, update);
      } else if (index == 15) {
        productTypePDDialog(context, update);
      } else if (index == 16) {
        pickUpLocationSelectBottomSheet(context, update);
      }
    },
    child: Container(
      decoration: BoxDecoration(
        color: grey1,
        borderRadius: BorderRadius.circular(circularBorderRadius10),
        border: Border.all(
          color: grey2,
          width: 2,
        ),
      ),
      width: width,
      height: height * 0.06,
      child: Padding(
        padding: const EdgeInsets.only(
          left: 8,
          right: 8,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 9,
              child: getSecondaryCommanText(
                () {
                  if (index == 1) {
                    if (editProvider!.selectedTaxID == null) {
                      return "${getTranslated(context, "Select Tax")!} ${getTranslated(context, "0%")!}";
                    }
                    try {
                      final taxesID = editProvider!.taxesList
                          .where(
                            (element) =>
                                element.id == editProvider!.taxId!.toString(),
                          )
                          .toList();

                      return "${taxesID.first.title!} ${taxesID.first.percentage!}%";
                    } catch (_) {
                      return "${getTranslated(context, "Select Tax")!} ${getTranslated(context, "0%")!}";
                    }
                    // return title;
                  } else if (index == 2) {
                    if (editProvider!.indicatorValue == '0') {
                      return getTranslated(context, "None")!;
                    } else if (editProvider!.indicatorValue == '1') {
                      return getTranslated(context, "Veg")!;
                    } else if (editProvider!.indicatorValue == '2') {
                      return getTranslated(context, "Non-Veg")!;
                    }
                    return title;
                  } else if (index == 3) {
                    if (editProvider!.madeIn != null) {
                      return "${getTranslated(context, "Made In")!} ${editProvider!.madeIn!}";
                    }
                    return title;
                  } else if (index == 4) {
                    if (editProvider!.deliverabletypeValue == '0') {
                      return getTranslated(context, "None")!;
                    } else if (editProvider!.deliverabletypeValue == '1') {
                      return getTranslated(context, "All")!;
                    } else if (editProvider!.deliverabletypeValue == '2') {
                      return getTranslated(context, "Include")!;
                    } else if (editProvider!.deliverabletypeValue == '3') {
                      return getTranslated(context, "Exclude")!;
                    }
                  } else if (index == 5) {
                    if (editProvider!.selectedCatName != null) {
                      return editProvider!.selectedCatName!;
                    }
                  } else if (index == 6) {
                    if (AppSettingsRepository
                        .appSettings.isCityWiseDeliveribility) {
                      if (editProvider!.deliverableCities.isNotEmpty) {
                        return editProvider!.deliverableCities
                            .map((e) => e.name)
                            .toList()
                            .join(', ');
                      }
                    } else {
                      if (editProvider!.deliverableZipcodes != null) {
                        return editProvider!.deliverableZipcodes!;
                      }
                    }
                  } else if (index == 7) {
                    if (editProvider!.tillwhichstatus == 'received') {
                      return getTranslated(context, "RECEIVED_LBL")!;
                    } else if (editProvider!.tillwhichstatus == 'processed') {
                      return getTranslated(context, "PROCESSED_LBL")!;
                    } else if (editProvider!.tillwhichstatus == 'shipped') {
                      return getTranslated(context, "SHIPED_LBL")!;
                    }
                  } else if (index == 8) {
                    if (editProvider!.selectedTypeOfVideo == 'vimeo') {
                      return getTranslated(context, "Vimeo")!;
                    } else if (editProvider!.selectedTypeOfVideo == 'youtube') {
                      return getTranslated(context, "Youtube")!;
                    } else if (editProvider!.selectedTypeOfVideo ==
                        'Self Hosted') {
                      return "Self Hosted";
                    }
                  } else if (index == 9) {
                    if (editProvider!.productType == 'simple_product') {
                      return getTranslated(context, "Simple Product")!;
                    } else if (editProvider!.productType ==
                        'variable_product') {
                      return getTranslated(context, "Variable Product")!;
                    } else if (editProvider!.productType == 'digital_product') {
                      return 'Digital Product';
                    }
                  } else if (index == 10) {
                    if (editProvider!.simpleproductStockStatus == '1') {
                      return getTranslated(context, "In Stock")!;
                    } else if (editProvider!.simpleproductStockStatus != null) {
                      return getTranslated(context, "Out Of Stock")!;
                    }
                  } else if (index == 11) {
                    if (editProvider!.variantStockLevelType ==
                        'product_level') {
                      return getTranslated(
                        context,
                        "Product Level (Stock Will Be Managed Generally)",
                      )!;
                    } else if (editProvider!.variantStockLevelType != null) {
                      return getTranslated(
                        context,
                        "Variable Level (Stock Will Be Managed Variant Wise)",
                      )!;
                    }
                  } else if (index == 12) {
                    if (editProvider!.stockStatus == '1') {
                      return getTranslated(context, "In Stock")!;
                    } else {
                      return getTranslated(context, "Out Of Stock")!;
                    }
                  } else if (index == 13) {
                    if (editProvider!.selectedBrandName != null) {
                      return editProvider!.selectedBrandName!;
                    }
                  } else if (index == 14) {
                    if (editProvider!
                            .selectedDigitalProductTypeOfDownloadLink !=
                        null) {
                      return editProvider!
                          .selectedDigitalProductTypeOfDownloadLink!;
                    }
                  } else if (index == 15) {
                    return editProvider!.currentSellectedProductIsPysical
                        ? "Physical Product"
                        : "Digital Product";
                  } else if (index == 16) {
                    if (editProvider!.selectedPickUpLocation != null) {
                      return editProvider!.selectedPickUpLocation!;
                    }
                  }
                  return title;
                }(),
              ),
            ),
            const Expanded(
              flex: 1,
              child: Icon(
                Icons.arrow_drop_down_outlined,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
