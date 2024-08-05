import 'package:sellermultivendor/Widget/parameterString.dart';

class Attribute {
  String? id, value, name, sType, sValue;

  Attribute({
    this.id,
    this.value,
    this.name,
    this.sType,
    this.sValue,
  });

  factory Attribute.fromJson(Map<String, dynamic> json) {
    return  Attribute(
      id: json[IDS],
      value: json[VALUE],
      name: json[AttrName],
      sType: json[SwatchType],
      sValue: json[SwatcheValue],
    );
  }
}
