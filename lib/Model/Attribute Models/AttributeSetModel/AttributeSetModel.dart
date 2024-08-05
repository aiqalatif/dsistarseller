import 'package:sellermultivendor/Widget/parameterString.dart';

class AttributeSetModel {
  String? id, name, status;

  AttributeSetModel({
    this.id,
    this.name,
    this.status,
  });

  factory AttributeSetModel.fromJson(Map<String, dynamic> json) {
    return  AttributeSetModel(
      id: json[Id],
      name: json[Name],
      status: json[STATUS],
    );
  }
}
