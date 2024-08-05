import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sellermultivendor/Model/groupDetails.dart';
import 'package:sellermultivendor/Model/groupMEmber.dart';
import 'package:sellermultivendor/Provider/settingProvider.dart';
import 'package:sellermultivendor/Widget/snackbar.dart';
import 'package:sellermultivendor/cubits/removeGroupMemberCubit.dart';

class RemoveGroupMemberDialog extends StatelessWidget {
  final GroupDetails groupDetails;
  final GroupMember groupMember;
  const RemoveGroupMemberDialog(
      {Key? key, required this.groupMember, required this.groupDetails})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (context.read<RemoveGroupMemberCubit>().state
            is! RemoveGroupMemberInProgress) {
          if (didPop) {
            return;
          }
          Navigator.of(context).pop();
        }
      },
      child: AlertDialog(
        title: const Text("Are you sure to remove this member?"),
        actions: [
          BlocConsumer<RemoveGroupMemberCubit, RemoveGroupMemberState>(
            listener: (context, state) {
              if (state is RemoveGroupMemberSuccess) {
                Navigator.of(context).pop(state.groupDetails);
              } else if (state is RemoveGroupMemberFailure) {
                Navigator.of(context).pop();
                setSnackbar(state.errorMessage, context);
              }
            },
            builder: (context, state) {
              return state is RemoveGroupMemberInProgress
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        CupertinoButton(
                            child: const Text("Yes"),
                            onPressed: () {
                              List<String> userIds = groupDetails.groupMembers!
                                  .map((e) => e.userId!)
                                  .toList();
                              userIds.removeWhere(
                                  (element) => element == groupMember.userId);

                              context.read<RemoveGroupMemberCubit>().editGroup(
                                  title: groupDetails.title!,
                                  groupId: groupDetails.groupId!,
                                  description: groupDetails.description!,
                                  userIds: userIds,
                                  currentUserId: context
                                          .read<SettingProvider>()
                                          .CUR_USERID ??
                                      "");
                            }),
                        CupertinoButton(
                            child: const Text("No"),
                            onPressed: () {
                              Navigator.of(context).pop();
                            }),
                      ],
                    );
            },
          ),
        ],
      ),
    );
  }
}
