import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sellermultivendor/Provider/settingProvider.dart';
import '../Helper/Constant.dart';
import '../Model/ProductModel/Product.dart';
import '../Repository/productListRepositry.dart';
import '../Repository/serachRepositry.dart';
import '../Widget/networkAvailablity.dart';
import '../Widget/parameterString.dart';
import '../Widget/sharedPreferances.dart';
import '../Widget/snackbar.dart';

class SearchProvider extends ChangeNotifier {
  TextEditingController controller = TextEditingController();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  int pos = 0;
  bool isProgress = false;
  List<Product> productList = [];
  List<TextEditingController> controllerList = [];
  Animation? buttonSqueezeanimation;
  AnimationController? buttonController;
  String searchText = "", lastsearch = "";
  int notificationoffset = 0;
  ScrollController? notificationcontroller;
  bool notificationisloadmore = true,
      notificationisgettingdata = false,
      notificationisnodata = false;

  initializeVariable() {
    controller.clear();
    pos = 0;
    isProgress = false;
    productList = [];
    controllerList = [];
    searchText = "";
    lastsearch = "";
    notificationoffset = 0;
    notificationisloadmore = true;
    notificationisgettingdata = false;
    notificationisnodata = false;
    notifyListeners();
  }

  Future getProduct(
    Function update,
    BuildContext context,
  ) async {
    isNetworkAvail = await isNetworkAvailable();
    if (isNetworkAvail) {
      try {
        if (notificationisloadmore) {
          notificationisloadmore = false;
          notificationisgettingdata = true;
          if (notificationoffset == 0) {
            productList = [];
          }
          update();

          context.read<SettingProvider>().CUR_USERID = await getPrefrence(Id);
          var parameter = {
            SEARCH: searchText.trim(),
            LIMIT: perPage.toString(),
            OFFSET: notificationoffset.toString(),
          };
          var result = await SearchRepository.getProducts(
            parameter: parameter,
          );
          bool error = result["error"];
          notificationisgettingdata = false;
          if (notificationoffset == 0) notificationisnodata = error;
          if (!error) {
            Future.delayed(
              Duration.zero,
              () {
                List mainlist = result['data'];

                if (mainlist.isNotEmpty) {
                  List<Product> items = [];
                  List<Product> allitems = [];

                  items.addAll(
                    mainlist.map((data) => Product.fromJson(data)).toList(),
                  );
                  allitems.addAll(items);

                  for (Product item in items) {
                    productList.where((i) => i.id == item.id).map(
                      (obj) {
                        allitems.remove(item);
                        return obj;
                      },
                    ).toList();
                  }
                  getAvailVarient(allitems);
                  notificationisloadmore = true;
                  notificationoffset = notificationoffset + perPage;
                } else {
                  notificationisloadmore = false;
                }
                update();
              },
            );
          } else {
            notificationisloadmore = false;
            update();
          }
        }
      } on TimeoutException catch (_) {
        setSnackbar(
          'somethingMSg',
          context,
        );
        notificationisloadmore = false;
        update();
      }
    } else {
      isNetworkAvail = false;
      update();
    }
  }

  void getAvailVarient(List<Product> tempList) {
    for (int j = 0; j < tempList.length; j++) {
      if (tempList[j].stockType == "2") {
        for (int i = 0; i < tempList[j].prVarientList!.length; i++) {
          if (tempList[j].prVarientList![i].availability == "1") {
            tempList[j].selVarient = i;

            break;
          }
        }
      }
    }
    productList.addAll(tempList);
  }

  delProductApi(
    String id,
    BuildContext context,
    Function update,
  ) async {
    isNetworkAvail = await isNetworkAvailable();
    if (isNetworkAvail) {
      var parameter = {
        ProductId: id,
      };
      var result =
          await ProductListRepository.deleteProductApi(parameter: parameter);

      bool error = result["error"];
      String? msg = result["message"];
      if (!error) {
        setSnackbar(
          msg!,
          context,
        );
      } else {
        setSnackbar(
          msg!,
          context,
        );
      }
    } else {
      isNetworkAvail = false;
      update();
    }
    return null;
  }
}
