// Comman Input Text Field
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../Helper/Color.dart';
import '../../../Helper/Constant.dart';
import '../../../Provider/settingProvider.dart';
import '../../../Widget/validation.dart';
import '../Add_Product.dart';

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
                return addProvider!.productFocus;
              } else if (index == 2) {
                return addProvider!.sortDescriptionFocus;
              } else if (index == 3) {
                return addProvider!.tagFocus;
              } else if (index == 4) {
                return addProvider!.totalAllowFocus;
              } else if (index == 5) {
                return addProvider!.minOrderFocus;
              } else if (index == 6) {
                return addProvider!.quantityStepSizeFocus;
              } else if (index == 7) {
                return addProvider!.warrantyPeriodFocus;
              } else if (index == 8) {
                return addProvider!.guaranteePeriodFocus;
              } else if (index == 9) {
                return addProvider!.vidioTypeFocus;
              } else if (index == 10) {
                return addProvider!.simpleProductPriceFocus;
              } else if (index == 11) {
                return addProvider!.simpleProductSpecialPriceFocus;
              } else if (index == 12) {
                return addProvider!.simpleProductSKUFocus;
              } else if (index == 13) {
                return addProvider!.simpleProductTotalStockFocus;
              } else if (index == 14) {
                return addProvider!.variountProductSKUFocus;
              } else if (index == 15) {
                return addProvider!.variountProductTotalStockFocus;
              } else if (index == 16) {
                return addProvider!.hsnCodeFucosNode;
              } else if (index == 17) {
                return addProvider!.digitalPriceFocus;
              } else if (index == 18) {
                return addProvider!.digitalSpecialFocus;
              } else if (index == 19) {
                return addProvider!.selfHostedFocus;
              } else if (index == 20) {
                return addProvider!.weightFocus;
              } else if (index == 21) {
                return addProvider!.heightFocus;
              } else if (index == 22) {
                return addProvider!.breadthFocus;
              } else if (index == 23) {
                return addProvider!.lengthFocus;
              }
            }(),
          );
        },
        focusNode: () {
          if (index == 1) {
            return addProvider!.productFocus;
          } else if (index == 2) {
            return addProvider!.sortDescriptionFocus;
          } else if (index == 3) {
            return addProvider!.tagFocus;
          } else if (index == 4) {
            return addProvider!.totalAllowFocus;
          } else if (index == 5) {
            return addProvider!.minOrderFocus;
          } else if (index == 6) {
            return addProvider!.quantityStepSizeFocus;
          } else if (index == 7) {
            return addProvider!.warrantyPeriodFocus;
          } else if (index == 8) {
            return addProvider!.guaranteePeriodFocus;
          } else if (index == 9) {
            return addProvider!.vidioTypeFocus;
          } else if (index == 10) {
            return addProvider!.simpleProductPriceFocus;
          } else if (index == 11) {
            return addProvider!.simpleProductSpecialPriceFocus;
          } else if (index == 12) {
            return addProvider!.simpleProductSKUFocus;
          } else if (index == 13) {
            return addProvider!.simpleProductTotalStockFocus;
          } else if (index == 14) {
            return addProvider!.variountProductSKUFocus;
          } else if (index == 15) {
            return addProvider!.variountProductTotalStockFocus;
          } else if (index == 16) {
            return addProvider!.hsnCodeFucosNode;
          } else if (index == 17) {
            return addProvider!.digitalPriceFocus;
          } else if (index == 18) {
            return addProvider!.digitalSpecialFocus;
          } else if (index == 19) {
            return addProvider!.selfHostedFocus;
          } else if (index == 20) {
            return addProvider!.weightFocus;
          } else if (index == 21) {
            return addProvider!.heightFocus;
          } else if (index == 22) {
            return addProvider!.breadthFocus;
          } else if (index == 23) {
            return addProvider!.lengthFocus;
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
            return addProvider!.productNameControlller;
          } else if (index == 2) {
            return addProvider!.sortDescriptionControlller;
          } else if (index == 3) {
            return addProvider!.tagsControlller;
          } else if (index == 4) {
            return addProvider!.totalAllowController;
          } else if (index == 5) {
            return addProvider!.minOrderQuantityControlller;
          } else if (index == 6) {
            return addProvider!.quantityStepSizeControlller;
          } else if (index == 7) {
            return addProvider!.warrantyPeriodController;
          } else if (index == 8) {
            return addProvider!.guaranteePeriodController;
          } else if (index == 9) {
            return addProvider!.vidioTypeController;
          } else if (index == 10) {
            return addProvider!.simpleProductPriceController;
          } else if (index == 11) {
            return addProvider!.simpleProductSpecialPriceController;
          } else if (index == 12) {
            return addProvider!.simpleProductSKUController;
          } else if (index == 13) {
            return addProvider!.simpleProductTotalStock;
          } else if (index == 14) {
            return addProvider!.variountProductSKUController;
          } else if (index == 15) {
            return addProvider!.variountProductTotalStock;
          } else if (index == 16) {
            return addProvider!.hsnCodeController;
          } else if (index == 17) {
            return addProvider!.digitalPriceController;
          } else if (index == 18) {
            return addProvider!.digitalSpecialController;
          } else if (index == 19) {
            return addProvider!.selfHostedDigitalProductURLController;
          } else if (index == 20) {
            return addProvider!.weightController;
          } else if (index == 21) {
            return addProvider!.heightController;
          } else if (index == 22) {
            return addProvider!.breadthController;
          } else if (index == 23) {
            return addProvider!.lengthController;
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
            addProvider!.setproductName(value);
          } else if (index == 2) {
            addProvider!.setsortDescription(value);
          } else if (index == 3) {
            addProvider!.settags(value);
          } else if (index == 4) {
            addProvider!.settotalAllowQuantity(value);
          } else if (index == 5) {
            addProvider!.setminOrderQuantity(value);
          } else if (index == 6) {
            addProvider!.setquantityStepSize(value);
          } else if (index == 7) {
            addProvider!.setwarrantyPeriod(value);
          } else if (index == 8) {
            addProvider!.setguaranteePeriod(value);
          } else if (index == 9) {
            addProvider!.videoUrl = value;
          } else if (index == 10) {
            addProvider!.simpleproductPrice = value;
          } else if (index == 11) {
            addProvider!.simpleproductSpecialPrice = value;
          } else if (index == 12) {
            addProvider!.simpleproductSKU = value;
          } else if (index == 13) {
            addProvider!.simpleproductTotalStock = value;
          } else if (index == 14) {
            addProvider!.variantproductSKU = value;
          } else if (index == 15) {
            addProvider!.variantproductTotalStock = value;
          } else if (index == 16) {
            addProvider!.hsnCode = value;
          } else if (index == 17) {
            addProvider!.digitalPrice = value;
          } else if (index == 18) {
            addProvider!.digitalSpecialPrice = value;
          } else if (index == 19) {
            addProvider!.digitalProductSelfHostedUrl = value;
          } else if (index == 20) {
            addProvider!.weight = value;
          } else if (index == 21) {
            addProvider!.height = value;
          } else if (index == 22) {
            addProvider!.breadth = value;
          } else if (index == 23) {
            addProvider!.length = value;
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
