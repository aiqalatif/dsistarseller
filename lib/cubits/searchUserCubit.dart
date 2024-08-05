import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sellermultivendor/Model/searchedUser.dart';
import 'package:sellermultivendor/Repository/userRepository.dart';

abstract class SearchUserState {}

class SearchUserInitial extends SearchUserState {}

class SearchUserInProgress extends SearchUserState {}

class SearchUserSuccess extends SearchUserState {
  final List<SearchedUser> users;

  SearchUserSuccess({required this.users});
}

class SearchUserFailure extends SearchUserState {
  final String errorMessage;

  SearchUserFailure(this.errorMessage);
}

class SearchUserCubit extends Cubit<SearchUserState> {
  final UserRepository _userRepository;

  SearchUserCubit(this._userRepository) : super(SearchUserInitial());

  void searchUser(
      {required String search, required String currentUserId}) async {
    emit(SearchUserInProgress());
    try {
      final result = await _userRepository.searchUser(search: search);
      result.removeWhere((user) => user.id == currentUserId);
      emit(SearchUserSuccess(users: result));
    } catch (e) {
      emit(SearchUserFailure(e.toString()));
    }
  }
}
