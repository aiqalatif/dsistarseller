import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sellermultivendor/Model/groupDetails.dart';
import 'package:sellermultivendor/Repository/chatRepository.dart';

abstract class GroupConversationsState {}

class GroupConversationsInitial extends GroupConversationsState {}

class GroupConversationsFetchInProgress extends GroupConversationsState {}

class GroupConversationsFetchSuccess extends GroupConversationsState {
  final List<GroupDetails> groupConversations;

  GroupConversationsFetchSuccess({required this.groupConversations});
}

class GroupConversationsFetchFailure extends GroupConversationsState {
  final String errorMessage;

  GroupConversationsFetchFailure(this.errorMessage);
}

class GroupConversationsCubit extends Cubit<GroupConversationsState> {
  final ChatRepository _chatRepository;

  GroupConversationsCubit(this._chatRepository)
      : super(GroupConversationsInitial());

  void fetchGroupConversations({required String userId}) async {
    try {
      emit(GroupConversationsFetchInProgress());

      emit(GroupConversationsFetchSuccess(
          groupConversations:
              await _chatRepository.getGroupConversationList(userId: userId)));
    } catch (e) {
      emit(GroupConversationsFetchFailure(e.toString()));
    }
  }

  void markMessagesReadOfGivenGroup({required String? groupId}) {
    if (state is GroupConversationsFetchSuccess) {
      List<GroupDetails> groupConversations =
          (state as GroupConversationsFetchSuccess).groupConversations;
      final index =
          groupConversations.indexWhere((group) => group.groupId == groupId);
      if (index != -1) {
        groupConversations[index] =
            groupConversations[index].copyWith(isRead: '0');
        emit(GroupConversationsFetchSuccess(
            groupConversations: groupConversations));
      }
    }
  }

  void markNewMessageArrivedInGroup({required String? groupId}) {
    if (state is GroupConversationsFetchSuccess) {
      List<GroupDetails> groupConversations =
          (state as GroupConversationsFetchSuccess).groupConversations;
      final index =
          groupConversations.indexWhere((group) => group.groupId == groupId);
      if (index != -1) {
        groupConversations[index] =
            groupConversations[index].copyWith(isRead: '1');
        emit(GroupConversationsFetchSuccess(
            groupConversations: groupConversations));
      }
    }
  }

  void updateGroupConvertation({required GroupDetails groupDetails}) {
    if (state is GroupConversationsFetchSuccess) {
      List<GroupDetails> groupConversations =
          (state as GroupConversationsFetchSuccess).groupConversations;
      final index = groupConversations
          .indexWhere((group) => group.groupId == groupDetails.groupId);
      if (index != -1) {
        groupConversations[index] = groupDetails;
        emit(GroupConversationsFetchSuccess(
            groupConversations: groupConversations));
      }
    }
  }

  void removeGroupConvertation({required String groupId}) {
    if (state is GroupConversationsFetchSuccess) {
      List<GroupDetails> groupConversations =
          (state as GroupConversationsFetchSuccess).groupConversations;
      groupConversations.removeWhere((group) => group.groupId == groupId);
      emit(GroupConversationsFetchSuccess(
          groupConversations: groupConversations));
    }
  }
}
