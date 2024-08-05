import '../Helper/ApiBaseHelper.dart';
import '../Widget/api.dart';

class FaQsRepository {
  static Future<Map<String, dynamic>> getFaqs({
    var parameter,
  }) async {
    try {
      var taxDetail =
          await ApiBaseHelper().postAPICall(getProductFaqsApi, parameter);

      return taxDetail;
    } on Exception {
      throw ApiException('Something went wrong');
    }
  }

  static Future<Map<String, dynamic>> addProductFaqs({
    var parameter,
  }) async {
    try {
      var taxDetail =
          await ApiBaseHelper().postAPICall(addProductFaqsApi, parameter);

      return taxDetail;
    } on Exception {
      throw ApiException('Something went wrong');
    }
  }


    static Future<Map<String, dynamic>> deleteTagsAPI({
    var parameter,
  }) async {
    try {
      var taxDetail =
          await ApiBaseHelper().postAPICall(deleteProductFaqApi, parameter);

      return taxDetail;
    } on Exception {
      throw ApiException('Something went wrong');
    }
  }


    static Future<Map<String, dynamic>> editProductFaqAPI({
    var parameter,
  }) async {
    try {
      var taxDetail =
          await ApiBaseHelper().postAPICall(editProductFaqApi, parameter);

      return taxDetail;
    } on Exception {
      throw ApiException('Something went wrong');
    }
  }
}
