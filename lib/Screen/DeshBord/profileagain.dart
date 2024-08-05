import 'package:flutter/material.dart';
import '../HomePage/Widget/DrawerWidget.dart';

class ProfileAgain extends StatefulWidget {
  const ProfileAgain({Key? key}) : super(key: key);

  @override
  State<ProfileAgain> createState() => _ProfileAgainState();
}

class _ProfileAgainState extends State<ProfileAgain> {
  @override
  Widget build(BuildContext context) {
    return DrawerWidget();
  }
}
