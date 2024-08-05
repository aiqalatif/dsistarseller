import 'package:flutter/material.dart';
import '../../../Helper/Color.dart';
import '../../../Helper/Constant.dart';

class CommanButton extends StatelessWidget {
  final bool selected;
  final String title;
  const CommanButton({
    Key? key,
    required this.selected,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(
    BuildContext context,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3.0),
      child: Container(
        height: 31,
        decoration: BoxDecoration(
          borderRadius:
              const BorderRadius.all(Radius.circular(circularBorderRadius5)),
          gradient: LinearGradient(
            colors: [
              selected ? grad1Color : white,
              selected ? grad2Color : white
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: const [0, 1],
            tileMode: TileMode.clamp,
          ),
          boxShadow: [
            selected
                ? const BoxShadow()
                : const BoxShadow(
                    color: blarColor,
                    offset: Offset(0, 0),
                    blurRadius: 4,
                    spreadRadius: 0,
                  ),
          ],
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              color: selected ? white : black,
              fontWeight: FontWeight.w400,
              fontFamily: "PlusJakartaSans",
              fontStyle: FontStyle.normal,
              fontSize: selected ? textFontSize16 : textFontSize14,
            ),
          ),
        ),
      ),
    );
  }
}

commanBtn(String title, bool fromNoDesing, bool outoffStock) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 3.0),
    child: Container(
      height: 25,
      decoration: BoxDecoration(
        color: fromNoDesing
            ? outoffStock
                ? newPrimary.withOpacity(1.0)
                : Colors.green.withOpacity(0.80)
            : white,
        borderRadius: BorderRadius.circular(circularBorderRadius5),
        boxShadow: [
          fromNoDesing
              ? const BoxShadow()
              : const BoxShadow(
                  color: blarColor,
                  offset: Offset(0, 0),
                  blurRadius: 4,
                  spreadRadius: 0,
                ),
        ],
      ),
      child: Center(
        child: Text(
          title,
          style: TextStyle(
            color: fromNoDesing ? white : black,
            fontWeight: FontWeight.w400,
            fontFamily: "PlusJakartaSans",
            fontStyle: FontStyle.normal,
            fontSize: textFontSize10,
          ),
        ),
      ),
    ),
  );
}
