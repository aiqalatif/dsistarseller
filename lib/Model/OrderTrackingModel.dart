import '../Widget/parameterString.dart';

class OrderTrackingModel {
  String? id;
  String? orderId;
  String? orderItemId;
  String? courierAgency;
  String? trackingId;
  String? url;
  String? shiprocketOrderId;
  String? shipmentId;
  String? courierCompanyId;
  String? awbCode;
  String? pickupStatus;
  String? isCanceled;
  String? labelUrl;
  String? invoiceUrl;
  String? pickUpScheduleDate;
  String? orderTrackingUrl;
  bool? createdShipRockerOrderBtn,
      awbBtn,
      sendPickUpReqBtn,
      cancelOrderBtn,
      generateLblBtn,
      generateInvoiceBtn;

  OrderTrackingModel(
      {this.id,
      this.orderId,
      this.orderItemId,
      this.courierAgency,
      this.trackingId,
      this.url,
      this.shiprocketOrderId,
      this.shipmentId,
      this.courierCompanyId,
      this.awbCode,
      this.pickupStatus,
      this.isCanceled,
      this.labelUrl,
      this.invoiceUrl,
      this.createdShipRockerOrderBtn,
      this.awbBtn,
      this.cancelOrderBtn,
      this.generateInvoiceBtn,
      this.generateLblBtn,
      this.sendPickUpReqBtn,
      this.pickUpScheduleDate,
      this.orderTrackingUrl});

  factory OrderTrackingModel.fromJson(Map<String, dynamic> json) {
    return OrderTrackingModel(
        id: json[Id],
        orderId: json[ORDER_ID],
        orderItemId: json[ORDERITEMID],
        courierAgency: json[courier_agency],
        trackingId: json[tracking_id],
        url: json[Url],
        shiprocketOrderId: json[SHIPROCKET_ORDER_ID],
        shipmentId: json[SHIPMENT_ID],
        courierCompanyId: json[COURIER_COMPANY_ID],
        awbCode: json[AWB_CODE],
        pickupStatus: json[PICKUP_STATUS],
        isCanceled: json[IS_CANCELED],
        labelUrl: json[LABEL_URL],
        invoiceUrl: json[INVOICE_URL],
        pickUpScheduleDate: json[PICKUP_SCHEDULED_DATE]);
  }
}
