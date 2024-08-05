import 'package:sellermultivendor/Model/city.dart';

import '../../Widget/parameterString.dart';
import 'Attribute.dart';
import 'FilterModel.dart';
import 'Variants.dart';

class Product {
  String? id,
      name,
      desc,
      totalStock,
      image,
      catName,
      type,
      rating,
      noOfRating,
      attrIds,
      tax,
      taxId,
      relativeImagePath,
      categoryId,
      sku,
      status,
      shortDescription,
      extraDescription,
      brandName,
      hsnCodeValue,
      stock,
      pickUpLoc;
  List<String>? otherImage;
  List<String>? showOtherImage;
  List<Product_Varient>? prVarientList;
  List<Attribute>? attributeList;
  List<String>? selectedId = [];
  List<String>? tagList = [];
  String? isFav,
      isReturnable,
      isCancelable,
      isPurchased,
      taxincludedInPrice,
      isCODAllow,
      availability,
      madein,
      indicator,
      stockType,
      cancleTill,
      total,
      banner,
      totalAllow,
      video,
      videoType,
      warranty,
      minimumOrderQuantity,
      quantityStepSize,
      madeIn,
      deliverableType,
      deliverableZipcodesIds,
      deliverableZipcodes,
      deliverableCityType,
      cancelableTill,
      description,
      downloadAllowed,
      downloadType,
      downloadLink,
      gurantee;

  bool? isFavLoading = false, isFromProd = false;
  int? offset, totalItem, selVarient;

  List<CityModel>? deliverableCities;
  List<Product>? subList;
  List<Filter>? filterList;

  Product({
    this.id,
    this.name,
    this.desc,
    this.image,
    this.catName,
    this.type,
    this.otherImage,
    this.totalStock,
    this.status,
    this.prVarientList,
    this.relativeImagePath,
    this.sku,
    this.attributeList,
    this.isFav,
    this.isCancelable,
    this.isReturnable,
    this.isCODAllow,
    this.isPurchased,
    this.hsnCodeValue,
    this.availability,
    this.noOfRating,
    this.attrIds,
    this.selectedId,
    this.rating,
    this.isFavLoading,
    this.indicator,
    this.madein,
    this.tax,
    this.taxId,
    this.brandName,
    this.shortDescription,
    this.extraDescription,
    this.total,
    this.categoryId,
    this.subList,
    this.filterList,
    this.stockType,
    this.isFromProd,
    this.showOtherImage,
    this.cancleTill,
    this.totalItem,
    this.offset,
    this.totalAllow,
    this.minimumOrderQuantity,
    this.quantityStepSize,
    this.madeIn,
    this.banner,
    this.selVarient,
    this.video,
    this.videoType,
    this.tagList,
    this.warranty,
    this.taxincludedInPrice,
    this.stock,
    this.description,
    this.deliverableType,
    this.deliverableZipcodesIds,
    this.downloadAllowed,
    this.downloadType,
    this.downloadLink,
    this.deliverableZipcodes,
    this.cancelableTill,
    this.gurantee,
    this.pickUpLoc,
    this.deliverableCities,
    this.deliverableCityType,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    List<Product_Varient> varientList = (json[Variants] as List)
        .map((data) => Product_Varient.fromJson(data))
        .toList();

    List<Attribute> attList = (json[Attributes] as List)
        .map((data) => Attribute.fromJson(data))
        .toList();

    List<CityModel> deliverableCityList = [];

    try {
      if (json['deliverable_cities'].isNotEmpty) {
        deliverableCityList.addAll((json['deliverable_cities'] as List)
            .map((e) => CityModel.fromMap(e))
            .toList());
      }
    } catch (_) {}

    var flist = (json[FILTERS] as List?);
    List<Filter> filterList = [];
    if (flist == null || flist.isEmpty) {
      filterList = [];
    } else {
      filterList = flist.map((data) => Filter.fromJson(data)).toList();
    }
    List<String> otherImage =
        List<String>.from(json["other_images_relative_path"]);

    List<String> showOtherimage = List<String>.from(json["other_images"]);

    List<String> selected = [];
    List<String> tags = List<String>.from(json[Tags]);

    return Product(
      id: json[Id],
      name: json[Name],
      desc: json[Description],
      image: json[IMage],
      totalStock: json['total_stock'].toString(),
      catName: json[CategoryName],
      rating: json[Rating],
      noOfRating: json[NoOfRatings],
      stock: json[Stock],
      type: json[Type],
      relativeImagePath: json["relative_path"],
      isFav: json[IsFavorite].toString(),
      isCancelable: json[IsCancelable],
      availability: json[Availability].toString(),
      isPurchased: json[IsPurchased].toString(),
      isReturnable: json[IsReturnable],
      otherImage: otherImage,
      showOtherImage: showOtherimage,
      hsnCodeValue: json['hsn_code'],
      prVarientList: varientList,
      sku: json["sku"],
      attributeList: attList,
      filterList: filterList,
      isFavLoading: false,
      status: json["status"],
      selVarient: 0,
      attrIds: json[AttrValueIds],
      madein: json[MadeIn],
      indicator: json[Indicator].toString(),
      stockType: json[StockType].toString(),
      tax: json[TaxPercentage],
      total: json[Total],
      categoryId: json[CategoryId],
      selectedId: selected,
      totalAllow: json[TotalAllowedQuantity],
      cancleTill: json[CancelableTill],
      shortDescription: json[ShortDescription],
      extraDescription: json[EXTRA_DESC],
      tagList: tags,
      minimumOrderQuantity: json[MinimumOrderQuantity],
      quantityStepSize: json[QuantityStepSize],
      madeIn: json[MadeIn],
      warranty: json[WarrantyPeriod],
      gurantee: json[GuaranteePeriod],
      isCODAllow: json[codAllowed],
      taxincludedInPrice: json[IsPricesInclusiveTax],
      videoType: json[VideoType],
      video: json["video_relative_path"],
      taxId: json[TaxId],
      deliverableType: json[DeliverableType],
      deliverableZipcodesIds: json[DeliverableZipcodesIds],
      deliverableZipcodes: json[DeliverableZipcodes],
      description: json[Description],
      cancelableTill: json[CancelableTill],
      downloadAllowed: json['download_allowed'],
      downloadType: json['download_type'],
      downloadLink: json['download_link'],
      brandName: json['brand'],
      pickUpLoc: json[PICKUP_LOCATION],
      deliverableCityType: json['deliverable_city_type'],
      deliverableCities: deliverableCityList,
    );
  }

  factory Product.fromCat(Map<String, dynamic> parsedJson) {
    return Product(
      id: parsedJson[Id],
      name: parsedJson[Name],
      image: parsedJson[Images],
      banner: parsedJson[BANNER],
      isFromProd: false,
      offset: 0,
      totalItem: 0,
      tax: parsedJson[TAX],
      subList: createSubList(parsedJson["children"]),
    );
  }

  static List<Product>? createSubList(List? parsedJson) {
    if (parsedJson == null || parsedJson.isEmpty) return null;

    return parsedJson.map((data) => Product.fromCat(data)).toList();
  }
}
