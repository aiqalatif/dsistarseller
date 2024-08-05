import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sellermultivendor/Model/personalChatHistory.dart';
import 'package:sellermultivendor/Repository/chatRepository.dart';

abstract class PersonalConverstationsState {}

class PersonalConverstationsInitial extends PersonalConverstationsState {}

class PersonalConverstationsFetchInProgress
    extends PersonalConverstationsState {}

class PersonalConverstationsFetchSuccess extends PersonalConverstationsState {
  final List<PersonalChatHistory> personalConversations;

  PersonalConverstationsFetchSuccess({required this.personalConversations});
}

class PersonalConverstationsFetchFailure extends PersonalConverstationsState {
  final String errorMessage;

  PersonalConverstationsFetchFailure(this.errorMessage);
}

class PersonalConverstationsCubit extends Cubit<PersonalConverstationsState> {
  final ChatRepository _chatRepository;

  PersonalConverstationsCubit(this._chatRepository)
      : super(PersonalConverstationsInitial());

  void fetchConversations({required String currentUserId}) async {
    emit(PersonalConverstationsFetchInProgress());
    try {
      final personalConversations = await _chatRepository
          .getConversationList(parameter: {
            // 'user_id': currentUserId
            });

      emit(PersonalConverstationsFetchSuccess(
          personalConversations: personalConversations));
    } catch (e) {
      emit(PersonalConverstationsFetchFailure(e.toString()));
    }
  }

  void updateUnreadMessageCounter({required String userId}) {
    if (state is PersonalConverstationsFetchSuccess) {
      List<PersonalChatHistory> personalConversations =
          (state as PersonalConverstationsFetchSuccess).personalConversations;
      final index = personalConversations
          .indexWhere((element) => element.opponentUserId == userId);
      if (index != -1) {
        final chatHistory = personalConversations[index];
        personalConversations[index] = chatHistory.copyWith(
            unreadMsg:
                (int.parse(chatHistory.unreadMsg ?? '0') + 1).toString());

        emit(PersonalConverstationsFetchSuccess(
            personalConversations: personalConversations));
      }
    }
  }

  void updatePersonalChatHistory(
      {required PersonalChatHistory personalChatHistory}) {
    if (state is PersonalConverstationsFetchSuccess) {
      List<PersonalChatHistory> personalConversations =
          (state as PersonalConverstationsFetchSuccess).personalConversations;
      final index = personalConversations.indexWhere((element) =>
          element.opponentUserId == personalChatHistory.opponentUserId);
      if (index != -1) {
        personalConversations[index] = personalChatHistory;
        emit(PersonalConverstationsFetchSuccess(
            personalConversations: personalConversations));
      }
    }
  }
}
