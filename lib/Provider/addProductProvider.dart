import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:sellermultivendor/Model/PickUpLocationModel/PickUpLocationModel.dart';
import 'package:sellermultivendor/Model/city.dart';
import 'package:sellermultivendor/Provider/settingProvider.dart';
import 'package:sellermultivendor/Repository/appSettingsRepository.dart';
import '../Model/Attribute Models/AttributeModel/AttributesModel.dart';
import '../Model/Attribute Models/AttributeSetModel/AttributeSetModel.dart';
import '../Model/Attribute Models/AttributeValueModel/AttributeValue.dart';
import '../Model/BrandModel/brandModel.dart';
import '../Model/CategoryModel/categoryModel.dart';
import '../Model/ProductModel/Variants.dart';
import '../Model/TaxesModel/TaxesModel.dart';
import '../Model/ZipCodesModel/ZipCodeModel.dart';
import '../Model/Country/countryModel.dart';
import '../Widget/api.dart';
import '../Widget/security.dart';
import '../Widget/networkAvailablity.dart';
import 'package:http/http.dart' as http;
import '../Widget/parameterString.dart';
import '../Widget/snackbar.dart';
import '../Widget/validation.dart';

enum AddProductStatus {
  initial,
  inProgress,
  isSuccsess,
  isFailure,
}

class AddProductProvider extends ChangeNotifier {
// update status

  AddProductStatus addProductStatus = AddProductStatus.initial;

  changeStatus(AddProductStatus status) {
    addProductStatus = status;
    notifyListeners();
  }

  freshInitializationOfAddProduct() {
    hsnCode = null;
    digitalPrice = null;
    productName = null;
    sortDescription = null;
    extraDescription = null;
    digitalProductName = '';
    tags = null;
    taxId = null;
    indicatorValue = null;
    madeIn = null;
    totalAllowQuantity = null;
    minOrderQuantity = null;
    quantityStepSize = null;
    warrantyPeriod = null;
    guaranteePeriod = null;
    deliverabletypeValue = "1";
    deliverableZipcodes = null;
    deliverableCities.clear();
    taxincludedinPrice = "0";
    isCODAllow = "0";
    isReturnable = "0";
    isCancelable = "0";
    tillwhichstatus = null;
    selectedCatName = null;
    selectedTaxID = null;
    isToggled = false;
    isreturnable = false;
    digitalProductDownloaded = false;
    isCODallow = false;
    iscancelable = false;
    taxincludedInPrice = false;
    attributeIndiacator = 0;
    selCityPos = -1;
    country = null;
    countryState = null;
    isLoadingMoreCity = null;
    countryOffset = 0;
    countryLoading = true;
    countrySearchLIst = [];
    isProgress = false;
    countryList = [];
    attrController = [];
    selectedTypeOfVideo = null;
    selectedDigitalProductTypeOfDownloadLink = null;
    videoUrl = null;
    videoOfProduct = null;
    description = null;
    selectedCatID = null;
    productType = null;
    variantStockLevelType = "product_level";
    curSelPos = 0;
    simpleproductStockStatus = "1";
    simpleproductPrice = null;
    simpleproductSpecialPrice = null;
    simpleproductSKU = null;
    simpleproductTotalStock = null;
    variantStockStatus = "0";
    finalAttList = [];
    tempAttList = [];
    variantsIds = null;
    variantPrice = null;
    variantSpecialPrice = null;
    variantImages = null;
    variantproductSKU = null;
    variantproductTotalStock = null;
    stockStatus = '1';
    variantSku = null;
    variantTotalStock = null;
    variantLevelStockStatus = null;
    isStockSelected = null;
    simpleProductSaveSettings = false;
    digitalProductSaveSettings = false;
    variantProductProductLevelSaveSettings = false;
    variantProductVariableLevelSaveSettings = false;
    selectedBrandName = null;
    selectedPickUpLocation = null;

    selectedDigitalLinkType = null;
    selectedBrandId = null;
    taxesList = [];
    attributeSetList = [];
    attributesList = [];
    attributesValueList = [];
    zipSearchList = [];
    catagorylist = [];
    variationBoolList = [];
    attrId = [];
    attrValId = [];
    attrVal = [];
    brandList = [];
    tempBrandList = [];
    brandLoading = true;
    brandOffset = 0;
    brandState = null;
    isLoadingMoreBrand = null;

    pickUpLocationList = [];
    temppickUpLocationList = [];
    locationLoading = true;
    locationOffset = 0;
    pickUpLocationState = null;
    isLoadingMoreLocation = null;

    data = null;
    suggessionisNoData = false;
    mainImageProductImage = null;
    otherPhotos = [];
    otherPhotosFromGellery = [];
    otherImageUrl = [];
    variationList = [];
    currentPage = 1;
    productNameControlller.clear();
    sortDescriptionControlller.clear();
    extraDescriptionControlller.clear();
    tagsControlller.clear();
    totalAllowController.clear();
    minOrderQuantityControlller.clear();
    quantityStepSizeControlller.clear();
    madeInControlller.clear();
    warrantyPeriodController.clear();
    guaranteePeriodController.clear();
    vidioTypeController.clear();
    simpleProductPriceController.clear();
    simpleProductSpecialPriceController.clear();
    simpleProductSKUController.clear();
    simpleProductTotalStock.clear();
    variountProductSKUController.clear();
    variountProductTotalStock.clear();
    countryController.clear();
    hsnCodeController.clear();
    digitalPriceController.clear();
    digitalSpecialController.clear();
    selfHostedDigitalProductURLController.clear();
    weightController.clear();
    heightController.clear();
    breadthController.clear();
    lengthController.clear();
    resultAttr = [];
    resultID = [];
    selectedAttributeValues = {};
    row = 1;
    height = null;
    weight = null;
    breadth = null;
    length = null;
  }

  int row = 1;
  List<String> resultAttr = [];
  List<String> resultID = [];
  Map<String, List<AttributeValueModel>> selectedAttributeValues = {};

// <===  curent selected page ===>

  int currentPage = 1;

  get currentPageValue => currentPage;

  setCurrentPageValue(int value) {
    currentPage = value;
    notifyListeners();
  }

  FocusNode? productFocus,
      sortDescriptionFocus,
      extraDescriptionFocus,
      tagFocus,
      totalAllowFocus,
      minOrderFocus,
      quantityStepSizeFocus,
      madeInFocus,
      warrantyPeriodFocus,
      guaranteePeriodFocus,
      vidioTypeFocus,
      simpleProductPriceFocus,
      simpleProductSpecialPriceFocus,
      simpleProductSKUFocus,
      simpleProductTotalStockFocus,
      variountProductSKUFocus,
      variountProductTotalStockFocus,
      hsnCodeFucosNode,
      rawKeyboardListenerFocus,
      tempFocusNode,
      attributeFocus,
      digitalPriceFocus,
      digitalSpecialFocus,
      selfHostedFocus,
      weightFocus,
      heightFocus,
      breadthFocus,
      lengthFocus = FocusNode();

//------------------------------------------------------------------------------
//======================= TextEditingController ================================

  TextEditingController productNameControlller = TextEditingController();
  TextEditingController sortDescriptionControlller = TextEditingController();
  TextEditingController extraDescriptionControlller = TextEditingController();
  TextEditingController tagsControlller = TextEditingController();
  TextEditingController totalAllowController = TextEditingController();
  TextEditingController minOrderQuantityControlller = TextEditingController();
  TextEditingController quantityStepSizeControlller = TextEditingController();
  TextEditingController madeInControlller = TextEditingController();
  TextEditingController warrantyPeriodController = TextEditingController();
  TextEditingController guaranteePeriodController = TextEditingController();
  TextEditingController vidioTypeController = TextEditingController();
  TextEditingController simpleProductPriceController = TextEditingController();
  TextEditingController simpleProductSpecialPriceController =
      TextEditingController();
  TextEditingController simpleProductSKUController = TextEditingController();
  TextEditingController simpleProductTotalStock = TextEditingController();
  TextEditingController variountProductSKUController = TextEditingController();
  TextEditingController variountProductTotalStock = TextEditingController();
  final TextEditingController countryController = TextEditingController();
  final ScrollController countryScrollController = ScrollController();
  TextEditingController hsnCodeController = TextEditingController();
  TextEditingController digitalPriceController = TextEditingController();
  TextEditingController digitalSpecialController = TextEditingController();
  TextEditingController selfHostedDigitalProductURLController =
      TextEditingController();
  TextEditingController weightController = TextEditingController();
  TextEditingController heightController = TextEditingController();
  TextEditingController breadthController = TextEditingController();
  TextEditingController lengthController = TextEditingController();

// <===  product data ===>
  String? hsnCode; //hsn_code
  String? productName; //pro_input_name
  String? sortDescription; // short_description
  String? extraDescription; // extra_description
  String? tags; // Tags
  String? taxId; // Tax (pro_input_tax)
  String? indicatorValue; // indicator
  bool currentSellectedProductIsPysical = true;
  String? madeIn; //made_in
  String? totalAllowQuantity; // total_allowed_quantity
  String? minOrderQuantity; // minimum_order_quantity
  String? quantityStepSize; // quantity_step_size
  String? warrantyPeriod; //warranty_period
  String? guaranteePeriod; //guarantee_period
  String? deliverabletypeValue = "1"; //deliverable_type
  List<CityModel> deliverableCities = [];
  String? deliverableZipcodes; //deliverable_zipcodes
  String? taxincludedinPrice = "0"; //is_prices_inclusive_tax
  String? isCODAllow = "0"; //cod_allowed
  String? isReturnable = "0"; //is_returnable
  String? isCancelable = "0"; //is_cancelable
  String? tillwhichstatus; //cancelable_till
  // => Variable For UI ...
  String? selectedCatName; // for UI
  int? selectedTaxID; // for UI
  //on-off toggles
  bool isToggled = false;
  bool isreturnable = false;
  bool isCODallow = false;
  bool iscancelable = false;
  bool taxincludedInPrice = false;
  bool digitalProductDownloaded = false;

//for remove extra add
  int attributeIndiacator = 0;

  //
  int? selCityPos = -1;
  String? country;
  StateSetter? countryState;
  bool? isLoadingMoreCity;
  int countryOffset = 0;
  bool countryLoading = true;
  List<CountryModel> countrySearchLIst = [];
  bool isProgress = false;
  List<CountryModel> countryList = [];
  String? selectedTypeOfVideo; // video_type
  String? videoUrl; //video
  File? videoOfProduct; // pro_input_video
  String? description; // pro_input_description
  String? selectedCatID; //category_id
  //attribute_values
  String? productType; //product_type
  String? variantStockLevelType =
      "product_level"; //variant_stock_level_type // defualt is product level  if not pass
  int curSelPos = 0;

// for simple product   if(product_type == simple_product)

  String? simpleproductStockStatus = "1"; //simple_product_stock_status
  String? simpleproductPrice; //simple_price
  String? simpleproductSpecialPrice; //simple_special_price
  String? simpleproductSKU; // product_sku
  String? simpleproductTotalStock; // product_total_stock
  String? variantStockStatus =
      "0"; //variant_stock_status //fix according to riddhi mam =0 for simple product // not give any option for selection

// for variable product
  List<List<AttributeValueModel>> finalAttList = [];
  List<List<AttributeValueModel>> tempAttList = [];
  String? variantsIds; //variants_ids
  String? variantPrice; // variant_price
  String? variantSpecialPrice; // variant_special_price
  String? variantImages; // variant_images

  //{if (variant_stock_level_type == product_level)}
  String? variantproductSKU; //sku_variant_type
  String? variantproductTotalStock; // total_stock_variant_type
  String stockStatus = '1'; // variant_status

  //{if(variant_stock_level_type == variable_level)}
  String? variantSku; // variant_sku
  String? variantTotalStock; // variant_total_stock
  String? variantLevelStockStatus; //variant_level_stock_status
  bool? isStockSelected;

//  other
  bool simpleProductSaveSettings = false;
  bool variantProductProductLevelSaveSettings = false;
  bool variantProductVariableLevelSaveSettings = false;
  bool digitalProductSaveSettings = false;
  late StateSetter taxesState;

// brand name
  final ScrollController brandScrollController = ScrollController();
  String? selectedBrandName;
  String? selectedBrandId;
  StateSetter? brandState;
  bool? isLoadingMoreBrand;
  int brandOffset = 0;
  bool brandLoading = true;
  List<BrandModel> brandList = [];
  List<BrandModel> tempBrandList = [];

  // pickUp location
  final ScrollController pickUpLocationScrollController = ScrollController();
  String? selectedPickUpLocation;
  StateSetter? pickUpLocationState;
  bool? isLoadingMoreLocation;
  int locationOffset = 0;
  bool locationLoading = true;
  List<PickUpLocationModel> pickUpLocationList = [];
  List<PickUpLocationModel> temppickUpLocationList = [];

  // getting data
  List<TaxesModel> taxesList = [];
  List<AttributeSetModel> attributeSetList = [];
  List<AttributeModel> attributesList = [];
  List<AttributeValueModel> attributesValueList = [];
  List<ZipCodeModel> zipSearchList = [];
  List<CategoryModel> catagorylist = [];
  List<TextEditingController> attrController = [];
  final List<TextEditingController> attrValController = [];
  List<bool> variationBoolList = [];
  List<int> attrId = [];
  List<int> attrValId = [];
  List<String> attrVal = [];
  String? data;
  bool suggessionisNoData = false;

  late String productImage,
      productImageUrl,
      uploadedVideoName,
      digitalProductName;
  var mainImageProductImage;
  Animation? buttonSqueezeanimation;
  AnimationController? buttonController;

  List<String> otherPhotos = [];
  List<File>? otherPhotosFromGellery = [];
  List<String> otherImageUrl = [];
  List<Product_Varient> variationList = [];

// digital product
  String? digitalPrice;
  String? digitalSpecialPrice;
  String? idDigitalProductDownladable = "0";
  String? selectedDigitalLinkType;
  String? selectedDigitalProductTypeOfDownloadLink =
      'Self Hosted'; // video_type
  String? digitalProductSelfHostedUrl;

  //shipping details
  String? weight, height, breadth, length;

  setproductName(String? value) {
    productName = value;
    notifyListeners();
  } //pro_input_name

  setDescription(String? value) {
    description = value;
    notifyListeners();
  } // short_description

  setsortDescription(String? value) {
    sortDescription = value;
    notifyListeners();
  } // short_description

  setExtraDescription(String? value) {
    extraDescription = value;
    notifyListeners();
  } // extra_description

  settags(String? value) {
    tags = value;
    notifyListeners();
  } // Tags

  settaxId(String? value) {
    taxId = value;
    notifyListeners();
  } // Tax (pro_input_tax)

  setindicatorValue(String? value) {
    indicatorValue = value;
    notifyListeners();
  } // indicator

  settmadeIn(String? value) {
    madeIn = value;
    notifyListeners();
  } //made_in

  settotalAllowQuantity(String? value) {
    totalAllowQuantity = value;
    notifyListeners();
  } // total_allowed_quantity

  setminOrderQuantity(String? value) {
    minOrderQuantity = value;
    notifyListeners();
  } // minimum_order_quantity

  setquantityStepSize(String? value) {
    quantityStepSize = value;
    notifyListeners();
  } // quantity_step_size

  setwarrantyPeriod(String? value) {
    warrantyPeriod = value;
    notifyListeners();
  } //warranty_period

  setguaranteePeriod(String? value) {
    guaranteePeriod = value;
    notifyListeners();
  } //guarantee_period

  setdeliverabletypeValue(String? value) {
    deliverabletypeValue = value;
    notifyListeners();
  } //deliverable_type

  setdeliverableZipcodes(String? value) {
    deliverableZipcodes = value;
    notifyListeners();
  } //deliverable_zipcodes

  settaxincludedinPrice(String? value) {
    taxincludedinPrice = value;
    notifyListeners();
  } //is_prices_inclusive_tax

  setisCODAllow(String? value) {
    isCODAllow = value;
    notifyListeners();
  } //cod_allowed

  setisReturnable(String? value) {
    isReturnable = value;
    notifyListeners();
  } //is_returnable

  setisCancelableget(String? value) {
    isCancelable = value;
    notifyListeners();
  } //is_cancelable

  settillwhichstatus(String? value) {
    tillwhichstatus = value;
    notifyListeners();
  } //cancelable_till

  setselectedCatName(String? value) {
    selectedCatName = value;
    notifyListeners();
  } // for UI

  setselectedTaxID(int? value) {
    selectedTaxID = value;
  } // for UI

  Future<void> addProductAPI(
    List<String> attributesValuesIds,
    BuildContext context,
    Function update,
  ) async {
    isNetworkAvail = await isNetworkAvailable();
    if (isNetworkAvail) {
      try {
        var request = http.MultipartRequest("POST", addProductsApi);

        if (currentSellectedProductIsPysical) {
          if (hsnCode != null) {
            request.fields['hsn_code'] = hsnCode!;
          }
          if (indicatorValue != null) {
            request.fields[Indicator] = indicatorValue!;
          }
          if (totalAllowQuantity != null) {
            request.fields[TotalAllowedQuantity] = totalAllowQuantity!;
          }
          request.fields[MinimumOrderQuantity] = minOrderQuantity!;
          request.fields[QuantityStepSize] = quantityStepSize!;
          if (warrantyPeriod != null) {
            request.fields[WarrantyPeriod] = warrantyPeriod!;
          }
          if (guaranteePeriod != null) {
            request.fields[GuaranteePeriod] = guaranteePeriod!;
          }

          if (AppSettingsRepository.appSettings.isCityWiseDeliveribility) {
            request.fields[DeliverableCityType] = deliverabletypeValue!;
            request.fields[DeliverableCities] = deliverableCities.isEmpty
                ? ""
                : deliverableCities.map((e) => e.id).toList().join(',');
          } else {
            request.fields[DeliverableType] = deliverabletypeValue!;
            request.fields[DeliverableZipcodes] = deliverableZipcodes ?? "";
          }
          request.fields[CodAllowed] = isCODAllow!;
          request.fields[IsReturnable] = isReturnable!;
          request.fields[IsCancelable] = isCancelable!;
          if (tillwhichstatus != null) {
            request.fields[CancelableTill] = tillwhichstatus!;
          }
        }
        request.headers.addAll(headers);
        // request.fields[SellerId] = context.read<SettingProvider>().currentUerID;
        request.fields[ProInputName] = productName!;
        request.fields[ShortDescription] = sortDescription!;
        if (extraDescription != null) {
          request.fields[ExtraInputDesc] = extraDescription!;
        }
        if (tags != null) {
          request.fields[Tags] = tags!;
        }
        if (taxId != null) {
          request.fields[ProInputTax] = taxId!;
        }
        if (madeIn != null) {
          request.fields[MadeIn] = madeIn!;
        }
        request.fields[IsPricesInclusiveTax] = taxincludedinPrice!;
        request.fields[ProInputImage] = productImage;

        if (otherPhotos.isNotEmpty) {
          request.fields[OtherImages] = otherPhotos.join(",");
        }
        if (selectedTypeOfVideo != null) {
          request.fields[VideoType] = selectedTypeOfVideo!;
        }
        if (videoUrl != null) {
          request.fields[Video] = videoUrl!;
        }
        if (uploadedVideoName != '') {
          request.fields[ProInputVideo] = uploadedVideoName;
        }
        if (description != null) {
          request.fields[ProInputDescription] = description ?? "";
        }
        if (selectedBrandName != null) {
          request.fields['brand'] = selectedBrandName!;
        }
        if (selectedPickUpLocation != null) {
          request.fields[PICKUP_LOCATION] = selectedPickUpLocation!;
        }
        request.fields[CategoryId] = selectedCatID!;
        request.fields[ProductType] = productType!;
        if (productType == 'variable_product') {
          request.fields[VariantStockLevelType] = variantStockLevelType!;
        }
        request.fields[AttributeValues] = attributesValuesIds.join(",");

        if (productType == 'simple_product') {
          String? status;
          if (isStockSelected == null || !isStockSelected!) {
            status = null;
          } else {
            status = simpleproductStockStatus;
          }
          request.fields[SimpleProductStockStatus] = status ?? 'null';
          request.fields[SimplePrice] = simpleProductPriceController.text;
          request.fields[SimpleSpecialPrice] =
              simpleProductSpecialPriceController.text;
          if (isStockSelected != null && isStockSelected == true) {
            request.fields[ProductSku] = simpleproductSKU ?? "";
            request.fields[ProductTotalStock] = simpleproductTotalStock!;
          }

          if (weight != null) {
            request.fields[WEIGHT] = weight!;
          }
          if (height != null) {
            request.fields[HEIGHT] = height!;
          }
          if (breadth != null) {
            request.fields[BREADTH] = breadth!;
          }
          if (length != null) {
            request.fields[LENGTH] = length!;
          }
        } else if (productType == 'variable_product') {
          String val = '',
              price = '',
              sprice = '',
              images = '',
              height = '',
              weight = '',
              length = '',
              breadth = '';
          List<List<String>> imagesList = [];
          for (int i = 0; i < variationList.length; i++) {
            if (val == '') {
              val = variationList[i].id!.replaceAll(',', ' ');
              price = variationList[i].price!;
              sprice = variationList[i].disPrice ?? ' ';
            } else {
              val = "$val,${variationList[i].id!.replaceAll(',', ' ')}";
              price = "$price,${variationList[i].price!}";
              sprice = "$sprice,${variationList[i].disPrice ?? ' '}";
            }
            if (variationList[i].height != null) {
              if (height != '') {
                height = '$height,${variationList[i].height!}';
              } else {
                height = variationList[i].height!;
              }
            }

            if (variationList[i].weight != null) {
              if (weight != '') {
                weight = '$weight,${variationList[i].weight!}';
              } else {
                weight = variationList[i].weight!;
              }
            }

            if (variationList[i].breadth != null) {
              if (breadth != '') {
                breadth = '$breadth,${variationList[i].breadth!}';
              } else {
                breadth = variationList[i].breadth!;
              }
            }

            if (variationList[i].length != null) {
              if (length != '') {
                length = '$length,${variationList[i].length!}';
              } else {
                length = variationList[i].length!;
              }
            }

            if (variationList[i].imageRelativePath != null) {
              if (variationList[i].imageRelativePath!.isNotEmpty &&
                  images != '') {
                images =
                    '$images,${variationList[i].imageRelativePath!.join(",")}';
              } else if (variationList[i].imageRelativePath!.isNotEmpty &&
                  images == '') {
                images = variationList[i].imageRelativePath!.join(",");
              }

              List<String> subListofImage = images.split(',');
              images = "";

              for (int j = 0; j < subListofImage.length; j++) {
                subListofImage[j] = '"${subListofImage[j]}"';
              }
              imagesList.add(subListofImage);
            }
          }

          if (height != '') {
            request.fields[HEIGHT] = height;
          }
          if (weight != '') {
            request.fields[WEIGHT] = weight;
          }
          if (length != '') {
            request.fields[LENGTH] = length;
          }
          if (breadth != '') {
            request.fields[BREADTH] = breadth;
          }
          request.fields[VariantsIds] = val;
          request.fields[VariantPrice] = price;
          request.fields[VariantSpecialPrice] = sprice;
          request.fields[variant_images] = imagesList.toString();
          if (isStockSelected != null && isStockSelected == true) {
            if (variantStockLevelType == 'product_level') {
              request.fields[SkuVariantType] =
                  variountProductSKUController.text;
              request.fields[TotalStockVariantType] =
                  variountProductTotalStock.text;
              request.fields[VariantStatus] = stockStatus;
            } else if (variantStockLevelType == 'variable_level') {
              String sku = '', totalStock = '', stkStatus = '';
              for (int i = 0; i < variationList.length; i++) {
                if (sku == '') {
                  sku = variationList[i].sku!;
                  totalStock = variationList[i].stock!;
                  stkStatus = variationList[i].stockStatus!;
                } else {
                  sku = "$sku,${variationList[i].sku!}";
                  totalStock = "$totalStock,${variationList[i].stock!}";
                  stkStatus = "$stkStatus,${variationList[i].stockStatus!}";
                }
              }
              request.fields[VariantSku] = sku;
              request.fields[VariantTotalStock] = totalStock;
              request.fields[VariantLevelStockStatus] = stkStatus;
            }
            request.fields[VariantStockStatus] = "0";
          }
        } else if (productType == 'digital_product') {
          request.fields['download_allowed'] =
              digitalProductDownloaded ? "1" : "0";
          request.fields[SimplePrice] = digitalPriceController.text;
          request.fields[SimpleSpecialPrice] = digitalSpecialController.text;
          if (digitalProductDownloaded) {
            if (selectedDigitalProductTypeOfDownloadLink == 'Self Hosted') {
              request.fields['download_link_type'] = "self_hosted";
              request.fields['pro_input_zip'] = "1";
            }
            if (selectedDigitalProductTypeOfDownloadLink == 'Add Link') {
              request.fields['download_link_type'] = "add_link";
              request.fields['download_link'] =
                  selfHostedDigitalProductURLController.text;
            }
          }
        }

        print("request field******${request.fields}****${request.files}");
        var response = await request.send();
        var responseData = await response.stream.toBytes();
        var responseString = String.fromCharCodes(responseData);
        print("resoinse statuscode***${response.statusCode}");
        var getdata = json.decode(responseString);
        bool error = getdata["error"];
        String msg = getdata['message'];
        if (!error) {
          await buttonController!.reverse();
          setSnackbar(msg, context);
          // Navigator.push(
          //   context,
          //   CupertinoPageRoute(
          //     builder: (context) => ProductList(
          //       flag: '',
          //       fromNavbar: false,
          //     ),
          //   ),
          // );
          // setCurrentPageValue(1);
          freshInitializationOfAddProduct();
          update();
          Navigator.pop(context, true); //go to previous page and refresh
        } else {
          await buttonController!.reverse();
          setSnackbar(msg, context);
        }
      } on TimeoutException catch (_) {
        setSnackbar(
          getTranslated(context, 'somethingMSg')!,
          context,
        );
      }
    } else {
      Future.delayed(const Duration(seconds: 2)).then(
        (_) async {
          await buttonController!.reverse();
          isNetworkAvail = false;
          update();
        },
      );
    }
  }
}
