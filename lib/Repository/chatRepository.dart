import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:sellermultivendor/Model/groupDetails.dart';
import 'package:sellermultivendor/Model/message.dart';
import 'package:sellermultivendor/Model/personalChatHistory.dart';
import 'package:sellermultivendor/Widget/api.dart';

import 'package:sellermultivendor/Widget/security.dart';

import '../Helper/ApiBaseHelper.dart';

class ChatRepository {
  Future<List<PersonalChatHistory>> getConversationList({
    required Map<String, dynamic> parameter,
  }) async {
    try {
      var result =
          await ApiBaseHelper().postAPICall(getPersonalChatListApi, parameter);

      if (result['error']) {
        throw ApiException(
            result['error_msg'] ?? 'Failed to load conversations');
      }

      return ((result['data'] ?? []) as List)
          .map((personalChat) =>
              PersonalChatHistory.fromJson(Map.from(personalChat ?? {})))
          .toList();
    } on FetchDataException catch (e) {
      if (e.toString() ==
          "Error During Communication: No Internet connection") {
        throw ApiException('No Internet connection');
      }
      throw e.toString();
    } on Exception catch (e) {
      throw ApiException(e.toString());
    }
  }

  static Future<void> readMessages(
      {required bool isGroup,
      required String fromId,
      required String userId}) async {
    try {
      await ApiBaseHelper().postAPICall(readMessagesApi, {
        'type': isGroup ? 'group' : 'person',
        'from_id': fromId,
        // 'user_id': userId
      });
    } on FetchDataException catch (e) {
      if (e.toString() ==
          "Error During Communication: No Internet connection") {
        throw ApiException('No Internet connection');
      }
      throw e.toString();
    } on Exception catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      throw ApiException(e.toString());
    }
  }

  Future<Map<String, dynamic>> getConversation({
    required Map<String, dynamic> parameter,
  }) async {
    try {
      final result =
          await ApiBaseHelper().postAPICall(getConversationApi, parameter);

      if (result['error']) {
        throw ApiException(result['error_msg'] ?? 'Failed to load messages');
      }

      return {
        'total': int.parse((result['data']['total_msg'] ?? '0').toString()),
        'messages': ((result['data']['msg'] ?? []) as List)
            .map((message) => Message.fromJson(Map.from(message ?? {})))
            .toList()
      };
    } on FetchDataException catch (e) {
      if (e.toString() ==
          "Error During Communication: No Internet connection") {
        throw ApiException('No Internet connection');
      }
      throw e.toString();
    } on Exception catch (e) {
      throw ApiException(e.toString());
    }
  }

  Future<Message> sendMessage({
    required Map<String, dynamic> parameter,
  }) async {
    try {
      if (kDebugMode) {
        print("Message parameter : $parameter");
      }
      final result = await Dio().post(sendMessageApi,
          options: Options(headers: headers),
          data: FormData.fromMap(parameter, ListFormat.multiCompatible));
      if (result.data['error']) {
        throw ApiException('Failed to send message');
      }

      return Message.fromJson(
          Map.from((result.data['new_msg'] as List).first ?? {}));
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionError) {
        throw ApiException('No Internet connection');
      }

      throw ApiException('Failed to send message');
    } on Exception catch (e) {
      throw ApiException(e.toString());
    }
  }

  Future<List<GroupDetails>> getGroupConversationList(
      {required String userId}) async {
    try {
      final result = await ApiBaseHelper()
          .postAPICall(getGroupChatListApi, {"user_id": userId});

      if (result['error']) {
        throw ApiException(result['message'].toString());
      }

      return ((result['data'] ?? []) as List)
          .map((groupDetails) =>
              GroupDetails.fromJson(Map.from(groupDetails ?? {})))
          .toList();
    } on FetchDataException catch (e) {
      if (e.toString() ==
          "Error During Communication: No Internet connection") {
        throw ApiException('No Internet connection');
      }
      throw e.toString();
    } catch (e) {
      throw ApiException(e.toString());
    }
  }

  Future<void> createGroup(
      {required String title,
      required String description,
      required String userIds,
      required String currentUserId}) async {
    try {
      await ApiBaseHelper().postAPICall(createGroupApi, {
        "title": title,
        'description': description,
        "user_id": currentUserId,
        "user_ids": userIds
      });
    } on FetchDataException catch (e) {
      if (e.toString() ==
          "Error During Communication: No Internet connection") {
        throw ApiException('No Internet connection');
      }
      throw e.toString();
    } catch (e) {
      throw ApiException(e.toString());
    }
  }

  Future<GroupDetails> editGroup(
      {required String title,
      required String groupId,
      required String description,
      required String userIds,
      required String currentUserId}) async {
    try {
      final result = await ApiBaseHelper().postAPICall(editGroupApi, {
        "title": title,
        'description': description,
        "user_id": currentUserId,
        "user_ids": userIds,
        "group_id": groupId
      });
      if (result['error']) {
        throw ApiException(result['message'].toString());
      }
      return GroupDetails.fromJson(
          Map.from((result['data'] as List).first ?? {}));
    } on FetchDataException catch (e) {
      if (e.toString() ==
          "Error During Communication: No Internet connection") {
        throw ApiException('No Internet connection');
      }
      throw e.toString();
    } catch (e) {
      throw ApiException(e.toString());
    }
  }

  Future<void> deleteGroup(
      {required String groupId, required String currentUserId}) async {
    try {
      final result = await ApiBaseHelper().postAPICall(
          deleteGroupApi, {"user_id": currentUserId, "group_id": groupId});
      if (result['error']) {
        throw ApiException(result['message'].toString());
      }
    } on FetchDataException catch (e) {
      if (e.toString() ==
          "Error During Communication: No Internet connection") {
        throw ApiException('No Internet connection');
      }
      throw e.toString();
    } catch (e) {
      throw ApiException(e.toString());
    }
  }
}
