import 'package:sellermultivendor/Widget/parameterString.dart';

class SalesReportModel {
  String? id,
      name,
      total,
      deliveryCharge,
      discountedPrice,
      taxAmount,
      paymentMethod,
      subDic,
      sellerName,
      dateAdded,
      storeName,
      finalTotal,
      size;
  bool isSelected = false;
  SalesReportModel({
    this.id,
    this.total,
    this.name,
    this.taxAmount,
    this.subDic,
    this.deliveryCharge,
    this.finalTotal,
    this.paymentMethod,
    this.storeName,
    this.size,
    this.dateAdded,
    this.sellerName,
    this.discountedPrice,
  });

  factory SalesReportModel.fromJson(Map<String, dynamic> json) {
    return SalesReportModel(
      id: json[Id],
      name: json[Name],
      total: json["total"],
      taxAmount: json["tax_amount"],
      discountedPrice: json["discounted_price"],
      deliveryCharge: json["delivery_charge"],
      finalTotal: json["final_total"],
      paymentMethod: json["payment_method"],
      storeName: json["store_name"],
      sellerName: json["seller_name"],
      dateAdded: json['date_added'],
    );
  }
}
