import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:sellermultivendor/Model/message.dart';
import 'package:sellermultivendor/Repository/chatRepository.dart';

abstract class SendMessageState {}

class SendMessageInitial extends SendMessageState {}

class SendMessageInProgress extends SendMessageState {}

class SendMessageSuccess extends SendMessageState {
  final Message message;

  SendMessageSuccess({required this.message});
}

class SendMessageFailure extends SendMessageState {
  final String errorMessage;

  SendMessageFailure(this.errorMessage);
}

class SendMessageCubit extends Cubit<SendMessageState> {
  final ChatRepository _chatRepository;

  SendMessageCubit(this._chatRepository) : super(SendMessageInitial());

  void sendMessage(
      {required bool isGroup,
      required String toUserId,
      required String currentUserId,
      required String message,
      required List<String> filePaths}) async {
    List<MultipartFile> files = [];
    for (var filePath in filePaths) {
      files.add(await MultipartFile.fromFile(filePath));
    }
    emit(SendMessageInProgress());
    try {
      emit(SendMessageSuccess(
          message: await _chatRepository.sendMessage(parameter: {
        'type': isGroup ? 'group' : 'person',
        // 'from_id': currentUserId,
        'to_id': toUserId,
        'message': message,
        'documents': files
      })));
      //send another text message if it has file attachment
      if (files.isNotEmpty && message.trim().isNotEmpty) {
        emit(SendMessageInProgress());
        emit(SendMessageSuccess(
            message: await _chatRepository.sendMessage(parameter: {
          'type': isGroup ? 'group' : 'person',
          // 'from_id': currentUserId,
          'to_id': toUserId,
          'message': message,
        })));
      }
    } catch (e) {
      emit(SendMessageFailure(e.toString()));
    }
  }
}
