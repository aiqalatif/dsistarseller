import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sellermultivendor/Provider/settingProvider.dart';
import '../Helper/Constant.dart';
import '../Model/ProductModel/Product.dart';
import '../Repository/productListRepositry.dart';
import '../Widget/networkAvailablity.dart';
import '../Widget/overylay.dart';
import '../Widget/parameterString.dart';
import '../Widget/snackbar.dart';
import '../Widget/validation.dart';

class StockProviderProvider extends ChangeNotifier {
  bool isLoading = true, isProgress = false;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  List<Product> productList = [];
  List<Product> tempList = [];
  String? sortBy = 'p.id', orderBy = "DESC";
  int offset = 0;
  int total = 0;
  String? totalProduct;
  bool isLoadingmore = true;
  ScrollController controller = ScrollController();
  List<dynamic>? filterList = [];
  List<String>? attnameList;
  List<String>? attsubList;
  List<String>? attListId;
  List<String> selectedId = [];
  bool isFirstLoad = true;
  String? filter = "";
  String selId = "";
  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  Animation? buttonSqueezeanimation;
  AnimationController? buttonController;
  bool listType = true;
  final List<TextEditingController> controllers = [];
  var items;
  initializaedVariableWithDefualtValue() {
    isLoading = true;
    isProgress = false;
    productList = [];
    tempList = [];
    sortBy = 'p.id';
    orderBy = "DESC";
    offset = 0;
    total = 0;
    totalProduct = null;
    isLoadingmore = true;
    filterList = [];
    attnameList = null;
    attsubList = null;
    attListId = null;
    selectedId = [];
    isFirstLoad = true;
    filter = "";
    selId = "";
    listType = true;
    items = null;
  }

  Future<void> getProduct(
    String top,
    BuildContext context,
    Function update,
  ) async {
    // if (readProduct) {
    isNetworkAvail = await isNetworkAvailable();
    if (isNetworkAvail) {
      var parameter = {
        //CATID: widget.id ?? '',
    
        SORT: sortBy,
        Order: orderBy,
        LIMIT: perPage.toString(),
        OFFSET: offset.toString(),
        TOP_RETAED: top,
        'show_only_active_products': "0",
        'show_only_stock_product': '1',
      };
      if (selId != "") {
        parameter[AttributeValueIds] = selId;
      }
      var result = await ProductListRepository.getProduct(parameter: parameter);

      bool error = result["error"];
      if (!error) {
        total = int.parse(result["total"]);

        if (isFirstLoad) {
          filterList = result["filters"];
          isFirstLoad = false;
        }
        if ((offset) < total) {
          tempList.clear();
          var data = result["data"];
          tempList =
              (data as List).map((data) => Product.fromJson(data)).toList();
          getAvailVarient();
          offset = offset + perPage;
        }
      } else {
        isLoadingmore = false;
      }
      isLoading = false;
      update();
    } else {
      isNetworkAvail = false;
      update();
    }
    /* } else {
      isLoading = false;
      update();

      Future.delayed(const Duration(microseconds: 500)).then(
        (_) async {
          setSnackbar(
              'You have not authorized permission for read Product!!', context);
        },
      );
    }*/
    return;
  }

  Future<void> setStockValue(
    String productVariantIdValue,
    BuildContext context,
    bool isAddValue,
    String quanntity,
    String currentStock,
  ) async {
    isNetworkAvail = await isNetworkAvailable();
    if (isNetworkAvail) {
      var parameter = {
        ProductVariantId: productVariantIdValue,
        Quantity: quanntity,
        Type: isAddValue ? 'add' : 'subtract',
        'current_stock': currentStock,
      };

      var result =
          await ProductListRepository.setStockStatus(parameter: parameter);
      // bool error = result["error"];
      String msg = result["message"];

      setSnackbar(msg, context);

      isLoading = false;
    } else {
      isNetworkAvail = false;
    }
    return;
  }

  void getAvailVarient() {
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

  Future<void> updateProductStatus(
    String id,
    String status,
    BuildContext context,
    Function setStateNow,
  ) async {
    isNetworkAvail = await isNetworkAvailable();
    if (isNetworkAvail) {
      try {
        var parameter = {
          "product_id": id,
          "status": status,
        };
        var result = await ProductListRepository.updateProductStatus(
            parameter: parameter);

        bool error = result["error"];
        String msg = result["message"];
        if (!error) {
          setSnackbar(
            msg,
            context,
          );
          isLoading = true;
          isLoadingmore = true;
          offset = 0;
          total = 0;
          productList.clear();
          getProduct("0", context, setStateNow);
        } else {
          setSnackbar(
            msg,
            context,
          );
        }
      } on TimeoutException catch (_) {
        setSnackbar(
          getTranslated(context, 'somethingMSg')!,
          context,
        );

        setStateNow();
      }
    } else {
      isNetworkAvail = false;
      setStateNow();
    }
    return;
  }

  deleteProductApi(
    String id,
    BuildContext context,
    Function setStateNow,
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
        showOverlay(
          msg!,
          context,
        );
      } else {
        showOverlay(
          msg!,
          context,
        );
      }
    } else {
      isNetworkAvail = false;
      isLoading = false;
      setStateNow();
    }
    return null;
  }
}
