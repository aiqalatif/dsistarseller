import 'package:sellermultivendor/Helper/ApiBaseHelper.dart';
import 'package:sellermultivendor/Model/searchedUser.dart';
import 'package:sellermultivendor/Widget/api.dart';

class UserRepository {
  Future<List<SearchedUser>> searchUser({required String search}) async {
    try {
      final result =
          await ApiBaseHelper().postAPICall(searchUserApi, {'search': search});
      if (result['error']) {
        throw ApiException(result['message']);
      }
      return ((result['data'] ?? []) as List)
          .map((searchedUser) =>
              SearchedUser.fromJson(Map.from(searchedUser ?? {})))
          .toList();
    } catch (e) {
      throw ApiException(e.toString());
    }
  }
}
