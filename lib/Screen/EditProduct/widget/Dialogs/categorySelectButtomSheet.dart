import 'package:flutter/material.dart';
import '../../../../Helper/Color.dart';
import '../../../../Helper/Constant.dart';
import '../../../../Model/CategoryModel/categoryModel.dart';
import '../../../../Provider/settingProvider.dart';
import '../../../../Widget/validation.dart';
import '../../EditProduct.dart';

categorySelectButtomSheet(
  BuildContext context,
  Function update,
) {
  showModalBottomSheet(
    isScrollControlled: true,
    context: context,
    backgroundColor: Colors.transparent,
    builder: (BuildContext context) {
      return Container(
        height: MediaQuery.of(context).size.height * 0.80,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(circularBorderRadius25),
            topRight: Radius.circular(circularBorderRadius25),
          ),
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(circularBorderRadius25),
            topRight: Radius.circular(circularBorderRadius25),
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, left: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Icon(Icons.arrow_back),
                      Text(
                        getTranslated(context, "Select Category")!,
                      ),
                      Container(width: 2),
                    ],
                  ),
                ),
                Center(
                  child: ListView.builder(
                    shrinkWrap: true,
                    padding: const EdgeInsetsDirectional.only(
                        bottom: 5, start: 10, end: 10),
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: editProvider!.catagorylist.length,
                    itemBuilder: (context, index) {
                      CategoryModel? item;

                      item = editProvider!.catagorylist.isEmpty
                          ? null
                          : editProvider!.catagorylist[index];

                      return item == null
                          ? Container()
                          : getCategorys(index, context, update);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

getCategorys(
  int index,
  BuildContext context,
  Function update,
) {
  CategoryModel model = editProvider!.catagorylist[index];
  return SingleChildScrollView(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () {
            Navigator.pop(context);
            editProvider!.selectedCatName = model.name;
            editProvider!.selectedCatID = model.id;
            update();
          },
          child: Column(
            children: [
              const Divider(),
              Row(
                children: [
                  editProvider!.selectedCatID == model.id
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
                      model.name!,
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
        SizedBox(
          child: ListView.builder(
            shrinkWrap: true,
            padding:
                const EdgeInsetsDirectional.only(bottom: 5, start: 15, end: 15),
            physics: const NeverScrollableScrollPhysics(),
            itemCount: model.children!.length,
            itemBuilder: (context, index) {
              CategoryModel? item1;
              item1 = model.children!.isEmpty ? null : model.children![index];
              return item1 == null
                  ? SizedBox(
                      child: Text(
                        getTranslated(context, "no sub cat")!,
                      ),
                    )
                  : Column(
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                            editProvider!.selectedCatName = item1!.name;
                            editProvider!.selectedCatID = item1.id;
                            update();
                          },
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  editProvider!.selectedCatID == item1.id
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
                                    width: 5,
                                  ),
                                  SizedBox(
                                    width: width * 0.62,
                                    child: Text(
                                      item1.name!,
                                      style: const TextStyle(
                                        fontSize: textFontSize16,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              const Divider(),
                            ],
                          ),
                        ),
                        SizedBox(
                          child: ListView.builder(
                            shrinkWrap: true,
                            padding: const EdgeInsetsDirectional.only(
                                bottom: 5, start: 10, end: 10),
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: item1.children!.length,
                            itemBuilder: (context, index) {
                              CategoryModel? item2;
                              item2 = item1!.children!.isEmpty
                                  ? null
                                  : item1.children![index];
                              return item2 == null
                                  ? Container()
                                  : Column(
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            editProvider!.selectedCatName =
                                                item2!.name;
                                            editProvider!.selectedCatID =
                                                item2.id;
                                            Navigator.pop(context);
                                            update();
                                          },
                                          child: Column(
                                            children: [
                                              Row(
                                                children: [
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  editProvider!.selectedCatID ==
                                                          item2.id
                                                      ? Container(
                                                          height: 20,
                                                          width: 20,
                                                          decoration:
                                                              const BoxDecoration(
                                                            color: grey2,
                                                            shape:
                                                                BoxShape.circle,
                                                          ),
                                                          child: Center(
                                                            child: Container(
                                                              height: 16,
                                                              width: 16,
                                                              decoration:
                                                                  const BoxDecoration(
                                                                color: primary,
                                                                shape: BoxShape
                                                                    .circle,
                                                              ),
                                                            ),
                                                          ),
                                                        )
                                                      : Container(
                                                          height: 20,
                                                          width: 20,
                                                          decoration:
                                                              const BoxDecoration(
                                                            color: grey2,
                                                            shape:
                                                                BoxShape.circle,
                                                          ),
                                                          child: Center(
                                                            child: Container(
                                                              height: 16,
                                                              width: 16,
                                                              decoration:
                                                                  const BoxDecoration(
                                                                color: white,
                                                                shape: BoxShape
                                                                    .circle,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                  const SizedBox(
                                                    width: 5,
                                                  ),
                                                  SizedBox(
                                                    width: width * 0.42,
                                                    child: Text(
                                                      item2.name!,
                                                      style: const TextStyle(
                                                        fontSize:
                                                            textFontSize15,
                                                      ),
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const Divider(),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          child: ListView.builder(
                                            shrinkWrap: true,
                                            padding: const EdgeInsetsDirectional
                                                    .only(
                                                bottom: 5, start: 10, end: 10),
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            itemCount: item2.children!.length,
                                            itemBuilder: (context, index) {
                                              CategoryModel? item3;
                                              item3 = item2!.children!.isEmpty
                                                  ? null
                                                  : item2.children![index];
                                              return item3 == null
                                                  ? Container()
                                                  : Column(
                                                      children: [
                                                        InkWell(
                                                          onTap: () {
                                                            editProvider!
                                                                    .selectedCatName =
                                                                item3!.name;
                                                            editProvider!
                                                                    .selectedCatID =
                                                                item3.id;
                                                            Navigator.pop(
                                                                context);
                                                            update();
                                                          },
                                                          child: Column(
                                                            children: [
                                                              Row(
                                                                children: [
                                                                  const SizedBox(
                                                                    width: 10,
                                                                  ),
                                                                  editProvider!
                                                                              .selectedCatID ==
                                                                          item3
                                                                              .id
                                                                      ? Container(
                                                                          height:
                                                                              20,
                                                                          width:
                                                                              20,
                                                                          decoration:
                                                                              const BoxDecoration(
                                                                            color:
                                                                                grey2,
                                                                            shape:
                                                                                BoxShape.circle,
                                                                          ),
                                                                          child:
                                                                              Center(
                                                                            child:
                                                                                Container(
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
                                                                          height:
                                                                              20,
                                                                          width:
                                                                              20,
                                                                          decoration:
                                                                              const BoxDecoration(
                                                                            color:
                                                                                grey2,
                                                                            shape:
                                                                                BoxShape.circle,
                                                                          ),
                                                                          child:
                                                                              Center(
                                                                            child:
                                                                                Container(
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
                                                                    width: 5,
                                                                  ),
                                                                  Text(item3
                                                                      .name!),
                                                                ],
                                                              ),
                                                              const Divider(),
                                                            ],
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          child:
                                                              ListView.builder(
                                                            shrinkWrap: true,
                                                            padding:
                                                                const EdgeInsetsDirectional
                                                                        .only(
                                                                    bottom: 5,
                                                                    start: 10,
                                                                    end: 10),
                                                            physics:
                                                                const NeverScrollableScrollPhysics(),
                                                            itemCount: item3
                                                                .children!
                                                                .length,
                                                            itemBuilder:
                                                                (context,
                                                                    index) {
                                                              CategoryModel?
                                                                  item4;
                                                              item4 = item3!
                                                                      .children!
                                                                      .isEmpty
                                                                  ? null
                                                                  : item3.children![
                                                                      index];
                                                              return item4 ==
                                                                      null
                                                                  ? Container()
                                                                  : Column(
                                                                      children: [
                                                                        InkWell(
                                                                          onTap:
                                                                              () {
                                                                            update();
                                                                            editProvider!.selectedCatName =
                                                                                item4!.name;
                                                                            editProvider!.selectedCatID =
                                                                                item4.id;
                                                                          },
                                                                          child:
                                                                              Row(
                                                                            children: [
                                                                              const SizedBox(
                                                                                width: 10,
                                                                              ),
                                                                              const Icon(
                                                                                Icons.subdirectory_arrow_right_outlined,
                                                                                color: primary,
                                                                                size: 20,
                                                                              ),
                                                                              const SizedBox(
                                                                                width: 5,
                                                                              ),
                                                                              Text(item4.name!),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        SizedBox(
                                                                          child:
                                                                              ListView.builder(
                                                                            shrinkWrap:
                                                                                true,
                                                                            padding: const EdgeInsetsDirectional.only(
                                                                                bottom: 5,
                                                                                start: 10,
                                                                                end: 10),
                                                                            physics:
                                                                                const NeverScrollableScrollPhysics(),
                                                                            itemCount:
                                                                                item4.children!.length,
                                                                            itemBuilder:
                                                                                (context, index) {
                                                                              CategoryModel? item5;
                                                                              item5 = item4!.children!.isEmpty ? null : item4.children![index];
                                                                              return item5 == null
                                                                                  ? Container()
                                                                                  : Column(
                                                                                      children: [
                                                                                        InkWell(
                                                                                          onTap: () {
                                                                                            update();
                                                                                            editProvider!.selectedCatName = item5!.name;
                                                                                            editProvider!.selectedCatID = item5.id;
                                                                                          },
                                                                                          child: Row(
                                                                                            children: [
                                                                                              const SizedBox(
                                                                                                width: 10,
                                                                                              ),
                                                                                              const Icon(
                                                                                                Icons.subdirectory_arrow_right_outlined,
                                                                                                color: secondary,
                                                                                                size: 20,
                                                                                              ),
                                                                                              const SizedBox(
                                                                                                width: 5,
                                                                                              ),
                                                                                              Text(item5.name!),
                                                                                            ],
                                                                                          ),
                                                                                        ),
                                                                                      ],
                                                                                    );
                                                                            },
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    );
                                                            },
                                                          ),
                                                        ),
                                                      ],
                                                    );
                                            },
                                          ),
                                        ),
                                      ],
                                    );
                            },
                          ),
                        ),
                      ],
                    );
            },
          ),
        ),
      ],
    ),
  );
}
