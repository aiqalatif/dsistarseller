import 'package:flutter/material.dart';
import 'package:sellermultivendor/Widget/validation.dart';
import '../../../../Helper/Color.dart';
import '../../../../Helper/Constant.dart';
import '../../../../Provider/settingProvider.dart';
import '../../../../Widget/desing.dart';
import '../../EditProduct.dart';

brandSelectButtomSheet(
  BuildContext context,
  Function update,
) {
  showModalBottomSheet(
    isScrollControlled: true,
    context: context,
    backgroundColor: Colors.transparent,
    builder: (BuildContext context) {
      return StatefulBuilder(
          builder: (BuildContext context, StateSetter setStater) {
        editProvider!.brandState = setStater;
        return Container(
          padding: const EdgeInsets.only(right: 20, left: 20, top: 20),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(circularBorderRadius25),
              topRight: Radius.circular(circularBorderRadius25),
            ),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8.0, left: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      child: const Icon(Icons.arrow_back),
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    Text(
                      getTranslated(context, "Select Brand")!,
                    ),
                    Container(width: 2),
                  ],
                ),
              ),
              editProvider!.brandLoading
                  ? const Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 50.0),
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : (editProvider!.brandList.isNotEmpty)
                      ? Flexible(
                        child: SingleChildScrollView(
                            controller: editProvider!.brandScrollController,
                            child: Stack(
                              children: [
                                Column(
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: getBrands(context, update),
                                    ),
                                    Center(
                                      child: DesignConfiguration
                                          .showCircularProgress(
                                        editProvider!.isLoadingMoreBrand!,
                                        primary,
                                      ),
                                    ),
                                  ],
                                ),
                                DesignConfiguration.showCircularProgress(
                                  editProvider!.isProgress,
                                  primary,
                                ),
                              ],
                            ),
                          ),
                      )
                      : Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20.0),
                          child: DesignConfiguration.getNoItem(context),
                        ),
              /*   SingleChildScrollView(
                  child: Column(
                    children: [

                      Center(
                        child: ListView.builder(
                          shrinkWrap: true,
                          padding: const EdgeInsetsDirectional.only(
                              bottom: 5, start: 10, end: 10),
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: editProvider!.brandList.length,
                          itemBuilder: (context, index) {
                            BrandModel? item;

                            item = editProvider!.brandList.isEmpty
                                ? null
                                : editProvider!.brandList[index];

                            return item == null
                                ? Container()
                                : getbrands(index, context, update);
                          },
                        ),
                      ),
                    ],
                  ),
                ),*/
            ],
          ),
        );
      });
    },
  );
}

getBrands(BuildContext context, Function update) {
  return editProvider!.brandList
      .asMap()
      .map((index, element) => MapEntry(
            index,
            InkWell(
              onTap: () {
                Navigator.pop(context);
                editProvider!.selectedBrandName =
                    editProvider!.brandList[index].name;
                editProvider!.selectedBrandId =
                    editProvider!.brandList[index].id;
                update();
              },
              child: Column(
                children: [
                  const Divider(),
                  Row(
                    children: [
                      editProvider!.selectedBrandId ==
                              editProvider!.brandList[index].id
                          ? Container(
                              height: 20,
                              width: 20,
                              decoration: const BoxDecoration(
                                color: grey2,
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Container(
                                  height: 16,
                                  width: 16,
                                  decoration: const BoxDecoration(
                                    color: primary,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                            )
                          : Container(
                              height: 20,
                              width: 20,
                              decoration: const BoxDecoration(
                                color: grey2,
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Container(
                                  height: 16,
                                  width: 16,
                                  decoration: const BoxDecoration(
                                    color: white,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                            ),
                      const SizedBox(
                        width: 10,
                      ),
                      SizedBox(
                        width: width * 0.6,
                        child: Text(
                          editProvider!.brandList[index].name!,
                          style: const TextStyle(
                            fontSize: textFontSize18,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ))
      .values
      .toList();
}
