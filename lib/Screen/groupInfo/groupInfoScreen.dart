import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sellermultivendor/Helper/Color.dart';
import 'package:sellermultivendor/Helper/Constant.dart';
import 'package:sellermultivendor/Model/groupDetails.dart';
import 'package:sellermultivendor/Model/groupMEmber.dart';
import 'package:sellermultivendor/Model/searchedUser.dart';
import 'package:sellermultivendor/Provider/settingProvider.dart';
import 'package:sellermultivendor/Repository/chatRepository.dart';
import 'package:sellermultivendor/Screen/groupInfo/widgets/deleteGroupDialog.dart';
import 'package:sellermultivendor/Screen/groupInfo/widgets/removeGroupMemberDialog.dart';
import 'package:sellermultivendor/Screen/searchUsersScreen.dart';
import 'package:sellermultivendor/Widget/routes.dart';
import 'package:sellermultivendor/Widget/snackbar.dart';
import 'package:sellermultivendor/Widget/validation.dart';
import 'package:sellermultivendor/cubits/deleteGroupCubit.dart';
import 'package:sellermultivendor/cubits/editGroupCubit.dart';
import 'package:sellermultivendor/cubits/groupConverstationsCubit.dart';
import 'package:sellermultivendor/cubits/removeGroupMemberCubit.dart';

class GroupInfoScreen extends StatefulWidget {
  final GroupDetails groupDetails;
  const GroupInfoScreen({Key? key, required this.groupDetails})
      : super(key: key);

  @override
  State<GroupInfoScreen> createState() => _GroupInfoScreenState();
}

class _GroupInfoScreenState extends State<GroupInfoScreen> {
  late GroupDetails _groupDetails;

  late final TextEditingController _titleTextEditingController =
      TextEditingController();
  late final TextEditingController _descriptionEditinngController =
      TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  List<SearchedUser> _users = [];

  @override
  void initState() {
    super.initState();
    _groupDetails = widget.groupDetails;
    setGroupTitleAndDescription();
  }

  void setGroupTitleAndDescription() {
    _titleTextEditingController.text = _groupDetails.title ?? '';
    _descriptionEditinngController.text = _groupDetails.description ?? '';
  }

  bool isUserAdmin() {
    return widget.groupDetails.isAdmin == "1";
  }

  @override
  void dispose() {
    _titleTextEditingController.dispose();
    _descriptionEditinngController.dispose();
    super.dispose();
  }

  Widget _buildTitleTextField() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(circularBorderRadius10),
      ),
      child: TextFormField(
        enabled: isUserAdmin(),
        controller: _titleTextEditingController,
        validator: (value) {
          if ((value ?? "").isEmpty) {
            return "Please enter title";
          }
          return null;
        },
        decoration: InputDecoration(
            labelText: getTranslated(context, "TITLE") ?? "TITLE"),
      ),
    );
  }

  Widget _buildDescriptionTextField() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(circularBorderRadius10),
      ),
      child: TextFormField(
        enabled: isUserAdmin(),
        controller: _descriptionEditinngController,
        validator: (value) {
          if ((value ?? "").isEmpty) {
            return "Please enter description";
          }
          return null;
        },
        decoration: InputDecoration(
            labelText: getTranslated(context, "DESCRIPTION") ?? "DESCRIPTION"),
      ),
    );
  }

  Widget _buildAddedUsers() {
    return _users.isEmpty
        ? const SizedBox()
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 15,
              ),
              Text(
                getTranslated(context, "ADDED_USERS") ?? "ADDED_USERS",
                style: const TextStyle(
                    fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10,
              ),
              ..._users.map((user) {
                return ListTile(
                  contentPadding: const EdgeInsets.all(0),
                  leading: (user.image ?? '').isEmpty
                      ? const Icon(Icons.person)
                      : SizedBox(
                          height: 25,
                          width: 25,
                          child: Image.network(user.image!)),
                  title: Text(user.username ?? ''),
                  trailing: GestureDetector(
                    onTap: () {
                      _users.removeWhere((element) => element.id == user.id);
                      setState(() {});
                    },
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.transparent)),
                      child: Center(
                        child: Icon(
                          Icons.close,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ],
          );
  }

  Widget _buildGroupCreationForm() {
    return Form(
        key: _formKey,
        child: Column(
          children: [
            _buildTitleTextField(),
            const SizedBox(
              height: 10,
            ),
            _buildDescriptionTextField()
          ],
        ));
  }

  Widget _buildEditGroupFloatingActionButton() {
    if (isUserAdmin()) {
      return BlocConsumer<EditGroupCubit, EditGroupState>(
        listener: (context, state) {
          if (state is EditGroupSuccess) {
            _groupDetails = _groupDetails.copyWith(
                groupMembers: state.groupDetails.groupMembers,
                noOfMembers: state.groupDetails.noOfMembers,
                title: state.groupDetails.title,
                description: state.groupDetails.description);
            _users = [];
            setGroupTitleAndDescription();
            setState(() {});
            context
                .read<GroupConversationsCubit>()
                .updateGroupConvertation(groupDetails: _groupDetails);
            setSnackbar("Group updated successfully", context);
          } else if (state is EditGroupFailure) {
            setSnackbar(state.errorMessage, context);
          }
        },
        builder: (context, state) {
          return FloatingActionButton(
            onPressed: () {
              if (state is EditGroupInProgress) {
                return;
              }

              if (_formKey.currentState!.validate()) {
                //Generate user ids
                List<String> userIds = _users.map((e) => e.id!).toList();
                //
                for (var member in _groupDetails.groupMembers!) {
                  if (member.isAdmin == "0") {
                    userIds.add(member.userId!);
                  }
                }
                context.read<EditGroupCubit>().editGroup(
                    groupId: _groupDetails.groupId ?? "",
                    title: _titleTextEditingController.text.trim(),
                    description: _descriptionEditinngController.text.trim(),
                    userIds: userIds,
                    currentUserId:
                        context.read<SettingProvider>().CUR_USERID ?? '0');
              }
            },
            child: state is EditGroupInProgress
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.0,
                      color: white,
                    ))
                : const Icon(Icons.check),
          );
        },
      );
    }
    return const SizedBox();
  }

  Widget _buildAddUserAndDeleteGroup() {
    return Column(
      children: [
        ListTile(
          onTap: () {
            Routes.navigateToSearchUserScreen(
                    users: _users,
                    context: context,
                    searchFor: SearchFor.groupCreation)
                .then((result) {
              if (result != null) {
                if (result['users'] != null) {
                  final addedUsers =
                      List<SearchedUser>.from(result['users'] ?? []);

                  //Remove the members from added users
                  for (var member in _groupDetails.groupMembers!) {
                    addedUsers
                        .removeWhere((element) => element.id == member.userId);
                  }
                  _users = addedUsers;
                  setState(() {});
                }
              }
            });
          },
          contentPadding: const EdgeInsets.all(0),
          leading: const Icon(
            Icons.person_add,
          ),
          title: Text(getTranslated(context, "ADD_USER") ?? "ADD_USER"),
        ),
        ListTile(
          onTap: () {
            showDialog<bool?>(
                context: context,
                builder: (context) {
                  return BlocProvider(
                    create: (_) => DeleteGroupCubit(ChatRepository()),
                    child: DeleteGroupDialog(groupId: _groupDetails.groupId!),
                  );
                }).then((value) {
              if (value != null && value) {
                context.read<GroupConversationsCubit>().removeGroupConvertation(
                    groupId: widget.groupDetails.groupId!);
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              }
            });
          },
          contentPadding: const EdgeInsets.all(0),
          leading: const Icon(
            Icons.delete,
            color: Colors.red,
          ),
          title: Text(
            getTranslated(context, "DELETE_GROUP") ?? "DELETE_GROUP",
            style: const TextStyle(
              color: Colors.red,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGroupMemberContainer({required GroupMember groupMember}) {
    return ListTile(
      leading: (groupMember.image ?? '').isEmpty
          ? const Icon(Icons.person)
          : SizedBox(
              height: 25, width: 25, child: Image.network(groupMember.image!)),
      contentPadding: const EdgeInsets.all(0),
      title: Text(groupMember.username ?? ""),
      trailing: groupMember.isAdmin == "1"
          ? const Text(
              "Group admin",
              style: TextStyle(fontWeight: FontWeight.w600),
            )
          : isUserAdmin()
              ? IconButton(
                  onPressed: () {
                    showDialog<GroupDetails?>(
                        context: context,
                        builder: (context) {
                          return BlocProvider(
                            create: (context) =>
                                RemoveGroupMemberCubit(ChatRepository()),
                            child: RemoveGroupMemberDialog(
                                groupMember: groupMember,
                                groupDetails: _groupDetails),
                          );
                        }).then((value) {
                      if (value != null) {
                        _groupDetails = _groupDetails.copyWith(
                            groupMembers: value.groupMembers);

                        context
                            .read<GroupConversationsCubit>()
                            .updateGroupConvertation(
                                groupDetails: _groupDetails);
                        setState(() {});
                      }
                    });
                  },
                  icon: const Icon(Icons.remove_circle))
              : const SizedBox(),
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
        Navigator.of(context).pop(_groupDetails);
      },
      child: Scaffold(
        floatingActionButton: _buildEditGroupFloatingActionButton(),
        appBar: getSimpleAppBar(
            getTranslated(context, "GROUP_INFO") ?? "GROUP_INFO", context,
            onTapBackButton: () {
          Navigator.of(context).pop(_groupDetails);
        }),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildGroupCreationForm(),
              isUserAdmin() ? _buildAddUserAndDeleteGroup() : const SizedBox(),
              _buildAddedUsers(),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: Text(
                  getTranslated(context, "MEMBERS") ?? "MEMBERS",
                  style: const TextStyle(
                      fontSize: 18.0, fontWeight: FontWeight.w600),
                ),
              ),
              ...(_groupDetails.groupMembers ?? [])
                  .map((groupMember) =>
                      _buildGroupMemberContainer(groupMember: groupMember))
                  .toList()
            ],
          ),
        ),
      ),
    );
  }
}
