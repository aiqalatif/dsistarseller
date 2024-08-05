import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sellermultivendor/Repository/chatRepository.dart';

abstract class CreateGroupState {}

class CreateGroupInitial extends CreateGroupState {}

class CreateGroupInProgress extends CreateGroupState {}

class CreateGroupSuccess extends CreateGroupState {}

class CreateGroupFailure extends CreateGroupState {
  final String errorMessage;

  CreateGroupFailure(this.errorMessage);
}

class CreateGroupCubit extends Cubit<CreateGroupState> {
  final ChatRepository _chatRepository;

  CreateGroupCubit(this._chatRepository) : super(CreateGroupInitial());

  void createGroup(
      {required String title,
      required String description,
      required List<String> userIds,
      required String currentUserId}) async {
    try {
      String ids = userIds.first;
      for (var i = 1; i < ids.length; i++) {
        ids = "${userIds[i]},$ids";
      }

      emit(CreateGroupInProgress());
      await _chatRepository.createGroup(
        description: description,
        title: title,
        userIds: ids,
        currentUserId: currentUserId,
      );
      emit(CreateGroupSuccess());
    } catch (e) {
      emit(CreateGroupFailure(e.toString()));
    }
  }
}
