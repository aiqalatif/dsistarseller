import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sellermultivendor/Provider/zipcodeProvider.dart';
import '../../../../Helper/Color.dart';
import '../../../../Helper/Constant.dart';
import '../../../../Widget/validation.dart';
import '../../EditProduct.dart';

zipcodeDialog(
  BuildContext context,
  Function update,
) async {
  await showModalBottomSheet(
    isScrollControlled: true,
    context: context,
    backgroundColor: Colors.transparent,
    builder: (BuildContext context) {
      return Container(
        height: 500,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(circularBorderRadius25),
            topRight: Radius.circular(circularBorderRadius25),
          ),
        ),
        child: StatefulBuilder(
          builder: (BuildContext context, setStater) {
            ScrollController scrollController = ScrollController();
            scrollController.addListener(() async {
              if (scrollController.offset >=
                      scrollController.position.maxScrollExtent &&
                  !scrollController.position.outOfRange) {
                if (context.mounted) {
                  await context
                      .read<ZipcodeProvider>()
                      .setZipCode(false, isRefresh: false);
                  setStater(() {});
                }
              }
            });
            // if (context.read<ZipcodeProvider>().searchString.isNotEmpty) {
            //   Future.delayed(Duration.zero, () async {
            //     context.read<ZipcodeProvider>().searchString = "";
            //     await context
            //         .read<ZipcodeProvider>()
            //         .setZipCode(false, isRefresh: true);
            //     setStater(() {});
            //   });
            // }
            editProvider!.taxesState = setStater;
            Timer? debounce;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20.0, 20.0, 0, 0),
                  child: Text(
                    getTranslated(context, "Select Zipcodes")!,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(color: primary),
                  ),
                ),
                const Divider(color: lightBlack),
                const SizedBox(
                  height: 5,
                ),
                Container(
                  margin: const EdgeInsets.fromLTRB(20.0, 0, 20, 0),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(
                        Radius.circular(circularBorderRadius5)),
                    boxShadow: [
                      BoxShadow(
                        color: blarColor,
                        offset: Offset(0, 0),
                        blurRadius: 4,
                        spreadRadius: 0,
                      ),
                    ],
                    color: white,
                  ),
                  child: TextFormField(
                    initialValue: context.read<ZipcodeProvider>().searchString,
                    decoration: InputDecoration(
                      filled: true,
                      isDense: true,
                      fillColor: white,
                      prefixIconConstraints: const BoxConstraints(
                        minWidth: 40,
                        maxHeight: 20,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 10,
                      ),
                      prefixIcon: const Icon(Icons.search),
                      hintText: getTranslated(context, "SEARCH"),
                      hintStyle: TextStyle(
                          color: black.withOpacity(0.3),
                          fontWeight: FontWeight.normal),
                      border: const OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 0,
                          style: BorderStyle.none,
                        ),
                      ),
                    ),
                    onChanged: (value) {
                      if (debounce?.isActive ?? false) debounce?.cancel();
                      //auto search after 1 second of typing
                      debounce =
                          Timer(const Duration(milliseconds: 1000), () async {
                        context.read<ZipcodeProvider>().searchString = value;
                        await context.read<ZipcodeProvider>().setZipCode(
                              false,
                              isRefresh: true,
                            );
                        setStater(() {});
                      });
                    },
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Expanded(
                  child: editProvider!.zipSearchList.isEmpty
                      ? Center(
                          child: Text(
                            getTranslated(context, "NO_DATA_FOUND")!,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(color: primary),
                          ),
                        )
                      : SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: () {
                              bool flag = false;
                              return editProvider!.zipSearchList
                                  .asMap()
                                  .map(
                                    (index, element) => MapEntry(
                                      index,
                                      InkWell(
                                        onTap: () {
                                          if (!flag) {
                                            flag = true;
                                          }
                                          if (editProvider!
                                                      .deliverableZipcodes ==
                                                  null ||
                                              editProvider!
                                                      .deliverableZipcodes ==
                                                  '') {
                                            editProvider!.deliverableZipcodes =
                                                editProvider!
                                                    .zipSearchList[index]
                                                    .zipcode;
                                          } else if (editProvider!
                                              .deliverableZipcodes!
                                              .contains(
                                                  '${editProvider!.zipSearchList[index].zipcode!},')) {
                                            var a =
                                                '${editProvider!.zipSearchList[index].zipcode!},';
                                            var b = editProvider!
                                                .deliverableZipcodes!
                                                .replaceAll(a, '');

                                            editProvider!.deliverableZipcodes =
                                                b;
                                          } else if (editProvider!
                                              .deliverableZipcodes!
                                              .contains(editProvider!
                                                  .zipSearchList[index]
                                                  .zipcode!)) {
                                            var a = editProvider!
                                                .zipSearchList[index].zipcode!;
                                            var b = editProvider!
                                                .deliverableZipcodes!
                                                .replaceAll(a, "");
                                            editProvider!.deliverableZipcodes =
                                                b;
                                          } else if (editProvider!
                                              .deliverableZipcodes!
                                              .endsWith(',')) {
                                            editProvider!.deliverableZipcodes =
                                                "${editProvider!.deliverableZipcodes!}${editProvider!.zipSearchList[index].zipcode!}";
                                          } else {
                                            editProvider!.deliverableZipcodes =
                                                "${editProvider!.deliverableZipcodes!},${editProvider!.zipSearchList[index].zipcode!}";
                                          }
                                          update();

                                          setStater(() => {});
                                          update();
                                        },
                                        child: Row(
                                          children: [
                                            Expanded(
                                              flex: 2,
                                              child: editProvider!
                                                              .deliverableZipcodes !=
                                                          null &&
                                                      editProvider!
                                                          .deliverableZipcodes!
                                                          .contains(editProvider!
                                                              .zipSearchList[
                                                                  index]
                                                              .zipcode!)
                                                  ? Container(
                                                      height: 20,
                                                      width: 20,
                                                      decoration:
                                                          const BoxDecoration(
                                                        color: grey2,
                                                        shape: BoxShape.circle,
                                                      ),
                                                      child: Center(
                                                        child: Container(
                                                          height: 16,
                                                          width: 16,
                                                          decoration:
                                                              const BoxDecoration(
                                                            color: primary,
                                                            shape:
                                                                BoxShape.circle,
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
                                                        shape: BoxShape.circle,
                                                      ),
                                                      child: Center(
                                                        child: Container(
                                                          height: 16,
                                                          width: 16,
                                                          decoration:
                                                              const BoxDecoration(
                                                            color: white,
                                                            shape:
                                                                BoxShape.circle,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                            ),
                                            Expanded(
                                              flex: 8,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text(
                                                  editProvider!
                                                      .zipSearchList[index]
                                                      .zipcode!,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                  .values
                                  .toList();
                            }(),
                          ),
                        ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      child: Text(
                        getTranslated(context, "CANCEL")!,
                        style: const TextStyle(
                          color: Colors.black,
                        ),
                      ),
                      onPressed: () {
                        editProvider!.deliverableZipcodes = null;
                        update();
                        Navigator.pop(context);
                      },
                    ),
                    TextButton(
                      child: Text(
                        getTranslated(context, "Ok")!,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      );
    },
  );
}
