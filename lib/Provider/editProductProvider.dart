import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sellermultivendor/Model/city.dart';
import 'package:sellermultivendor/Provider/settingProvider.dart';
import 'package:sellermultivendor/Repository/appSettingsRepository.dart';
import '../Model/Attribute Models/AttributeModel/AttributesModel.dart';
import '../Model/Attribute Models/AttributeSetModel/AttributeSetModel.dart';
import '../Model/Attribute Models/AttributeValueModel/AttributeValue.dart';
import '../Model/BrandModel/brandModel.dart';
import '../Model/CategoryModel/categoryModel.dart';
import '../Model/PickUpLocationModel/PickUpLocationModel.dart';
import '../Model/ProductModel/Variants.dart';
import '../Model/TaxesModel/TaxesModel.dart';
import '../Model/ZipCodesModel/ZipCodeModel.dart';
import '../Model/Country/countryModel.dart';
import '../Widget/api.dart';
import '../Widget/security.dart';
import '../Widget/networkAvailablity.dart';
import '../Widget/parameterString.dart';
import '../Widget/snackbar.dart';
import '../Widget/validation.dart';

class EditProductProvider extends ChangeNotifier {
  freshInitializationOfEditProduct() {
    variantProductProductLevelSaveSettings = false;
    variantProductVariableLevelSaveSettings = false;
    description = null;
    digitalPrice = null;
    selectedDigitalProductTypeOfDownloadLink = null;
    digitalProductDownloaded = false;
    digitalProductNamePathNameForSelectedFile = '';
    digitalProductSaveSettings = false;
    productNameControlller.clear();
    sortDescriptionControlller.clear();
    extraDescriptionControlller.clear();
    digitalPriceController.clear();
    digitalSpecialController.clear();
    selfHostedDigitalProductURLController.clear();
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
    hsnCodeController.clear();
    variantproductSKU = null;
    variantproductTotalStock = null;
    stockStatus = '1';
    simpleproductPrice = null;
    simpleproductSpecialPrice = null;
    productImageRelativePath = null;
    productImage = null;
    productImageUrl = null;
    uploadedVideoName = null;
    otherPhotos = [];
    showOtherImages = [];
    variationList = [];
    isStockSelected = null;
    simpleProductSaveSettings = false;
    selCountryPos = -1;
    country = null;
    isLoadingMoreCountry = null;
    countryOffset = 0;
    countryLoading = true;
    countrySearchList = [];
    isProgress = false;
    countryList = [];
    countryController.clear();
    row = 1;
    col = null;
    currentPage = 1;
    selectedCatName = null;
    selectedTaxID = null;
    mainImageProductImage = null;
    isToggled = false;
    isreturnable = false;
    isCODallow = false;
    iscancelable = false;
    taxincludedInPrice = false;
    attributeIndiacator = 0;
    isLoading = true;
    data;
    suggessionisNoData = false;
    selectedAttributeValues = {};
    hsnCode = null;
    oldVariantId = "";
    productName = null;
    sortDescription = null;
    extraDescription = null;
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
    taxincludedinPrice = "0";
    isCODAllow = "0";
    isReturnable = "0";
    isCancelable = "0";
    tillwhichstatus = null;
    selectedTypeOfVideo = null;
    videoUrl = null;
    selectedCatID = null;
    productType = null;
    variantStockLevelType = "product_level";
    curSelPos = 0;
    simpleproductStockStatus;
    simpleproductSKU;
    simpleproductTotalStock;
    variantStockStatus = "0";
    finalAttList = [];
    tempAttList = [];
    variantSku;
    variantTotalStock;
    variantLevelStockStatus;
    taxesList = [];
    attributeSetList = [];
    attributesList = [];
    attributesValueList = [];
    zipSearchList = [];
    catagorylist = [];
    attrController.clear();
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
    selectedBrandId = null;
    selectedBrandName = null;
    selectedPickUpLocation = null;
    pickUpLocationList = [];
    temppickUpLocationList = [];
    locationLoading = true;
    locationOffset = 0;
    pickUpLocationState = null;
    isLoadingMoreLocation = null;
    selectedAttribute = [];
    resultAttr = [];
    resultID = [];
    max = null;
    weightController.clear();
    heightController.clear();
    breadthController.clear();
    lengthController.clear();
    height = null;
    weight = null;
    breadth = null;
    length = null;
    deliverableCities.clear();
  }

  int? max;
  List<String> resultAttr = [];
  List<String> resultID = [];
  List<String> selectedAttribute = [];

//------------------------------------------------------------------------------
//========================= For Form Validation ================================
  Animation? buttonSqueezeanimation;
  AnimationController? buttonController;

  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  String? hsnCode; //hsn_code
  String? oldVariantId = "";
  String? productName; //pro_input_name
  String? sortDescription; // short_description
  String? extraDescription; // extra_description
  String? tags; // Tags
  String? taxId; // Tax (pro_input_tax)
  String? indicatorValue; // indicator
  String? madeIn; //made_in
  String? totalAllowQuantity; // total_allowed_quantity
  String? minOrderQuantity; // minimum_order_quantity
  String? quantityStepSize; // quantity_step_size
  String? warrantyPeriod; //warranty_period
  String? guaranteePeriod; //guarantee_period
  String? deliverabletypeValue = "1"; //deliverable_type
  String? deliverableZipcodes; //deliverable_zipcodes
  List<CityModel> deliverableCities = [];
  String? taxincludedinPrice = "0"; //is_prices_inclusive_tax
  String? isCODAllow = "0"; //cod_allowed
  String? isReturnable = "0"; //is_returnable
  String? isCancelable = "0"; //is_cancelable
  String? tillwhichstatus; //cancelable_till
  //File? mainProductImage;//pro_input_image
  String? selectedTypeOfVideo; // video_type
  String? videoUrl; //video

  String? selectedCatID; //category_id
  //attribute_values
  String? productType; //product_type
  String? variantStockLevelType =
      "product_level"; //variant_stock_level_type // defualt is product level  if not pass
  int curSelPos = 0;

// for simple product   if(product_type == simple_product)

  String? simpleproductStockStatus; //simple_product_stock_status

  String? simpleproductSKU; // product_sku
  String? simpleproductTotalStock; // product_total_stock
  String? variantStockStatus =
      "0"; //variant_stock_status //fix according to riddhi mam =0 for simple product // not give any option for selection

// for variable product
  List<List<AttributeValueModel>> finalAttList = [];
  List<List<AttributeValueModel>> tempAttList = [];

  //{if(variant_stock_level_type == variable_level)}
  String? variantSku; // variant_sku
  String? variantTotalStock; // variant_total_stock
  String? variantLevelStockStatus; //variant_level_stock_status

  // getting data
  List<TaxesModel> taxesList = [];
  List<AttributeSetModel> attributeSetList = [];
  List<AttributeModel> attributesList = [];
  List<AttributeValueModel> attributesValueList = [];
  List<ZipCodeModel> zipSearchList = [];
  List<CategoryModel> catagorylist = [];
  final List<TextEditingController> attrController = [];
  List<bool> variationBoolList = [];
  List<int> attrId = [];
  List<int> attrValId = [];
  List<String> attrVal = [];

// temprary variable for test
  late Map<String, List<AttributeValueModel>> selectedAttributeValues = {};

  // for UI
  String? selectedCatName; // for UI
  int? selectedTaxID; // for UI
  var mainImageProductImage;

//on-off toggles
  bool isToggled = false;
  bool isreturnable = false;
  bool isCODallow = false;
  bool iscancelable = false;

  bool taxincludedInPrice = false;
  bool digitalProductDownloaded = false;

//for remove extra add
  int attributeIndiacator = 0;
  bool currentSellectedProductIsPysical = true;

// network variable
  bool isLoading = true;
  String? data;
  bool suggessionisNoData = false;
  int currentPage = 1;
  int? col;
  int row = 1;
  int? selCountryPos = -1;
  String? country;
  StateSetter? countryState;
  bool? isLoadingMoreCountry;
  int countryOffset = 0;
  bool countryLoading = true;
  List<CountryModel> countrySearchList = [];
  final ScrollController countryScrollController = ScrollController();
  bool isProgress = false;
  List<CountryModel> countryList = [];
  final TextEditingController countryController = TextEditingController();
  String? simpleproductPrice; //simple_price
  String? simpleproductSpecialPrice; //simple_special_price
  String? productImageRelativePath,
      productImage,
      productImageUrl,
      uploadedVideoName;
  late String digitalProductNamePathNameForSelectedFile;
  List<String> otherPhotos = [];
  List<String> showOtherImages = [];
  List<Product_Varient> variationList = [];
  bool? isStockSelected;

//  other
  bool simpleProductSaveSettings = false;

//{if (variant_stock_level_type == product_level)}
  String? variantproductSKU; //sku_variant_type
  String? variantproductTotalStock; // total_stock_variant_type
  String stockStatus = '1'; // variant_status
  bool digitalProductSaveSettings = false;

  String? description; // pro_input_description
  late StateSetter taxesState;
  bool variantProductProductLevelSaveSettings = false;
  bool variantProductVariableLevelSaveSettings = false;

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

// Focus Node.
  FocusNode? productFocus,
      sortDescriptionFocus,
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
      rawKeyboardListenerFocus,
      tempFocusNode,
      hsnCodeFucosNode,
      attributeFocus,
      digitalPriceFocus,
      digitalSpecialFocus,
      selfHostedFocus,
      weightFocus,
      heightFocus,
      breadthFocus,
      lengthFocus = FocusNode();

// digital product
  String? digitalPrice;
  String? digitalSpecialPrice;
  String? idDigitalProductDownladable = "0";
  String? selectedDigitalLinkType;
  String? selectedDigitalProductTypeOfDownloadLink; // video_type
  String? digitalProductSelfHostedUrl;

  //shipping details
  String? weight, height, breadth, length;

//----------------------------------------------------------------------------
//======================= TextEditingController ==============================

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
  TextEditingController weightController = TextEditingController();
  TextEditingController heightController = TextEditingController();
  TextEditingController breadthController = TextEditingController();
  TextEditingController lengthController = TextEditingController();
  TextEditingController simpleProductSKUController = TextEditingController();
  TextEditingController simpleProductTotalStock = TextEditingController();
  TextEditingController variountProductSKUController = TextEditingController();
  TextEditingController variountProductTotalStock = TextEditingController();
  TextEditingController hsnCodeController = TextEditingController();
  TextEditingController digitalPriceController = TextEditingController();
  TextEditingController digitalSpecialController = TextEditingController();
  TextEditingController selfHostedDigitalProductURLController =
      TextEditingController();

  Future<void> addProductAPI(
    List<String> attributesValuesIds,
    BuildContext context,
    Function update,
    String id,
  ) async {
    isNetworkAvail = await isNetworkAvailable();
    if (isNetworkAvail) {
      try {
        var request = http.MultipartRequest("POST", editProductApi);
        if (currentSellectedProductIsPysical) {
          request.fields['hsn_code'] = hsnCode!;
          if (indicatorValue != null) {
            request.fields[Indicator] = indicatorValue!;
          }
          request.fields[TotalAllowedQuantity] = totalAllowQuantity!;
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
        // request.fields[SellerId] = context.read<SettingProvider>().CUR_USERID!;
        request.fields[editProductId] = id;
        request.fields[EditVariantId] = oldVariantId!;
        request.fields[ProInputName] = productName!;
        if (selectedBrandName != null) {
          request.fields['brand'] = selectedBrandName!;
        }
        if (selectedPickUpLocation != null) {
          request.fields[PICKUP_LOCATION] = selectedPickUpLocation!;
        }
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
        request.fields[ProInputImage] = productImageRelativePath!;
        if (otherPhotos.isNotEmpty) {
          request.fields[OtherImages] = otherPhotos.join(",");
        }

        if (selectedTypeOfVideo != null) {
          request.fields[VideoType] = selectedTypeOfVideo!;
        }
        if (videoUrl != null) request.fields[Video] = videoUrl!;
        if (uploadedVideoName != '') {
          request.fields[ProInputVideo] = uploadedVideoName!;
        }
        request.fields[ProInputDescription] = description ?? "";
        request.fields[CategoryId] = selectedCatID!;
        request.fields[ProductType] = productType!;

        request.fields[AttributeValues] = attributesValuesIds.join(",");
        if (productType == 'simple_product') {
          if (isStockSelected == null || !isStockSelected!) {
            request.fields[SimpleProductStockStatus] = "";
          } else {
            request.fields[SimpleProductStockStatus] =
                simpleproductStockStatus ?? "0";
          }
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
            String testing = "";
            if (variationList[i].attribute_value_ids.toString() != "null") {
              testing =
                  variationList[i].attribute_value_ids!.replaceAll(',', ' ');
            } else {
              testing = variationList[i].id!.replaceAll(',', ' ');
            }
            if (testing != "") {
              if (val == "") {
                val = testing;
                price = variationList[i].price!;
                sprice = variationList[i].disPrice ?? ' ';
              } else {
                val = "$val,$testing";
                price = "$price,${variationList[i].price!}";
                sprice = "$sprice,${variationList[i].disPrice ?? ' '}";
              }
            }
            print("variationList[i].height****${variationList[i].height}");
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
          print("height update***$height");
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
          // if (imagesList.length == 1) {
          //   request.fields[variant_images] = imagesList[0].toString();
          // } else {
          request.fields[variant_images] = imagesList.toString();
          // }
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
            request.fields[VariantStockLevelType] = variantStockLevelType!;
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
        print("request field****${request.fields}");
        var response = await request.send();
        var responseData = await response.stream.toBytes();
        var responseString = String.fromCharCodes(responseData);
        var getdata = json.decode(responseString);
        bool error = getdata["error"];
        String msg = getdata['message'];
        if (!error) {
          await buttonController!.reverse();
          setSnackbar(msg, context);
          // Navigator.pushReplacement(
          //   context,
          //   CupertinoPageRoute(
          //     builder: (context) => ProductList(
          //       flag: '',
          //       fromNavbar: false,
          //     ),
          //   ),
          // );
          Navigator.pop(context,
              true); //true means refresh the previous page after a product is been edited
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
