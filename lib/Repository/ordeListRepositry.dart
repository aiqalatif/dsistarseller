import '../Helper/ApiBaseHelper.dart';
import '../Widget/api.dart';

class OrderListRepository {

  static Future<Map<String, dynamic>> getOrders(
    {
    var parameter,
  }
  ) async {
    try {
     var taxDetail =
          await ApiBaseHelper().postAPICall(getOrdersApi, parameter);

      return taxDetail;
    } on Exception {
      throw ApiException('Something went wrong');
    }
  }
}
