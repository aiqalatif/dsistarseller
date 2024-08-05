import 'package:flutter/material.dart';
import '../../../Helper/Color.dart';

getAppBarHome(BuildContext context, String appName) {
  return AppBar(
    title: Text(
      appName,
      style: const TextStyle(
        color: grad2Color,
      ),
    ),
    backgroundColor: white,
    iconTheme: const IconThemeData(
      color: grad2Color,
    ),
  );
}
