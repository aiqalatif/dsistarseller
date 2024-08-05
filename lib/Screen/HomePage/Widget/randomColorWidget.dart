import 'dart:math';
import 'package:flutter/material.dart';
import '../../../Helper/Color.dart';
import '../../../Helper/Constant.dart';

Color generateRandomColor() {
  Random random = Random();
  // Pick a random number in the range [0.0, 1.0)
  double randomDouble = random.nextDouble();

  return Color((randomDouble * 0xFFFFFF).toInt()).withOpacity(1.0);
}

gethomePageTextDesing(
  String numberValue,
  String title,
) {
  return Column(
    children: [
      Text(numberValue,
          style: const TextStyle(
              color: black,
              fontWeight: FontWeight.w400,
              fontFamily: "Roboto",
              fontStyle: FontStyle.normal,
              fontSize: textFontSize14),
          textAlign: TextAlign.left),
      const SizedBox(height: 10),
      Text(title,
          style: const TextStyle(
              color: primary,
              fontWeight: FontWeight.w400,
              fontFamily: "Roboto",
              fontStyle: FontStyle.normal,
              fontSize: textFontSize12),
          textAlign: TextAlign.left)
    ],
  );
}
