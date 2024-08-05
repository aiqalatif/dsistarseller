import 'package:sellermultivendor/Widget/parameterString.dart';

class MinMaxPrice {
  String? minPrice,
      maxPrice,
      specialPrice,
      maxSpecialPrice,
      discountInPercentage;
  MinMaxPrice({
    this.minPrice,
    this.maxPrice,
    this.specialPrice,
    this.maxSpecialPrice,
    this.discountInPercentage,
  });
  factory MinMaxPrice.fromJson(Map<String, dynamic> json) {
    return MinMaxPrice(
      minPrice: json[MinPrice],
      maxPrice: json[MaxPrice],
      specialPrice: json[SpecialPrice],
      maxSpecialPrice: json[MaxSpecialPrice],
      discountInPercentage: json[DiscountInPercentage],
    );
  }
}
