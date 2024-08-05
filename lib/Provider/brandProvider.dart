import 'package:flutter/material.dart';
import 'package:sellermultivendor/Screen/EditProduct/EditProduct.dart';
import '../Model/BrandModel/brandModel.dart';
import '../Repository/brandRepository.dart';
import '../Widget/parameterString.dart';
import '../Screen/AddProduct/Add_Product.dart';

class BrandProvider extends ChangeNotifier {
  String errorMessage = '';

  Future<bool> setBrands(bool fromAdd) async {
    int brandPerPage = 20;
    try {
      var parameter = {
        LIMIT: brandPerPage.toString(),
        OFFSET: fromAdd
            ? addProvider!.brandOffset.toString()
            : editProvider!.brandOffset.toString(),
      };

      var result = await BrandRepository.setBrand(parameter: parameter);
      bool error = result['error'];
      errorMessage = result['message'];
      if (fromAdd) {
        addProvider!.tempBrandList.clear();
      } else {
        editProvider!.tempBrandList.clear();
      }
      if (!error) {
        var data = result['data'];
        if (fromAdd) {
          addProvider!.tempBrandList =
              (data as List).map((data) => BrandModel.fromJson(data)).toList();
          addProvider!.brandList.addAll(addProvider!.tempBrandList);
        } else {
          editProvider!.tempBrandList =
              (data as List).map((data) => BrandModel.fromJson(data)).toList();
          editProvider!.brandList.addAll(editProvider!.tempBrandList);
        }
      }
      if (fromAdd) {
        addProvider!.brandLoading = false;
        addProvider!.isLoadingMoreBrand = false;
        addProvider!.isProgress = false;
        addProvider!.brandOffset += brandPerPage;
      } else {
        editProvider!.brandLoading = false;
        editProvider!.isLoadingMoreBrand = false;
        editProvider!.isProgress = false;
        editProvider!.brandOffset += brandPerPage;
      }

      return error;
    } catch (e) {
      errorMessage = e.toString();
      return true;
    }
  }
}
