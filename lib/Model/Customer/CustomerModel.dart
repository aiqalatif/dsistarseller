import 'package:intl/intl.dart';

class Customer {
  String? id,
      name,
      mobile,
      email,
      balance,
      city,
      image,
      area,
      street,
      status,
      date;
  Customer({
    this.id,
    this.name,
    this.mobile,
    this.email,
    this.balance,
    this.city,
    this.image,
    this.area,
    this.street,
    this.status,
    this.date,
  });

  Customer.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    mobile = json['mobile'];
    email = json['email'];
    balance = json['balance'];
    city = json['city'];
    image = json['image'];
    area = json['area'];
    street = json['street'];
    status = json['status'];
    date = json['date'] != null
        ? DateFormat('dd-MM-yyyy').format(
            DateTime.parse(
              json['date'],
            ),
          )
        : '';
  }
}
