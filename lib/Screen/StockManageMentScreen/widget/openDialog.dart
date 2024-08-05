import 'package:flutter/material.dart';
import 'package:sellermultivendor/Helper/Color.dart';
import 'package:sellermultivendor/Provider/settingProvider.dart';
import 'package:sellermultivendor/Widget/ButtonDesing.dart';
import 'package:sellermultivendor/Widget/validation.dart';
import '../../../../Helper/Constant.dart';
import '../StockManageMentList.dart';

getButtonDesing(
  IconData icon,
) {
  return Container(
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      border: Border.all(
        color: lightBlack2,
        style: BorderStyle.solid,
        width: 1.0,
      ),
    ),
    child: Padding(
      padding: const EdgeInsets.all(5.0),
      child: Icon(
        icon,
        color: black,
        size: 18,
      ),
    ),
  );
}

FocusNode? stockFocus;
Future<void> manageStockDialog(
  BuildContext context,
  String title,
  String stockValue,
  String variantId,
) async {
  controllerForStock.text = '0';
  bool? addValue = true;
  bool selectTypeValue = false;
  await showModalBottomSheet(
    isScrollControlled: true,
    context: context,
    backgroundColor: Colors.transparent,
    builder: (BuildContext ctx) {
      return StatefulBuilder(
        builder: (
          BuildContext ctx,
          StateSetter setState,
        ) {
          return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.9),
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(circularBorderRadius25),
                    topRight: Radius.circular(circularBorderRadius25),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: width * 0.8,
                            child: Text(
                              title,
                              style: const TextStyle(
                                fontSize: 18,
                                color: black,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.pop(ctx);
                            },
                            child: const Icon(
                              Icons.close,
                              color: primary,
                            ),
                          ),
                        ],
                      ),
                      const Divider(),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "${getTranslated(context, 'Current Stock')!} : ",
                            ),
                            Container(
                              width: 80,
                              height: 25,
                              decoration: BoxDecoration(
                                color: lightWhite,
                                borderRadius: BorderRadius.circular(
                                    circularBorderRadius5),
                                border: Border.all(
                                  color: lightBlack2,
                                  style: BorderStyle.solid,
                                  width: 1.0,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  stockValue == '' ? '0' : stockValue,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("${getTranslated(context, 'Quantity')!} : "),
                            Row(
                              children: [
                                InkWell(
                                  onTap: () {
                                    int temp =
                                        int.parse(controllerForStock.text);
                                    // stockFocus!.unfocus();
                                    controllerForStock.text =
                                        temp == 0 ? '1' : (temp + 1).toString();
                                    setState(() {});
                                  },
                                  child: getButtonDesing(Icons.add),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                SizedBox(
                                  width: width * 0.2,
                                  height: 25,
                                  child: Center(
                                    child: TextFormField(
                                      controller: controllerForStock,
                                      onFieldSubmitted: (v) {
                                        FocusScope.of(context)
                                            .requestFocus(stockFocus);
                                      },
                                      keyboardType: TextInputType.number,
                                      style: const TextStyle(
                                        color: fontColor,
                                        fontWeight: FontWeight.normal,
                                      ),
                                      focusNode: stockFocus,
                                      onSaved: (value) {
                                        stockFocus!.unfocus();
                                      },
                                      textAlign: TextAlign.center,
                                      decoration: InputDecoration(
                                        counterText: "",
                                        counterStyle: const TextStyle(
                                            height: double.minPositive),
                                        filled: true,
                                        fillColor: lightWhite,
                                        prefixIconConstraints:
                                            const BoxConstraints(
                                                minWidth: 40, maxHeight: 20),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: fontColor),
                                          borderRadius: BorderRadius.circular(
                                              circularBorderRadius7),
                                        ),
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: lightWhite),
                                          borderRadius: BorderRadius.circular(
                                              circularBorderRadius8),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                InkWell(
                                  onTap: () {
                                    int temp =
                                        int.parse(controllerForStock.text);
                                    if (controllerForStock.text == '' ||
                                        controllerForStock.text == '0') {
                                      controllerForStock.text = '0';
                                    } else {
                                      controllerForStock.text =
                                          (temp - 1).toString();
                                    }
                                    setState(() {});
                                  },
                                  child: getButtonDesing(Icons.remove),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 0.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("${getTranslated(context, 'Type')!} : "),
                            Row(
                              children: [
                                InkWell(
                                  onTap: () {
                                    addValue = true;
                                    setState(() {});
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: addValue == null
                                          ? white
                                          : addValue!
                                              ? primary
                                              : white,
                                      border: Border.all(
                                        color: black,
                                        style: BorderStyle.solid,
                                        width: 1.0,
                                      ),
                                    ),
                                    child: const Padding(
                                      padding: EdgeInsets.all(1.0),
                                      child: Icon(
                                        Icons.done,
                                        color: white,
                                        size: 18,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 4.0,
                                    vertical: 2.0,
                                  ),
                                  child: Text(getTranslated(context, 'Add')!),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                InkWell(
                                  onTap: () {
                                    addValue = false;
                                    setState(() {});
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: addValue == null
                                          ? white
                                          : addValue!
                                              ? white
                                              : primary,
                                      border: Border.all(
                                        color: black,
                                        style: BorderStyle.solid,
                                        width: 1.0,
                                      ),
                                    ),
                                    child: const Padding(
                                      padding: EdgeInsets.all(1.0),
                                      child: Icon(
                                        Icons.done,
                                        color: white,
                                        size: 18,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 4.0,
                                    vertical: 2.0,
                                  ),
                                  child: Text(
                                    getTranslated(context, 'Subtract')!,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      selectTypeValue
                          ? Text(
                              getTranslated(
                                  context, 'Note : Please Select Type...!')!,
                              style: const TextStyle(color: red),
                            )
                          : Container(),
                      SimBtn(
                        onBtnSelected: () {
                          if (addValue == null) {
                            selectTypeValue = true;
                            setState(() {});
                          } else if (controllerForStock.text == '' ||
                              controllerForStock.text == '0') {
                            selectTypeValue = false;
                            setState(() {});
                          } else {
                            selectTypeValue = false;
                            isUpdateDone = true;
                            setState(() {});
                            Navigator.pop(ctx);
                            stockManagementProvider!.setStockValue(
                              variantId,
                              context,
                              addValue!,
                              controllerForStock.text.toString(),
                              stockValue,
                            );
                          }
                        },
                        title: getTranslated(context, 'Submit'),
                        size: 50,
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      );
    },
  );
}
