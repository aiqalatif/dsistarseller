import '../Helper/ApiBaseHelper.dart';
import '../Widget/api.dart';

class PickUpLocationRepository {
  // for add faqs.
  static Future<Map<String, dynamic>> getPickUpLocation({
    required Map<String, dynamic> parameter,
  }) async {
    try {
      var detail =
          await ApiBaseHelper().postAPICall(getPickUpLocationApi, parameter);
      print("details pickup****$detail");

      return detail;
    } on Exception {
      throw ApiException('Something went wrong');
    }
  }
}
