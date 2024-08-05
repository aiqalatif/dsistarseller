import 'package:flutter/material.dart';
import '../../../Helper/Color.dart';
import '../../../Helper/Constant.dart';
import '../../../Widget/validation.dart';
import '../SalesReport.dart';
import 'getRowFields.dart';

class ListIteam extends StatelessWidget {
  final int index;
  const ListIteam({
    Key? key,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        right: 15.0,
        bottom: 15.0,
        left: 15.0,
      ),
      child: Container(
        decoration: const BoxDecoration(
          borderRadius:
              BorderRadius.all(Radius.circular(circularBorderRadius5)),
          boxShadow: [
            BoxShadow(
              color: blarColor,
              offset: Offset(0, 0),
              blurRadius: 4,
              spreadRadius: 0,
            ),
          ],
          color: white,
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(circularBorderRadius5),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      "${getTranslated(context, 'Name')!} : ${salesProvider!.tranList[index].name ?? ''}",
                      style: const TextStyle(
                        color: black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      margin: const EdgeInsets.only(left: 8),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 2,
                      ),
                      decoration: const BoxDecoration(
                        color: primary,
                        borderRadius: BorderRadius.all(
                          Radius.circular(circularBorderRadius5),
                        ),
                      ),
                      child: Text(
                        StringValidation.capitalize(
                            salesProvider!.tranList[index].paymentMethod!),
                        style: const TextStyle(
                          color: white,
                          fontSize: textFontSize14,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    )
                  ],
                ),
                const Divider(),
                GetRowFields(
                  title: "${getTranslated(context, 'ORDER_ID_LBL')} : ",
                  value: salesProvider!.tranList[index].id!,
                  simple: true,
                ),
                GetRowFields(
                  title: "${getTranslated(context, "Date & Time")} : ",
                  value: salesProvider!.tranList[index].dateAdded!,
                  simple: true,
                ),
                GetRowFields(
                  title:
                      "${getTranslated(context, 'Total')!} (${getTranslated(context, "INCLUDE_TAXLBL")}):",
                  /* ${tempList[0].taxPer!}%) :",*/
                  value: salesProvider!.tranList[index].total!,
                  simple: false,
                ),
                // GetRowFields(
                //   title: "${getTranslated(context, "Tax Amount")} : ",
                //   value: salesProvider!.tranList[index].taxAmount!,
                //   simple: false,
                // ),
                GetRowFields(
                  title: "${getTranslated(context, 'Discount')} : ",
                  value: salesProvider!.tranList[index].discountedPrice!,
                  simple: false,
                ),
                GetRowFields(
                  title: "${getTranslated(context, 'DELIVERY_CHARGE')} : ",
                  value: salesProvider!.tranList[index].deliveryCharge!,
                  simple: false,
                ),
                const Divider(),
                GetRowFields(
                  title: "${getTranslated(context, 'Final Total')} : ",
                  value: salesProvider!.tranList[index].finalTotal!,
                  simple: false,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
