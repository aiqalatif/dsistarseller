import '../Helper/ApiBaseHelper.dart';
import '../Widget/api.dart';

class CityListRepository {
  static Future<Map<String, dynamic>> getCities({
    required Map<String, dynamic> parameter,
  }) async {
    try {
      return await ApiBaseHelper().postAPICall(getCitiesApi, parameter);
    } on Exception catch (e) {
      throw ApiException(e.toString());
    }
  }
}
