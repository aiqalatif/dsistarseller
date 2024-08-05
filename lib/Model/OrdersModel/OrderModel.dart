import 'package:intl/intl.dart';
import 'package:sellermultivendor/Widget/parameterString.dart';
import 'AttachmentModel.dart';
import 'OrderItemsModel.dart';

class OrderTracking {
  OrderTracking({
    this.id,
    this.orderId,
    this.courierAgency,
    this.trackingId,
    this.url,
    this.orderDetails,
  });

  String? id;
  String? orderId;
  String? courierAgency;
  String? trackingId;
  String? url;
  Order_Model? orderDetails;

  factory OrderTracking.fromJson(Map<String, dynamic> json) => OrderTracking(
        id: json["id"],
        orderId: json["order_id"],
        courierAgency: json["courier_agency"],
        trackingId: json["tracking_id"],
        url: json["url"],
        orderDetails: json["order_details"] == ""
            ? null
            : Order_Model.fromJson(json["order_details"]),
      );
}

class Order_Model {
  String? id,
      name,
      mobile,
      latitude,
      longitude,
      delCharge,
      username,
      walBal,
      orderRecipientPerson,
      promo,
      promoDis,
      payMethod,
      total,
      subTotal,
      payable,
      address,
      taxAmt,
      taxPer,
      orderDate,
      dateTime,
      isCancleable,
      isReturnable,
      isAlrCancelled,
      isAlrReturned,
      rtnReqSubmitted,
      otp,
      email,
      // deliveryBoyId,
      invoice,
      delDate,
      delTime,
      countryCode,userId, notes;
  List<Attachment>? attachList = [];
  List<OrderItem>? itemList;
  List<String?>? listStatus = [];
  List<String?>? listDate = [];
  int? isShipRockerOrder;


  Order_Model({
    this.id,
    this.name,
    this.mobile,
    this.delCharge,
    this.walBal,
    this.promo,
    this.promoDis,
    this.payMethod,
    this.total,
    this.subTotal,
    this.payable,
    this.address,
    this.orderRecipientPerson,
    this.taxPer,
    this.taxAmt,
    this.orderDate,
    this.dateTime,
    this.email,
    this.itemList,
    this.listStatus,
    this.listDate,
    this.isReturnable,
    this.username,
    this.isCancleable,
    this.isAlrCancelled,
    this.isAlrReturned,
    this.rtnReqSubmitted,
    this.otp,
    this.invoice,
    this.latitude,
    this.longitude,
    this.delDate,
    this.delTime,
    // this.deliveryBoyId,
    this.countryCode,
    this.isShipRockerOrder,
    this.userId,
    this.notes
  });


  factory Order_Model.fromJson(Map<String, dynamic> parsedJson) {
    List<OrderItem> itemList = [];
    var order = (parsedJson[OrderItemss] as List?);
    itemList = order!.map((data) => OrderItem.fromJson(data)).toList();
    String date = parsedJson[DateAdded];

    date = DateFormat('dd-MM-yyyy').format(DateTime.parse(date));

    List<String?> lStatus = [];
    List<String?> lDate = [];

    return Order_Model(
      id: parsedJson[Id],
      name: parsedJson[Username],
      mobile: parsedJson[Mobile],
      delCharge: parsedJson[DeliveryCharge],
      walBal: parsedJson[WalletBalance],
      promo: parsedJson[PromoCode],
      promoDis: parsedJson[PromoDiscount],
      payMethod: parsedJson[PaymentMethod],
      total: parsedJson[FinalTotal],
      subTotal: parsedJson[Total],
      payable: parsedJson[TotalPayable],
      address: parsedJson[Address],
      username: parsedJson['username'],
      taxAmt: parsedJson[TotalTaxAmount],
      taxPer: parsedJson[TotalTaxPercent],
      dateTime: parsedJson[DateAdded],
      isCancleable: parsedJson[IsCancelable],
      isReturnable: parsedJson[IsReturnable],
      orderRecipientPerson: parsedJson["order_recipient_person"],
      isAlrCancelled: parsedJson[IsAlreadyCancelled],
      isAlrReturned: parsedJson[IsAlreadyReturned],
      rtnReqSubmitted: parsedJson[ReturnRequestSubmitted],
      orderDate: date,
      itemList: itemList,
      listStatus: lStatus,
      listDate: lDate,
      otp: parsedJson[Otp],
      latitude: parsedJson[Latitude],
      email: parsedJson['email'],
      longitude: parsedJson[Longitude],
      countryCode: parsedJson[COUNTRY_CODE],
      delDate: parsedJson[DeliveryDate] != ""
          ? DateFormat('dd-MM-yyyy')
              .format(DateTime.parse(parsedJson[DeliveryDate]))
          : '',
      delTime: parsedJson[DeliveryTime] ?? '',
      isShipRockerOrder: parsedJson[IS_SHIPROCKET_ORDER],
      userId: parsedJson[UserId],
      notes: parsedJson["notes"]
      //deliveryBoyId: parsedJson[Delivery_Boy_Id]
    );
  }
}
