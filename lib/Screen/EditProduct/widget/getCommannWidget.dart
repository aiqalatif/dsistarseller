// Comman Primary Text Field :-
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../Helper/Color.dart';
import '../../../Helper/Constant.dart';
import '../../../Provider/settingProvider.dart';
import '../../../Widget/validation.dart';
import '../EditProduct.dart';

getPrimaryCommanText(String title, bool isMultipleLine) {
  return Text(
    title,
    style: const TextStyle(
      fontSize: textFontSize16,
      color: black,
    ),
    overflow: isMultipleLine ? TextOverflow.ellipsis : null,
    softWrap: true,
    maxLines: isMultipleLine ? 2 : 1,
  );
}

// get command sized Box

getCommanSizedBox() {
  return const SizedBox(
    height: 10,
  );
}

// Comman Secondary Text Field :-

getSecondaryCommanText(String title) {
  return Text(
    title,
    style: const TextStyle(
      color: Colors.grey,
    ),
    softWrap: false,
    overflow: TextOverflow.ellipsis,
    maxLines: 1,
  );
}

getCommanInputTextField(
  String title,
  int index,
  double heightvalue,
  double widthvalue,
  int textType,
  BuildContext context,
) {
  return Container(
    decoration: BoxDecoration(
      color: grey1,
      borderRadius: BorderRadius.circular(circularBorderRadius10),
      border: Border.all(
        color: grey2,
        width: 2,
      ),
    ),
    width: width * widthvalue,
    height: height * heightvalue,
    child: Padding(
      padding: const EdgeInsets.only(
        left: 8,
        right: 8,
      ),
      child: TextFormField(
        onFieldSubmitted: (v) {
          FocusScope.of(context).requestFocus(
            () {
              if (index == 1) {
                return editProvider!.productFocus;
              } else if (index == 2) {
                return editProvider!.sortDescriptionFocus;
              } else if (index == 3) {
                return editProvider!.tagFocus;
              } else if (index == 4) {
                return editProvider!.totalAllowFocus;
              } else if (index == 5) {
                return editProvider!.minOrderFocus;
              } else if (index == 6) {
                return editProvider!.quantityStepSizeFocus;
              } else if (index == 7) {
                return editProvider!.warrantyPeriodFocus;
              } else if (index == 8) {
                return editProvider!.guaranteePeriodFocus;
              } else if (index == 9) {
                return editProvider!.vidioTypeFocus;
              } else if (index == 10) {
                return editProvider!.simpleProductPriceFocus;
              } else if (index == 11) {
                return editProvider!.simpleProductSpecialPriceFocus;
              } else if (index == 12) {
                return editProvider!.simpleProductSKUFocus;
              } else if (index == 13) {
                return editProvider!.simpleProductTotalStockFocus;
              } else if (index == 14) {
                return editProvider!.variountProductSKUFocus;
              } else if (index == 15) {
                return editProvider!.variountProductTotalStockFocus;
              } else if (index == 16) {
                return editProvider!.hsnCodeFucosNode;
              } else if (index == 17) {
                return editProvider!.digitalPriceFocus;
              } else if (index == 18) {
                return editProvider!.digitalSpecialFocus;
              } else if (index == 19) {
                return editProvider!.selfHostedFocus;
              }
            }(),
          );
        },
        focusNode: () {
          if (index == 1) {
            return editProvider!.productFocus;
          } else if (index == 2) {
            return editProvider!.sortDescriptionFocus;
          } else if (index == 3) {
            return editProvider!.tagFocus;
          } else if (index == 4) {
            return editProvider!.totalAllowFocus;
          } else if (index == 5) {
            return editProvider!.minOrderFocus;
          } else if (index == 6) {
            return editProvider!.quantityStepSizeFocus;
          } else if (index == 7) {
            return editProvider!.warrantyPeriodFocus;
          } else if (index == 8) {
            return editProvider!.guaranteePeriodFocus;
          } else if (index == 9) {
            return editProvider!.vidioTypeFocus;
          } else if (index == 10) {
            return editProvider!.simpleProductPriceFocus;
          } else if (index == 11) {
            return editProvider!.simpleProductSpecialPriceFocus;
          } else if (index == 12) {
            return editProvider!.simpleProductSKUFocus;
          } else if (index == 13) {
            return editProvider!.simpleProductTotalStockFocus;
          } else if (index == 14) {
            return editProvider!.variountProductSKUFocus;
          } else if (index == 15) {
            return editProvider!.variountProductTotalStockFocus;
          } else if (index == 16) {
            return editProvider!.hsnCodeFucosNode;
          } else if (index == 17) {
            return editProvider!.digitalPriceFocus;
          } else if (index == 18) {
            return editProvider!.digitalSpecialFocus;
          } else if (index == 19) {
            return editProvider!.selfHostedFocus;
          }
        }(),
        readOnly: false,
        textInputAction: TextInputAction.newline,
        style: const TextStyle(
          color: black,
          fontWeight: FontWeight.normal,
        ),
        controller: () {
          if (index == 1) {
            return editProvider!.productNameControlller;
          } else if (index == 2) {
            return editProvider!.sortDescriptionControlller;
          } else if (index == 3) {
            return editProvider!.tagsControlller;
          } else if (index == 4) {
            return editProvider!.totalAllowController;
          } else if (index == 5) {
            return editProvider!.minOrderQuantityControlller;
          } else if (index == 6) {
            return editProvider!.quantityStepSizeControlller;
          } else if (index == 7) {
            return editProvider!.warrantyPeriodController;
          } else if (index == 8) {
            return editProvider!.guaranteePeriodController;
          } else if (index == 9) {
            return editProvider!.vidioTypeController;
          } else if (index == 10) {
            return editProvider!.simpleProductPriceController;
          } else if (index == 11) {
            return editProvider!.simpleProductSpecialPriceController;
          } else if (index == 12) {
            return editProvider!.simpleProductSKUController;
          } else if (index == 13) {
            return editProvider!.simpleProductTotalStock;
          } else if (index == 14) {
            return editProvider!.variountProductSKUController;
          } else if (index == 15) {
            return editProvider!.variountProductTotalStock;
          } else if (index == 16) {
            return editProvider!.hsnCodeController;
          } else if (index == 17) {
            return editProvider!.digitalPriceController;
          } else if (index == 18) {
            return editProvider!.digitalSpecialController;
          } else if (index == 19) {
            return editProvider!.selfHostedDigitalProductURLController;
          }
        }(),
        inputFormatters: [FilteringTextInputFormatter.singleLineFormatter],
        keyboardType: textType == 1
            ? TextInputType.multiline
            : textType == 2
                ? TextInputType.text
                : TextInputType.number,
        onChanged: (value) {
          if (index == 1) {
            editProvider!.productName = value;
          } else if (index == 2) {
            editProvider!.sortDescription = value;
          } else if (index == 3) {
            editProvider!.tags = value;
          } else if (index == 4) {
            editProvider!.totalAllowQuantity = value;
          } else if (index == 5) {
            editProvider!.minOrderQuantity = value;
          } else if (index == 6) {
            editProvider!.quantityStepSize = value;
          } else if (index == 7) {
            editProvider!.warrantyPeriod = value;
          } else if (index == 8) {
            editProvider!.guaranteePeriod = value;
          } else if (index == 9) {
            editProvider!.videoUrl = value;
          } else if (index == 10) {
            editProvider!.simpleproductPrice = value;
          } else if (index == 11) {
            editProvider!.simpleproductSpecialPrice = value;
          } else if (index == 12) {
            editProvider!.simpleproductSKU = value;
          } else if (index == 13) {
            editProvider!.simpleproductTotalStock = value;
          } else if (index == 14) {
            editProvider!.variantproductSKU = value;
          } else if (index == 15) {
            editProvider!.variantproductTotalStock = value;
          } else if (index == 16) {
            editProvider!.hsnCode = value;
          } else if (index == 17) {
            editProvider!.digitalPrice = value;
          } else if (index == 18) {
            editProvider!.digitalPrice = value;
          } else if (index == 19) {
            editProvider!.digitalProductSelfHostedUrl = value;
          }
        },
        validator: (val) => () {
          if (index == 1) {
            StringValidation.validateProduct(val, context);
          } else if (index == 2) {
            StringValidation.sortdescriptionvalidate(val, context);
          } else if (index == 4) {
            StringValidation.validateThisFieldRequered(val, context);
          } else if (index == 5) {
            StringValidation.validateThisFieldRequered(val, context);
          } else if (index == 6) {
            StringValidation.validateThisFieldRequered(val, context);
          }
        }(),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintStyle: const TextStyle(
            color: Colors.grey,
            fontSize: textFontSize14,
          ),
          hintText: title,
        ),
        minLines: null,
        maxLines: index == 2 ? null : 1,
        expands: index == 2 ? true : false,
      ),
    ),
  );
}
