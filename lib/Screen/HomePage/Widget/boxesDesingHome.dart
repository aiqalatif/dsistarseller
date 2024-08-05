import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import '../../../Helper/Color.dart';
import '../../../Helper/Constant.dart';
import '../../../Provider/walletProvider.dart';
import '../../../Widget/desing.dart';
import '../../../Widget/routes.dart';
import '../../ProductList/ProductList.dart';
import '../../WalletHistory/WalletHistory.dart';

boxesDesingHome(
  String svg,
  String title,
  String? numberCounting,
  int index,
  BuildContext context,
) {
  return Expanded(
    child: InkWell(
      onTap: () {
        if (index == 0) {
          Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (context) =>
                  ChangeNotifierProvider<WalletTransactionProvider>(
                create: (context) => WalletTransactionProvider(),
                child: const WalletHistory(),
              ),
            ),
          );
        } else if (index == 1) {
          Routes.navigateToSalesReport(context);
        } else if (index == 2) {
          Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (context) => ProductList(
                flag: "sold",
                fromNavbar: false,
              ),
            ),
          );
        } else if (index == 3) {
          Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (context) => ProductList(
                flag: "low",
                fromNavbar: false,
              ),
            ),
          );
        }
      },
      child: Padding(
        padding: EdgeInsetsDirectional.only(
          end: index == 0 || index == 2 ? 7.5 : 0.0,
          start: index == 1 || index == 3 ? 7.5 : 0.0,
        ),
        child: Container(
          decoration: const BoxDecoration(
            borderRadius:
                BorderRadius.all(Radius.circular(circularBorderRadius15)),
            color: white,
            boxShadow: [
              BoxShadow(
                color: blarColor,
                offset: Offset(0, 0),
                blurRadius: 4,
                spreadRadius: 0,
              ),
            ],
          ),
          height: 141,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsetsDirectional.only(
                    top: 18.0, bottom: 15.0, start: 18.0),
                child: SvgPicture.asset(
                  DesignConfiguration.setSvgPath(svg),
                  width: 30,
                  height: 30,
                  colorFilter: const ColorFilter.mode(primary, BlendMode.srcIn),
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.only(
                  start: 18.0,
                  bottom: 10.0,
                ),
                child: Text(title,
                    style: const TextStyle(
                        color: black,
                        fontWeight: FontWeight.w400,
                        fontFamily: "PlusJakartaSans",
                        fontStyle: FontStyle.normal,
                        fontSize: textFontSize14),
                    textAlign: TextAlign.left),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.only(
                  start: 18.0,
                  bottom: 10.0,
                ),
                child: Text(numberCounting ?? "",
                    style: const TextStyle(
                        color: black,
                        fontWeight: FontWeight.w700,
                        fontFamily: "PlusJakartaSans",
                        fontStyle: FontStyle.normal,
                        fontSize: textFontSize16),
                    textAlign: TextAlign.left),
              )
            ],
          ),
        ),
      ),
    ),
  );
}
