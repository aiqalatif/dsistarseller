import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sellermultivendor/Model/groupDetails.dart';
import 'package:sellermultivendor/Repository/chatRepository.dart';

abstract class RemoveGroupMemberState {}

class RemoveGroupMemberInitial extends RemoveGroupMemberState {}

class RemoveGroupMemberInProgress extends RemoveGroupMemberState {}

class RemoveGroupMemberSuccess extends RemoveGroupMemberState {
  final GroupDetails groupDetails;

  RemoveGroupMemberSuccess({required this.groupDetails});
}

class RemoveGroupMemberFailure extends RemoveGroupMemberState {
  final String errorMessage;

  RemoveGroupMemberFailure(this.errorMessage);
}

class RemoveGroupMemberCubit extends Cubit<RemoveGroupMemberState> {
  final ChatRepository _chatRepository;

  RemoveGroupMemberCubit(this._chatRepository)
      : super(RemoveGroupMemberInitial());

  void editGroup(
      {required String title,
      required String groupId,
      required String description,
      required List<String> userIds,
      required String currentUserId}) async {
    try {
      String ids = userIds.first;
      for (var i = 1; i < userIds.length; i++) {
        ids = "${userIds[i]},$ids";
      }

      emit(RemoveGroupMemberInProgress());
      final editGroupDetails = await _chatRepository.editGroup(
        groupId: groupId,
        description: description,
        title: title,
        userIds: ids,
        currentUserId: currentUserId,
      );
      emit(RemoveGroupMemberSuccess(groupDetails: editGroupDetails));
    } catch (e) {
      emit(RemoveGroupMemberFailure(e.toString()));
    }
  }
}
