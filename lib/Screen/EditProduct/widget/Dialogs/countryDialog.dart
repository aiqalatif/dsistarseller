import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../Helper/Color.dart';
import '../../../../Helper/Constant.dart';
import '../../../../Provider/countryProvider.dart';
import '../../../../Widget/desing.dart';
import '../../../../Widget/snackbar.dart';
import '../../../../Widget/validation.dart';
import '../../EditProduct.dart';

countryDialog(
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
          editProvider!.countryState = setStater;
          return Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(circularBorderRadius25),
                topRight: Radius.circular(circularBorderRadius25),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20.0, 20.0, 0, 0),
                  child: Text(
                    getTranslated(context, "Made In")!,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(color: primary),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: TextField(
                          controller: editProvider!.countryController,
                          autofocus: false,
                          style: const TextStyle(
                            color: primary,
                          ),
                          decoration: InputDecoration(
                            contentPadding:
                                const EdgeInsets.fromLTRB(0, 15.0, 0, 15.0),
                            hintText: getTranslated(context, 'SEARCH_LBL'),
                            hintStyle:
                                TextStyle(color: primary.withOpacity(0.5)),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context).colorScheme.primary),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context).colorScheme.primary),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: IconButton(
                          onPressed: () async {
                            editProvider!.isLoadingMoreCountry = true;
                            update();
                            await context
                                .read<CountryProvider>()
                                .setCountrys(true, false)
                                .then(
                              (value) {
                                if (value == true) {
                                  setSnackbar(
                                      context
                                          .read<CountryProvider>()
                                          .errorMessage,
                                      context);
                                }
                              },
                            );
                          },
                          icon: const Icon(
                            Icons.search,
                            size: 20,
                          )),
                    )
                  ],
                ),
                editProvider!.countryLoading
                    ? const Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 50.0),
                          child: CircularProgressIndicator(),
                        ),
                      )
                    : (editProvider!.countrySearchList.isNotEmpty)
                        ? Flexible(
                            child: SizedBox(
                              height: MediaQuery.of(context).size.height * 0.4,
                              child: SingleChildScrollView(
                                controller:
                                    editProvider!.countryScrollController,
                                child: Stack(
                                  children: [
                                    Column(
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children:
                                              getCityList(context, update),
                                        ),
                                        Center(
                                          child: DesignConfiguration
                                              .showCircularProgress(
                                                  editProvider!
                                                      .isLoadingMoreCountry!,
                                                  primary),
                                        ),
                                      ],
                                    ),
                                    DesignConfiguration.showCircularProgress(
                                        editProvider!.isProgress, primary),
                                  ],
                                ),
                              ),
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20.0),
                            child: DesignConfiguration.getNoItem(context),
                          )
              ],
            ),
          );
        },
      );
    },
  );
}

getCityList(
  BuildContext context,
  Function update,
) {
  return editProvider!.countrySearchList
      .asMap()
      .map(
        (index, element) => MapEntry(
          index,
          InkWell(
            onTap: () {
              editProvider!.madeIn =
                  editProvider!.countrySearchList[index].name;
              editProvider!.selCountryPos = index;

              Navigator.of(context).pop();
              update();

              editProvider!.country = editProvider!
                  .countrySearchList[editProvider!.selCountryPos!].id;
            },
            child: SizedBox(
              width: double.maxFinite,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  editProvider!.countrySearchList[index].name!,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
            ),
          ),
        ),
      )
      .values
      .toList();
}
