import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sellermultivendor/Provider/settingProvider.dart';
import 'package:sellermultivendor/Screen/EditProduct/EditProduct.dart';
import '../Model/PickUpLocationModel/PickUpLocationModel.dart';
import '../Repository/PickUpLocationRepository.dart';
import '../Widget/parameterString.dart';
import '../Screen/AddProduct/Add_Product.dart';

class PickUpLocationProvider extends ChangeNotifier {
  String errorMessage = '';
  bool? isLoadingMoreLocation;
  int locationOffset = 0;
  int total = 0;
  bool locationLoading = true;
  List<PickUpLocationModel> temppickUpLocationList = [];
  List<PickUpLocationModel> pickUpLocationList = [];
  final ScrollController pickUpLocationScrollController = ScrollController();
  Animation? buttonSqueezeanimation;
  AnimationController? buttonController;
  final TextEditingController controllerForText = TextEditingController();
  String searchText = "", lastsearch = "";
  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  freshInitializationOfAddPickUpLocation() {
    errorMessage = '';
    isLoadingMoreLocation = null;
    locationOffset = 0;
    total = 0;
    locationLoading = true;
    temppickUpLocationList.clear();
    pickUpLocationList.clear();
    controllerForText.clear();
    searchText = "";
    lastsearch = "";
  }

  Future<bool> getPickUpLocations(BuildContext context, int fromAdd,
      {Function? update}) async {
    int pickUpLocationPerPage = 20;
    try {
      var parameter = {
        LIMIT: pickUpLocationPerPage.toString(),
        OFFSET: fromAdd == 1
            ? addProvider!.locationOffset.toString()
            : fromAdd == 2
                ? editProvider!.locationOffset.toString()
                : locationOffset.toString(),
        // SellerId: context.read<SettingProvider>().CUR_USERID,
        SEARCH: searchText.trim(),
      };

      var result = await PickUpLocationRepository.getPickUpLocation(
          parameter: parameter);
      bool error = result['error'];
      errorMessage = result['message'];
      if (fromAdd == 1) {
        addProvider!.temppickUpLocationList.clear();
      } else if (fromAdd == 2) {
        editProvider!.temppickUpLocationList.clear();
      } else {
        temppickUpLocationList.clear();
      }
      print("result****$result");

      if (!error) {
        var data = result["data"]['rows'];
        total = int.parse(result["data"]["total"]);

        print("data****$data");
        if (fromAdd == 1) {
          addProvider!.temppickUpLocationList = (data as List)
              .map((data) => PickUpLocationModel.fromJson(data))
              .toList();
          addProvider!.pickUpLocationList
              .addAll(addProvider!.temppickUpLocationList);
        } else if (fromAdd == 2) {
          editProvider!.temppickUpLocationList = (data as List)
              .map((data) => PickUpLocationModel.fromJson(data))
              .toList();
          editProvider!.pickUpLocationList
              .addAll(editProvider!.temppickUpLocationList);
        } else {
          temppickUpLocationList = (data as List)
              .map((data) => PickUpLocationModel.fromJson(data))
              .toList();
          pickUpLocationList.addAll(temppickUpLocationList);
        }
      }
      if (fromAdd == 1) {
        addProvider!.locationLoading = false;
        addProvider!.isLoadingMoreLocation = false;
        addProvider!.isProgress = false;
        addProvider!.locationOffset += pickUpLocationPerPage;
      } else if (fromAdd == 2) {
        editProvider!.locationLoading = false;
        editProvider!.isLoadingMoreLocation = false;
        editProvider!.isProgress = false;
        editProvider!.locationOffset += pickUpLocationPerPage;
      } else {
        locationLoading = false;
        isLoadingMoreLocation = false;
        locationOffset += pickUpLocationPerPage;
        update!();
      }

      return error;
    } catch (e) {
      errorMessage = e.toString();
      return true;
    }
  }
}
