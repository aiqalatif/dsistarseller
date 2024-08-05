import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sellermultivendor/Helper/Constant.dart';
import 'package:sellermultivendor/Model/message.dart';
import 'package:sellermultivendor/Repository/chatRepository.dart';

abstract class ConversationState {}

class ConversationInitial extends ConversationState {}

class ConversationFetchInProgress extends ConversationState {}

class ConversationFetchSuccess extends ConversationState {
  final int total;
  final List<Message> messages;
  final bool fetchMoreError;
  final bool fetchMoreInProgress;

  ConversationFetchSuccess(
      {required this.messages,
      required this.fetchMoreError,
      required this.fetchMoreInProgress,
      required this.total});

  ConversationFetchSuccess copyWith(
      {bool? fetchMoreError,
      bool? fetchMoreInProgress,
      int? total,
      List<Message>? messages}) {
    return ConversationFetchSuccess(
      total: total ?? this.total,
      messages: messages ?? this.messages,
      fetchMoreError: fetchMoreError ?? this.fetchMoreError,
      fetchMoreInProgress: fetchMoreInProgress ?? this.fetchMoreInProgress,
    );
  }
}

class ConversationFetchFailure extends ConversationState {
  final String errorMessage;

  ConversationFetchFailure(this.errorMessage);
}

class ConversationCubit extends Cubit<ConversationState> {
  final ChatRepository _chatRepository;

  ConversationCubit(this._chatRepository) : super(ConversationInitial());

  void fetchConversation(
      {required bool isGroup,
      required String fromUserId,
      required String currentUserId}) async {
    emit(ConversationFetchInProgress());
    try {
      final result = await _chatRepository.getConversation(parameter: {
        'type': isGroup ? 'group' : 'person',
        'to_id': currentUserId,
        'from_id': fromUserId,
        'limit': messagesLoadLimit
      });

      emit(ConversationFetchSuccess(
          messages: List.from(result['messages']),
          fetchMoreError: false,
          fetchMoreInProgress: false,
          total: result['total'] as int));
    } catch (e) {
      emit(ConversationFetchFailure(e.toString()));
    }
  }

  bool hasMore() {
    if (state is ConversationFetchSuccess) {
      return (state as ConversationFetchSuccess).messages.length <
          (state as ConversationFetchSuccess).total;
    }
    return false;
  }

  void fetchMore(
      {required bool isGroup,
      required String fromUserId,
      required String currentUserId}) async {
    //
    if (state is ConversationFetchSuccess) {
      if ((state as ConversationFetchSuccess).fetchMoreInProgress) {
        return;
      }
      try {
        emit((state as ConversationFetchSuccess)
            .copyWith(fetchMoreInProgress: true));

        final moreMessages = await _chatRepository.getConversation(parameter: {
          'type': isGroup ? 'group' : 'person',
          'to_id': currentUserId,
          'from_id': fromUserId,
          'limit': messagesLoadLimit,
          'offset':
              (state as ConversationFetchSuccess).messages.length.toString()
        });

        final currentState = (state as ConversationFetchSuccess);
        List<Message> messages = currentState.messages;
        for (var message in moreMessages['messages'] as List<Message>) {
          if (messages.indexWhere((element) => element.id == message.id) ==
              -1) {
            messages.add(message);
          }
        }

        emit(ConversationFetchSuccess(
          fetchMoreError: false,
          fetchMoreInProgress: false,
          total: moreMessages['total'] as int,
          messages: messages,
        ));
      } catch (e) {
        emit((state as ConversationFetchSuccess)
            .copyWith(fetchMoreInProgress: false, fetchMoreError: true));
      }
    }
  }

  List<Message> getMessages() {
    if (state is ConversationFetchSuccess) {
      List<Message> chatMessages = (state as ConversationFetchSuccess).messages;
      chatMessages.sort((a, b) => DateTime.parse(b.dateCreated!)
          .compareTo(DateTime.parse(a.dateCreated!)));

      return chatMessages;
    }
    return [];
  }

  List<String> getMessageDates() {
    if (state is ConversationFetchSuccess) {
      List<String> dates = getMessages()
          .map((e) =>
              formatDateYYMMDD(dateTime: DateTime.parse(e.dateCreated ?? '')))
          .toList();

      dates = dates.toSet().toList();

      return dates;
    }
    return [];
  }

  List<Message> getMessagesByDate({required String dateTime}) {
    if (state is ConversationFetchSuccess) {
      List<Message> messages = getMessages()
          .where((element) => isSameDay(
              dateTime: DateTime.parse(element.dateCreated!),
              takeCurrentDate: false,
              givenDate: DateTime.parse(dateTime)))
          .toList();

      return messages.reversed.toList();
    }
    return [];
  }

  void addMessage({required Message message}) {
    if (state is ConversationFetchSuccess) {
      List<Message> messages = (state as ConversationFetchSuccess).messages;

      messages.insert(0, message);
      emit((state as ConversationFetchSuccess).copyWith(messages: messages));
    }
  }
}
