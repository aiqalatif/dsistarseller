import 'package:flutter/material.dart';
import '../../../Helper/Constant.dart';
import '../../../Widget/validation.dart';
import '../Profile.dart';
import 'commanDesingFields.dart';

class GetThirdHeader extends StatelessWidget {
  final Function setStateNow;
  const GetThirdHeader({
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
              icon: Icons.format_list_numbered_outlined,
              title: getTranslated(context, "AccountNumber")!,
              variable: profileProvider!.accNo,
              empty: getTranslated(context, "NotAdded")!,
              addField: getTranslated(context, "addAccontNumber")!,
              key: profileProvider!.accnumberKey,
              keybordtype: TextInputType.text,
              validation: (val) => StringValidation.validateField(val, context),
              index: 7,
              update: setStateNow,
              fromMap: false,
            ),
            getDivider(),
            CommanDesingFields(
              icon: Icons.import_contacts_outlined,
              title: getTranslated(context, "AccountName")!,
              variable: profileProvider!.accname,
              empty: getTranslated(context, "NotAdded")!,
              addField: getTranslated(context, "addAccountName")!,
              key: profileProvider!.accnameKey,
              keybordtype: TextInputType.text,
              validation: (val) => StringValidation.validateField(val, context),
              index: 8,
              update: setStateNow,
              fromMap: false,
            ),
            getDivider(),
            CommanDesingFields(
              icon: Icons.request_quote_outlined,
              title: getTranslated(context, "BankCode")!,
              variable: profileProvider!.bankcode,
              empty: getTranslated(context, "NotAdded")!,
              addField: getTranslated(context, "addBankCode")!,
              key: profileProvider!.bankcodeKey,
              keybordtype: TextInputType.text,
              validation: (val) => StringValidation.validateField(val, context),
              index: 9,
              update: setStateNow,
              fromMap: false,
            ),
            getDivider(),
            CommanDesingFields(
              icon: Icons.account_balance_outlined,
              title: getTranslated(context, "BankName")!,
              variable: profileProvider!.bankname,
              empty: getTranslated(context, "NotAdded")!,
              addField: getTranslated(context, "addBankName")!,
              key: profileProvider!.banknameKey,
              keybordtype: TextInputType.text,
              validation: (val) => StringValidation.validateField(val, context),
              index: 10,
              update: setStateNow,
              fromMap: false,
            ),
          ],
        ),
      ),
    );
  }
}
