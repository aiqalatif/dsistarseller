//------------------------------------------------------------------------------
//============================== Tax Selection =================================

import 'package:flutter/material.dart';
import '../../../../Helper/Color.dart';
import '../../../../Helper/Constant.dart';
import '../../../../Widget/validation.dart';
import '../../Add_Product.dart';

taxesDialog(BuildContext context, Function setStateNow) async {
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
                        getTranslated(context, "Select Tax")!,
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(color: primary),
                      ),
                      Text(
                        getTranslated(context, "0%")!,
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
                      children: getTaxtList(context, setStateNow),
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

List<Widget> getTaxtList(BuildContext context, Function setStateNow) {
  return addProvider!.taxesList
      .asMap()
      .map(
        (index, element) => MapEntry(
          index,
          InkWell(
            onTap: () {
              addProvider!.selectedTaxID = index;
              addProvider!.taxId =
                  addProvider!.taxesList[addProvider!.selectedTaxID!].id;

              Navigator.of(context).pop();

              setStateNow();
            },
            child: SizedBox(
              width: double.maxFinite,
              child: Padding(
                padding: const EdgeInsets.all(
                  20.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      addProvider!.taxesList[index].title!,
                    ),
                    Text(
                      "${addProvider!.taxesList[index].percentage!}%",
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      )
      .values
      .toList();
}
