import 'package:flutter/material.dart';
import '../../../Helper/Color.dart';
import '../../../Helper/Constant.dart';
import '../OrderList.dart';

class CommanDesingWidget extends StatelessWidget {
  final String title;
  final IconData icon;
  final int index;
  final String? onTapAction;
  final Function update;
  const CommanDesingWidget({
    Key? key,
    required this.icon,
    required this.index,
    required this.title,
    required this.onTapAction,
    required this.update,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: Container(
        width: 95,
        height: 55,
        decoration: BoxDecoration(
          gradient: currentSelected == index
              ? const LinearGradient(
                  colors: [grad1Color, grad2Color],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          boxShadow: const [
            BoxShadow(
              color: blarColor,
              offset: Offset(0, 0),
              blurRadius: 4,
              spreadRadius: 0,
            ),
          ],
          color: white,
          borderRadius: const BorderRadius.all(
            Radius.circular(circularBorderRadius10),
          ),
        ),
        child: InkWell(
          onTap: () {
            currentSelected = index;
            orderListProvider!.activeStatus = onTapAction;
            orderListProvider!.scrollLoadmore = true;
            orderListProvider!.scrollOffset = 0;
            orderListProvider!.getOrder(update, context);

            update();
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsetsDirectional.only(
                  top: 8.0,
                  start: 15.0,
                ),
                child: Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    color: currentSelected == index ? white : black,
                    fontSize: textFontSize12,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.only(
                  start: 15.0,
                  top: 8.0,
                ),
                child: Text(
                  () {
                    if (index == 0) {
                      if (orderListProvider!.all != null) {
                        return orderListProvider!.all!;
                      } else {
                        return "";
                      }
                    } else if (index == 1) {
                      if (orderListProvider!.received != null) {
                        return orderListProvider!.received!;
                      } else {
                        return "";
                      }
                    } else if (index == 2) {
                      if (orderListProvider!.processed != null) {
                        return orderListProvider!.processed!;
                      } else {
                        return "";
                      }
                    } else if (index == 3) {
                      if (orderListProvider!.shipped != null) {
                        return orderListProvider!.shipped!;
                      } else {
                        return "";
                      }
                    } else if (index == 4) {
                      if (orderListProvider!.delivered != null) {
                        return orderListProvider!.delivered!;
                      } else {
                        return "";
                      }
                    } else if (index == 5) {
                      if (orderListProvider!.cancelled != null) {
                        return orderListProvider!.cancelled!;
                      } else {
                        return "";
                      }
                    } else if (index == 6) {
                      if (orderListProvider!.returned != null) {
                        return orderListProvider!.returned!;
                      } else {
                        return "";
                      }
                    } else {
                      return "";
                    }
                  }(),
                  style: TextStyle(
                    color: currentSelected == index ? white : black,
                    fontWeight: FontWeight.bold,
                    fontSize: textFontSize16,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
