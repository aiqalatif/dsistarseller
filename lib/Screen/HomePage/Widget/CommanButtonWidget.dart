import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../Helper/Color.dart';
import '../../../Provider/walletProvider.dart';
import '../../../Widget/routes.dart';
import '../../ProductList/ProductList.dart';
import '../../WalletHistory/WalletHistory.dart';

commanDesingButtons(
  int flex,
  int index,
  IconData icon,
  String title,
  String? data,
  BuildContext context,
) {
  return Expanded(
    flex: flex,
    child: InkWell(
      onTap: () {
        if (index == 0) {
          Routes.navigateToOrderList(context);
        } else if (index == 1) {
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
        } else if (index == 2) {
          Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (context) =>  ProductList(
                flag: '',
                   fromNavbar: false,
              ),
            ),
          );
        } else if (index == 4) {
          //rating
        } else if (index == 5) {
          Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (context) => ProductList(
                flag: "sold",
                fromNavbar: false,
              ),
            ),
          );
        } else if (index == 6) {
          Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (context) => ProductList(
                flag: "low",
                fromNavbar: false,
              ),
            ),
          );
        } else if (index == 7) {
          Routes.navigateToSalesReport(context);
        }
      },
      child: Card(
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            children: [
              Icon(
                icon,
                color: primary,
              ),
              Text(
                title,
                style: const TextStyle(
                  color: grey,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                data ?? "",
                style: const TextStyle(
                  color: black,
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.ellipsis,
              )
            ],
          ),
        ),
      ),
    ),
  );
}
