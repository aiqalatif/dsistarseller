import 'dart:convert';

import "package:flutter/material.dart";
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sellermultivendor/Helper/PushNotificationService.dart';
import 'package:sellermultivendor/Model/message.dart';
import 'package:sellermultivendor/Repository/NotificationRepository.dart';
import 'package:sellermultivendor/Screen/DeshBord/profileagain.dart';
import 'package:sellermultivendor/Widget/snackbar.dart';
import 'package:sellermultivendor/Widget/validation.dart';
import 'package:sellermultivendor/cubits/personalConverstationsCubit.dart';
import '../../Helper/Color.dart';
import '../../Helper/Constant.dart';
import '../../Widget/desing.dart';
import '../HomePage/home.dart';
import '../OrderList/OrderList.dart';
import '../ProductList/ProductList.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> with WidgetsBindingObserver {
  late List<Widget> fragments;
  int _curBottom = 0;
  DateTime? currentBackPressTime;
  @override
  void initState() {
    super.initState();
    fragments = [
      const Home(),
      const OrderList(),
      ProductList(
        flag: "",
        fromNavbar: true,
      ),
      const ProfileAgain(),
    ];
    Future.delayed(Duration.zero, () {
      PushNotificationService(context: context).initialise();
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      NotificationRepository.getChatNotifications().then((messages) {
        for (var encodedMessage in messages) {
          final message =
              Message.fromJson(Map.from(jsonDecode(encodedMessage) ?? {}));

          if (conversationScreenStateKey.currentState?.mounted ?? false) {
            final state = conversationScreenStateKey.currentState!;
            if (state.widget.isGroup) {
              //Update for group message here
            } else {
              if (state.widget.personalChatHistory?.getOtherUserId() !=
                  message.fromId) {
                context
                    .read<PersonalConverstationsCubit>()
                    .updateUnreadMessageCounter(userId: message.fromId!);
              } else {
                state.addMessage(message: message);
              }
            }
          } else {
            if (message.type == 'person') {
              context
                  .read<PersonalConverstationsCubit>()
                  .updateUnreadMessageCounter(
                    userId: message.fromId!,
                  );
            } else {
              // Update group message
            }
          }
        }
        //Clear the message notifications
        NotificationRepository.clearChatNotifications();
      });
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _curBottom == 0 &&
          !(currentBackPressTime == null ||
              DateTime.now().difference(currentBackPressTime!) >
                  const Duration(seconds: 2)),
      onPopInvoked: (didPop) {
        if (_curBottom != 0) {
          setState(() {
            _curBottom = 0;
          });
        } else {
          DateTime now = DateTime.now();

          if (currentBackPressTime == null ||
              now.difference(currentBackPressTime!) >
                  const Duration(seconds: 2)) {
            currentBackPressTime = now;
            setSnackbar('Press back again to Exit', context);
            setState(() {});
          }
        }
      },
      child: Scaffold(
        bottomNavigationBar: getBottomNav(),
        body: fragments[_curBottom],
      ),
    );
  }

  getBottomNav() {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(circularBorderRadius13)),
        boxShadow: [
          BoxShadow(
            color: fillColor,
            offset: Offset(0, -3),
            blurRadius: 6,
            spreadRadius: 0,
          )
        ],
        color: white,
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(circularBorderRadius12),
          topLeft: Radius.circular(circularBorderRadius12),
        ),
        child: BottomNavigationBar(
          unselectedItemColor: primary,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                DesignConfiguration.setSvgPath('home'),
                colorFilter: const ColorFilter.mode(primary, BlendMode.srcIn),
              ),
              activeIcon: SvgPicture.asset(
                DesignConfiguration.setSvgPath('homeSelected'),
                colorFilter: const ColorFilter.mode(primary, BlendMode.srcIn),
              ),
              label: getTranslated(context, 'Home')!,
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                DesignConfiguration.setSvgPath('order'),
                colorFilter: const ColorFilter.mode(primary, BlendMode.srcIn),
              ),
              activeIcon: SvgPicture.asset(
                DesignConfiguration.setSvgPath('orderselected'),
                colorFilter: const ColorFilter.mode(primary, BlendMode.srcIn),
              ),
              label: getTranslated(context, 'Orders')!,
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                DesignConfiguration.setSvgPath('product'),
                colorFilter: const ColorFilter.mode(primary, BlendMode.srcIn),
              ),
              activeIcon: SvgPicture.asset(
                DesignConfiguration.setSvgPath('productSelected'),
                colorFilter: const ColorFilter.mode(primary, BlendMode.srcIn),
              ),
              label: getTranslated(context, 'PRODUCTS')!,
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                DesignConfiguration.setSvgPath('profile'),
                colorFilter: const ColorFilter.mode(primary, BlendMode.srcIn),
              ),
              activeIcon: SvgPicture.asset(
                DesignConfiguration.setSvgPath('profileSelected'),
                colorFilter: const ColorFilter.mode(primary, BlendMode.srcIn),
              ),
              label: getTranslated(context, 'Profile')!,
            ),
          ],
          type: BottomNavigationBarType.fixed,
          currentIndex: _curBottom,
          selectedItemColor: primary,
          onTap: (int index) {
            if (mounted) {
              setState(
                () {
                  _curBottom = index;
                },
              );
            }
          },
          elevation: 25,
        ),
      ),
    );
  }
}
