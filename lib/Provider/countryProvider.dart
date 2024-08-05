import 'package:flutter/material.dart';
import '../Helper/Constant.dart';
import '../Screen/EditProduct/EditProduct.dart';
import '../Widget/parameterString.dart';
import '../Model/Country/countryModel.dart';
import '../Repository/countryRepositry.dart';
import '../Screen/AddProduct/Add_Product.dart';

class CountryProvider extends ChangeNotifier {
  String errorMessage = '';

  Future<bool> setCountrys(bool isSearchCity, bool fromAddProduct) async {
    try {
      var parameter = {
        LIMIT: perPage.toString(),
        OFFSET: fromAddProduct
            ? addProvider!.countryOffset.toString()
            : editProvider!.countryOffset.toString(),
      };
      if (isSearchCity) {
        parameter[SEARCH] = fromAddProduct
            ? addProvider!.countryController.text
            : editProvider!.countryController.text;
        parameter[OFFSET] = '0';
        if (fromAddProduct) {
          addProvider!.countrySearchLIst.clear();
        } else {
          editProvider!.countrySearchList.clear();
        }
      }
      var result = await CountryRepository.setCountry(parameter: parameter);
      bool error = result['error'];
      errorMessage = result['message'];
      if (!error) {
        var data = result['data'];
        if (fromAddProduct) {
          addProvider!.countryList = (data as List)
              .map((data) => CountryModel.fromJson(data))
              .toList();
          addProvider!.countrySearchLIst.addAll(addProvider!.countryList);
        } else {
          editProvider!.countryList = (data as List)
              .map((data) => CountryModel.fromJson(data))
              .toList();
          editProvider!.countrySearchList.addAll(editProvider!.countryList);
        }
      }
      if (fromAddProduct) {
        addProvider!.countryLoading = false;
        addProvider!.isLoadingMoreCity = false;
        addProvider!.isProgress = false;
        addProvider!.countryOffset += perPage;
      } else {
        editProvider!.countryLoading = false;
        editProvider!.isLoadingMoreCountry = false;
        editProvider!.isProgress = false;
        editProvider!.countryOffset += perPage;
        if (editProvider!.countryState != null) {
          // editProvider!.cityState!(() {});
        }
      }
      return error;
    } catch (e) {
      errorMessage = e.toString();
      return true;
    }
  }
}
