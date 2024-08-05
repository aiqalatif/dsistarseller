import 'package:flutter/material.dart';
import '../../../../Helper/Color.dart';
import '../../../../Helper/Constant.dart';
import '../../Add_Product.dart';

productTypePDDialog(
  BuildContext context,
  Function setStateNow,
) async {
  await showModalBottomSheet(
    isScrollControlled: true,
    context: context,
    backgroundColor: Colors.transparent,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setStater) {
          addProvider!.taxesState = setStater;
          return Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(circularBorderRadius25),
                topRight: Radius.circular(circularBorderRadius25),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Product Type',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(color: primary),
                      ),
                    ],
                  ),
                ),
                const Divider(color: lightBlack),
                Flexible(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: () {
                            addProvider!.currentSellectedProductIsPysical =
                                true;
                            Navigator.of(context).pop();
                            setStateNow();
                          },
                          child: const SizedBox(
                            width: double.maxFinite,
                            child: Padding(
                              padding: EdgeInsets.all(20.0),
                              child: Text(
                                "Physical Product",
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            addProvider!.currentSellectedProductIsPysical =
                                false;
                            Navigator.of(context).pop();
                            setStateNow();
                          },
                          child: const SizedBox(
                            width: double.maxFinite,
                            child: Padding(
                              padding: EdgeInsets.all(20.0),
                              child: Text(
                                "Digital Product",
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}
