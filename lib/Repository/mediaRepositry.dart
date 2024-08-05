import '../Helper/ApiBaseHelper.dart';
import '../Widget/api.dart';

class MediaRepository {
  // for add faqs.
  static Future<Map<String, dynamic>> getMedia(
    {
    var parameter,
  }
  ) async {
    try {
     var taxDetail =
          await ApiBaseHelper().postAPICall(getMediaApi, parameter);

      return taxDetail;
    } on Exception {
      throw ApiException('Something went wrong');
    }
  }
}
