import 'package:flutter/material.dart';
import '../../../../Helper/Constant.dart';

class Indicators extends StatelessWidget {
  final Color? color;
  final String? text;
  final bool? isSquare;
  final double size;
  final Color? textColor;

  const Indicators({
    Key? key,
    this.color,
    this.text,
    this.isSquare,
    this.size = 9,
    this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: isSquare! ? BoxShape.rectangle : BoxShape.circle,
            color: color,
          ),
        ),
        const SizedBox(
          width: 4,
        ),
        Expanded(
          child: Text(
            text!,
            style: TextStyle(
              fontSize: textFontSize9,
              color: textColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        )
      ],
    );
  }
}
