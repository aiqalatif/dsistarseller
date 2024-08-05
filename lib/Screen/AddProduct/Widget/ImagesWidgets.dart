import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../Helper/Color.dart';
import '../../../Helper/Constant.dart';
import '../../../Widget/validation.dart';
import '../../MediaUpload/Media.dart';
import '../Add_Product.dart';
import 'getCommanWidget.dart';

selectedMainImageShow() {
  return ClipRRect(
    borderRadius: BorderRadius.circular(circularBorderRadius10),
    child: Image.network(
      addProvider!.productImageUrl,
      width: 100,
      height: 100,
      fit: BoxFit.cover,
    ),
  );
}

//------------------------------------------------------------------------------
//========================= Main Image =========================================

videoUpload(
  BuildContext context,
  Function setState,
) {
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
                  type: "add",
                ),
              ),
            ).then((value) => setState());
          },
        ),
      ],
    ),
  );
}

selectedVideoShow() {
  return addProvider!.uploadedVideoName == ''
      ? Container()
      : SizedBox(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: Text(
                    addProvider!.uploadedVideoName,
                  ),
                ),
                const Icon(
                  Icons.check_circle,
                  color: Colors.green,
                ),
              ],
            ),
          ),
        );
}

//------------------------------------------------------------------------------
//========================= Other Image ========================================

otherImages(String from, int pos, BuildContext context, Function setState) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        getPrimaryCommanText(getTranslated(context, "Other Images")!, true),
        InkWell(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(circularBorderRadius5),
              color: primary,
            ),
            width: 100,
            height: 35,
            child: Center(
              child: Text(
                getTranslated(context, "Upload")!,
                style: const TextStyle(
                  fontSize: textFontSize16,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
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
                  type: "add",
                ),
              ),
            ).then(
              (value) => setState(),
            );
          },
        ),
      ],
    ),
  );
}

variantOtherImageShow(int pos, Function setState) {
  return addProvider!.variationList.length == pos ||
          addProvider!.variationList[pos].imagesUrl == null
      ? Container()
      : SizedBox(
          width: double.infinity,
          height: 130,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: addProvider!.variationList[pos].imagesUrl!.length,
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
                          addProvider!.variationList[pos].imagesUrl![i],
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        addProvider!.variationList[pos].imagesUrl!.removeAt(i);
                        setState();
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
                    ),
                  ],
                ),
              );
            },
          ),
        );
}
