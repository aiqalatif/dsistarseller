import '../../Widget/parameterString.dart';

class CountryModel {
  String? id, name;

  CountryModel({
    this.id,
    this.name,
  });

  factory CountryModel.fromJson(Map<String, dynamic> json) {
    return CountryModel(
      id: json[Id],
      name: json[Name],
    );
  }
}
