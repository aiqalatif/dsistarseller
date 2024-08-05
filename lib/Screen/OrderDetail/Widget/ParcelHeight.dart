import 'package:flutter/material.dart';
import '../../../../../../Helper/Color.dart';
import '../../../../../../Helper/Constant.dart';
import '../../../../../../Provider/settingProvider.dart';
import '../../../../../../Widget/validation.dart';

// ignore: must_be_immutable
class ParcelHeight extends StatelessWidget {
  String heightC;
  Function update;

  ParcelHeight({Key? key, required this.heightC, required this.update})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              getTranslated(context, "Height (cms)")!,
              style: const TextStyle(
                fontSize: textFontSize16,
                color: black,
              ),
              overflow: TextOverflow.ellipsis,
              softWrap: true,
              maxLines: 2,
            ),
          ),
          Expanded(
              child: Container(
            width: width * 0.4,
            height: height * 0.06,
            padding: const EdgeInsets.only(),
            child: TextFormField(
              keyboardType: TextInputType.number,
              initialValue: heightC.toString(),
              style: const TextStyle(
                color: black,
                fontWeight: FontWeight.normal,
              ),
              textInputAction: TextInputAction.next,
              //inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              onChanged: (String? value) {
                heightC = value!;
                update(value);
              },
              validator: (val) => StringValidation.validateField(val, context),
              decoration: InputDecoration(
                filled: true,
                fillColor: grey1,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                prefixIconConstraints:
                    const BoxConstraints(minWidth: 40, maxHeight: 20),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: grey2),
                  borderRadius: BorderRadius.circular(circularBorderRadius7),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: const BorderSide(color: lightWhite),
                  borderRadius: BorderRadius.circular(circularBorderRadius8),
                ),
              ),
            ),
          )),
        ],
      ),
    );
  }
}
