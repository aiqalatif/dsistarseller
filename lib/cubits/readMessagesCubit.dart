import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sellermultivendor/Repository/chatRepository.dart';

abstract class ReadMessagesState {}

class ReadMessagesInitial extends ReadMessagesState {}

class ReadMessagesInProgress extends ReadMessagesState {}

class ReadMessagesSuccess extends ReadMessagesState {}

class ReadMessagesFailure extends ReadMessagesState {
  final String errorMessage;

  ReadMessagesFailure(this.errorMessage);
}

class ReadMessagesCubit extends Cubit<ReadMessagesState> {
  ReadMessagesCubit() : super(ReadMessagesInitial());

  void readMessages(
      {required bool isGroup,
      required String fromUserId,
      required String currentUserId}) async {
    emit(ReadMessagesInProgress());
    try {
      await ChatRepository.readMessages(
          fromId: fromUserId, isGroup: isGroup, userId: currentUserId);

      emit(ReadMessagesSuccess());
    } catch (e) {
      emit(ReadMessagesFailure(e.toString()));
    }
  }
}
