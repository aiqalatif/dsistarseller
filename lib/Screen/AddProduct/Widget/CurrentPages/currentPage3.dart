import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../Helper/Color.dart';
import '../../../../Helper/Constant.dart';
import '../../../../Provider/settingProvider.dart';
import '../../../../Widget/validation.dart';
import '../../Add_Product.dart';
import '../ImagesWidgets.dart';
import '../getCommanBtn.dart';
import '../getCommanInputTextFieldWidget.dart';
import '../getCommanWidget.dart';
import '../getIconSelectionDesingWidget.dart';

currentPage3(
  BuildContext context,
  Function setState,
  Function updateCitys,
) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          Expanded(
            flex: 2,
            child: getPrimaryCommanText(
                getTranslated(context, "Product Main Image")!, true),
          ),
          Expanded(
            flex: 2,
            child: getCommonButtonAdd(
                getTranslated(context, "Upload")!, 1, setState, context),
          ),
        ],
      ),
      addProvider!.productImage != '' ? getCommanSizedBox() : Container(),
      addProvider!.productImage != '' ? getCommanSizedBox() : Container(),
      addProvider!.productImage != '' ? selectedMainImageShow() : Container(),
      getCommanSizedBox(),
      getCommanSizedBox(),
      Row(
        children: [
          Expanded(
            flex: 2,
            child: getPrimaryCommanText(
                getTranslated(context, "Product Other Images")!, true),
          ),
          Expanded(
            flex: 2,
            child: getCommonButtonAdd(
                getTranslated(context, "Upload")!, 2, setState, context),
          ),
        ],
      ),
      addProvider!.otherImageUrl.isNotEmpty ? getCommanSizedBox() : Container(),
      addProvider!.otherImageUrl.isNotEmpty ? getCommanSizedBox() : Container(),
      addProvider!.otherImageUrl.isNotEmpty
          ? uploadedOtherImageShow(setState)
          : Container(),
      getCommanSizedBox(),
      getPrimaryCommanText(getTranslated(context, "Select Video Type")!, false),
      getCommanSizedBox(),
      getIconSelectionDesing(
          getTranslated(context, "not Selected Yet!(ex. Vimeo, Youtube)")!,
          8,
          context,
          setState,
          updateCitys),
      getCommanSizedBox(),
      (addProvider!.selectedTypeOfVideo == 'vimeo' ||
              addProvider!.selectedTypeOfVideo == 'youtube')
          ? getCommanInputTextField(
              addProvider!.selectedTypeOfVideo == 'vimeo'
                  ? getTranslated(
                      context,
                      "Paste Vimeo Video link / url ...!",
                    )!
                  : addProvider!.selectedTypeOfVideo == 'youtube'
                      ? getTranslated(
                          context,
                          "Paste Youtube Video link / url...!",
                        )!
                      : getTranslated(context, "Self Hosted")!,
              9,
              0.06,
              1,
              2,
              context,
            )
          : addProvider!.selectedTypeOfVideo == 'Self Hosted'
              ? Column(
                  children: [
                    videoUpload(context, setState),
                    selectedVideoShow(),
                  ],
                )
              : Container(),
      getCommanSizedBox(),
      Row(
        children: [
          Expanded(
            flex: 2,
            child: getPrimaryCommanText(
                getTranslated(context, 'Product Description')!, true),
          ),
          Expanded(
            flex: 2,
            child: getCommonButtonAdd(
                (addProvider!.description == "" ||
                        addProvider!.description == null)
                    ? getTranslated(context, "Add Description")!
                    : getTranslated(context, "Edit Description")!,
                3,
                setState,
                context),
          ),
        ],
      ),
      (addProvider!.description == "" || addProvider!.description == null)
          ? Container()
          : getCommanSizedBox(),
      (addProvider!.description == "" || addProvider!.description == null)
          ? Container()
          : getDescription(1),
      getCommanSizedBox(),
      Row(
        children: [
          Expanded(
            flex: 2,
            child: getPrimaryCommanText(
                getTranslated(context, "Extra Description")!, true),
          ),
          Expanded(
            flex: 2,
            child: getCommonButtonAdd(
                (addProvider!.extraDescription == "" ||
                    addProvider!.extraDescription == null)
                    ? "Add Extra Description"
                    : "Edit Extra Description",
                9,
                setState,
                context),
          ),
        ],
      ),
      (addProvider!.extraDescription == "" ||
          addProvider!.extraDescription == null)
          ? Container()
          : getCommanSizedBox(),
      (addProvider!.extraDescription == "" ||
          addProvider!.extraDescription == null)
          ? Container()
          : getDescription(3),
    ],
  );
}

//==============================================================================
//=========================== Description ======================================

getDescription(int fromdescription) {
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(circularBorderRadius5),
      border: Border.all(
        color: primary,
      ),
    ),
    width: width,
    child: Padding(
      padding: const EdgeInsets.only(
        left: 8,
        right: 8,
      ),
      child: HtmlWidget(
        fromdescription == 1
            ? addProvider!.description ?? ""
            : fromdescription == 2
                ? addProvider!.sortDescription ?? ""
                : addProvider!.extraDescription ?? "",
        onErrorBuilder: (context, element, error) =>
            Text('$element error: $error'),
        onLoadingBuilder: (context, element, loadingProgress) =>
            const CircularProgressIndicator(),
        onTapUrl: (url) {
          launchUrl(
            Uri.parse(url),
          );
          return true;
        },
        renderMode: RenderMode.column,
        textStyle: const TextStyle(fontSize: textFontSize14),
      ),
    ),
  );
}
