import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sellermultivendor/Model/groupDetails.dart';
import 'package:sellermultivendor/Repository/chatRepository.dart';

abstract class EditGroupState {}

class EditGroupInitial extends EditGroupState {}

class EditGroupInProgress extends EditGroupState {}

class EditGroupSuccess extends EditGroupState {
  final GroupDetails groupDetails;

  EditGroupSuccess({required this.groupDetails});
}

class EditGroupFailure extends EditGroupState {
  final String errorMessage;

  EditGroupFailure(this.errorMessage);
}

class EditGroupCubit extends Cubit<EditGroupState> {
  final ChatRepository _chatRepository;

  EditGroupCubit(this._chatRepository) : super(EditGroupInitial());

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

      emit(EditGroupInProgress());
      final editGroupDetails = await _chatRepository.editGroup(
        groupId: groupId,
        description: description,
        title: title,
        userIds: ids,
        currentUserId: currentUserId,
      );
      emit(EditGroupSuccess(groupDetails: editGroupDetails));
    } catch (e) {
      emit(EditGroupFailure(e.toString()));
    }
  }
}
