import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sellermultivendor/Provider/settingProvider.dart';
import 'package:sellermultivendor/Widget/snackbar.dart';
import 'package:sellermultivendor/cubits/deleteGroupCubit.dart';

class DeleteGroupDialog extends StatelessWidget {
  final String groupId;
  const DeleteGroupDialog({Key? key, required this.groupId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (context.read<DeleteGroupCubit>().state is! DeleteGroupInProgress) {
          if (didPop) {
            return;
          }
          Navigator.of(context).pop();
        }
      },
      child: AlertDialog(
        title: const Text("Are you sure to delete this group?"),
        actions: [
          BlocConsumer<DeleteGroupCubit, DeleteGroupState>(
            listener: (context, state) {
              if (state is DeleteGroupSuccess) {
                Navigator.of(context).pop(true);
              } else if (state is DeleteGroupFailure) {
                Navigator.of(context).pop();
                setSnackbar(state.errorMessage, context);
              }
            },
            builder: (context, state) {
              return state is DeleteGroupInProgress
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        CupertinoButton(
                            child: const Text("Yes"),
                            onPressed: () {
                              context.read<DeleteGroupCubit>().deleteGroup(
                                  groupId: groupId,
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
