//==============================================================================
//=========================== Reset Button ===============================
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../Helper/Color.dart';
import '../../../Helper/Constant.dart';
import '../../../Widget/snackbar.dart';
import '../../../Widget/validation.dart';
import '../Add_Product.dart';

resetProButton(BuildContext context) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceAround,
    children: [
      InkWell(
        onTap: () {
          Navigator.pushReplacement(
            context,
            CupertinoPageRoute<String>(
              builder: (context) => const AddProduct(),
            ),
          );
          setSnackbar(getTranslated(context, "Reset Successfully")!, context);
        },
        child: Container(
          height: 50,
          width: 150,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(circularBorderRadius10),
            color: lightBlack2,
          ),
          child: Center(
            child: Text(
              getTranslated(context, "Reset All")!,
              style: const TextStyle(
                fontSize: textFontSize20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    ],
  );
}
