import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sellermultivendor/Repository/chatRepository.dart';

abstract class DeleteGroupState {}

class DeleteGroupInitial extends DeleteGroupState {}

class DeleteGroupInProgress extends DeleteGroupState {}

class DeleteGroupSuccess extends DeleteGroupState {}

class DeleteGroupFailure extends DeleteGroupState {
  final String errorMessage;

  DeleteGroupFailure(this.errorMessage);
}

class DeleteGroupCubit extends Cubit<DeleteGroupState> {
  final ChatRepository _chatRepository;

  DeleteGroupCubit(this._chatRepository) : super(DeleteGroupInitial());

  void deleteGroup(
      {required String groupId, required String currentUserId}) async {
    emit(DeleteGroupInProgress());
    try {
      await _chatRepository.deleteGroup(
          groupId: groupId, currentUserId: currentUserId);
      emit(DeleteGroupSuccess());
    } catch (e) {
      emit(DeleteGroupFailure(e.toString()));
    }
  }
}
