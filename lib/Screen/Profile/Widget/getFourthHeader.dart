import 'package:flutter/material.dart';
import '../../../Helper/Constant.dart';
import '../../../Widget/validation.dart';
import '../Profile.dart';
import 'commanDesingFields.dart';

class GetFurthHeader extends StatelessWidget {
  final Function setStateNow;

  const GetFurthHeader({
    Key? key,
    required this.setStateNow,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 5.0),
      child: Card(
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(circularBorderRadius10),
          ),
        ),
        child: Column(
          children: <Widget>[
            CommanDesingFields(
              icon: Icons.travel_explore_outlined,
              title: getTranslated(context, "Latitude")!,
              variable: profileProvider!.latitutute,
              empty: getTranslated(context, "NotAdded")!,
              addField: getTranslated(context, "AddLatitude")!,
              key: profileProvider!.latitututeKey,
              keybordtype: TextInputType.text,
              validation: (val) => StringValidation.validateField(val, context),
              index: 11,
              update: setStateNow,
              fromMap: true,
            ),
            getDivider(),
            CommanDesingFields(
              icon: Icons.language_outlined,
              title: getTranslated(context, "Longitude")!,
              variable: profileProvider!.longitude,
              empty: getTranslated(context, "NotAdded")!,
              addField: getTranslated(context, "AddLongitude")!,
              key: profileProvider!.longituteKey,
              keybordtype: TextInputType.text,
              validation: (val) => StringValidation.validateField(val, context),
              index: 12,
              update: setStateNow,
              fromMap: true,
            ),
            getDivider(),
            CommanDesingFields(
              icon: Icons.text_snippet_outlined,
              title: getTranslated(context, "TaxName")!,
              variable: profileProvider!.taxname,
              empty: getTranslated(context, "NotAdded")!,
              addField: getTranslated(context, "addTaxName")!,
              key: profileProvider!.taxnameKey,
              keybordtype: TextInputType.text,
              validation: (val) => StringValidation.validateField(val, context),
              index: 13,
              update: setStateNow,
              fromMap: false,
            ),
            getDivider(),
            CommanDesingFields(
              icon: Icons.assignment_outlined,
              title: getTranslated(context, "TaxNumber")!,
              variable: profileProvider!.taxnumber,
              empty: getTranslated(context, "NotAdded")!,
              addField: getTranslated(context, "addTaxNumber")!,
              key: profileProvider!.taxnumberKey,
              keybordtype: TextInputType.text,
              validation: (val) => StringValidation.validateField(val, context),
              index: 14,
              update: setStateNow,
              fromMap: false,
            ),
            getDivider(),
            CommanDesingFields(
              icon: Icons.picture_in_picture_outlined,
              title: getTranslated(context, "PanNumber")!,
              variable: profileProvider!.pannumber,
              empty: getTranslated(context, "NotAdded")!,
              addField: getTranslated(context, "addPanNumber")!,
              key: profileProvider!.pannumberKey,
              keybordtype: TextInputType.text,
              validation: (val) => StringValidation.validateField(val, context),
              index: 15,
              update: setStateNow,
              fromMap: false,
            ),
            getDivider(),
            CommanDesingFields(
              icon: Icons.history_edu,
              title: getTranslated(context, "Authorized Signature")!,
              variable: profileProvider!.authSign,
              empty: getTranslated(context, "NotAdded")!,
              addField: getTranslated(context, "Add Authorized Signature")!,
              index: 16,
              update: setStateNow,
              fromMap: false,
            ),
          ],
        ),
      ),
    );
  }

  Widget authSignField() {
    return Row(
      children: const [],
    );
  }
}
