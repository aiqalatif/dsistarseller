// get command sized Box
import 'package:flutter/material.dart';
import '../../../Helper/Color.dart';
import '../../../Helper/Constant.dart';

getCommanSizedBox() {
  return const SizedBox(
    height: 10,
  );
}

// Comman Primary Text Field :-

getPrimaryCommanText(String title, bool isMultipleLine) {
  return Text(
    title,
    style: const TextStyle(
      fontSize: textFontSize16,
      color: black,
    ),
    overflow: isMultipleLine ? TextOverflow.ellipsis : null,
    softWrap: true,
    maxLines: isMultipleLine ? 2 : 1,
  );
}

// Comman Secondary Text Field :-

getSecondaryCommanText(String title) {
  return Text(
    title,
    style: const TextStyle(
      color: Colors.grey,
    ),
    softWrap: false,
    overflow: TextOverflow.ellipsis,
    maxLines: 1,
  );
}
