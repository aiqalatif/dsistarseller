import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sellermultivendor/Provider/settingProvider.dart';
import '../Model/FAQModel/Faqs_Model.dart';
import '../Repository/faqRepositry.dart';
import '../Widget/networkAvailablity.dart';
import '../Widget/parameterString.dart';
import '../Widget/sharedPreferances.dart';
import '../Widget/snackbar.dart';
import '../Widget/validation.dart';

class FaQProvider extends ChangeNotifier {
  Animation? buttonSqueezeanimation;
  AnimationController? buttonController;
  bool scrollLoadmore = true, scrollGettingData = false, scrollNodata = false;
  int scrollOffset = 0;
  List<FaqsModel> tagList = [];
  List<FaqsModel> tempList = [];
  List<TextEditingController> listController = [];
  List<FaqsModel> selectedList = [];
  ScrollController? scrollController;
  TextEditingController mobilenumberController = TextEditingController();
  TextEditingController answerController = TextEditingController();
  FocusNode? tagsController = FocusNode();
  FocusNode? ansFocus = FocusNode();
  String? tagvalue;
  String? ansValue;
  int perPageLoad = 10;

  initializevariableValues() {
    scrollLoadmore = true;
    scrollGettingData = false;
    scrollNodata = false;
    scrollOffset = 0;
    tagList = [];
    tempList = [];
    listController = [];
    selectedList = [];
    mobilenumberController.clear();
    answerController.clear();
    tagvalue = null;
    ansValue = null;
    perPageLoad = 10;
  }

  Future<void> getFaQs(
    BuildContext context,
    Function update,
    String id,
  ) async {
    isNetworkAvail = await isNetworkAvailable();
    if (isNetworkAvail) {
      if (scrollLoadmore) {
        scrollLoadmore = false;
        scrollGettingData = true;
        if (scrollOffset == 0) {
          listController = [];
          tagList = [];
          update();
        }
        try {
          var parameter = {
            // SellerId: context.read<SettingProvider>().CUR_USERID,
            ProductId: id,
            LIMIT: perPageLoad.toString(),
            OFFSET: scrollOffset.toString(),
          };
          var result = await FaQsRepository.getFaqs(
            parameter: parameter,
          );
          bool error = result["error"];
          String? msg = result["message"];
          scrollGettingData = false;
          if (scrollOffset == 0) scrollNodata = error;

          if (!error) {
            tempList.clear();
            var data = result["data"];
            if (data.length != 0) {
              tempList = (data as List)
                  .map(
                    (data) => FaqsModel.fromJson(data),
                  )
                  .toList();

              tagList.addAll(tempList);
              for (var tag in tagList) {
                listController.add(TextEditingController(text: tag.answer!));
              }
              scrollLoadmore = true;
              scrollOffset = scrollOffset + perPageLoad;
            } else {
              scrollLoadmore = false;
            }
          } else {
            setSnackbar(msg!, context);
            scrollLoadmore = false;
          }
          scrollLoadmore = false;
          update();
        } on TimeoutException catch (_) {
          setSnackbar(
            getTranslated(context, "somethingMSg")!,
            context,
          );
          scrollLoadmore = false;
          update();
        }
      }
    } else {
      isNetworkAvail = false;
      scrollLoadmore = false;
      update();
    }
  }

  Future<void> addTagAPI(
    BuildContext context,
    String id,
    Function update,
  ) async {
    var parameter = {
      // SellerId: context.read<SettingProvider>().CUR_USERID,
      ProductId: id,
      QUESTION: tagvalue,
    };
    if (ansValue != "" && ansValue != null) {
      parameter[ANSWER] = ansValue;
    }
    var result = await FaQsRepository.addProductFaqs(
      parameter: parameter,
    );
    bool error = result["error"];
    String? msg = result["message"];
    if (!error) {
      setSnackbar(msg!, context);
      tagvalue = null;
      ansValue = null;
      mobilenumberController.text = "";
      answerController.text = "";
      update();
    } else {
      setSnackbar(msg!, context);
    }
  }

  Future<void> deleteTagsAPI(
    String? id,
    BuildContext context,
  ) async {
    context.read<SettingProvider>().CUR_USERID = await getPrefrence(Id);
    var parameter = {
      // SellerId: context.read<SettingProvider>().CUR_USERID,
      Id: id,
    };
    var result = await FaQsRepository.deleteTagsAPI(
      parameter: parameter,
    );
    bool error = result["error"];
    String? msg = result["message"];
    if (!error) {
      setSnackbar(msg!, context);
      tagList.clear();
      scrollLoadmore = true;
    } else {
      setSnackbar(msg!, context);
    }
  }

  Future<void> editProductFaqAPI(
    String? id,
    String answer,
    BuildContext context,
  ) async {
    context.read<SettingProvider>().CUR_USERID = await getPrefrence(Id);
    var parameter = {
      // SellerId: context.read<SettingProvider>().CUR_USERID,
      Id: id,
      ANSWER: answer,
    };
    var result = await FaQsRepository.deleteTagsAPI(
      parameter: parameter,
    );
    bool error = result["error"];
    String? msg = result["message"];
    if (!error) {
      setSnackbar(msg!, context);
      tagList.clear();
      scrollLoadmore = true;
    } else {
      setSnackbar(msg!, context);
    }
  }
}
