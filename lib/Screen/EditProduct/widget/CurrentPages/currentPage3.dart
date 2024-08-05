import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:sellermultivendor/Screen/EditProduct/widget/getCommannWidget.dart';
import 'package:sellermultivendor/Screen/EditProduct/widget/getIconSelectionDesingWidget.dart';
import 'package:sellermultivendor/Screen/EditProduct/widget/getCommonButton.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../Helper/Color.dart';
import '../../../../Helper/Constant.dart';
import '../../../../Provider/settingProvider.dart';
import '../../../../Widget/validation.dart';
import '../../../MediaUpload/Media.dart';
import '../../EditProduct.dart';

currentPage3(
  BuildContext context,
  Function setStateNow,
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
            child: getCommonButton(
              getTranslated(context, "Upload")!,
              1,
              setStateNow,
              context,
            ),
          ),
        ],
      ),
      editProvider!.productImage != '' ? getCommanSizedBox() : Container(),
      editProvider!.productImage != '' ? getCommanSizedBox() : Container(),
      editProvider!.productImage != '' ? selectedMainImageShow() : Container(),
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
            child: getCommonButton(
              getTranslated(context, "Upload")!,
              2,
              setStateNow,
              context,
            ),
          ),
        ],
      ),
      editProvider!.showOtherImages.isNotEmpty
          ? getCommanSizedBox()
          : Container(),
      editProvider!.showOtherImages.isNotEmpty
          ? getCommanSizedBox()
          : Container(),
      editProvider!.showOtherImages.isNotEmpty
          ? uploadedOtherImageShow(setStateNow)
          : Container(),
      getCommanSizedBox(),
      getPrimaryCommanText(getTranslated(context, "Select Video Type")!, false),
      getCommanSizedBox(),
      getIconSelectionDesing(
        getTranslated(context, "not Selected Yet!(ex. Vimeo, Youtube)")!,
        8,
        context,
        setStateNow,
      ),
      getCommanSizedBox(),
      (editProvider!.selectedTypeOfVideo == 'vimeo' ||
              editProvider!.selectedTypeOfVideo == 'youtube')
          ? getCommanInputTextField(
              editProvider!.selectedTypeOfVideo == 'vimeo'
                  ? getTranslated(
                      context,
                      "Paste Vimeo Video link / url ...!",
                    )!
                  : editProvider!.selectedTypeOfVideo == 'youtube'
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
          : editProvider!.selectedTypeOfVideo == 'Self Hosted'
              ? Column(
                  children: [
                    videoUpload(context, setStateNow),
                    selectedVideoShow(),
                  ],
                )
              : Container(),
      getCommanSizedBox(),
      Row(
        children: [
          Expanded(
            flex: 2,
            child: getPrimaryCommanText("Product Description", true),
          ),
          Expanded(
            flex: 2,
            child: getCommonButton(
              (editProvider!.description == "" ||
                      editProvider!.description == null)
                  ? getTranslated(context, "Add Description")!
                  : getTranslated(context, "Edit Description")!,
              3,
              setStateNow,
              context,
            ),
          ),
        ],
      ),
      (editProvider!.description == "" || editProvider!.description == null)
          ? Container()
          : getCommanSizedBox(),
      (editProvider!.description == "" || editProvider!.description == null)
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
            child: getCommonButton(
                (editProvider!.extraDescription == "" ||
                        editProvider!.extraDescription == null)
                    ? "Add Extra Description"
                    : "Edit Extra Description",
                9,
                setStateNow,
                context),
          ),
        ],
      ),
      (editProvider!.extraDescription == "" ||
              editProvider!.extraDescription == null)
          ? Container()
          : getCommanSizedBox(),
      (editProvider!.extraDescription == "" ||
              editProvider!.extraDescription == null)
          ? Container()
          : getDescription(3),
    ],
  );
}

selectedMainImageShow() {
  return editProvider!.productImage == ''
      ? Container()
      : ClipRRect(
          borderRadius: BorderRadius.circular(circularBorderRadius10),
          child: Image.network(
            editProvider!.productImageUrl!,
            width: 100,
            height: 100,
            fit: BoxFit.cover,
          ),
        );
}

uploadedOtherImageShow(Function update) {
  return editProvider!.showOtherImages.isEmpty
      ? Container()
      : SizedBox(
          width: double.infinity,
          height: 130,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: editProvider!.showOtherImages.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, i) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Stack(
                  alignment: AlignmentDirectional.topEnd,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 8.0,
                        right: 8.0,
                      ),
                      child: ClipRRect(
                        borderRadius:
                            BorderRadius.circular(circularBorderRadius10),
                        child: Image.network(
                          editProvider!.showOtherImages[i],
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        editProvider!.showOtherImages.removeAt(i);
                        editProvider!.otherPhotos.removeAt(i);
                        update();
                      },
                      child: Container(
                        width: 20,
                        height: 20,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: primary,
                        ),
                        child: const Icon(
                          Icons.clear,
                          size: 15,
                          color: white,
                        ),
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        );
}

videoUpload(BuildContext context, Function update) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          getTranslated(context, "Video * ")!,
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
                builder: (context) => const Media(
                  from: "video",
                  pos: 0,
                  type: "edit",
                ),
              ),
            ).then((value) => update());
          },
        ),
      ],
    ),
  );
}

selectedVideoShow() {
  return editProvider!.uploadedVideoName == ''
      ? Container()
      : SizedBox(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(child: Text(editProvider!.uploadedVideoName!)),
                const Icon(
                  Icons.check_circle,
                  color: Colors.green,
                ),
              ],
            ),
          ),
        );
}

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
            ? editProvider!.description ?? ""
            : fromdescription == 2
                ? editProvider!.sortDescription ?? ""
                : editProvider!.extraDescription ?? "",
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
