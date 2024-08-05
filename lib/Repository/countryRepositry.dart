
import '../Helper/ApiBaseHelper.dart';
import '../Widget/api.dart';

class CountryRepository {
  // for add faqs.
  static Future<Map<String, dynamic>> setCountry({
    required Map<String, dynamic> parameter,
  }) async {
    try {
      var loginDetail =
          await ApiBaseHelper().postAPICall(getCountriesDataApi, parameter);

      return loginDetail;
    } on Exception {
      throw ApiException('Something went wrong');
    }
  }
}