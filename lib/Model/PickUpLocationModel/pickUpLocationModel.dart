import '../../Widget/parameterString.dart';

class PickUpLocationModel {
  String? id,
      sellerId,
      pickupLoc,
      email,
      phone,
      address,
      address2,
      city,
      state,
      country,
      pinCode,
      name;

  PickUpLocationModel(
      {this.id,
      this.name,
      this.sellerId,
      this.country,
      this.phone,
      this.state,
      this.email,
      this.address,
      this.address2,
      this.city,
      this.pickupLoc,
      this.pinCode});

  factory PickUpLocationModel.fromJson(Map<String, dynamic> json) {
    return PickUpLocationModel(
      id: json[Id],
      name: json[Name],
      // sellerId: json[SellerId],
      pickupLoc: json[PICKUP_LOCATION],
      email: json[EmailText],
      phone: json[PHONE],
      address: json[Address],
      address2: json[Address2],
      city: json[City],
      state: json[STATE],
      country: json[COUNTRY],
      pinCode: json[PIN_CODE],
    );
  }
}
