import '../Helper/ApiBaseHelper.dart';
import '../Widget/api.dart';

class ProductListRepository {
  static Future<Map<String, dynamic>> setStockStatus({
    var parameter,
  }) async {
    try {
      var response =
          await ApiBaseHelper().postAPICall(manageStockApi, parameter);

      return response;
    } on Exception {
      throw ApiException('Something went wrong');
    }
  }

  static Future<Map<String, dynamic>> getProduct({
    var parameter,
  }) async {
    try {
      var taxDetail =
          await ApiBaseHelper().postAPICall(getProductsApi, parameter);

      return taxDetail;
    } on Exception {
      throw ApiException('Something went wrong');
    }
  }

  static Future<Map<String, dynamic>> updateProductStatus({
    var parameter,
  }) async {
    try {
      var taxDetail =
          await ApiBaseHelper().postAPICall(updateProductStatusAPI, parameter);

      return taxDetail;
    } on Exception {
      throw ApiException('Something went wrong');
    }
  }

  static Future<Map<String, dynamic>> deleteProductApi({
    var parameter,
  }) async {
    try {
      var taxDetail =
          await ApiBaseHelper().postAPICall(getDeleteProductApi, parameter);

      return taxDetail;
    } on Exception {
      throw ApiException('Something went wrong');
    }
  }
}
