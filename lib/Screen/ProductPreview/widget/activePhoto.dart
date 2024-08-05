import 'package:flutter/material.dart';
import '../../../Helper/Color.dart';
import '../../../Helper/Constant.dart';

class ActivePhoto extends StatelessWidget {
  const ActivePhoto({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(
        start: 5.0,
        end: 5.0,
      ),
      child: Container(
        height: 10.0,
        width: 10.0,
        decoration: BoxDecoration(
          color: primary,
          borderRadius: BorderRadius.circular(circularBorderRadius5),
          boxShadow: const [
            BoxShadow(
              color: Colors.grey,
              spreadRadius: 0.0,
              blurRadius: 2.0,
            )
          ],
        ),
      ),
    );
  }
}
