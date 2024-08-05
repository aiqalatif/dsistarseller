import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sellermultivendor/Provider/pickUpLocationProvider.dart';
import 'package:sellermultivendor/Repository/appSettingsRepository.dart';

import 'package:sellermultivendor/Screen/EditProduct/widget/CurrentPages/currentPage1.dart';
import 'package:sellermultivendor/Screen/EditProduct/widget/CurrentPages/currentPage2.dart';
import 'package:sellermultivendor/Screen/EditProduct/widget/CurrentPages/currentPage3.dart';
import 'package:sellermultivendor/Screen/EditProduct/widget/getCommannWidget.dart';
import 'package:sellermultivendor/Screen/EditProduct/widget/getCommonSwitch.dart';
import 'package:sellermultivendor/Screen/EditProduct/widget/getIconSelectionDesingWidget.dart';
import 'package:sellermultivendor/Screen/EditProduct/widget/Dialogs/variantStockStatusDialog.dart';
import 'package:sellermultivendor/Screen/EditProduct/widget/getCommonButton.dart';
import 'package:sticky_headers/sticky_headers.dart';
import '../../Helper/Color.dart';
import '../../Helper/Constant.dart';
import '../../Model/Attribute Models/AttributeModel/AttributesModel.dart';
import '../../Model/Attribute Models/AttributeSetModel/AttributeSetModel.dart';
import '../../Model/Attribute Models/AttributeValueModel/AttributeValue.dart';
import '../../Model/BrandModel/brandModel.dart';
import '../../Model/ProductModel/Product.dart';
import '../../Model/ProductModel/Variants.dart';
import '../../Provider/attributeSetProvider.dart';
import '../../Provider/brandProvider.dart';
import '../../Provider/categoryProvider.dart';
import '../../Provider/countryProvider.dart';
import '../../Provider/editProductProvider.dart';
import '../../Provider/settingProvider.dart';
import '../../Provider/taxProvider.dart';
import '../../Provider/zipcodeProvider.dart';
import '../../Widget/ButtonDesing.dart';
import '../../Widget/FilterChips.dart';
import '../../Widget/api.dart';
import '../../Widget/desing.dart';
import '../../Widget/networkAvailablity.dart';
import '../../Widget/parameterString.dart';
import '../../Widget/sharedPreferances.dart';
import '../../Widget/simmerEffect.dart';
import '../../Widget/snackbar.dart';
import '../../Widget/validation.dart';
import '../HomePage/home.dart';
import '../MediaUpload/Media.dart';

class EditProduct extends StatefulWidget {
  final Product? model;

  const EditProduct({
    Key? key,
    this.model,
  }) : super(key: key);

  @override
  _EditProductState createState() => _EditProductState();
}

EditProductProvider? editProvider;

class _EditProductState extends State<EditProduct>
    with TickerProviderStateMixin {
  Future<void> _playAnimation() async {
    try {
      await editProvider!.buttonController!.forward();
    } on TickerCanceled {}
  }

//------------------------------------------------------------------------------
//========================= InIt MEthod ========================================
  getAllData() async {
    isNetworkAvail = await isNetworkAvailable();
    if (isNetworkAvail) {
      await context.read<BrandProvider>().setBrands(false).then(
        (value) {
          if (value == true) {
            setSnackbar(context.read<BrandProvider>().errorMessage, context);
          }
        },
      );
      if (mounted && editProvider!.brandState != null) {
        if (mounted) {
          setState(() {});
        }
      }

      await context
          .read<PickUpLocationProvider>()
          .getPickUpLocations(context, 2)
          .then(
        (value) {
          if (value == true) {
            setSnackbar(
                context.read<PickUpLocationProvider>().errorMessage, context);
          }
        },
      );
      if (mounted && editProvider!.pickUpLocationState != null) {
        if (mounted) {
          setState(() {});
        }
      }
      //getBrands();
      await context.read<CountryProvider>().setCountrys(false, false).then(
        (value) {
          if (value == true) {
            setSnackbar(context.read<CountryProvider>().errorMessage, context);
          }
        },
      );
      //get zipCode
      await context.read<ZipcodeProvider>().setZipCode(false).then(
        (value) {
          if (value == true) {
            setSnackbar(context.read<ZipcodeProvider>().errorMessage, context);
          }
        },
      );
      await context
          .read<CategoryProvider>()
          .setCategory(
            false,
            context,
          )
          .then(
        (value) {
          if (value == true) {
            setSnackbar(context.read<CategoryProvider>().errorMessage, context);
          }
        },
      );
      await context.read<TaxProvider>().setTax(false).then(
        (value) {
          if (value == true) {
            setSnackbar(context.read<TaxProvider>().errorMessage, context);
          }
        },
      );
      // get attribute set
      await context.read<AttributeProvider>().setAttributeSet(false).then(
        (value) {
          if (value == true) {
            setSnackbar(
                context.read<AttributeProvider>().errorMessage, context);
          }
        },
      );
      // get attribute
      await context.read<AttributeProvider>().setAttributes(false).then(
        (value) {
          if (value == true) {
            setSnackbar(
                context.read<AttributeProvider>().errorMessage, context);
          }
        },
      );
      // get attribute value
      await context.read<AttributeProvider>().setAttributesValue(false).then(
        (value) {
          if (value == true) {
            setSnackbar(
                context.read<AttributeProvider>().errorMessage, context);
          }
        },
      );
      Future.delayed(
        const Duration(seconds: 3),
        () {
          initializaAllvariables();
        },
      );
      setState(
        () {},
      );
    } else {
      setState(
        () {
          isNetworkAvail = false;
        },
      );
    }
  }

  setStateNow() {
    setState(() {});
  }

  @override
  void initState() {
    editProvider = Provider.of<EditProductProvider>(context, listen: false);
    editProvider!.freshInitializationOfEditProduct();
    editProvider!.productImage = "";
    editProvider!.productImageRelativePath = "";
    editProvider!.productImageUrl = "";
    editProvider!.uploadedVideoName = "";
    editProvider!.countryScrollController.addListener(_scrollListener);
    editProvider!.brandScrollController.addListener(_brandScrollListener);
    editProvider!.pickUpLocationScrollController
        .addListener(_pickUpScrollListener);
    getAllData();
    editProvider!.buttonController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    editProvider!.uploadedVideoName = '';
    editProvider!.otherPhotos = [];
    editProvider!.showOtherImages = [];

    editProvider!.buttonSqueezeanimation = Tween(
      begin: double.maxFinite,
      end: 50.0,
    ).animate(
      CurvedAnimation(
        parent: editProvider!.buttonController!,
        curve: const Interval(
          0.0,
          0.150,
        ),
      ),
    );
    editProvider!.currentPage = 1;
    super.initState();
  }

  _scrollListener() async {
    if (editProvider!.countryScrollController.offset >=
            editProvider!.countryScrollController.position.maxScrollExtent &&
        !editProvider!.countryScrollController.position.outOfRange) {
      if (mounted) {
        setState(() {});

        editProvider!.countryState!(() {
          editProvider!.isLoadingMoreCountry = true;
          editProvider!.isProgress = true;
        });
        await context.read<CountryProvider>().setCountrys(false, false).then(
          (value) {
            if (value == true) {
              setSnackbar(
                  context.read<CountryProvider>().errorMessage, context);
            }
          },
        );
      }
    }
  }

  _brandScrollListener() async {
    if (editProvider!.brandScrollController.offset >=
            editProvider!.brandScrollController.position.maxScrollExtent &&
        !editProvider!.brandScrollController.position.outOfRange) {
      if (mounted) {
        setState(() {});

        editProvider!.brandState!(() {
          editProvider!.isLoadingMoreBrand = true;
          editProvider!.isProgress = true;
        });

        //get Country
        await context.read<BrandProvider>().setBrands(false).then((value) {
          if (value == true) {
            setSnackbar(context.read<BrandProvider>().errorMessage, context);
          }
        });
        if (mounted && editProvider!.brandState != null) {
          editProvider!.brandState!(() {});
        }
        if (mounted) setState(() {});
      }
    }
  }

  _pickUpScrollListener() async {
    if (editProvider!.pickUpLocationScrollController.offset >=
            editProvider!
                .pickUpLocationScrollController.position.maxScrollExtent &&
        !editProvider!.pickUpLocationScrollController.position.outOfRange) {
      if (mounted) {
        setState(() {});

        editProvider!.pickUpLocationState!(() {
          editProvider!.isLoadingMoreLocation = true;
          editProvider!.isProgress = true;
        });

        //get Country
        await context
            .read<PickUpLocationProvider>()
            .getPickUpLocations(context, 2)
            .then((value) {
          if (value == true) {
            setSnackbar(
                context.read<PickUpLocationProvider>().errorMessage, context);
          }
        });
        if (mounted && editProvider!.pickUpLocationState != null) {
          editProvider!.pickUpLocationState!(() {});
        }
        if (mounted) setState(() {});
      }
    }
  }

  void initializaAllvariables() {
    //pro_input_name
    editProvider!.productNameControlller.text = widget.model!.name!;
    editProvider!.productName = editProvider!.productNameControlller.text;
    //hnsCode
    editProvider!.hsnCodeController.text = widget.model!.hsnCodeValue ?? '';
    editProvider!.hsnCode = widget.model!.hsnCodeValue ?? '';
    // short_description
    (widget.model!.shortDescription == null)
        ? ""
        : editProvider!.sortDescriptionControlller.text =
            widget.model!.shortDescription!;
    editProvider!.sortDescription =
        editProvider!.sortDescriptionControlller.text;
    (widget.model!.extraDescription == null)
        ? ""
        : editProvider!.extraDescriptionControlller.text =
            widget.model!.extraDescription!;
    editProvider!.extraDescription =
        editProvider!.extraDescriptionControlller.text;
    // Tags
    for (var element in widget.model!.tagList!) {
      var temp = element;
      editProvider!.tagsControlller.text =
          "${editProvider!.tagsControlller.text}$temp, ";
    }
    editProvider!.tags = editProvider!.tagsControlller.text;

    //category_id
    editProvider!.selectedCatName = widget.model!.catName;
    editProvider!.selectedCatID = widget.model!.categoryId;

    //total allowed quantity
    if (widget.model!.totalAllow != null) {
      editProvider!.totalAllowQuantity = widget.model!.totalAllow;
      editProvider!.totalAllowController.text = widget.model!.totalAllow!;
    }
    if (widget.model!.brandName != null) {
      editProvider!.selectedBrandName = widget.model!.brandName;
    }
    if (widget.model!.pickUpLoc != null) {
      editProvider!.selectedPickUpLocation = widget.model!.pickUpLoc;
    }
    //minimam order quantity
    if (widget.model!.minimumOrderQuantity != null) {
      editProvider!.minOrderQuantity = widget.model!.minimumOrderQuantity;
      editProvider!.minOrderQuantityControlller.text =
          widget.model!.minimumOrderQuantity!;
    }
    // Minimum Order Quantity
    if (widget.model!.minimumOrderQuantity == null) {
      editProvider!.minOrderQuantity = "1";
      editProvider!.minOrderQuantityControlller.text = "1";
    }
    //quantity step size
    if (widget.model!.quantityStepSize != null) {
      editProvider!.quantityStepSize = widget.model!.quantityStepSize;
      editProvider!.quantityStepSizeControlller.text =
          widget.model!.quantityStepSize!;
    }
    // Quantity step size
    if (widget.model!.quantityStepSize == null) {
      editProvider!.quantityStepSize = "1";
      editProvider!.quantityStepSizeControlller.text = "1";
    }
    // Made In
    if (widget.model!.madeIn != null) {
      editProvider!.madeIn = widget.model!.madeIn;
      editProvider!.madeInControlller.text = widget.model!.madeIn!;
    }

    //warranty_period
    if (widget.model!.warranty != null) {
      editProvider!.warrantyPeriod = widget.model!.warranty;
      editProvider!.warrantyPeriodController.text = widget.model!.warranty!;
    }
    //guarantee_period
    if (widget.model!.gurantee != null) {
      editProvider!.guaranteePeriod = widget.model!.gurantee;
      editProvider!.guaranteePeriodController.text = widget.model!.gurantee!;
    }
    //deliverable_type

    //is_returnable
    if (widget.model!.isReturnable != null) {
      editProvider!.isReturnable = widget.model!.isReturnable;
      editProvider!.isreturnable =
          widget.model!.isReturnable == "1" ? true : false;
    }

    //is_cancelable
    if (widget.model!.isCancelable != null) {
      editProvider!.isCancelable = widget.model!.isCancelable;
      editProvider!.iscancelable =
          widget.model!.isCancelable == "1" ? true : false;
      if (editProvider!.iscancelable) {
        if (widget.model!.cancelableTill != "" &&
            widget.model!.cancelableTill != null) {
          editProvider!.tillwhichstatus = widget.model!.cancelableTill;
        }
      }
    }
    //cod_allowed
    if (widget.model!.isCODAllow != null) {
      editProvider!.isCODAllow = widget.model!.isCODAllow;
      editProvider!.isCODallow = widget.model!.isCODAllow == "1" ? true : false;
    }
    //taxincludedinPrice
    if (widget.model!.taxincludedInPrice != null) {
      editProvider!.taxincludedinPrice = widget.model!.taxincludedInPrice;
      editProvider!.taxincludedInPrice =
          widget.model!.taxincludedInPrice == "1" ? true : false;
    }
    // indicator
    if (widget.model!.indicator != null) {
      editProvider!.indicatorValue = widget.model!.indicator;
    }
    //Image
    if (widget.model!.image != null && widget.model!.image != "") {
      editProvider!.productImage = widget.model!.image!;
      editProvider!.productImageUrl = widget.model!.image!;
      editProvider!.productImageRelativePath = widget.model!.relativeImagePath!;
    }
    //video_type
    if (widget.model!.videoType != null && widget.model!.videoType != "") {
      editProvider!.selectedTypeOfVideo = widget.model!.videoType;
      if (widget.model!.video != null && widget.model!.video != "") {
        editProvider!.videoUrl = widget.model!.video;
        editProvider!.vidioTypeController.text = widget.model!.video!;
      }
    }
    //tax_id
    if (widget.model!.taxId != null) {
      editProvider!.taxId = widget.model!.taxId;
      editProvider!.selectedTaxID = int.parse(widget.model!.taxId!);
    }
    //deliverable_type
    if (widget.model!.deliverableType != null) {
      editProvider!.deliverabletypeValue = widget.model!.deliverableType;
    }
    //deliverable_zipcodes
    if (widget.model!.deliverableZipcodes != "") {
      editProvider!.deliverableZipcodes = widget.model!.deliverableZipcodes;
    }
    //deliverable_ities
    if (widget.model!.deliverableCityType != null &&
        widget.model!.deliverableCityType != "" &&
        AppSettingsRepository.appSettings.isCityWiseDeliveribility) {
      editProvider!.deliverabletypeValue =
          widget.model?.deliverableCityType ?? "";
      editProvider!.deliverableCities = widget.model?.deliverableCities ?? [];
    }
    //Description
    if (widget.model!.description != null) {
      editProvider!.description = widget.model!.description;
    }
    for (int i = 0; i <= widget.model!.otherImage!.length; i++) {}

    //Other Images
    if (widget.model!.otherImage != null) {
      editProvider!.otherPhotos = widget.model!.otherImage!;
      editProvider!.showOtherImages = widget.model!.showOtherImage!;
    }
    // Type Of Product
    if (widget.model!.type != null) {
      editProvider!.productType = widget.model!.type;
    }

//------------------------------------------------------------------------------
//========================= Simple Product =====================================

    if (editProvider!.productType == "simple_product") {
      // simple product price
      if (widget.model!.sku != null) {
        editProvider!.simpleproductSKU = widget.model!.sku;
        editProvider!.simpleProductSKUController.text = widget.model!.sku!;
      }
      if (widget.model!.stock != null) {
        editProvider!.simpleproductTotalStock = widget.model!.stock;
        editProvider!.simpleProductTotalStock.text = widget.model!.stock!;
      }
      if (widget.model!.prVarientList![widget.model!.selVarient!].price !=
          null) {
        editProvider!.simpleProductPriceController.text =
            widget.model!.prVarientList![widget.model!.selVarient!].price!;
        editProvider!.simpleproductPrice =
            widget.model!.prVarientList![widget.model!.selVarient!].price!;
      }
      // simple product special price
      if (widget.model!.prVarientList![widget.model!.selVarient!].disPrice !=
          null) {
        editProvider!.simpleProductSpecialPriceController.text =
            widget.model!.prVarientList![widget.model!.selVarient!].disPrice!;
        editProvider!.simpleproductSpecialPrice =
            widget.model!.prVarientList![widget.model!.selVarient!].disPrice!;
      }

      if (widget.model!.prVarientList![widget.model!.selVarient!].height !=
          null) {
        editProvider!.heightController.text =
            widget.model!.prVarientList![widget.model!.selVarient!].height!;
        editProvider!.height =
            widget.model!.prVarientList![widget.model!.selVarient!].height!;
      }

      if (widget.model!.prVarientList![widget.model!.selVarient!].weight !=
          null) {
        editProvider!.weightController.text =
            widget.model!.prVarientList![widget.model!.selVarient!].weight!;
        editProvider!.weight =
            widget.model!.prVarientList![widget.model!.selVarient!].weight!;
      }

      if (widget.model!.prVarientList![widget.model!.selVarient!].breadth !=
          null) {
        editProvider!.breadthController.text =
            widget.model!.prVarientList![widget.model!.selVarient!].breadth!;
        editProvider!.breadth =
            widget.model!.prVarientList![widget.model!.selVarient!].breadth!;
      }

      if (widget.model!.prVarientList![widget.model!.selVarient!].length !=
          null) {
        editProvider!.lengthController.text =
            widget.model!.prVarientList![widget.model!.selVarient!].length!;
        editProvider!.length =
            widget.model!.prVarientList![widget.model!.selVarient!].length!;
      }

      //Enable Stock Management
      if (widget.model!.stockType != '') {
        editProvider!.isStockSelected = true;
      }
      if (widget
              .model!.prVarientList![widget.model!.selVarient!].availability !=
          '') {
        editProvider!.simpleproductStockStatus = widget
            .model!.prVarientList![widget.model!.selVarient!].availability;
      }
      // for save setting
      editProvider!.simpleProductSaveSettings = true;
      // for variant

      if (widget.model!.attributeList!.isEmpty.toString() == "false") {
        var index = widget.model!.attributeList!.length;
        for (int i = 0; i < index; i++) {
          var oldListOfAttributeValueID =
              widget.model!.attributeList![i].id.toString().split(',');

          String? oldattributename = widget.model!.attributeList![i].name;
          editProvider!.attrController
              .add(TextEditingController(text: oldattributename));
          editProvider!.variationBoolList.add(true);
          // for get the value of element
          final attributes = editProvider!.attributesList
              .where((element) => element.name == oldattributename)
              .toList();
          String? attributeID;
          for (var element in attributes) {
            attributeID = element.id;
          }
          List<AttributeValueModel> tempagain = [];
          for (var element in oldListOfAttributeValueID) {
            final tempvar = editProvider!.attributesValueList
                .where((e) => e.id == element)
                .toList();
            if (tempvar.isNotEmpty) {
              tempagain.add(tempvar[0]);
            }
          }
          if (attributeID != null) {
            editProvider!.selectedAttributeValues[attributeID] = tempagain;
          }
        }
        editProvider!.attributeIndiacator = editProvider!.attrController.length;
        if (widget.model!.prVarientList!.isEmpty.toString() == "false") {
          var index = widget.model!.prVarientList!.length;
          for (int i = 0; i < index; i++) {
            //old variant id
            editProvider!.oldVariantId = () {
              if (editProvider!.oldVariantId == "") {
                return widget.model!.prVarientList![i].id;
              } else {
                return "${editProvider!.oldVariantId!},${widget.model!.prVarientList![i].id!}";
              }
            }();
          }
        }
      }
    }
    //----------------------------------------------------------------------------
    //========================= Variant Product ==================================

    if (editProvider!.productType == "variable_product") {
      List<String> colCount = [];
      // logic for stock is enable or not .
      if (widget.model!.stockType == "null") {
        // product level but stock management dissable
        editProvider!.isStockSelected = false;
      }
      if (widget.model!.stockType == "") {
        editProvider!.variantProductProductLevelSaveSettings = true;
        editProvider!.isStockSelected = false;
        // For variant
        if (widget.model!.attributeList!.isEmpty.toString() == "false") {
          var index = widget.model!.attributeList!.length;
          for (int i = 0; i < index; i++) {
            var oldListOfAttributeValueID =
                widget.model!.attributeList![i].id.toString().split(',');
            //old variant id

            String? oldattributename = widget.model!.attributeList![i].name;
            editProvider!.attrController.add(
              TextEditingController(text: oldattributename),
            );
            editProvider!.variationBoolList.add(true);
            // for get the value of element
            final attributes = editProvider!.attributesList
                .where((element) => element.name == oldattributename)
                .toList();
            String? attributeID;
            for (var element in attributes) {
              attributeID = element.id;
            }
            List<AttributeValueModel> tempagain = [];
            for (var element in oldListOfAttributeValueID) {
              final tempvar = editProvider!.attributesValueList
                  .where((e) => e.id == element)
                  .toList();
              if (tempvar.isNotEmpty) {
                tempagain.add(tempvar[0]);
              }
            }
            if (attributeID != null) {
              editProvider!.selectedAttributeValues[attributeID] = tempagain;
            }
          }
          editProvider!.attributeIndiacator =
              editProvider!.attrController.length;
          if (widget.model!.prVarientList!.isEmpty.toString() == "false") {
            var index = widget.model!.prVarientList!.length;
            for (int i = 0; i < index; i++) {
              //old variant id
              editProvider!.oldVariantId = () {
                if (editProvider!.oldVariantId == "") {
                  return widget.model!.prVarientList![i].id;
                } else {
                  return "${editProvider!.oldVariantId!},${widget.model!.prVarientList![i].id!}";
                }
              }();
            }
          }
        }
        for (int i = 0; i < widget.model!.prVarientList!.length; i++) {
          editProvider!.variationList.add(widget.model!.prVarientList![i]);
          colCount = editProvider!.variationList[i].attr_name!.split(',');
        }
        editProvider!.col = colCount.length;
        editProvider!.row = widget.model!.prVarientList!.length;

        //===============================================================
      }
      if (widget.model!.stockType == "1") {
        // enable and product level
        editProvider!.isStockSelected = true;
        editProvider!.variantStockLevelType = 'product_level';
        editProvider!.variantProductProductLevelSaveSettings = true;
        if (widget.model!.prVarientList!.isNotEmpty) {
          if (widget.model!.prVarientList![0].sku != "") {
            editProvider!.variountProductSKUController.text =
                widget.model!.prVarientList![0].sku!;
            editProvider!.variantproductSKU =
                widget.model!.prVarientList![0].sku!;
          }
        }
        if (widget.model!.prVarientList![0].stock! != "") {
          editProvider!.variountProductTotalStock.text =
              widget.model!.prVarientList![0].stock!;
          editProvider!.variantproductTotalStock =
              widget.model!.prVarientList![0].stock!;
        }
        editProvider!.stockStatus = widget.model!.stockType!;

        // For variant =========================================================
        //======================================================================

        if (widget.model!.attributeList!.isEmpty.toString() == "false") {
          var index = widget.model!.attributeList!.length;
          for (int i = 0; i < index; i++) {
            var oldListOfAttributeValueID =
                widget.model!.attributeList![i].id.toString().split(',');
            //old variant id

            String? oldattributename = widget.model!.attributeList![i].name;
            editProvider!.attrController
                .add(TextEditingController(text: oldattributename));
            editProvider!.variationBoolList.add(true);
            // for get the value of element
            final attributes = editProvider!.attributesList
                .where((element) => element.name == oldattributename)
                .toList();
            String? attributeID;
            for (var element in attributes) {
              attributeID = element.id;
            }
            List<AttributeValueModel> tempagain = [];
            for (var element in oldListOfAttributeValueID) {
              final tempvar = editProvider!.attributesValueList
                  .where((e) => e.id == element)
                  .toList();
              if (tempvar.isNotEmpty) {
                tempagain.add(
                  tempvar[0],
                );
              }
            }
            if (attributeID != null) {
              editProvider!.selectedAttributeValues[attributeID] = tempagain;
            }
          }
          editProvider!.attributeIndiacator =
              editProvider!.attrController.length;
          if (widget.model!.prVarientList!.isEmpty.toString() == "false") {
            var index = widget.model!.prVarientList!.length;
            for (int i = 0; i < index; i++) {
              //old variant id
              editProvider!.oldVariantId = () {
                if (editProvider!.oldVariantId == "") {
                  return widget.model!.prVarientList![i].id;
                } else {
                  return "${editProvider!.oldVariantId!},${widget.model!.prVarientList![i].id!}";
                }
              }();
            }
          }
        }
        editProvider!.variationList.clear();
        for (int i = 0; i < widget.model!.prVarientList!.length; i++) {
          editProvider!.variationList.add(widget.model!.prVarientList![i]);
          colCount = editProvider!.variationList[i].attr_name!.split(',');
        }

        editProvider!.col = colCount.length;
        editProvider!.row = widget.model!.prVarientList!.length;

        //==============================================================================
        //==============================================================================
      }
      if (widget.model!.stockType == "2") {
        // enable and variable level
        // complete
        editProvider!.isStockSelected = true;
        editProvider!.variantStockLevelType = 'variable_level';
        editProvider!.variantProductVariableLevelSaveSettings = true;
        // For Atttribute Value
        //======================================================================
        if (widget.model!.attributeList!.isEmpty.toString() == "false") {
          var index = widget.model!.attributeList!.length;
          for (int i = 0; i < index; i++) {
            var oldListOfAttributeValueID =
                widget.model!.attributeList![i].id.toString().split(',');
            //old variant id
            String? oldattributename = widget.model!.attributeList![i].name;
            editProvider!.attrController.add(
              TextEditingController(text: oldattributename),
            );
            editProvider!.variationBoolList.add(true);
            // for get the value of element
            final attributes = editProvider!.attributesList
                .where((element) => element.name == oldattributename)
                .toList();
            String? attributeID;
            for (var element in attributes) {
              attributeID = element.id;
            }
            List<AttributeValueModel> tempagain = [];
            for (var element in oldListOfAttributeValueID) {
              List<AttributeValueModel> tempvar = editProvider!
                  .attributesValueList
                  .where((e) => e.id == element)
                  .toList();
              if (tempvar.isNotEmpty) {
                tempagain.add(
                  tempvar[0],
                );
              }
            }
            if (attributeID != null) {
              editProvider!.selectedAttributeValues[attributeID] = tempagain;
            }
          }
          editProvider!.attributeIndiacator =
              editProvider!.attrController.length;
          if (widget.model!.prVarientList!.isEmpty.toString() == "false") {
            var index = widget.model!.prVarientList!.length;
            for (int i = 0; i < index; i++) {
              //old variant id
              editProvider!.oldVariantId = () {
                if (editProvider!.oldVariantId == "") {
                  return widget.model!.prVarientList![i].id;
                } else {
                  return "${editProvider!.oldVariantId!},${widget.model!.prVarientList![i].id!}";
                }
              }();
            }
          }
        }
        editProvider!.variationList.clear();
        for (int i = 0; i < widget.model!.prVarientList!.length; i++) {
          editProvider!.variationList.add(widget.model!.prVarientList![i]);
          colCount = editProvider!.variationList[i].attr_name!.split(',');
        }
        int i = 0;
        for (var _ in editProvider!.variationList) {
          i = i + 1;
        }
        editProvider!.col = colCount.length;
        editProvider!.row = widget.model!.prVarientList!.length;
      }
    }

//----------------------------------------------------------------------------
//========================= Variant Product ==================================

    if (editProvider!.productType == "digital_product") {
      editProvider!.currentSellectedProductIsPysical = false;
      //
      if (widget.model!.prVarientList![widget.model!.selVarient!].price !=
          null) {
        editProvider!.digitalPriceController.text =
            widget.model!.prVarientList![widget.model!.selVarient!].price!;

        // editProvider!.simpleproductPrice =
        //     widget.model!.prVarientList![widget.model!.selVarient!].price!;
      }
      // simple product special price
      if (widget.model!.prVarientList![widget.model!.selVarient!].disPrice !=
          null) {
        editProvider!.digitalSpecialController.text =
            widget.model!.prVarientList![widget.model!.selVarient!].disPrice!;
      }
      if (widget.model!.downloadAllowed != null) {
        editProvider!.digitalProductDownloaded =
            widget.model!.downloadAllowed == "1" ? true : false;
        if (widget.model!.downloadAllowed == "1") {
          if (widget.model!.downloadType == "self_hosted") {
            editProvider!.selectedDigitalProductTypeOfDownloadLink =
                'Self Hosted';
            editProvider!.digitalProductNamePathNameForSelectedFile =
                widget.model!.downloadLink!;
            // code is painding for selfhosted
          }
          if (widget.model!.downloadType == "add_link") {
            editProvider!.selectedDigitalProductTypeOfDownloadLink = 'Add Link';
            editProvider!.selfHostedDigitalProductURLController.text =
                widget.model!.downloadLink ?? "";
          }
          if (widget.model!.downloadLink == "" ||
              widget.model!.downloadLink == null) {
            editProvider!.selectedDigitalProductTypeOfDownloadLink =
                'Self Hosted';
          }
        }
      }

      // for attribute
      editProvider!.digitalProductSaveSettings = true;

      if (widget.model!.attributeList!.isEmpty.toString() == "false") {
        var index = widget.model!.attributeList!.length;
        for (int i = 0; i < index; i++) {
          var oldListOfAttributeValueID =
              widget.model!.attributeList![i].id.toString().split(',');

          String? oldattributename = widget.model!.attributeList![i].name;
          editProvider!.attrController
              .add(TextEditingController(text: oldattributename));
          editProvider!.variationBoolList.add(true);
          // for get the value of element
          final attributes = editProvider!.attributesList
              .where((element) => element.name == oldattributename)
              .toList();
          String? attributeID;
          for (var element in attributes) {
            attributeID = element.id;
          }
          List<AttributeValueModel> tempagain = [];
          for (var element in oldListOfAttributeValueID) {
            final tempvar = editProvider!.attributesValueList
                .where((e) => e.id == element)
                .toList();
            if (tempvar.isNotEmpty) {
              tempagain.add(tempvar[0]);
            }
          }
          if (attributeID != null) {
            editProvider!.selectedAttributeValues[attributeID] = tempagain;
          }
        }
        editProvider!.attributeIndiacator = editProvider!.attrController.length;
        if (widget.model!.prVarientList!.isEmpty.toString() == "false") {
          var index = widget.model!.prVarientList!.length;
          for (int i = 0; i < index; i++) {
            //old variant id
            editProvider!.oldVariantId = () {
              if (editProvider!.oldVariantId == "") {
                return widget.model!.prVarientList![i].id;
              } else {
                return "${editProvider!.oldVariantId!},${widget.model!.prVarientList![i].id!}";
              }
            }();
          }
        }
      }
    }
//------------------------------------------------------------------------------
//========================= Loading Indiacator =================================

    setState(
      () {
        editProvider!.isLoading = false;
      },
    );
  }

  Future<void> getBrands() async {
    context.read<SettingProvider>().CUR_USERID = await getPrefrence(Id);
    var parameter = {
      // SellerId: context.read<SettingProvider>().CUR_USERID,
    };
    apiBaseHelper.postAPICall(getBrandsDataApi, parameter).then(
      (getdata) async {
        bool error = getdata["error"];
        String? msg = getdata["message"];

        if (!error) {
          editProvider!.brandList.clear();
          var data = getdata["data"];
          editProvider!.brandList =
              (data as List).map((data) => BrandModel.fromJson(data)).toList();
        } else {
          setSnackbar(
            msg!,
            context,
          );
        }
      },
      onError: (error) {
        setSnackbar(
          error.toString(),
          context,
        );
      },
    );
  }

  attributeDialog(int pos) async {
    await showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setStater) {
            editProvider!.taxesState = setStater;
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(circularBorderRadius25),
                  topRight: Radius.circular(circularBorderRadius25),
                ),
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Padding(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              getTranslated(context, "Select Attribute")!,
                              style: Theme.of(this.context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(color: primary),
                            ),
                          ],
                        ),
                      ),
                      const Divider(color: lightBlack),
                      editProvider!.suggessionisNoData
                          ? DesignConfiguration.getNoItem(context)
                          : SizedBox(
                              width: double.maxFinite,
                              height: editProvider!.attributeSetList.isNotEmpty
                                  ? MediaQuery.of(context).size.height * 0.3
                                  : 0,
                              child: SingleChildScrollView(
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount:
                                      editProvider!.attributeSetList.length,
                                  itemBuilder: (context, index) {
                                    List<AttributeModel> attrList = [];

                                    AttributeSetModel item =
                                        editProvider!.attributeSetList[index];

                                    for (int i = 0;
                                        i < editProvider!.attributesList.length;
                                        i++) {
                                      if (item.id ==
                                          editProvider!.attributesList[i]
                                              .attributeSetId) {
                                        attrList.add(
                                            editProvider!.attributesList[i]);
                                      }
                                    }
                                    return Material(
                                      child: StickyHeaderBuilder(
                                        builder: (BuildContext context,
                                            double stuckAmount) {
                                          return Container(
                                            decoration: BoxDecoration(
                                                color: primary,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        circularBorderRadius5)),
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8.0, vertical: 2),
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              editProvider!
                                                      .attributeSetList[index]
                                                      .name ??
                                                  '',
                                              style: const TextStyle(
                                                  color: Colors.white),
                                            ),
                                          );
                                        },
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: List<int>.generate(
                                              attrList.length, (i) => i).map(
                                            (item) {
                                              return InkWell(
                                                onTap: () {
                                                  setState(
                                                    () {
                                                      editProvider!
                                                          .attrController[pos]
                                                          .text = attrList[
                                                              item]
                                                          .name!;
                                                      editProvider!
                                                              .attributeIndiacator =
                                                          pos + 1;
                                                      if (!editProvider!.attrId
                                                          .contains(int.parse(
                                                              attrList[item]
                                                                  .id!))) {
                                                        editProvider!.attrId
                                                            .add(int.parse(
                                                                attrList[item]
                                                                    .id!));
                                                        Navigator.pop(context);
                                                      } else {
                                                        setSnackbar(
                                                          getTranslated(context,
                                                              "Already inserted..")!,
                                                          context,
                                                        );
                                                      }
                                                    },
                                                  );
                                                },
                                                child: Container(
                                                  width: double.maxFinite,
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text(
                                                    attrList[item].name ?? '',
                                                    textAlign: TextAlign.start,
                                                  ),
                                                ),
                                              );
                                            },
                                          ).toList(),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

//------------------------------------------------------------------------------
//========================= Other Image ========================================

// logic painding

  otherImages(String from, int pos) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            getTranslated(context, "Other Images")!,
          ),
          InkWell(
            child: Container(
              decoration: BoxDecoration(
                color: primary,
                borderRadius: BorderRadius.circular(circularBorderRadius5),
              ),
              width: 90,
              height: 40,
              child: Center(
                child: Text(
                  getTranslated(context, "Upload")!,
                  style: const TextStyle(
                    color: white,
                  ),
                ),
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) => Media(
                    from: from,
                    pos: pos,
                    type: "edit",
                  ),
                ),
              ).then(
                (value) => setState(
                  () {},
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  variantOtherImageShow(int pos) {
    return editProvider!.variationList.length == pos ||
            editProvider!.variationList[pos].images == null ||
            editProvider!.variationList[pos].images!.isEmpty
        ? Container()
        : Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: double.infinity,
              height: 105,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: editProvider!.variationList[pos].images!.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, i) {
                  return InkWell(
                    child: Stack(
                      alignment: AlignmentDirectional.topEnd,
                      children: [
                        ClipRRect(
                          borderRadius:
                              BorderRadius.circular(circularBorderRadius5),
                          child: DesignConfiguration.getCacheNotworkImage(
                            boxFit: BoxFit.cover,
                            context: context,
                            heightvalue: 100.0,
                            placeHolderSize: 100.0,
                            imageurlString: editProvider!
                                    .variationList[pos].imagesUrl?[i] ??
                                editProvider!.variationList[pos].images![i],
                            widthvalue: 100.0,
                          ),
                        ),
                        /* Image.network(
                          editProvider!.variationList[pos].images![i],
                          width: 100,
                          height: 100,
                        ),*/
                        Container(
                          color: Colors.black26,
                          child: const Icon(
                            Icons.clear,
                            size: 15,
                          ),
                        )
                      ],
                    ),
                    onTap: () {
                      if (mounted) {
                        setState(
                          () {
                            editProvider!.variationList[pos].images!
                                .removeAt(i);
                            try {
                              editProvider!
                                  .variationList[pos].imageRelativePath!
                                  .removeAt(i);
                            } catch (_) {}
                          },
                        );
                      }
                    },
                  );
                },
              ),
            ),
          );
  }

//------------------------------------------------------------------------------
//========================= Additional Info ====================================

// logic painding

  additionalInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // currentSelectedPossitionBord(context, setStateNow),
        editProvider!.curSelPos == 0
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  getCommanSizedBox(),
                  getPrimaryCommanText(
                      getTranslated(context, "Type Of Product")!, false),
                  getCommanSizedBox(),

                  getIconSelectionDesing(
                    getTranslated(context, "Select Type")!,
                    9,
                    context,
                    setStateNow,
                  ),
                  editProvider!.productType == 'simple_product'
                      ? getCommanSizedBox()
                      : Container(),
                  editProvider!.productType == 'simple_product'
                      ? getCommanSizedBox()
                      : Container(),
                  editProvider!.productType == 'simple_product'
                      ? Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: getPrimaryCommanText(
                                  getTranslated(context, "PRICE_LBL")!, true),
                            ),
                            Expanded(
                              flex: 3,
                              child: getCommanInputTextField(
                                " ",
                                10,
                                0.06,
                                1,
                                3,
                                context,
                              ),
                            ),
                          ],
                        )
                      : Container(),
                  // For Simple Product

                  editProvider!.productType == 'simple_product'
                      ? getCommanSizedBox()
                      : Container(),

                  editProvider!.productType == 'simple_product'
                      ? Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: getPrimaryCommanText(
                                  getTranslated(context, "Special Price")!,
                                  true),
                            ),
                            Expanded(
                              flex: 3,
                              child: getCommanInputTextField(
                                //logic painding
                                " ",
                                11,
                                0.06,
                                1,
                                3, context,
                              ),
                            ),
                          ],
                        )
                      : Container(),
                  editProvider!.productType == 'simple_product'
                      ? getCommanSizedBox()
                      : Container(),
                  editProvider!.productType != 'digital_product'
                      ? Row(
                          children: [
                            Expanded(
                              flex: 5,
                              child: getPrimaryCommanText(
                                  getTranslated(
                                      context, "Enable Stock Management")!,
                                  true),
                            ),
                            Expanded(
                              flex: 2,
                              child: CheckboxListTile(
                                value: editProvider!.isStockSelected ?? false,
                                onChanged: (bool? value) {
                                  setState(
                                    () {
                                      editProvider!.isStockSelected = value!;
                                    },
                                  );
                                },
                              ),
                            ),
                          ],
                        )
                      : Container(),
                  editProvider!.isStockSelected != null &&
                          editProvider!.isStockSelected == true &&
                          editProvider!.productType == 'simple_product'
                      ? Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: getPrimaryCommanText(
                                      getTranslated(context, "SKU")!, true),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: getCommanInputTextField(
                                    //logic painding
                                    " ",
                                    12,
                                    0.06,
                                    1,
                                    2, context,
                                  ),
                                ),
                              ],
                            ),
                            getCommanSizedBox(),
                            Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: getPrimaryCommanText(
                                      getTranslated(context, "Total Stock")!,
                                      true),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: getCommanInputTextField(
                                    " ",
                                    13,
                                    0.06,
                                    1,
                                    3,
                                    context,
                                  ),
                                ),
                              ],
                            ),
                            getCommanSizedBox(),
                            getIconSelectionDesing(
                              getTranslated(context, "Select Stock Status")!,
                              10,
                              context,
                              setStateNow,
                            ),
                          ],
                        )
                      : Container(),
                  editProvider!.productType == 'simple_product'
                      ? getCommanSizedBox()
                      : Container(),
                  editProvider!.productType == 'simple_product'
                      ? getCommanSizedBox()
                      : Container(),
                  editProvider!.productType == 'simple_product'
                      ? getCommonButton(
                          getTranslated(context, "Save Settings")!,
                          4,
                          setStateNow,
                          context)
                      : Container(),

                  editProvider!.isStockSelected != null &&
                          editProvider!.isStockSelected == true &&
                          editProvider!.productType == 'variable_product'
                      ? getPrimaryCommanText(
                          getTranslated(
                              context, "Choose Stock Management Type")!,
                          false)
                      : Container(),
                  editProvider!.productType == 'variable_product'
                      ? getCommanSizedBox()
                      : Container(),
                  editProvider!.isStockSelected != null &&
                          editProvider!.isStockSelected == true &&
                          editProvider!.productType == 'variable_product'
                      ? getIconSelectionDesing(
                          getTranslated(context, "Select Stock Status")!,
                          11,
                          context,
                          setStateNow,
                        )
                      : Container(),
                  editProvider!.productType == 'variable_product' &&
                          editProvider!.variantStockLevelType ==
                              "product_level" &&
                          editProvider!.isStockSelected != null &&
                          editProvider!.isStockSelected == true
                      ? Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            getCommanSizedBox(),
                            Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: getPrimaryCommanText(
                                      getTranslated(context, "SKU")!, true),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: getCommanInputTextField(
                                    " ",
                                    14,
                                    0.06,
                                    1,
                                    2,
                                    context,
                                  ),
                                ),
                              ],
                            ),
                            getCommanSizedBox(),
                            Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: getPrimaryCommanText(
                                      getTranslated(context, "Total Stock")!,
                                      true),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: getCommanInputTextField(
                                    " ",
                                    15,
                                    0.06,
                                    1,
                                    3,
                                    context,
                                  ),
                                ),
                              ],
                            ),
                            getPrimaryCommanText("Stock Status", false),
                            getCommanSizedBox(),
                            getIconSelectionDesing(
                              getTranslated(context, "Select Stock Status")!,
                              12,
                              context,
                              setStateNow,
                            ),
                          ],
                        )
                      : Container(),
                  getCommanSizedBox(),
                  getCommanSizedBox(),

                  editProvider!.productType == 'variable_product' &&
                          editProvider!.variantStockLevelType == "product_level"
                      ? getCommonButton(
                          getTranslated(context, "Save Settings")!,
                          5,
                          setStateNow,
                          context)
                      : Container(),

                  editProvider!.productType == 'variable_product' &&
                          editProvider!.variantStockLevelType ==
                              "variable_level"
                      ? getCommonButton(
                          getTranslated(context, "Save Settings")!,
                          6,
                          setStateNow,
                          context)
                      : Container(),

                  //Digital Product

                  editProvider!.productType == 'digital_product'
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: getPrimaryCommanText(
                                      getTranslated(context, "PRICE_LBL")!,
                                      true),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: getCommanInputTextField(
                                    " ",
                                    17,
                                    0.06,
                                    1,
                                    3,
                                    context,
                                  ),
                                ),
                              ],
                            ),
                            getCommanSizedBox(),
                            Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: getPrimaryCommanText(
                                      getTranslated(context, "Special Price")!,
                                      true),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: getCommanInputTextField(
                                    " ",
                                    18,
                                    0.06,
                                    1,
                                    3,
                                    context,
                                  ),
                                ),
                              ],
                            ),
                            getCommanSizedBox(),
                            Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: getPrimaryCommanText(
                                      "Is Download allowed?", true),
                                ),
                                getCommanSwitch(5, setState),
                              ],
                            ),
                            getCommanSizedBox(),
                            editProvider!.digitalProductDownloaded
                                ? Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      getPrimaryCommanText(
                                          'Download Link Type', false),
                                      getCommanSizedBox(),
                                      getIconSelectionDesing(
                                        "Self Hosted",
                                        14,
                                        context,
                                        setState,
                                      ),
                                      editProvider!
                                                  .selectedDigitalProductTypeOfDownloadLink ==
                                              'Self Hosted'
                                          ? getCommanSizedBox()
                                          : Container(),
                                      editProvider!
                                                  .selectedDigitalProductTypeOfDownloadLink ==
                                              'Self Hosted'
                                          ? getCommanSizedBox()
                                          : Container(),
                                      editProvider!
                                                  .selectedDigitalProductTypeOfDownloadLink ==
                                              'Self Hosted'
                                          ? InkWell(
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: primary,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          circularBorderRadius5),
                                                ),
                                                width: 90,
                                                height: 40,
                                                child: Center(
                                                  child: Text(
                                                    getTranslated(
                                                        context, "Upload")!,
                                                    style: const TextStyle(
                                                      color: white,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  CupertinoPageRoute(
                                                    builder: (context) =>
                                                        const Media(
                                                      from: "archive,document",
                                                      pos: 0,
                                                      type: "edit",
                                                    ),
                                                  ),
                                                ).then(
                                                    (value) => setState(() {}));
                                              },
                                            )
                                          : Container(),
                                      editProvider!.selectedDigitalProductTypeOfDownloadLink ==
                                                  'Self Hosted' &&
                                              editProvider!
                                                      .digitalProductNamePathNameForSelectedFile !=
                                                  ''
                                          ? Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Row(
                                                children: [
                                                  const Icon(
                                                      Icons.file_open_rounded),
                                                  const SizedBox(
                                                    width: 5,
                                                  ),
                                                  Expanded(
                                                    child: Text(
                                                      editProvider!
                                                          .digitalProductNamePathNameForSelectedFile,
                                                      maxLines: 10,
                                                      softWrap: true,
                                                      style: const TextStyle(
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          : Container(),
                                      editProvider!
                                                  .selectedDigitalProductTypeOfDownloadLink ==
                                              'Add Link'
                                          ? getCommanSizedBox()
                                          : Container(),
                                      editProvider!
                                                  .selectedDigitalProductTypeOfDownloadLink ==
                                              'Add Link'
                                          ? getPrimaryCommanText(
                                              'Digital Product Link', false)
                                          : Container(),
                                      editProvider!
                                                  .selectedDigitalProductTypeOfDownloadLink ==
                                              'Add Link'
                                          ? getCommanSizedBox()
                                          : Container(),
                                      editProvider!
                                                  .selectedDigitalProductTypeOfDownloadLink ==
                                              'Add Link'
                                          ? getCommanInputTextField(
                                              'Paste digital product link or URL here',
                                              19,
                                              0.06,
                                              1,
                                              2,
                                              context,
                                            )
                                          : Container(),
                                    ],
                                  )
                                : Container(),
                            getCommanSizedBox(),
                            InkWell(
                              onTap: () {
                                if (editProvider!
                                    .digitalPriceController.text.isEmpty) {
                                  setSnackbar(
                                    getTranslated(
                                        context, "Please enter product price")!,
                                    context,
                                  );
                                } else if (editProvider!
                                    .digitalSpecialController.text.isEmpty) {
                                  editProvider!.digitalProductSaveSettings =
                                      true;
                                  setSnackbar(
                                    getTranslated(
                                        context, "Setting saved successfully")!,
                                    context,
                                  );
                                  setState(() {});
                                } else if (int.parse(editProvider!
                                        .digitalPriceController.text) <
                                    int.parse(editProvider!
                                        .digitalSpecialController.text)) {
                                  setSnackbar(
                                    getTranslated(context,
                                        "Special price must be less than original price")!,
                                    context,
                                  );
                                } else {
                                  editProvider!.digitalProductSaveSettings =
                                      true;
                                  setSnackbar(
                                    getTranslated(
                                        context, "Setting saved successfully")!,
                                    context,
                                  );
                                  setState(() {});
                                }
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                      circularBorderRadius5),
                                  color: primary,
                                ),
                                height: 35,
                                child: Center(
                                  child: Text(
                                    getTranslated(context, "Save Settings")!,
                                    style: const TextStyle(
                                      fontSize: textFontSize16,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      : Container(),
                ],
              )
            : Container(),

// current selected possition == 1

        editProvider!.curSelPos == 1 &&
                (editProvider!.simpleProductSaveSettings ||
                    editProvider!.variantProductVariableLevelSaveSettings ||
                    editProvider!.variantProductProductLevelSaveSettings ||
                    editProvider!.digitalProductSaveSettings)
            ? Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  getCommanSizedBox(),
                  getCommanSizedBox(),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      getPrimaryCommanText(
                          getTranslated(context, "Attributes")!, false),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          OutlinedButton(
                            onPressed: () {
                              if (editProvider!.attributeIndiacator ==
                                  editProvider!.attrController.length) {
                                setState(
                                  () {
                                    editProvider!.attrController
                                        .add(TextEditingController());
                                    editProvider!.variationBoolList.add(false);
                                  },
                                );
                              } else {
                                setSnackbar(
                                  getTranslated(context,
                                      "fill the box then add another")!,
                                  context,
                                );
                              }
                            },
                            child: Text(
                                getTranslated(context, "Add Attribute")!,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold)),
                          ),
                          OutlinedButton(
                            onPressed: () {
                              editProvider!.tempAttList.clear();
                              List<String> attributeIds = [];
                              for (var i = 0;
                                  i < editProvider!.variationBoolList.length;
                                  i++) {
                                if (editProvider!.variationBoolList[i]) {
                                  final attributes = editProvider!
                                      .attributesList
                                      .where((element) =>
                                          element.name ==
                                          editProvider!.attrController[i].text)
                                      .toList();
                                  if (attributes.isNotEmpty) {
                                    attributeIds.add(attributes.first.id!);
                                  }
                                }
                              }
                              setState(
                                () {
                                  editProvider!.resultAttr = [];
                                  editProvider!.resultID = [];
                                  editProvider!.variationList = [];
                                  editProvider!.finalAttList = [];
                                  for (var key in attributeIds) {
                                    editProvider!.tempAttList.add(editProvider!
                                        .selectedAttributeValues[key]!);
                                  }
                                  for (int i = 0;
                                      i < editProvider!.tempAttList.length;
                                      i++) {
                                    editProvider!.finalAttList
                                        .add(editProvider!.tempAttList[i]);
                                  }
                                  if (editProvider!.finalAttList.isNotEmpty) {
                                    editProvider!.max =
                                        editProvider!.finalAttList.length - 1;

                                    getCombination([], [], 0);
                                    editProvider!.row = 1;
                                    editProvider!.col = editProvider!.max! + 1;
                                    for (int i = 0;
                                        i < editProvider!.col!;
                                        i++) {
                                      int singleRow =
                                          editProvider!.finalAttList[i].length;
                                      editProvider!.row =
                                          editProvider!.row * singleRow;
                                    }
                                  }
                                  setSnackbar(
                                    getTranslated(context,
                                        "Attributes saved successfully")!,
                                    context,
                                  );
                                },
                              );
                            },
                            child: Text(
                              getTranslated(context, "Save Attribute")!,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  getCommanSizedBox(),
                  editProvider!.productType == 'variable_product'
                      ? Text(
                          getTranslated(
                            context,
                            "Note : select checkbox if the attribute is to be used for variation",
                          )!,
                        )
                      : Container(),
                  getCommanSizedBox(),
                  for (int i = 0; i < editProvider!.attrController.length; i++)
                    addAttribute(i)
                ],
              )
            : Container(),
        editProvider!.curSelPos == 2 && editProvider!.variationList.isNotEmpty
            ? ListView.builder(
                itemCount: editProvider!.row,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, i) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: white,
                        borderRadius:
                            BorderRadius.circular(circularBorderRadius5),
                        border: Border.all(
                          color: grey1,
                          style: BorderStyle.solid,
                          width: 1.0,
                        ),
                      ),
                      //    color: Colors.red,
                      child: ExpansionTile(
                        textColor: Colors.green,
                        title: Row(
                          children: [
                            for (int j = 0; j < editProvider!.col!; j++)
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: Text(
                                      editProvider!.variationList[i].attr_name!
                                          .split(',')[j],
                                      style: const TextStyle(
                                        color: lightBlack2,
                                      )),
                                ),
                              ),
                            InkWell(
                              child: const Padding(
                                padding: EdgeInsets.all(5.0),
                                child: Icon(
                                  Icons.close,
                                  color: lightBlack2,
                                ),
                              ),
                              onTap: () {
                                editProvider!.variationList.removeAt(i);
                                editProvider!.row = editProvider!.row - 1;
                                setState(
                                  () {},
                                );
                              },
                            ),
                          ],
                        ),
                        children: <Widget>[
                          Column(
                            children: _buildExpandableContent(i),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              )
            : Container()
      ],
    );
  }

  getCombination(List<String> att, List<String> attId, int i) {
    for (int j = 0, l = editProvider!.finalAttList[i].length; j < l; j++) {
      List<String> a = [];
      List<String> aId = [];
      if (att.isNotEmpty) {
        a.addAll(att);
        aId.addAll(attId);
      }
      a.add(editProvider!.finalAttList[i][j].value!);
      aId.add(editProvider!.finalAttList[i][j].id!);

      if (i == editProvider!.max) {
        editProvider!.resultAttr.addAll(a);
        editProvider!.resultID.addAll(aId);

        Product_Varient model =
            Product_Varient(attr_name: a.join(","), id: aId.join(","));

        editProvider!.variationList.add(model);
      } else {
        getCombination(a, aId, i + 1);
      }
    }
  }

  _buildExpandableContent(int pos) {
    List<Widget> columnContent = [];

    columnContent.add(
      variantProductPrice(pos),
    );
    columnContent.add(
      variantProductSpecialPrice(pos),
    );
    columnContent.add(
      variantProductWeight(pos),
    );
    columnContent.add(
      variantProductHeight(pos),
    );
    columnContent.add(
      variantProductBreadth(pos),
    );
    columnContent.add(
      variantProductLength(pos),
    );

    columnContent.add(
      editProvider!.productType == 'variable_product' &&
              editProvider!.variantStockLevelType == "variable_level" &&
              editProvider!.isStockSelected != null &&
              editProvider!.isStockSelected == true
          ? Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                variableVariableSKU(pos),
                variantVariableTotalstock(pos),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    getTranslated(context, "Stock Status :")!,
                  ),
                ),
                variantStockStatusSelect(pos)
              ],
            )
          : Container(),
    );

    columnContent.add(otherImages("variant", pos));

    columnContent.add(variantOtherImageShow(pos));
    return columnContent;
  }

// ========== variant Product Price add In side the variant price add ==========

  Widget variantProductPrice(int pos) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: width * 0.4,
            child: Text(
              "${getTranslated(context, "PRICE_LBL")!} :",
              style: const TextStyle(
                fontSize: textFontSize16,
                color: black,
              ),
              maxLines: 2,
            ),
          ),
          Container(
            width: width * 0.4,
            height: 40,
            padding: const EdgeInsets.only(),
            child: TextFormField(
              keyboardType: TextInputType.number,
              initialValue: editProvider!.variationList[pos].price ?? '',
              style: const TextStyle(
                color: fontColor,
                fontWeight: FontWeight.normal,
              ),
              textInputAction: TextInputAction.next,
              onChanged: (String? value) {
                editProvider!.variationList[pos].price = value;
              },
              decoration: InputDecoration(
                filled: true,
                fillColor: lightWhite,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                prefixIconConstraints:
                    const BoxConstraints(minWidth: 40, maxHeight: 20),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: fontColor),
                  borderRadius: BorderRadius.circular(circularBorderRadius7),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: const BorderSide(color: lightWhite),
                  borderRadius: BorderRadius.circular(circularBorderRadius8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget variantProductSpecialPrice(int pos) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: width * 0.4,
            child: Text(
              "${getTranslated(context, "Special Price")!} :",
              style: const TextStyle(
                fontSize: textFontSize16,
                color: black,
              ),
              maxLines: 2,
            ),
          ),
          Container(
            width: width * 0.4,
            height: 40,
            padding: const EdgeInsets.only(),
            child: TextFormField(
              keyboardType: TextInputType.number,
              initialValue: editProvider!.variationList[pos].disPrice ?? '',
              style: const TextStyle(
                color: fontColor,
                fontWeight: FontWeight.normal,
              ),
              textInputAction: TextInputAction.next,
              onChanged: (String? value) {
                editProvider!.variationList[pos].disPrice = value;
              },
              decoration: InputDecoration(
                filled: true,
                fillColor: lightWhite,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                prefixIconConstraints:
                    const BoxConstraints(minWidth: 40, maxHeight: 20),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: fontColor),
                  borderRadius: BorderRadius.circular(circularBorderRadius7),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: const BorderSide(color: lightWhite),
                  borderRadius: BorderRadius.circular(circularBorderRadius8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget variantProductHeight(int pos) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: width * 0.4,
            child: Text(
              "${getTranslated(context, "Height (cms)")!} :",
              style: const TextStyle(
                fontSize: textFontSize16,
                color: black,
              ),
              maxLines: 2,
            ),
          ),
          Container(
            width: width * 0.4,
            height: 40,
            padding: const EdgeInsets.only(),
            child: TextFormField(
              keyboardType: TextInputType.number,
              initialValue: editProvider!.variationList[pos].height ?? '',
              style: const TextStyle(
                color: fontColor,
                fontWeight: FontWeight.normal,
              ),
              textInputAction: TextInputAction.next,
              onChanged: (String? value) {
                editProvider!.variationList[pos].height = value;
              },
              decoration: InputDecoration(
                filled: true,
                fillColor: lightWhite,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                prefixIconConstraints:
                    const BoxConstraints(minWidth: 40, maxHeight: 20),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: fontColor),
                  borderRadius: BorderRadius.circular(circularBorderRadius7),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: const BorderSide(color: lightWhite),
                  borderRadius: BorderRadius.circular(circularBorderRadius8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget variantProductWeight(int pos) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: width * 0.4,
            child: Text(
              "${getTranslated(context, "Weight (kg)")!} :",
              style: const TextStyle(
                fontSize: textFontSize16,
                color: black,
              ),
              maxLines: 2,
            ),
          ),
          Container(
            width: width * 0.4,
            height: 40,
            padding: const EdgeInsets.only(),
            child: TextFormField(
              keyboardType: TextInputType.number,
              initialValue: editProvider!.variationList[pos].weight ?? '',
              style: const TextStyle(
                color: fontColor,
                fontWeight: FontWeight.normal,
              ),
              textInputAction: TextInputAction.next,
              onChanged: (String? value) {
                editProvider!.variationList[pos].weight = value;
              },
              decoration: InputDecoration(
                filled: true,
                fillColor: lightWhite,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                prefixIconConstraints:
                    const BoxConstraints(minWidth: 40, maxHeight: 20),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: fontColor),
                  borderRadius: BorderRadius.circular(circularBorderRadius7),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: const BorderSide(color: lightWhite),
                  borderRadius: BorderRadius.circular(circularBorderRadius8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget variantProductBreadth(int pos) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: width * 0.4,
            child: Text(
              "${getTranslated(context, "Breadth (cms)")!} :",
              style: const TextStyle(
                fontSize: textFontSize16,
                color: black,
              ),
              maxLines: 2,
            ),
          ),
          Container(
            width: width * 0.4,
            height: 40,
            padding: const EdgeInsets.only(),
            child: TextFormField(
              keyboardType: TextInputType.number,
              initialValue: editProvider!.variationList[pos].breadth ?? '',
              style: const TextStyle(
                color: fontColor,
                fontWeight: FontWeight.normal,
              ),
              textInputAction: TextInputAction.next,
              onChanged: (String? value) {
                editProvider!.variationList[pos].breadth = value;
              },
              decoration: InputDecoration(
                filled: true,
                fillColor: lightWhite,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                prefixIconConstraints:
                    const BoxConstraints(minWidth: 40, maxHeight: 20),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: fontColor),
                  borderRadius: BorderRadius.circular(circularBorderRadius7),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: const BorderSide(color: lightWhite),
                  borderRadius: BorderRadius.circular(circularBorderRadius8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget variantProductLength(int pos) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: width * 0.4,
            child: Text(
              "${getTranslated(context, "Length (kg)")!} :",
              style: const TextStyle(
                fontSize: textFontSize16,
                color: black,
              ),
              maxLines: 2,
            ),
          ),
          Container(
            width: width * 0.4,
            height: 40,
            padding: const EdgeInsets.only(),
            child: TextFormField(
              keyboardType: TextInputType.number,
              initialValue: editProvider!.variationList[pos].length ?? '',
              style: const TextStyle(
                color: fontColor,
                fontWeight: FontWeight.normal,
              ),
              textInputAction: TextInputAction.next,
              onChanged: (String? value) {
                editProvider!.variationList[pos].length = value;
              },
              decoration: InputDecoration(
                filled: true,
                fillColor: lightWhite,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                prefixIconConstraints:
                    const BoxConstraints(minWidth: 40, maxHeight: 20),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: fontColor),
                  borderRadius: BorderRadius.circular(circularBorderRadius7),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: const BorderSide(color: lightWhite),
                  borderRadius: BorderRadius.circular(circularBorderRadius8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  addValAttribute(List<AttributeValueModel> selected,
      List<AttributeValueModel> searchRange, String attributeId) {
    showModalBottomSheet<List<AttributeValueModel>>(
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(circularBorderRadius10),
          topRight: Radius.circular(circularBorderRadius10),
        ),
      ),
      enableDrag: true,
      context: context,
      builder: (context) {
        return SizedBox(
          height: 240,
          width: MediaQuery.of(context).size.width,
          child: CustomScrollView(
            slivers: <Widget>[
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            getTranslated(context, "Select Attribute Value")!,
                            style: const TextStyle(
                              fontSize: textFontSize18,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ],
                    ),
                    const Divider(
                      color: Colors.grey,
                    ),
                  ],
                ),
              ),
              SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 2,
                    mainAxisSpacing: 5.0,
                    crossAxisSpacing: 5.0),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return filterChipWidget(
                      chipName: searchRange[index],
                      selectedList: selected,
                      update: update,
                      fromAdd: false,
                    );
                  },
                  childCount: searchRange.length,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  update() {
    setState(
      () {},
    );
  }

  addAttribute(int pos) {
    final result = editProvider!.attributesList
        .where(
            (element) => element.name == editProvider!.attrController[pos].text)
        .toList();
    final attributeId = result.isEmpty ? "" : result.first.id;
    return Card(
      color: lightWhite,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(circularBorderRadius15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  getTranslated(context, "Select Attribute")!,
                ),
                Checkbox(
                  value: editProvider!.variationBoolList[pos],
                  onChanged: (bool? value) {
                    setState(
                      () {
                        editProvider!.variationBoolList[pos] = value ?? false;
                      },
                    );
                  },
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: TextFormField(
              textAlign: TextAlign.center,
              readOnly: true,
              onTap: () {
                attributeDialog(pos);
              },
              controller: editProvider!.attrController[pos],
              keyboardType: TextInputType.text,
              style: const TextStyle(
                color: primary,
                fontWeight: FontWeight.normal,
              ),
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                filled: true,
                fillColor: lightWhite,
                hintText: getTranslated(context, "Select Attributes")!,
                hintStyle: const TextStyle(
                  color: primary,
                  fontWeight: FontWeight.normal,
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                prefixIconConstraints:
                    const BoxConstraints(minWidth: 40, maxHeight: 20),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.transparent),
                  borderRadius: BorderRadius.circular(circularBorderRadius7),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: const BorderSide(color: lightWhite),
                  borderRadius: BorderRadius.circular(circularBorderRadius8),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: GestureDetector(
              onTap: () {
                final attributeValues = editProvider!.attributesValueList
                    .where((element) => element.attributeId == attributeId)
                    .toList();

                addValAttribute(
                    editProvider!.selectedAttributeValues[attributeId]!,
                    attributeValues,
                    attributeId!);
              },
              child: Container(
                width: width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(circularBorderRadius7),
                  color: lightWhite,
                ),
                constraints: const BoxConstraints(
                  minHeight: 50,
                ),
                child: (editProvider!.selectedAttributeValues[attributeId!] ??
                            [])
                        .isEmpty
                    ? Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Center(
                          child: Text(
                            getTranslated(context, "Add attribute value")!,
                            style: const TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      )
                    : Wrap(
                        alignment: WrapAlignment.center,
                        direction: Axis.horizontal,
                        children:
                            editProvider!.selectedAttributeValues[attributeId]!
                                .map(
                                  (value) => Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                            circularBorderRadius10),
                                        color: primary_app,
                                        border: Border.all(
                                          color: black,
                                          width: 0.5,
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          value.value!,
                                          style: const TextStyle(
                                            color: white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  variantStockStatusSelect(int pos) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        child: Container(
          padding: const EdgeInsets.only(
            top: 5,
            bottom: 5,
            left: 5,
            right: 5,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(circularBorderRadius10),
            border: Border.all(
              color: lightBlack,
              width: 1,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      editProvider!.variationList[pos].stockStatus == '1'
                          ? getTranslated(context, "In Stock")!
                          : getTranslated(context, "Out Of Stock")!,
                    )
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_drop_down,
                color: primary,
              )
            ],
          ),
        ),
        onTap: () {
          variantStockStatusDialog("variable", pos, context, update);
        },
      ),
    );
  }

  variantVariableTotalstock(int pos) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: width * 0.4,
            child: Text(
              "${getTranslated(context, "Total Stock")!} :",
              style: const TextStyle(
                fontSize: textFontSize16,
                color: black,
              ),
              maxLines: 2,
            ),
          ),
          Container(
            width: width * 0.4,
            padding: const EdgeInsets.only(),
            child: TextFormField(
              keyboardType: TextInputType.number,
              initialValue: editProvider!.variationList[pos].stock ?? '',
              style: const TextStyle(
                color: fontColor,
                fontWeight: FontWeight.normal,
              ),
              focusNode: editProvider!.variountProductTotalStockFocus,
              textInputAction: TextInputAction.next,
              onChanged: (String? value) {
                editProvider!.variationList[pos].stock = value;
              },
              decoration: InputDecoration(
                filled: true,
                fillColor: lightWhite,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                prefixIconConstraints:
                    const BoxConstraints(minWidth: 40, maxHeight: 20),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: fontColor),
                  borderRadius: BorderRadius.circular(circularBorderRadius7),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: const BorderSide(color: lightWhite),
                  borderRadius: BorderRadius.circular(circularBorderRadius8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget variableVariableSKU(int pos) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: width * 0.4,
            child: Text(
              "${getTranslated(context, "SKU")!} :",
              style: const TextStyle(
                fontSize: textFontSize16,
                color: black,
              ),
              maxLines: 2,
            ),
          ),
          Container(
            width: width * 0.4,
            padding: const EdgeInsets.only(),
            child: TextFormField(
              onFieldSubmitted: (v) {
                FocusScope.of(context)
                    .requestFocus(editProvider!.variountProductSKUFocus);
              },
              initialValue: editProvider!.variationList[pos].sku ?? '',
              style: const TextStyle(
                color: fontColor,
                fontWeight: FontWeight.normal,
              ),
              focusNode: editProvider!.variountProductSKUFocus,
              textInputAction: TextInputAction.next,
              onChanged: (String? value) {
                editProvider!.variationList[pos].sku = value;
              },
              decoration: InputDecoration(
                filled: true,
                fillColor: lightWhite,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                prefixIconConstraints:
                    const BoxConstraints(minWidth: 40, maxHeight: 20),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: fontColor),
                  borderRadius: BorderRadius.circular(circularBorderRadius7),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: const BorderSide(color: lightWhite),
                  borderRadius: BorderRadius.circular(circularBorderRadius8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

//==============================================================================
//=========================== Add Product API Call =============================

  currentPage4() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        additionalInfo(),
      ],
    );
  }

//==============================================================================
//=========================== Description ======================================

  getButtomBarButton() {
    return Positioned.directional(
      bottom: 0.0,
      textDirection: Directionality.of(context),
      child: Container(
        width: width,
        height: 60,
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 8, left: 16, right: 16),
          child: Row(
            children: [
              editProvider!.currentPage != 1
                  ? Expanded(
                      child: InkWell(
                        onTap: () {
                          if (editProvider!.currentPage == 1) {
                          } else if (editProvider!.currentPage == 2) {
                            editProvider!.currentPage = 1;
                          } else if (editProvider!.currentPage == 3) {
                            editProvider!.currentPage = 2;
                          } else if (editProvider!.currentPage == 4) {
                            editProvider!.currentPage = 3;
                          }
                          setState(
                            () {},
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(circularBorderRadius5),
                            color: lightWhite1,
                          ),
                          height: 56,
                          child: Center(
                            child: Text(
                              getTranslated(context, "Back")!,
                              style: const TextStyle(
                                fontSize: textFontSize16,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
              editProvider!.currentPage != 1
                  ? const SizedBox(
                      width: 10,
                    )
                  : const SizedBox.shrink(),
              Expanded(
                child: AppBtn(
                  onBtnSelected: () async {
                    if (editProvider!.currentPage == 1) {
                      if (editProvider!.productName == null ||
                          editProvider!.productName == '') {
                        setSnackbar(
                          getTranslated(context, "Please select product Name")!,
                          context,
                        );
                      } else if (editProvider!.hsnCode == null) {
                        setSnackbar(
                          'Please Add HSN Code',
                          context,
                        );
                      } else if (editProvider!.sortDescription == null ||
                          editProvider!.sortDescription == '') {
                        setSnackbar(
                          getTranslated(
                              context, "Please Add Sort Description")!,
                          context,
                        );
                      } else {
                        setState(
                          () {
                            editProvider!.currentPage = 2;
                          },
                        );
                      }
                    } else if (editProvider!.currentPage == 2) {
                      if (editProvider!.minOrderQuantity == null ||
                          editProvider!.minOrderQuantity == '') {
                        setSnackbar(
                          getTranslated(
                              context, "Please Add minimam Order Quantity")!,
                          context,
                        );
                      } else if (editProvider!.quantityStepSize == null ||
                          editProvider!.quantityStepSize == '') {
                        setSnackbar(
                          getTranslated(
                              context, "Please Add Quantity Step Size")!,
                          context,
                        );
                      } else if (editProvider!.isCancelable == "1" &&
                          editProvider!.tillwhichstatus == null) {
                        setSnackbar(
                          getTranslated(
                              context, "Please Add Till Which Status")!,
                          context,
                        );
                      } else if (editProvider!.selectedCatID == null ||
                          editProvider!.selectedCatID == '') {
                        setSnackbar(
                          getTranslated(context, "Please select category")!,
                          context,
                        );
                      } else {
                        setState(
                          () {
                            editProvider!.currentPage = 3;
                          },
                        );
                      }
                    } else if (editProvider!.currentPage == 3) {
                      if (editProvider!.productImage == "") {
                        setSnackbar(
                          getTranslated(
                              context, "Please Add Product Main Image")!,
                          context,
                        );
                      } else if ((editProvider!.description == '' ||
                          editProvider!.description == null)) {
                        setSnackbar(
                          getTranslated(context, "Please Add Description")!,
                          context,
                        );
                      } else {
                        setState(
                          () {
                            editProvider!.currentPage = 4;
                          },
                        );
                      }
                    } else if (editProvider!.currentPage == 4) {
                      validateAndSubmit();
                    }
                  },
                  height: 60,
                  title: editProvider!.currentPage != 4
                      ? getTranslated(context, "Next")!
                      : getTranslated(context, "Edit Product")!,
                  btnAnim: editProvider!.buttonSqueezeanimation,
                  btnCntrl: editProvider!.buttonController,
                  paddingRequired: false,
                ),
              ),
              /* Expanded(
                child: InkWell(
                  onTap: () async {
                    if (editProvider!.currentPage == 1) {
                      if (editProvider!.productName == null ||
                          editProvider!.productName == '') {
                        setSnackbar(
                          getTranslated(context, "Please select product Name")!,
                          context,
                        );
                      } else if (editProvider!.hsnCode == null) {
                        setSnackbar(
                          'Please Add HSN Code',
                          context,
                        );
                      } else if (editProvider!.sortDescription == null ||
                          editProvider!.sortDescription == '') {
                        setSnackbar(
                          getTranslated(
                              context, "Please Add Sort Description")!,
                          context,
                        );
                      } else {
                        setState(
                          () {
                            editProvider!.currentPage = 2;
                          },
                        );
                      }
                    } else if (editProvider!.currentPage == 2) {
                      if (editProvider!.minOrderQuantity == null ||
                          editProvider!.minOrderQuantity == '') {
                        setSnackbar(
                          getTranslated(
                              context, "Please Add minimam Order Quantity")!,
                          context,
                        );
                      } else if (editProvider!.quantityStepSize == null ||
                          editProvider!.quantityStepSize == '') {
                        setSnackbar(
                          getTranslated(
                              context, "Please Add Quantity Step Size")!,
                          context,
                        );
                      } else if (editProvider!.isCancelable == "1" &&
                          editProvider!.tillwhichstatus == null) {
                        setSnackbar(
                          getTranslated(
                              context, "Please Add Till Which Status")!,
                          context,
                        );
                      } else if (editProvider!.selectedCatID == null ||
                          editProvider!.selectedCatID == '') {
                        setSnackbar(
                          getTranslated(context, "Please select category")!,
                          context,
                        );
                      } else {
                        setState(
                          () {
                            editProvider!.currentPage = 3;
                          },
                        );
                      }
                    } else if (editProvider!.currentPage == 3) {
                      if (editProvider!.productImage == "") {
                        setSnackbar(
                          getTranslated(
                              context, "Please Add Product Main Image")!,
                          context,
                        );
                      } else if ((editProvider!.description == '' ||
                          editProvider!.description == null)) {
                        setSnackbar(
                          getTranslated(context, "Please Add Description")!,
                          context,
                        );
                      } else {
                        setState(
                          () {
                            editProvider!.currentPage = 4;
                          },
                        );
                      }
                    } else if (editProvider!.currentPage == 4) {
                      validateAndSubmit();
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [grad1Color, grad2Color],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        stops: [0, 1],
                        tileMode: TileMode.clamp,
                      ),
                      borderRadius:
                          BorderRadius.circular(circularBorderRadius5),
                      color: primary,
                    ),
                    height: 56,
                    child: Center(
                      child: Text(
                        editProvider!.currentPage != 4
                            ? getTranslated(context, "Next")!
                            : getTranslated(context, "Edit Product")!,
                        style: const TextStyle(
                          fontSize: textFontSize16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),*/
            ],
          ),
        ),
      ),
    );
  }

//==============================================================================
//=========================== Body Part ========================================

  getBodyPart() {
    return SizedBox(
      height: height,
      child: Stack(
        children: [
          SingleChildScrollView(
            child: Form(
              key: editProvider!.formkey,
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 25.0,
                  bottom: 20,
                  right: 20.0,
                  left: 20.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    editProvider!.currentPage == 1
                        ? currentPage1(context, setStateNow)
                        : Container(),
                    editProvider!.currentPage == 2
                        ? currentPage2(context, setStateNow)
                        : Container(),
                    editProvider!.currentPage == 3
                        ? currentPage3(context, setStateNow)
                        : Container(),
                    editProvider!.currentPage == 4
                        ? currentPage4()
                        : Container(),
                    const SizedBox(
                      height: 60,
                    ),
                  ],
                ),
              ),
            ),
          ),
          getButtomBarButton(),
        ],
      ),
    );
  }

  void validateAndSubmit() async {
    List<String> attributeIds = [];
    List<String> attributesValuesIds = [];

    for (var i = 0; i < editProvider!.variationBoolList.length; i++) {
      if (editProvider!.variationBoolList[i]) {
        final attributes = editProvider!.attributesList
            .where((element) =>
                element.name == editProvider!.attrController[i].text)
            .toList();
        if (attributes.isNotEmpty) {
          attributeIds.add(attributes.first.id!);
        }
      }
    }
    for (var key in attributeIds) {
      for (var element in editProvider!.selectedAttributeValues[key]!) {
        attributesValuesIds.add(element.id!);
      }
    }

    if (validateAndSave()) {
      _playAnimation();
      editProvider!.addProductAPI(
        attributesValuesIds,
        context,
        update,
        widget.model!.id!,
      );
    }
  }

  bool validateAndSave() {
    final form = editProvider!.formkey.currentState!;
    form.save();
    if (form.validate()) {
      if (editProvider!.productImage == '' &&
          editProvider!.mainImageProductImage == "") {
        setSnackbar(
          getTranslated(context, "Please Add product image")!,
          context,
        );
        return false;
      } else if (editProvider!.selectedCatID == null) {
        setSnackbar(
          getTranslated(context, "Please select category")!,
          context,
        );
        return false;
      } else if (editProvider!.selectedTypeOfVideo != null &&
          (editProvider!.selectedTypeOfVideo.toString().toLowerCase() ==
                  'vimeo' ||
              editProvider!.selectedTypeOfVideo.toString().toLowerCase() ==
                  'youtube') &&
          (editProvider!.videoUrl == null ||
              editProvider!.videoUrl.toString().trim().isEmpty)) {
        setSnackbar(
          getTranslated(context, "Please enter video url")!,
          context,
        );
        return false;
      } else if (editProvider!.selectedTypeOfVideo != null &&
          editProvider!.selectedTypeOfVideo.toString().toLowerCase() ==
              'self hosted' &&
          editProvider!.uploadedVideoName == '') {
        setSnackbar(
          getTranslated(context, 'PLZ_SEL_SELF_HOSTED_VIDEO')!,
          context,
        );
        return false;
      } else if (editProvider!.productType == null) {
        setSnackbar(
          getTranslated(context, "Please select product type")!,
          context,
        );
        return false;
      } else if (editProvider!.productType == 'simple_product') {
        if (editProvider!.simpleProductPriceController.text.isEmpty) {
          setSnackbar(
            getTranslated(context, "Please enter product price")!,
            context,
          );
          return false;
        } else if (editProvider!.simpleProductPriceController.text.isNotEmpty &&
            editProvider!.simpleProductSpecialPriceController.text.isNotEmpty &&
            double.parse(
                    editProvider!.simpleProductSpecialPriceController.text) >
                double.parse(editProvider!.simpleProductPriceController.text)) {
          setSnackbar(
            getTranslated(context, "Special price can not greater than price")!,
            context,
          );
          return false;
        } else if (editProvider!.isStockSelected != null &&
            editProvider!.isStockSelected == true) {
          if (editProvider!.simpleproductSKU == null ||
              editProvider!.simpleproductTotalStock == null) {
            setSnackbar(
              getTranslated(context, "Please enter stock details")!,
              context,
            );
            return false;
          }

          return true;
        }
        return true;
      } else if (editProvider!.productType == 'variable_product') {
        for (int i = 0; i < editProvider!.variationList.length; i++) {
          if (editProvider!.variationList[i].price == null ||
              editProvider!.variationList[i].price!.isEmpty) {
            setSnackbar(
              getTranslated(context, "Please enter price details")!,
              context,
            );
            return false;
          }
        }
        if (editProvider!.isStockSelected != null &&
            editProvider!.isStockSelected == true) {
          if (editProvider!.variantStockLevelType == "product_level" &&
              (editProvider!.variantproductSKU == null ||
                  editProvider!.variantproductTotalStock == null)) {
            setSnackbar(
              getTranslated(context, "Please enter stock details")!,
              context,
            );
            return false;
          }

          if (editProvider!.variantStockLevelType == "variable_level") {
            for (int i = 0; i < editProvider!.variationList.length; i++) {
              if (editProvider!.variationList[i].sku == null ||
                  editProvider!.variationList[i].sku!.isEmpty ||
                  editProvider!.variationList[i].stock == null ||
                  editProvider!.variationList[i].stock!.isEmpty) {
                setSnackbar(
                  getTranslated(context, "Please enter stock details")!,
                  context,
                );
                return false;
              }
            }

            return true;
          }
          return true;
        }
      }
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (editProvider!.currentPage == 1) {
          if (didPop) {
            return;
          }
          Navigator.of(context).pop();
        } else {
          setState(() {
            editProvider!.currentPage = editProvider!.currentPage - 1;
          });
        }
      },
      child: Scaffold(
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [grad1Color, grad2Color],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [0, 1],
                tileMode: TileMode.clamp,
              ),
            ),
          ),
          titleSpacing: 0,
          backgroundColor: white,
          leading: Builder(
            builder: (BuildContext context) {
              return Container(
                color: Colors.transparent,
                margin: const EdgeInsets.all(10),
                // decoration: DesignConfiguration.shadow(),
                child: InkWell(
                  borderRadius: BorderRadius.circular(circularBorderRadius5),
                  onTap: () {
                    if (editProvider!.currentPage == 1) {
                      Navigator.of(context).pop();
                    } else {
                      setState(() {
                        editProvider!.currentPage =
                            editProvider!.currentPage - 1;
                      });
                    }
                  },
                  child: const Center(
                    child: Icon(
                      Icons.arrow_back,
                      color: white,
                      size: 25,
                    ),
                  ),
                ),
              );
            },
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                getTranslated(context, "Edit Product")!,
                style: const TextStyle(
                  color: white,
                  fontSize: textFontSize16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(width: width * 0.1),
              Text(
                "${getTranslated(context, "Step")!} ${editProvider!.currentPage} ${getTranslated(context, "of")!} 4",
                style: const TextStyle(
                  color: white,
                  fontSize: textFontSize14,
                ),
              ),
            ],
          ),
        ),
        body: editProvider!.isLoading ? const ShimmerEffect() : getBodyPart(),
      ),
    );
  }
}
