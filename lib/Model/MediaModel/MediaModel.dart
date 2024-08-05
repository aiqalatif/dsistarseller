import 'package:sellermultivendor/Widget/parameterString.dart';

class MediaModel {
  String? id, name, image, extention, subDic, size, path;
  bool isSelected = false;
  MediaModel({
    this.id,
    this.name,
    this.image,
    this.extention,
    this.subDic,
    this.size,
    this.isSelected = false,
    this.path,
  });

  factory MediaModel.fromJson(Map<String, dynamic> json) {
    return MediaModel(
      id: json[Id],
      name: json[Name],
      image: json[IMage],
      extention: json[EXTENSION],
      size: json[SIZE],
      subDic: json[SUB_DIC],
      path: json["relative_path"],
      isSelected: false,
    );
  }
}
