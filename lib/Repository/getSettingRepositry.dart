import '../Helper/ApiBaseHelper.dart';
import '../Widget/api.dart';

class SystemRepository {
  //
  //This method is used to fetch System policies {e.g. Privacy Policy, T&C etc..}
  static Future<Map<String, dynamic>> fetchSystemPolicies(
      {required String policyType}) async {
    try {
      var parameter = {};
      var policy = await ApiBaseHelper().postAPICall(getSettingsApi, parameter);

      return {'policy': policy['data']};
    } on Exception {
      throw ApiException('Something went wrong');
    }
  }

  static Future<Map<String, dynamic>> fetchSystemSettings() async {
    try {
      var settings = await ApiBaseHelper().postAPICall(getSettingsApi, {});
      return settings['data'];
    } on Exception catch (_) {
      throw ApiException('Something went wrong');
    }
  }
}
