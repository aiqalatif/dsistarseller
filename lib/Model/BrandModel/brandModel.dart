import '../../Widget/parameterString.dart';

class BrandModel {
  String? id, name, image;
  BrandModel({
    this.id,
    this.name,
    this.image,
  });

  factory BrandModel.fromJson(Map<String, dynamic> json) {
    return BrandModel(
      id: json[Id],
      name: json[Name],
      image: json[IMage],
    );
  }
}
