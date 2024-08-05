import 'package:flutter/material.dart';
import '../Model/TaxesModel/TaxesModel.dart';
import '../Repository/taxRepositry.dart';
import '../Screen/AddProduct/Add_Product.dart';
import '../Screen/EditProduct/EditProduct.dart';

class TaxProvider extends ChangeNotifier {
  String errorMessage = '';

  Future<bool> setTax(bool fromAddProduct) async {
    try {
      var result = await TaxRepository.setTax();
      bool error = result['error'];
      errorMessage = result['message'];
      if (!error) {
        var data = result['data'];
        if (fromAddProduct) {
          addProvider!.taxesList =
              (data as List).map((data) => TaxesModel.fromJson(data)).toList();
        } else {
          editProvider!.taxesList =
              (data as List).map((data) => TaxesModel.fromJson(data)).toList();
        }
      }
      return error;
    } catch (e) {
      errorMessage = e.toString();
      return true;
    }
  }
}
