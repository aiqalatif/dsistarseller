import 'package:flutter/material.dart';
import '../../../Helper/Color.dart';
import '../../../Helper/Constant.dart';

class GetDesingButton extends StatelessWidget {
  final String title;
  final IconData icon;
  const GetDesingButton({
    Key? key,
    required this.icon,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 1,
      borderRadius: BorderRadius.circular(circularBorderRadius8),
      child: Container(
        height: 25.0, //MediaQuery.of(context).size.width * .08,
        width: 120.0, //MediaQuery.of(context).size.width * .3,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(circularBorderRadius8),
        ),
        child: Row(
          children: <Widget>[
            LayoutBuilder(
              builder: (context, constraints) {
                return Container(
                  height: constraints.maxHeight,
                  width: constraints.maxHeight,
                  decoration: BoxDecoration(
                    color: primary,
                    borderRadius: BorderRadius.circular(circularBorderRadius8),
                  ),
                  child: Icon(
                    icon,
                    color: Colors.white,
                    size: 18,
                  ),
                );
              },
            ),
            Expanded(
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
