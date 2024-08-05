import 'package:flutter/material.dart';
import '../Model/ZipCodesModel/ZipCodeModel.dart';
import '../Repository/zipcodeRepositry.dart';
import '../Screen/AddProduct/Add_Product.dart';
import '../Screen/EditProduct/EditProduct.dart';

class ZipcodeProvider extends ChangeNotifier {
  int offset = 0;
  int total = 0;
  String errorMessage = '';
  String searchString = '';

  Future<bool> setZipCode(bool fromAddProduct, {bool isRefresh = true}) async {
    if (isRefresh) {
      offset = 0;
      if (fromAddProduct) {
        addProvider!.zipSearchList.clear();
      } else {
        editProvider!.zipSearchList.clear();
      }
    } else {
      if (fromAddProduct) {
        if (total >= addProvider!.zipSearchList.length) {
          return false;
        }
      } else {
        if (total >= editProvider!.zipSearchList.length) {
          return false;
        }
      }
    }
    try {
      var result = await ZipcodeRepository.setZipCode(
          offset: offset, limit: 10, search: searchString);
      bool error = result['error'];
      errorMessage = result['message'];
      if (!error) {
        total = int.parse(result["total"].toString());
        if (offset < total) {
          var data = result['data'];
          if (fromAddProduct) {
            addProvider!.zipSearchList.addAll((data as List)
                .map((data) => ZipCodeModel.fromJson(data))
                .toList());
          } else {
            editProvider!.zipSearchList.addAll((data as List)
                .map((data) => ZipCodeModel.fromJson(data))
                .toList());
          }
        }
      }
      return error;
    } catch (e) {
      errorMessage = e.toString();
      return true;
    }
  }
}
