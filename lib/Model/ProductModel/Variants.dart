import 'package:sellermultivendor/Widget/parameterString.dart';

class Product_Varient {
  String? id,
      productId,
      attribute_value_ids,
      price,
      disPrice,
      type,
      attr_name,
      varient_value,
      availability,
      cartCount,
      stock,
      status,
      sku,
      stockStatus = '1',
      height,
      weight,
      breadth,
      length;

  List<String>? images;
  List<String>? imagesUrl;
  List<String>? imageRelativePath;

  Product_Varient(
      {this.id,
      this.productId,
      this.attr_name,
      this.varient_value,
      this.price,
      this.disPrice,
      this.attribute_value_ids,
      this.availability,
      this.cartCount,
      this.stock,
      this.imageRelativePath,
      this.images,
      this.imagesUrl,
      this.sku,
      this.stockStatus = '1',
      this.length,
      this.breadth,
      this.height,
      this.weight,
      this.status});

  factory Product_Varient.fromJson(Map<String, dynamic> json) {
    List<String> images = List<String>.from(json[Images]);
    List<String> variantRelativePath =
        List<String>.from(json["variant_relative_path"]);

    return Product_Varient(
      id: json[Id],
      attribute_value_ids: json[AttributeValueIds],
      productId: json[ProductId],
      attr_name: json[AttrName],
      varient_value: json[VariantValues],
      disPrice: json[SpecialPrice],
      price: json[Price],
      availability: json[Availability].toString(),
      cartCount: json[CartCount],
      stock: json[Stock],
      status: json[Status] ?? "",
      imageRelativePath: variantRelativePath,
      sku: json['sku'],
      images: images,
      weight: json[WEIGHT],
      height: json[HEIGHT],
      breadth: json[BREADTH],
      length: json[LENGTH],
    );
  }

// fromVariation(
//     String id,
//     String att,
//     String disPrice,
//     String price,
//     String stockType,
//     List<String> images,
//     List<String> imagesUrl,
//     String sku,
//     String stock,
//     String totalStock,
//     String stkStatus) {
//   return Product_Varient(
//       id: id,
//       attr_name: att,
//       disPrice: disPrice,
//       price: price,
//       images: images,
//       imagesUrl: imagesUrl,
//       sku: sku,
//       stockType: stockType,
//       stock: totalStock,
//       stockStatus: stkStatus);
// }
}
