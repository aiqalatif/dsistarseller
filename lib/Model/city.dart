class CityModel {
  String id;
  String name;

  CityModel({
    required this.id,
    required this.name,
  });

  factory CityModel.fromMap(Map<String, dynamic> map) {
    return CityModel(
      id: map['id'].toString(),
      name: map['name'] ?? "",
    );
  }
  @override
  bool operator ==(other) => other is CityModel && id == other.id;
}
