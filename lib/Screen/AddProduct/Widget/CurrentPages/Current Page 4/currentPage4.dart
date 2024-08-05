import 'package:flutter/material.dart';

currentPage4(
  BuildContext context,
  Function setState,
  Function updateCity,
) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      additionalInfo(context, setState, updateCity),
    ],
  );
}

additionalInfo(
  BuildContext context,
  Function setState,
  Function updateCity,
) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    children: [
      // currentSelectedPossitionBord(context, setState),
      // selectionPossitionZero(context, setState, updateCity),
      // selectionPossitionOne(context, setState),
      // selectionPossitionTwo(context, setState),
    ],
  );
}
