import 'package:flutter/material.dart';
import '../../../../Helper/Color.dart';
import '../../../../Helper/Constant.dart';
import '../../../../Widget/validation.dart';
import '../../EditProduct.dart';

taxesDialog(
  BuildContext context,
  Function update,
) async {
  await showModalBottomSheet(
    isScrollControlled: true,
    context: context,
    backgroundColor: Colors.transparent,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setStater) {
          editProvider!.taxesState = setStater;
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
                      children: getTaxtList(context, update),
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

List<Widget> getTaxtList(
  BuildContext context,
  Function update,
) {
  return editProvider!.taxesList
      .asMap()
      .map(
        (index, element) => MapEntry(
          index,
          InkWell(
            onTap: () {
              editProvider!.selectedTaxID = index;
              editProvider!.taxId =
                  editProvider!.taxesList[editProvider!.selectedTaxID!].id;
              Navigator.of(context).pop();
              update();
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
                      editProvider!.taxesList[index].title!,
                    ),
                    Text(
                      "${editProvider!.taxesList[index].percentage!}%",
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
