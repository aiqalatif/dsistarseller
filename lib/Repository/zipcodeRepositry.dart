import '../Helper/ApiBaseHelper.dart';
import '../Widget/api.dart';

class ZipcodeRepository {
  // for add faqs.
  static Future<Map<String, dynamic>> setZipCode(
      {required int offset, required int limit, String? search}) async {
    try {
      var parameter = {
        "offset": offset.toString(),
        "limit": limit.toString(),
        if (search != null && search.trim().isNotEmpty) "search": search
      };
      var zipCodeDetail =
          await ApiBaseHelper().postAPICall(getZipcodesApi, parameter);

      return zipCodeDetail;
    } on Exception {
      throw ApiException('Something went wrong');
    }
  }
}
