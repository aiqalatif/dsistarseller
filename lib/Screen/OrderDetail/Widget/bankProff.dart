import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../Helper/Color.dart';
import '../../../Model/OrdersModel/OrderModel.dart';
import '../../../Widget/validation.dart';

class BankProof extends StatelessWidget {
  final Order_Model model;
  const BankProof({Key? key, required this.model}) : super(key: key);

  void _launchURL(String url) async => await canLaunchUrl(Uri.parse(url))
      ? await launchUrl(Uri.parse(url))
      : throw 'Could not launch $url';

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: model.attachList!.length, //original file ma joe levu
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, i) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  child: Text(
                    "${getTranslated(context, "Attachment")!} ${i + 1}",
                    style: const TextStyle(
                        decoration: TextDecoration.underline, color: primary),
                  ),
                  onTap: () {
                    _launchURL(model.attachList![i].attachment!);
                  },
                ),
                InkWell(
                  child: const Icon(
                    Icons.delete,
                    color: fontColor,
                  ),
                  onTap: () {},
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
