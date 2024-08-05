import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sellermultivendor/Helper/Color.dart';
import 'package:sellermultivendor/Helper/Constant.dart';
import 'package:sellermultivendor/Provider/settingProvider.dart';
import 'package:sellermultivendor/Widget/errorContainer.dart';
import 'package:sellermultivendor/Widget/noNetwork.dart';
import 'package:sellermultivendor/Widget/routes.dart';
import 'package:sellermultivendor/Widget/validation.dart';
import 'package:sellermultivendor/cubits/personalConverstationsCubit.dart';

class ConversationListScreen extends StatefulWidget {
  const ConversationListScreen({Key? key}) : super(key: key);

  @override
  State<ConversationListScreen> createState() => ConversationListScreenState();
}

class ConversationListScreenState extends State<ConversationListScreen>
    with TickerProviderStateMixin {
  final TextEditingController _textEditingController = TextEditingController();

  late AnimationController buttonController;
  late Animation buttonSqueezeanimation;

  @override
  void initState() {
    buttonController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    buttonSqueezeanimation = Tween(
      begin: width * 0.7,
      end: 50.0,
    ).animate(
      CurvedAnimation(
        parent: buttonController,
        curve: const Interval(
          0.0,
          0.150,
        ),
      ),
    );
    super.initState();
    Future.delayed(Duration.zero, () {
      context.read<PersonalConverstationsCubit>().fetchConversations(
          currentUserId: context.read<SettingProvider>().CUR_USERID ?? '0');
    });
  }

  @override
  void dispose() {
    buttonController.dispose();
    _textEditingController.dispose();
    super.dispose();
  }

  Widget _buildPersonalConversationsContainer() {
    return BlocBuilder<PersonalConverstationsCubit,
        PersonalConverstationsState>(
      builder: (context, state) {
        if (state is PersonalConverstationsFetchSuccess) {
          if (state.personalConversations.isEmpty) {
            return Center(
              child: Text(
                getTranslated(context, noMessagesKey) ?? noMessagesKey,
                style: const TextStyle(color: primary, fontSize: 16.0),
              ),
            );
          }
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Column(
              children: state.personalConversations.map(
                (personalChatHistory) {
                  final unreadMessages = personalChatHistory.unreadMsg ?? '';
                  return ListTile(
                    onTap: () async {
                      Routes.navigateToConversationScreen(
                          isGroup: false,
                          context: context,
                          personalChatHistory: personalChatHistory);
                    },
                    tileColor: white,
                    title: Text(personalChatHistory.opponentUsername ?? ''),
                    leading: (personalChatHistory.image ?? '').isEmpty
                        ? const Icon(Icons.person)
                        : SizedBox(
                            height: 25,
                            width: 25,
                            child: CachedNetworkImage(
                              imageUrl: personalChatHistory.image!,
                              errorWidget: (context, url, error) {
                                return const Icon(Icons.person);
                              },
                            )),
                    trailing:
                        (unreadMessages.isNotEmpty && unreadMessages != '0')
                            ? CircleAvatar(
                                radius: 14,
                                child: Text(
                                  personalChatHistory.unreadMsg!,
                                  style: const TextStyle(
                                    color: white,
                                  ),
                                ),
                              )
                            : const SizedBox(),
                  );
                },
              ).toList(),
            ),
          );
        }
        //
        if (state is PersonalConverstationsFetchFailure) {
          if (state.errorMessage == 'No Internet connection') {
            return Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 50),
                child: noInternet(context, () {
                  buttonController.forward().then((value) {
                    buttonController.value = 0;
                    context
                        .read<PersonalConverstationsCubit>()
                        .fetchConversations(
                            currentUserId:
                                context.read<SettingProvider>().CUR_USERID ??
                                    '0');
                  });
                }, buttonSqueezeanimation, buttonController),
              ),
            );
          }
          return Center(
            child: ErrorContainer(
                onTapRetry: () {
                  context
                      .read<PersonalConverstationsCubit>()
                      .fetchConversations(
                          currentUserId:
                              context.read<SettingProvider>().CUR_USERID ??
                                  '0');
                },
                errorMessage: state.errorMessage),
          );
        }
        return Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 200),
            child: SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2.0,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
        );
      },
    );
  }

/*
  Widget _buildGroupConversationsContainer() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              getTranslated(context, groupChatLabelKey) ?? groupChatLabelKey,
              style:
                  const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            IconButton(
                onPressed: () {
                  Routes.navigateToCreateGroupScreen(context);
                },
                icon: const Icon(Icons.add))
          ],
        ),
        const SizedBox(
          height: 15,
        ),
        BlocBuilder<GroupConversationsCubit, GroupConversationsState>(
          builder: (context, state) {
            if (state is GroupConversationsFetchSuccess) {
              return Column(
                children: state.groupConversations.map(
                  (groupDetails) {
                    return ListTile(
                      onTap: () async {
                        Routes.navigateToConversationScreen(
                            context: context,
                            isGroup: true,
                            groupDetails: groupDetails);
                      },
                      tileColor: white,
                      title: Text("#${groupDetails.title}"),
                      trailing: groupDetails.isRead == '1'
                          ? Container(
                              decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.primary,
                                  borderRadius: BorderRadius.circular(5)),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: const Text(
                                "New",
                                style: TextStyle(
                                  color: white,
                                ),
                              ),
                            )
                          : const SizedBox(),
                    );
                  },
                ).toList(),
              );
            }
            if (state is GroupConversationsFetchFailure) {
              return Center(
                child: ErrorContainer(
                    onTapRetry: () {
                      context
                          .read<GroupConversationsCubit>()
                          .fetchGroupConversations(
                              userId:
                                  context.read<SettingProvider>().CUR_USERID ??
                                      '0');
                    },
                    errorMessage: state.errorMessage),
              );
            }
            return Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.0,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

*/
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getSimpleAppBar('CHAT', context),
      body: _buildPersonalConversationsContainer(),
    );
  }
}
