import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sellermultivendor/Model/personalChatHistory.dart';
import 'package:sellermultivendor/Model/searchedUser.dart';
import 'package:sellermultivendor/Provider/settingProvider.dart';
import 'package:sellermultivendor/Widget/errorContainer.dart';
import 'package:sellermultivendor/Widget/routes.dart';
import 'package:sellermultivendor/Widget/validation.dart';
import 'package:sellermultivendor/cubits/searchUserCubit.dart';

enum SearchFor { conversation, groupCreation }

class SearchUsersScreen extends StatefulWidget {
  final SearchFor searchFor;
  final List<SearchedUser>? searchedUser;
  const SearchUsersScreen(
      {Key? key, required this.searchFor, this.searchedUser})
      : super(key: key);

  @override
  State<SearchUsersScreen> createState() => _SearchUsersScreenState();
}

class _SearchUsersScreenState extends State<SearchUsersScreen> {
  late final List<SearchedUser> _usersAddedForGroupCreation =
      widget.searchedUser ?? List.from([]);

  late final TextEditingController searchQueryTextEditingController =
      TextEditingController()..addListener(searchQueryTextControllerListener);

  Timer? waitForNextSearchRequestTimer;

  int waitForNextRequestSearchQueryTimeInMilliSeconds = 500;

  void navigateToPreviousScreen() {
    if (widget.searchFor == SearchFor.groupCreation) {
      Navigator.of(context).pop({"users": _usersAddedForGroupCreation});
    } else {
      Navigator.of(context).pop();
    }
  }

  void searchQueryTextControllerListener() {
    waitForNextSearchRequestTimer?.cancel();
    setWaitForNextSearchRequestTimer();
  }

  void setWaitForNextSearchRequestTimer() {
    if (waitForNextRequestSearchQueryTimeInMilliSeconds != 400) {
      waitForNextRequestSearchQueryTimeInMilliSeconds = 400;
    }
    waitForNextSearchRequestTimer =
        Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (waitForNextRequestSearchQueryTimeInMilliSeconds == 0) {
        timer.cancel();
        if (searchQueryTextEditingController.text.trim().isNotEmpty) {
          context.read<SearchUserCubit>().searchUser(
                currentUserId:
                    context.read<SettingProvider>().CUR_USERID ?? '0',
                search: searchQueryTextEditingController.text.trim(),
              );
        }
      } else {
        waitForNextRequestSearchQueryTimeInMilliSeconds =
            waitForNextRequestSearchQueryTimeInMilliSeconds - 100;
      }
    });
  }

  @override
  void dispose() {
    waitForNextSearchRequestTimer?.cancel();
    searchQueryTextEditingController
        .removeListener(searchQueryTextControllerListener);
    searchQueryTextEditingController.dispose();
    super.dispose();
  }

  Widget _buildSearchTextField() {
    return TextField(
      controller: searchQueryTextEditingController,
      autofocus: true,
      cursorColor: Theme.of(context).colorScheme.primary,
      style: TextStyle(color: Theme.of(context).colorScheme.secondary),
      decoration: InputDecoration(
        hintStyle: TextStyle(color: Theme.of(context).colorScheme.background),
        border: InputBorder.none,
        hintText: getTranslated(context, "SEARCH_USER") ?? "SEARCH_USER",
      ),
    );
  }

  Widget _buildSearchTextContainer() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Text(
          getTranslated(context, "SEARCH_USER") ?? "SEARCH_USER",
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 16.0,
          ),
        ),
      ),
    );
  }

  //This will be use if searchFor.groupCreation
  Widget _buildIsUserSelectedContainer({required SearchedUser searchedUser}) {
    final userAdded = _usersAddedForGroupCreation
            .indexWhere((element) => element.id == searchedUser.id) !=
        -1;

    return GestureDetector(
      onTap: () {
        if (userAdded) {
          _usersAddedForGroupCreation
              .removeWhere((element) => element.id == searchedUser.id);
        } else {
          _usersAddedForGroupCreation.add(searchedUser);
        }
        setState(() {});
      },
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
            border: Border.all(color: Theme.of(context).colorScheme.primary)),
        child: userAdded
            ? Center(
                child: Icon(
                  Icons.check,
                  color: Theme.of(context).colorScheme.primary,
                ),
              )
            : const SizedBox(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) {
          return;
        }
        navigateToPreviousScreen();
      },
      child: Scaffold(
          appBar: AppBar(
            actions: [
              IconButton(
                  iconSize: 26,
                  color: Theme.of(context).colorScheme.secondary,
                  onPressed: () {
                    searchQueryTextEditingController.clear();
                    setState(() {});
                  },
                  icon: const Icon(Icons.clear))
            ],
            title: _buildSearchTextField(),
            elevation: 0.5,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            leading: IconButton(
              onPressed: () {
                navigateToPreviousScreen();
              },
              icon: const Icon(Icons.arrow_back_ios),
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
          body: BlocBuilder<SearchUserCubit, SearchUserState>(
            builder: (context, state) {
              if (state is SearchUserSuccess) {
                if (searchQueryTextEditingController.text.trim().isEmpty) {
                  return _buildSearchTextContainer();
                }
                return ListView.builder(
                    itemCount: state.users.length,
                    itemBuilder: (context, index) {
                      final user = state.users[index];
                      return ListTile(
                        leading: (user.image ?? '').isEmpty
                            ? const Icon(Icons.person)
                            : SizedBox(
                                height: 25,
                                width: 25,
                                child: Image.network(user.image!)),
                        onTap: () {
                          if (widget.searchFor == SearchFor.conversation) {
                            Navigator.of(context).pop();
                            Routes.navigateToConversationScreen(
                                context: context,
                                personalChatHistory: PersonalChatHistory(
                                    id: user.id,
                                    unreadMsg: '0',
                                    opponentUserId: user.id,
                                    opponentUsername: user.username,
                                    image: user.image),
                                isGroup: false);
                          }
                        },
                        title: Text(user.username ?? ''),
                        trailing: widget.searchFor == SearchFor.groupCreation
                            ? _buildIsUserSelectedContainer(searchedUser: user)
                            : const SizedBox(),
                      );
                    });
              }

              if (state is SearchUserFailure) {
                return Center(
                  child: ErrorContainer(
                    errorMessage: state.errorMessage,
                    onTapRetry: () {
                      context.read<SearchUserCubit>().searchUser(
                          currentUserId:
                              context.read<SettingProvider>().CUR_USERID ?? '0',
                          search: searchQueryTextEditingController.text.trim());
                    },
                  ),
                );
              }

              if (state is SearchUserInitial) {
                return _buildSearchTextContainer();
              }

              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          )),
    );
  }
}
