
import '../Helper/ApiBaseHelper.dart';
import '../Widget/api.dart';

class SearchRepository {

  static Future<Map<String, dynamic>> getProducts({
    required Map<String, dynamic> parameter,
  }) async {
    try {
      var loginDetail =
          await ApiBaseHelper().postAPICall(getProductsApi, parameter);

      return loginDetail;
    } on Exception {
      throw ApiException('Something went wrong');
    }
  }
}