import 'package:sellermultivendor/Widget/parameterString.dart';

class AttributeModel {
  String? id, name, attributeSetId, attributeSetName, status;

  AttributeModel({
    this.id,
    this.name,
    this.status,
    this.attributeSetId,
    this.attributeSetName,
  });

  factory AttributeModel.fromJson(Map<String, dynamic> json) {
    return AttributeModel(
      id: json[Id],
      name: json[Name],
      status: json[STATUS],
      attributeSetId: json[AttributeSetId],
      attributeSetName: json[AttributeSetName],
    );
  }
}
