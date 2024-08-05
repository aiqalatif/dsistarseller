import 'dart:core';
import '../Helper/ApiBaseHelper.dart';
import '../Model/getWithdrawelRequest/getWithdrawelmodel.dart';
import '../Widget/api.dart';

class WithDrawelRepository {
  ///This method is used to getTransactionsOfUSer
  static Future<Map<String, dynamic>> fetchUserWithDrawelReq({
    required Map<String, dynamic> parameter,
  }) async {
    try {
      var transactionsList =
          await ApiBaseHelper().postAPICall(getWithDrawalRequestApi, parameter);

      return {
        'totalTransactions': transactionsList['total'].toString(),
        'transactionsList': (transactionsList['data'] as List)
            .map((transactionsData) =>
                (GetWithdrawelReq.fromJson(transactionsData)))
            .toList()
      };
    } on Exception {
      throw ApiException('Something went wrong');
    }
  }
}
