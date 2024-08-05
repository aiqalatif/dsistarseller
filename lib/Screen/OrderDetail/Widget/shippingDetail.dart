import 'dart:io';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../Helper/Color.dart';
import '../../../Helper/Constant.dart';
import '../../../Model/OrdersModel/OrderModel.dart';
import '../../../Widget/validation.dart';
import '../../HomePage/home.dart';

class ShippingDetail extends StatelessWidget {
  final List<Order_Model> tempList;

  const ShippingDetail({
    Key? key,
    required this.tempList,
  }) : super(key: key);

  _launchCaller() async {
    var url = "tel:${tempList[0].mobile}";
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return customerViewPermission
        ? Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Container(
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                borderRadius:
                    BorderRadius.all(Radius.circular(circularBorderRadius5)),
                color: white,
                boxShadow: [
                  BoxShadow(
                      color: blarColor,
                      offset: Offset(0, 0),
                      blurRadius: 4,
                      spreadRadius: 0),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 15.0, vertical: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          getTranslated(context, "SHIPPING_DETAIL")!,
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall!
                              .copyWith(
                                  color: primary,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: "PlusJakartaSans",
                                  fontStyle: FontStyle.normal,
                                  fontSize: textFontSize13),
                        ),
                        const Spacer(),
                        SizedBox(
                          height: 30,
                          child: IconButton(
                            icon: const Icon(
                              Icons.location_on,
                              color: primary,
                            ),
                            onPressed: () async {
                              var url = '';
                              if (Platform.isAndroid) {
                                url =
                                    "https://www.google.com/maps/dir/?api=1&destination=${tempList[0].latitude},${tempList[0].longitude}&travelmode=driving&dir_action=navigate";
                              } else {
                                url =
                                    "http://maps.apple.com/?saddr=&daddr=${tempList[0].latitude},${tempList[0].longitude}&directionsmode=driving&dir_action=navigate";
                              }
                              await launchUrl(
                                Uri.parse(url),
                                mode: LaunchMode.externalApplication,
                              );
                            },
                          ),
                        )
                      ],
                    ),
                    const Divider(
                      color: grey3,
                    ),
                    Text(
                      tempList[0].orderRecipientPerson != null &&
                              tempList[0].orderRecipientPerson!.isNotEmpty
                          ? StringValidation.capitalize(
                              tempList[0].orderRecipientPerson!)
                          : " ",
                      style: const TextStyle(
                        color: black,
                        fontWeight: FontWeight.w400,
                        fontFamily: "PlusJakartaSans",
                        fontStyle: FontStyle.normal,
                        fontSize: textFontSize13,
                      ),
                    ),
                    Text(
                      () {
                        return tempList[0].address != null ||
                                tempList[0].address != ""
                            ? StringValidation.capitalize(tempList[0].address!)
                            : "";
                      }(),
                      style: const TextStyle(
                        fontFamily: 'PlusJakartaSans',
                        color: grey3,
                        fontSize: textFontSize13,
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.normal,
                      ),
                    ),
                    InkWell(
                      onTap: _launchCaller,
                      child: Row(
                        children: [
                          const Icon(
                            Icons.call,
                            size: 15,
                            color: primary,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            tempList[0].mobile!,
                            style: const TextStyle(
                              color: primary,
                              fontFamily: 'PlusJakartaSans',
                              fontSize: textFontSize13,
                              fontWeight: FontWeight.w400,
                              fontStyle: FontStyle.normal,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        : const SizedBox();
  }
}
