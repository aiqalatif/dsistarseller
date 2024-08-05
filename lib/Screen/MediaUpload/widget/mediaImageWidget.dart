import 'package:flutter/material.dart';
import '../../../Helper/Color.dart';
import '../../../Widget/desing.dart';
import '../../../Widget/routes.dart';
import '../../../Widget/validation.dart';
import '../../AddProduct/Add_Product.dart' as add;
import '../../EditProduct/EditProduct.dart' as edit;
import '../Media.dart';

getMediaItem(
  int index,
  Function update,
  String from,
  String type,
  BuildContext context,
) {
  return Card(
    child: InkWell(
      onTap: () {
        mediaProvider!.mediaList[index].isSelected =
            !mediaProvider!.mediaList[index].isSelected;

        if (from == "main") {
          if (type == "add") {
            mediaProvider!.currentSelectedName =
                mediaProvider!.mediaList[index].id!;
            add.addProvider!.productImage =
                "${mediaProvider!.mediaList[index].subDic!}${mediaProvider!.mediaList[index].name!}";
            add.addProvider!.productImageUrl =
                mediaProvider!.mediaList[index].image!;
          }
          if (type == "edit") {
            edit.editProvider!.productImage =
                "${mediaProvider!.mediaList[index].subDic!}${mediaProvider!.mediaList[index].name!}";
            edit.editProvider!.productImageUrl =
                mediaProvider!.mediaList[index].image!;
            edit.editProvider!.productImageRelativePath =
                mediaProvider!.mediaList[index].path!;
          }
        } else if (from == "video") {
          if (type == "add") {
            add.addProvider!.uploadedVideoName =
                "${mediaProvider!.mediaList[index].subDic!}${mediaProvider!.mediaList[index].name!}";
          }
          if (type == "edit") {
            edit.editProvider!.uploadedVideoName =
                "${mediaProvider!.mediaList[index].subDic!}${mediaProvider!.mediaList[index].name!}";
          }
          Routes.pop(context);
        } else if (from == "other") {
          if (mediaProvider!.mediaList[index].isSelected) {
            // otherImgList.add(mediaList[index].path!);
            // otherImgUrlList.add(mediaList[index].image!);
          } else {
            mediaProvider!.otherImgList
                .add(mediaProvider!.mediaList[index].path!);
            mediaProvider!.otherImgUrlList
                .remove(mediaProvider!.mediaList[index].image!);
          }
        } else if (from == 'variant') {
          if (mediaProvider!.mediaList[index].isSelected) {
            mediaProvider!.variantImgList.add(
                "${mediaProvider!.mediaList[index].subDic!}${mediaProvider!.mediaList[index].name!}");
            mediaProvider!.variantImgUrlList
                .add(mediaProvider!.mediaList[index].image!);
            mediaProvider!.variantImgRelativePath
                .add(mediaProvider!.mediaList[index].path!);
          } else {
            mediaProvider!.variantImgList.remove(
                "${mediaProvider!.mediaList[index].subDic!}${mediaProvider!.mediaList[index].name!}");
            mediaProvider!.variantImgUrlList
                .remove(mediaProvider!.mediaList[index].image!);
            mediaProvider!.variantImgRelativePath
                .remove(mediaProvider!.mediaList[index].path!);
          }
        }
        update();
      },
      child: Stack(
        children: [
          Row(
            children: [
              Image.network(
                mediaProvider!.mediaList[index].image!,
                height: 200,
                width: 200,
                errorBuilder: (context, error, stackTrace) =>
                    DesignConfiguration.erroWidget(200),
                color: Colors.black.withOpacity(
                    mediaProvider!.mediaList[index].isSelected ? 1 : 0),
                colorBlendMode: BlendMode.color,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          '${getTranslated(context, "Name")!} : ${mediaProvider!.mediaList[index].name!}'),
                      Text(
                          '${getTranslated(context, "Sub Directory")!} : ${mediaProvider!.mediaList[index].subDic!}'),
                      Text(
                          '${getTranslated(context, "Size")!} : ${mediaProvider!.mediaList[index].size!}'),
                      Text(
                          '${getTranslated(context, "extension")!} : ${mediaProvider!.mediaList[index].extention!}'),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Container(
            color: Colors.black.withOpacity(
                mediaProvider!.mediaList[index].isSelected ? 0.1 : 0),
          ),
          from != "main"
              ? mediaProvider!.mediaList[index].isSelected
                  ? const Align(
                      alignment: Alignment.bottomRight,
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.check_circle,
                          color: primary,
                        ),
                      ),
                    )
                  : Container()
              : mediaProvider!.currentSelectedName ==
                      mediaProvider!.mediaList[index].id!
                  ? const Align(
                      alignment: Alignment.bottomRight,
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.check_circle,
                          color: primary,
                        ),
                      ),
                    )
                  : Container(),
        ],
      ),
    ),
  );
}
