// Comman Input Text Field :-     .
import 'package:flutter/material.dart';
import 'package:sellermultivendor/Repository/appSettingsRepository.dart';
import 'package:sellermultivendor/Screen/AddProduct/Widget/Dialogs/pickUpLocationBottomSheet.dart';
import 'package:sellermultivendor/Screen/AddProduct/Widget/Dialogs/selectCityDialog.dart';
import '../../../Helper/Color.dart';
import '../../../Helper/Constant.dart';
import '../../../Provider/settingProvider.dart';
import '../../../Widget/validation.dart';
import '../Add_Product.dart';
import 'Dialogs/IndicatorDialog.dart';
import 'Dialogs/brandSelectButtomSheet.dart';
import 'Dialogs/categorySelectButtomSheet.dart';
import 'Dialogs/countryDialog.dart';
import 'Dialogs/deliverableTypeDialog.dart';
import 'Dialogs/digitalProductVideoTypeButtomSheet.dart';
import 'Dialogs/productPDTypeDialog.dart';
import 'Dialogs/productTypeDialog.dart';
import 'Dialogs/selectZipcode.dart';
import 'Dialogs/stockStatusDialog.dart';
import 'Dialogs/taxesDialog.dart';
import 'Dialogs/tillWhichStatusDialog.dart';
import 'Dialogs/variantStockStatusDialog.dart';

import 'Dialogs/videoselectionDialog.dart';
import 'getCommanWidget.dart';

getIconSelectionDesing(
  String title,
  int index,
  BuildContext context,
  Function setState,
  Function updateCity,
) {
  return InkWell(
    onTap: () {
      if (index == 1) {
        taxesDialog(context, setState);
      } else if (index == 2) {
        indicatorDialog(context, setState);
      } else if (index == 3) {
        countryDialog(context, setState, updateCity);
      } else if (index == 4) {
        addProvider!.deliverableZipcodes = null;
        deliverableTypeDialog(context, setState);
      } else if (index == 5) {
        categorySelectButtomSheet(context, setState);
      } else if (index == 6) {
        if (AppSettingsRepository.appSettings.isCityWiseDeliveribility) {
          cityDialog(context, setState);
        } else {
          zipcodeDialog(context, setState);
        }
      } else if (index == 7) {
        tillWhichStatusDialog(context, setState);
      } else if (index == 8) {
        videoselectionDialog(context, setState);
      } else if (index == 9) {
        FocusScope.of(context).requestFocus(FocusNode());
        productTypeDialog(context, setState);
      } else if (index == 10) {
        FocusScope.of(context).requestFocus(FocusNode());
        stockStatusDialog(context, setState);
      } else if (index == 11) {
        // variountProductStockManagementTypeDialog(context, setState);
      } else if (index == 12) {
        variantStockStatusDialog("product", 0, context, setState);
      } else if (index == 13) {
        brandSelectButtomSheet(context, setState);
      } else if (index == 14) {
        digitalProductVideoTypeDialog(context, setState);
      } else if (index == 15) {
        productTypePDDialog(context, setState);
      } else if (index == 16) {
        pickUpLocationSelectButtomSheet(context, setState);
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
                    if (addProvider!.selectedTaxID != null) {
                      return "${addProvider!.taxesList[addProvider!.selectedTaxID!].title!} ${addProvider!.taxesList[addProvider!.selectedTaxID!].percentage!}%";
                    }
                    return title;
                  } else if (index == 2) {
                    if (addProvider!.indicatorValue == '0') {
                      return getTranslated(context, "None")!;
                    } else if (addProvider!.indicatorValue == '1') {
                      return getTranslated(context, "Veg")!;
                    } else if (addProvider!.indicatorValue == '2') {
                      return getTranslated(context, "Non-Veg")!;
                    }
                    return title;
                  } else if (index == 3) {
                    if (addProvider!.madeIn != null) {
                      return "${getTranslated(context, "Made In")!} ${addProvider!.madeIn!}";
                    }
                    return title;
                  } else if (index == 4) {
                    if (addProvider!.deliverabletypeValue == '0') {
                      return getTranslated(context, "None")!;
                    } else if (addProvider!.deliverabletypeValue == '1') {
                      return getTranslated(context, "All")!;
                    } else if (addProvider!.deliverabletypeValue == '2') {
                      return getTranslated(context, "Include")!;
                    } else if (addProvider!.deliverabletypeValue == '3') {
                      return getTranslated(context, "Exclude")!;
                    }
                  } else if (index == 5) {
                    if (addProvider!.selectedCatName != null) {
                      return addProvider!.selectedCatName!;
                    }
                  } else if (index == 6) {
                    if (AppSettingsRepository
                        .appSettings.isCityWiseDeliveribility) {
                      if (addProvider!.deliverableCities.isNotEmpty) {
                        return addProvider!.deliverableCities
                            .map((e) => e.name)
                            .toList()
                            .join(', ');
                      }
                    } else {
                      if (addProvider!.deliverableZipcodes != null) {
                        return addProvider!.deliverableZipcodes!;
                      }
                    }
                  } else if (index == 7) {
                    if (addProvider!.tillwhichstatus == 'received') {
                      return getTranslated(context, "RECEIVED_LBL")!;
                    } else if (addProvider!.tillwhichstatus == 'processed') {
                      return getTranslated(context, "PROCESSED_LBL")!;
                    } else if (addProvider!.tillwhichstatus == 'shipped') {
                      return getTranslated(context, "SHIPED_LBL")!;
                    }
                  } else if (index == 8) {
                    if (addProvider!.selectedTypeOfVideo == 'vimeo') {
                      return getTranslated(context, "Vimeo")!;
                    } else if (addProvider!.selectedTypeOfVideo == 'youtube') {
                      return getTranslated(context, "Youtube")!;
                    } else if (addProvider!.selectedTypeOfVideo ==
                        'Self Hosted') {
                      return "Self Hosted";
                    }
                  } else if (index == 9) {
                    if (addProvider!.productType == 'simple_product') {
                      return getTranslated(context, "Simple Product")!;
                    } else if (addProvider!.productType == 'variable_product') {
                      return getTranslated(context, "Variable Product")!;
                    } else if (addProvider!.productType == 'digital_product') {
                      return "Digital Product";
                    }
                  } else if (index == 10) {
                    if (addProvider!.simpleproductStockStatus == '1') {
                      return getTranslated(context, "In Stock")!;
                    } else if (addProvider!.simpleproductStockStatus != null) {
                      return getTranslated(context, "Out Of Stock")!;
                    }
                  } else if (index == 11) {
                    if (addProvider!.variantStockLevelType == 'product_level') {
                      return getTranslated(
                        context,
                        "Product Level (Stock Will Be Managed Generally)",
                      )!;
                    } else if (addProvider!.variantStockLevelType != null) {
                      return getTranslated(
                        context,
                        "Variable Level (Stock Will Be Managed Variant Wise)",
                      )!;
                    }
                  } else if (index == 12) {
                    if (addProvider!.stockStatus == '1') {
                      return getTranslated(context, "In Stock")!;
                    } else {
                      return getTranslated(context, "Out Of Stock")!;
                    }
                  } else if (index == 13) {
                    if (addProvider!.selectedBrandName != null) {
                      return addProvider!.selectedBrandName!;
                    }
                  } else if (index == 14) {
                    if (addProvider!.selectedDigitalProductTypeOfDownloadLink !=
                        null) {
                      return addProvider!
                          .selectedDigitalProductTypeOfDownloadLink!;
                    }
                  } else if (index == 15) {
                    return addProvider!.currentSellectedProductIsPysical
                        ? "Physical Product"
                        : "Digital Product";
                  } else if (index == 16) {
                    if (addProvider!.selectedPickUpLocation != null) {
                      return addProvider!.selectedPickUpLocation!;
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
