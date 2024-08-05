import 'package:sellermultivendor/Widget/parameterString.dart';

class TaxesModel {
  String? id, title, percentage, status;

  TaxesModel({
    this.id,
    this.title,
    this.percentage,
    this.status,
  });

  factory TaxesModel.fromJson(Map<String, dynamic> json) {
    return TaxesModel(
      id: json[Id],
      title: json[Title],
      percentage: json[Percentage],
      status: json[STATUS],
    );
  }

  @override
  String toString() {
    return title!;
  }

  ///this method will prevent the override of toString
  String userAsString() {
    return '#$id $title';
  }
}
