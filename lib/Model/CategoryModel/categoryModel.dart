import 'package:sellermultivendor/Widget/parameterString.dart';

class CategoryModel {
  String? id, name; // children;
  List<CategoryModel>? children;
  CategoryModel({
    this.id,
    this.name,
    this.children,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json[Id],
      name: json[Name],
      //  children: json[Percentage],
      children: List<CategoryModel>.from(
        json["children"].map(
          (x) => CategoryModel.fromJson(x),
        ),
      ),
    );
  }
}
