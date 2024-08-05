import 'package:flutter/material.dart';
import '../../../Widget/validation.dart';
import '../OrderList.dart';
import 'commanDesingField.dart';

class DetailHeaderOne extends StatelessWidget {
  final Function setStateNow;
  const DetailHeaderOne({
    Key? key,
    required this.setStateNow,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Row(
        children: [
          CommanDesingWidget(
            title: getTranslated(context, "ORDER")!,
            icon: Icons.shopping_cart,
            index: 0,
            onTapAction: null,
            update: setStateNow,
          ),
          CommanDesingWidget(
            title: getTranslated(context, "RECEIVED_LBL")!,
            icon: Icons.archive,
            index: 1,
            onTapAction: orderListProvider!.statusList[1],
            update: setStateNow,
          ),
          CommanDesingWidget(
            title: getTranslated(context, "PROCESSED_LBL")!,
            icon: Icons.work,
            index: 2,
            onTapAction: orderListProvider!.statusList[2],
            update: setStateNow,
          ),
        ],
      ),
    );
  }
}

class DetailHeaderTwo extends StatelessWidget {
  final Function setStateNow;
  const DetailHeaderTwo({Key? key, required this.setStateNow})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CommanDesingWidget(
          title: getTranslated(context, "SHIPED_LBL")!,
          icon: Icons.airport_shuttle,
          index: 3,
          onTapAction: orderListProvider!.statusList[3],
          update: setStateNow,
        ),
        CommanDesingWidget(
          title: getTranslated(context, "DELIVERED_LBL")!,
          icon: Icons.assignment_turned_in,
          index: 4,
          onTapAction: orderListProvider!.statusList[4],
          update: setStateNow,
        ),

        // index = 5
        CommanDesingWidget(
          title: getTranslated(context, "CANCELLED_LBL")!,
          icon: Icons.cancel,
          index: 5,
          onTapAction: orderListProvider!.statusList[5],
          update: setStateNow,
        ),

        CommanDesingWidget(
          title: getTranslated(context, "RETURNED_LBL")!,
          icon: Icons.upload,
          index: 6,
          onTapAction: orderListProvider!.statusList[6],
          update: setStateNow,
        )
      ],
    );
  }
}
