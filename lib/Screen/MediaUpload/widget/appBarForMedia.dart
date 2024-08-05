import 'package:flutter/material.dart';
import '../../../Helper/Color.dart';
import '../../../Helper/Constant.dart';
import '../../../Widget/desing.dart';
import '../../../Widget/routes.dart';
import '../../../Widget/validation.dart';
import '../../AddProduct/Add_Product.dart' as add;
import '../../EditProduct/EditProduct.dart' as edit;
import '../Media.dart';

getAppBarForMedia(
  String title,
  String from,
  String type,
  int pos,
  BuildContext context,
) {
  return AppBar(
    titleSpacing: 0,
    backgroundColor: white,
    leading: Builder(
      builder: (BuildContext context) {
        return Container(
          margin: const EdgeInsets.all(10),
          decoration: DesignConfiguration.shadow(),
          child: InkWell(
            borderRadius: BorderRadius.circular(circularBorderRadius5),
            onTap: () => Navigator.of(context).pop(),
            child: const Center(
              child: Icon(
                Icons.keyboard_arrow_left,
                color: primary,
                size: 30,
              ),
            ),
          ),
        );
      },
    ),
    title: Text(
      title,
      style: const TextStyle(
        color: grad2Color,
      ),
    ),
    actions: [
      (from == "other" ||
              from == 'variant' ||
              (from == "main" && type == "add"))
          ? TextButton(
              onPressed: () {
                if (from == "other") {
                  if (type == "add") {
                    for (var element in mediaProvider!.mediaList) {
                        if (element.isSelected) {
                          add.addProvider!.otherPhotos.add(element.path!);
                          add.addProvider!.otherImageUrl.add(element.image!);
                        }
                      }
                  }
                  if (type == "edit") {
                    edit.editProvider!.otherPhotos
                        .addAll(mediaProvider!.otherImgList);
                    if (edit.editProvider!.showOtherImages.isNotEmpty) {
                      if (mediaProvider!.otherImgList.isNotEmpty) {
                        for (int i = 0;
                            i < mediaProvider!.otherImgList.length;
                            i++) {
                          edit.editProvider!.showOtherImages.removeLast();
                        }
                      }
                    }
                    edit.editProvider!.showOtherImages
                        .addAll(mediaProvider!.otherImgUrlList);
                  }
                } else if (from == 'variant') {
                  if (type == "add") {
                    add.addProvider!.variationList[pos].images =
                        mediaProvider!.variantImgList;
                    add.addProvider!.variationList[pos].imagesUrl =
                        mediaProvider!.variantImgUrlList;
                    add.addProvider!.variationList[pos].imageRelativePath =
                        mediaProvider!.variantImgRelativePath;
                  }
                  if (type == "edit") {
                    edit.editProvider!.variationList[pos].images =
                        mediaProvider!.variantImgList;
                    edit.editProvider!.variationList[pos].imagesUrl =
                        mediaProvider!.variantImgUrlList;
                    edit.editProvider!.variationList[pos].imageRelativePath =
                        mediaProvider!.variantImgRelativePath;
                  }
                }
                Routes.pop(context);
              },
              child: Text(
                getTranslated(context, "Done")!,
              ),
            )
          : Container()
    ],
  );
}
