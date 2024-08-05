import '../Helper/ApiBaseHelper.dart';
import '../Widget/api.dart';

class CategoryRepository {
  static Future<Map<String, dynamic>> setCategory({
    required Map<dynamic, dynamic> parameter,
  }) async {
    try {
     
      var taxDetail =
          await ApiBaseHelper().postAPICall(getCategoriesApi, parameter);

      return taxDetail;
    } on Exception {
      throw ApiException('Something went wrong');
    }
  }
}
