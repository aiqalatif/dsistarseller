import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../Helper/Color.dart';
import '../../../Helper/Constant.dart';
import '../../../Model/OrdersModel/OrderModel.dart';
import '../../../Widget/desing.dart';
import '../../../Widget/parameterString.dart';
import '../../../Widget/validation.dart';
import '../../HomePage/home.dart';
import '../../OrderDetail/OrderDetail.dart';
import '../OrderList.dart';

class OrderIteam extends StatelessWidget {
  final int index;
  final Function update;

  const OrderIteam({
    Key? key,
    required this.index,
    required this.update,
  }) : super(key: key);

  _launchCaller(String phone) async {
    var url = "tel:$phone";
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    Order_Model model = orderListProvider!.orderList[index];
    Color back;

    if ((model.itemList![0].activeStatus!) == DELIVERD) {
      back = Colors.green;
    } else if ((model.itemList![0].activeStatus!) == SHIPED) {
      back = Colors.orange;
    } else if ((model.itemList![0].activeStatus!) == CANCLED ||
        model.itemList![0].activeStatus! == RETURNED) {
      back = red;
    } else if ((model.itemList![0].activeStatus!) == PROCESSED) {
      back = Colors.indigo;
    } else if ((model.itemList![0].activeStatus!) == PROCESSED) {
      back = Colors.indigo;
    } else if (model.itemList![0].activeStatus! == "awaiting") {
      back = Colors.black;
    } else if (model.itemList![0].status! == 'return_request_decline') {
      back = Colors.red;
    } else if (model.itemList![0].status! == 'return_request_pending') {
      back = Colors.indigo.withOpacity(0.85);
    } else {
      back = Colors.cyan;
    }
    return Padding(
      padding: const EdgeInsets.only(top: 12.0),
      child: Container(
        decoration: const BoxDecoration(
          borderRadius:
              BorderRadius.all(Radius.circular(circularBorderRadius5)),
          boxShadow: [
            BoxShadow(
              color: blarColor,
              offset: Offset(0, 0),
              blurRadius: 4,
              spreadRadius: 0,
            ),
          ],
          color: white,
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(circularBorderRadius5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsetsDirectional.only(
                  top: 08.0,
                  start: 21,
                  end: 12,
                  bottom: 00,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Row(
                      children: [
                        Text(
                          "${getTranslated(context, "Order_No")!}.",
                          style: const TextStyle(
                              color: grey, fontSize: textFontSize14),
                        ),
                        Text(
                          model.id!,
                          style: const TextStyle(color: black),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 2),
                      decoration: BoxDecoration(
                        color: back,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(
                            circularBorderRadius5,
                          ),
                        ),
                      ),
                      child: Text(
                        () {
                          if (StringValidation.capitalize(model.itemList![0].activeStatus!) ==
                              "Received") {
                            return getTranslated(context, "RECEIVED_LBL")!;
                          } else if (StringValidation.capitalize(model.itemList![0].activeStatus!) ==
                              "Processed") {
                            return getTranslated(context, "PROCESSED_LBL")!;
                          } else if (StringValidation.capitalize(
                                  model.itemList![0].activeStatus!) ==
                              "Shipped") {
                            return getTranslated(context, "SHIPED_LBL")!;
                          } else if (StringValidation.capitalize(
                                  model.itemList![0].activeStatus!) ==
                              "Delivered") {
                            return getTranslated(context, "DELIVERED_LBL")!;
                          } else if (StringValidation.capitalize(
                                  model.itemList![0].activeStatus!) ==
                              "Awaiting") {
                            return getTranslated(context, "AWAITING_LBL")!;
                          } else if (StringValidation.capitalize(
                                  model.itemList![0].activeStatus!) ==
                              "Cancelled") {
                            return getTranslated(context, "CANCELLED_LBL")!;
                          } else if (StringValidation.capitalize(
                                  model.itemList![0].activeStatus!) ==
                              "Returned") {
                            return getTranslated(context, "RETURNED_LBL")!;
                          } else if (StringValidation.capitalize(
                                  model.itemList![0].activeStatus!) ==
                              "Return_request_pending") {
                            return getTranslated(
                                context, "RETURN_REQUEST_PENDING_LBL")!;
                          } else if (StringValidation.capitalize(
                                  model.itemList![0].activeStatus!) ==
                              "Return_request_approved") {
                            return getTranslated(
                                context, "RETURN_REQUEST_APPROVE_LBL")!;
                          } else if (StringValidation.capitalize(
                                  model.itemList![0].activeStatus!) ==
                              "Return_request_decline") {
                            return getTranslated(
                                context, "RETURN_REQUEST_DECLINE_LBL")!;
                          } else {
                            return StringValidation.capitalize(
                                model.itemList![0].activeStatus!);
                          }
                        }(),
                        style: const TextStyle(color: white),
                      ),
                    )
                  ],
                ),
              ),
              const Divider(),
              Padding(
                padding: const EdgeInsets.only(
                    right: 21.0, left: 21.0, bottom: 10, top: 5),
                child: Row(
                  children: [
                    Flexible(
                      child: Row(
                        children: [
                          const Icon(
                            Icons.person,
                            size: 20,
                            color: black,
                          ),
                          const SizedBox(width: 08),
                          Expanded(
                            child: Text(
                              model.name != null && model.name!.isNotEmpty
                                  ? " ${StringValidation.capitalize(model.name!)}"
                                  : " ",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(color: black),
                            ),
                          ),
                        ],
                      ),
                    ),
                    customerViewPermission
                        ? InkWell(
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.call,
                                  size: 20,
                                  color: black,
                                ),
                                const SizedBox(width: 08),
                                Text(
                                  " ${model.mobile!}",
                                  style: const TextStyle(
                                      color: black,
                                      decoration: TextDecoration.underline),
                                ),
                              ],
                            ),
                            onTap: () {
                              _launchCaller(model.mobile!);
                            },
                          )
                        : const SizedBox.shrink()
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(right: 21.0, left: 21.0, bottom: 10),
                child: Row(
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.money,
                          size: 20,
                          color: black,
                        ),
                        const SizedBox(width: 08),
                        Row(
                          children: [
                            Text(
                              " ${getTranslated(context, "PayableTXT")!}: ",
                              style: const TextStyle(color: grey),
                            ),
                            Text(
                              " ${DesignConfiguration.getPriceFormat(context, double.parse(model.payable!))!}",
                              style: const TextStyle(color: black),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        const Icon(
                          Icons.payment,
                          size: 20,
                          color: black,
                        ),
                        const SizedBox(width: 08),
                        Text(
                          " ${model.payMethod!}",
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(right: 21.0, left: 21.0, bottom: 10),
                child: Row(
                  children: [
                    const Icon(
                      Icons.date_range,
                      size: 20,
                      color: black,
                    ),
                    const SizedBox(width: 08),
                    Row(
                      children: [
                        Text(
                          " ${getTranslated(context, "ORDER_DATE")!}: ",
                          style: const TextStyle(color: grey),
                        ),
                        Text(
                          model.orderDate!,
                          style: const TextStyle(color: black),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
          onTap: () async {
            await Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (context) => OrderDetail(
                  id: model.id,
                  update: update,
                ),
              ),
            ) /* .then(
              (value) {
                orderListProvider!.initializeAllVariable();
                orderListProvider!.scrollOffset = 0;
                Future.delayed(
                  Duration.zero,
                  () {
                    orderListProvider!.appBarTitle = Text(
                      getTranslated(context, "Orders")!,
                      style: const TextStyle(color: grad2Color),
                    );
                  },
                );

                orderListProvider!.getOrder(update, context);
                update();
              },
            ) */
                ;
          },
        ),
      ),
    );
  }
}
