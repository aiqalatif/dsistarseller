import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sellermultivendor/Helper/Color.dart';
import 'package:sellermultivendor/Helper/Constant.dart';
import 'package:sellermultivendor/Model/searchedUser.dart';
import 'package:sellermultivendor/Provider/settingProvider.dart';
import 'package:sellermultivendor/Screen/searchUsersScreen.dart';
import 'package:sellermultivendor/Widget/routes.dart';
import 'package:sellermultivendor/Widget/snackbar.dart';
import 'package:sellermultivendor/Widget/validation.dart';
import 'package:sellermultivendor/cubits/createGroupCubit.dart';
import 'package:sellermultivendor/cubits/groupConverstationsCubit.dart';

class CreateGroupScreen extends StatefulWidget {
  const CreateGroupScreen({Key? key}) : super(key: key);

  @override
  State<CreateGroupScreen> createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends State<CreateGroupScreen> {
  late final TextEditingController _titleTextEditingController =
      TextEditingController();
  late final TextEditingController _descriptionEditinngController =
      TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  List<SearchedUser> _users = [];

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

  Widget _buildSearchBar() {
    return GestureDetector(
      onTap: () async {
        Routes.navigateToSearchUserScreen(
                users: _users,
                context: context,
                searchFor: SearchFor.groupCreation)
            .then((result) {
          if (result != null) {
            if (result['users'] != null) {
              _users = List<SearchedUser>.from(result['users'] ?? []);
              setState(() {});
            }
          }
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        decoration: const BoxDecoration(color: white),
        child: Row(
          children: [
            Text(
              getTranslated(context, 'SEARCH_USER') ?? 'SEARCH_USER',
              style: const TextStyle(fontSize: 15.0),
            ),
            const Spacer(),
            const Icon(Icons.search),
          ],
        ),
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

  Widget _buildCreateGroupFloatingActionButton() {
    return BlocConsumer<CreateGroupCubit, CreateGroupState>(
      listener: (context, state) {
        if (state is CreateGroupSuccess) {
          context.read<GroupConversationsCubit>().fetchGroupConversations(
              userId: context.read<SettingProvider>().CUR_USERID ?? '0');
          Navigator.of(context).pop();
        } else if (state is CreateGroupFailure) {
          setSnackbar(state.errorMessage, context);
        }
      },
      builder: (context, state) {
        return FloatingActionButton(
          onPressed: () {
            if (state is CreateGroupInProgress) {
              return;
            }
            if (_users.isEmpty) {
              return;
            }
            if (_formKey.currentState!.validate()) {
              context.read<CreateGroupCubit>().createGroup(
                  title: _titleTextEditingController.text.trim(),
                  description: _descriptionEditinngController.text.trim(),
                  userIds: _users.map((e) => e.id!).toList(),
                  currentUserId:
                      context.read<SettingProvider>().CUR_USERID ?? '0');
            }
          },
          child: state is CreateGroupInProgress
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: _buildCreateGroupFloatingActionButton(),
      appBar: getSimpleAppBar('CREATE_GROUP', context),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSearchBar(),
            _buildGroupCreationForm(),
            _buildAddedUsers(),
          ],
        ),
      ),
    );
  }
}
