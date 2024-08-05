import 'package:flutter/material.dart';
import '../Model/Attribute Models/AttributeModel/AttributesModel.dart';
import '../Model/Attribute Models/AttributeSetModel/AttributeSetModel.dart';
import '../Model/Attribute Models/AttributeValueModel/AttributeValue.dart';
import '../Repository/attributeSetRepositry.dart';
import '../Screen/AddProduct/Add_Product.dart';
import '../Screen/EditProduct/EditProduct.dart';

class AttributeProvider extends ChangeNotifier {
  String errorMessage = '';

  Future<bool> setAttributeSet(bool fromAddProduct) async {
    try {
      var result = await AttributeRepository.setAttributeset();
      bool error = result['error'];
      errorMessage = result['message'];
      if (!error) {
        var data = result['data'];
        if (fromAddProduct) {
          addProvider!.attributeSetList = (data as List)
              .map(
                (data) => AttributeSetModel.fromJson(data),
              )
              .toList();
        } else {
          editProvider!.attributeSetList = (data as List)
              .map(
                (data) => AttributeSetModel.fromJson(data),
              )
              .toList();
        }
      }
      return error;
    } catch (e) {
      errorMessage = e.toString();
      return true;
    }
  }

  Future<bool> setAttributes(bool fromAddProduct) async {
    try {
      var result = await AttributeRepository.attributeset();
      bool error = result['error'];
      errorMessage = result['message'];
      if (!error) {
        var data = result['data'];
        if (fromAddProduct) {
          addProvider!.attributesList = (data as List)
              .map(
                (data) => AttributeModel.fromJson(data),
              )
              .toList();
          for (var element in addProvider!.attributesList) {
            addProvider!.selectedAttributeValues[element.id!] = [];
          }
        } else {
          editProvider!.attributesList = (data as List)
              .map(
                (data) => AttributeModel.fromJson(data),
              )
              .toList();
          for (var element in editProvider!.attributesList) {
            editProvider!.selectedAttributeValues[element.id!] = [];
          }
        }
      }
      return error;
    } catch (e) {
      errorMessage = e.toString();
      return true;
    }
  }

  Future<bool> setAttributesValue(bool fromAddProduct) async {
    try {
      var result = await AttributeRepository.attributeValue();
      bool error = result['error'];
      errorMessage = result['message'];
      if (!error) {
        var data = result['data'];
        if (fromAddProduct) {
          addProvider!.attributesValueList = (data as List)
              .map(
                (data) => AttributeValueModel.fromJson(data),
              )
              .toList();
          for (var element in addProvider!.attributesList) {
            addProvider!.selectedAttributeValues[element.id!] = [];
          }
        } else {
          editProvider!.attributesValueList = (data as List)
              .map(
                (data) => AttributeValueModel.fromJson(data),
              )
              .toList();
        }
      }
      return error;
    } catch (e) {
      errorMessage = e.toString();
      return true;
    }
  }
}
