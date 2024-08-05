import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sellermultivendor/Helper/ApiBaseHelper.dart';
import 'package:sellermultivendor/Helper/Color.dart';
import 'package:sellermultivendor/Screen/EditProduct/EditProduct.dart';
import '../../Helper/Constant.dart';
import '../../Model/ProductModel/Product.dart';
import '../../Provider/searchProvider.dart';
import '../../Provider/settingProvider.dart';
import '../../Widget/desing.dart';
import '../../Widget/networkAvailablity.dart';
import '../../Widget/routes.dart';
import '../../Widget/validation.dart';
import '../../Widget/noNetwork.dart';

class Search extends StatefulWidget {
  final Function? updateHome;
  const Search({Key? key, this.updateHome}) : super(key: key);
  @override
  _StateSearch createState() => _StateSearch();
}

SearchProvider? searchProvider;

class _StateSearch extends State<Search> with TickerProviderStateMixin {
  late AnimationController _animationController;
  ApiBaseHelper apiBaseHelper = ApiBaseHelper();

  setStateNow() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    searchProvider = Provider.of<SearchProvider>(context, listen: false);
    searchProvider!.initializeVariable();

    searchProvider!.productList.clear();

    searchProvider!.notificationoffset = 0;

    searchProvider!.notificationcontroller =
        ScrollController(keepScrollOffset: true);
    searchProvider!.notificationcontroller!
        .addListener(_transactionscrollListener);

    searchProvider!.controller.addListener(
      () {
        if (searchProvider!.controller.text.isEmpty) {
          if (mounted) {
            setState(() {
              searchProvider!.searchText = "";
            });
          }
        } else {
          if (mounted) {
            setState(
              () {
                searchProvider!.searchText = searchProvider!.controller.text;
              },
            );
          }
        }

        if (searchProvider!.lastsearch != searchProvider!.searchText &&
            (searchProvider!.searchText.isNotEmpty)) {
          searchProvider!.lastsearch = searchProvider!.searchText;
          searchProvider!.notificationisloadmore = true;
          searchProvider!.notificationoffset = 0;
          searchProvider!.getProduct(setStateNow, context);
        }
      },
    );

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );

    searchProvider!.buttonController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);

    searchProvider!.buttonSqueezeanimation = Tween(
      begin: width * 0.7,
      end: 50.0,
    ).animate(
      CurvedAnimation(
        parent: searchProvider!.buttonController!,
        curve: const Interval(
          0.0,
          0.150,
        ),
      ),
    );
  }

  _transactionscrollListener() {
    if (searchProvider!.notificationcontroller!.offset >=
            searchProvider!.notificationcontroller!.position.maxScrollExtent &&
        !searchProvider!.notificationcontroller!.position.outOfRange) {
      if (mounted) {
        setState(
          () {
            searchProvider!.getProduct(setStateNow, context);
          },
        );
      }
    }
  }

  @override
  void dispose() {
    searchProvider!.buttonController!.dispose();
    searchProvider!.notificationcontroller!.dispose();
    for (int i = 0; i < searchProvider!.controllerList.length; i++) {
      searchProvider!.controllerList[i].dispose();
    }
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _playAnimation() async {
    try {
      await searchProvider!.buttonController!.forward();
    } on TickerCanceled {}
  }

  setStateNoInternate() async {
    _playAnimation();

    Future.delayed(const Duration(seconds: 2)).then(
      (_) async {
        isNetworkAvail = await isNetworkAvailable();
        if (isNetworkAvail) {
          Navigator.pushReplacement(
            context,
            CupertinoPageRoute(
              builder: (BuildContext context) => super.widget,
            ),
          );
        } else {
          await searchProvider!.buttonController!.reverse();
          if (mounted) {
            setState(
              () {},
            );
          }
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      key: searchProvider!.scaffoldKey,
      appBar: AppBar(
        leading: Builder(builder: (BuildContext context) {
          return Container(
            margin: const EdgeInsets.all(10),
            decoration: DesignConfiguration.shadow(),
            child: Card(
              elevation: 0,
              child: InkWell(
                borderRadius: BorderRadius.circular(circularBorderRadius5),
                onTap: () => Navigator.of(context).pop(),
                child: const Padding(
                  padding: EdgeInsetsDirectional.only(end: 4.0),
                  child: Icon(
                    Icons.keyboard_arrow_left,
                    color: primary,
                  ),
                ),
              ),
            ),
          );
        }),
        backgroundColor: white,
        title: TextField(
          controller: searchProvider!.controller,
          autofocus: true,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.fromLTRB(0, 15.0, 0, 15.0),
            prefixIcon: const Icon(Icons.search, color: primary, size: 17),
            hintText: getTranslated(context, "SEARCH")!,
            hintStyle: TextStyle(
              color: primary.withOpacity(
                0.5,
              ),
            ),
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: white),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: white),
            ),
          ),
        ),
        titleSpacing: 0,
      ),
      body: isNetworkAvail
          ? Stack(
              children: <Widget>[
                _showContent(),
                DesignConfiguration.showCircularProgress(
                    searchProvider!.isProgress, primary),
              ],
            )
          : noInternet(
              context,
              setStateNoInternate,
              searchProvider!.buttonSqueezeanimation,
              searchProvider!.buttonController),
    );
  }

  Widget listItem(int index) {
    Product model = searchProvider!.productList[index];

    if (searchProvider!.controllerList.length < index + 1) {
      searchProvider!.controllerList.add(TextEditingController());
    }
    searchProvider!.controllerList[index].text =
        model.prVarientList![model.selVarient!].cartCount!;

    double price =
        double.parse(model.prVarientList![model.selVarient!].disPrice!);
    if (price == 0) {
      price = double.parse(model.prVarientList![model.selVarient!].price!);
    }
    List att = [], val = [];
    if (model.prVarientList![model.selVarient!].attr_name != null) {
      att = model.prVarientList![model.selVarient!].attr_name!.split(',');
      val = model.prVarientList![model.selVarient!].varient_value!.split(',');
    }

    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: InkWell(
          splashColor: primary.withOpacity(0.2),
          onTap: () {
            Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (context) => EditProduct(
                  model: model,
                ),
              ),
            );
          },
          child: Stack(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Hero(
                    tag: "$index${model.id}",
                    child: ClipRRect(
                      borderRadius:
                          BorderRadius.circular(circularBorderRadius7),
                      child: DesignConfiguration.getCacheNotworkImage(
                        boxFit: BoxFit.cover,
                        context: context,
                        heightvalue: 80,
                        placeHolderSize: 80,
                        imageurlString:
                            searchProvider!.productList[index].image!,
                        widthvalue: 80,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            model.name!,
                            style:
                                Theme.of(context).textTheme.titleSmall!.copyWith(
                                      color: lightBlack,
                                    ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: <Widget>[
                                  Text(
                                      DesignConfiguration.getPriceFormat(
                                        context,
                                        double.parse(
                                          price.toString(),
                                        ),
                                      )!,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium),
                                  Text(
                                    double.parse(model
                                                .prVarientList![
                                                    model.selVarient!]
                                                .disPrice!) !=
                                            0
                                        ? DesignConfiguration.getPriceFormat(
                                            context,
                                            double.parse(model
                                                .prVarientList![
                                                    model.selVarient!]
                                                .price!),
                                          )!
                                        : "",
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelSmall!
                                        .copyWith(
                                          decoration:
                                              TextDecoration.lineThrough,
                                          letterSpacing: 0,
                                        ),
                                  ),
                                ],
                              ),
                              InkWell(
                                onTap: () {
                                  productDeletDialog(model.name!, model.id!);
                                },
                                child: const Card(
                                  child: Icon(
                                    Icons.delete,
                                    color: primary,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          model.prVarientList![model.selVarient!].attr_name !=
                                      null &&
                                  model.prVarientList![model.selVarient!]
                                      .attr_name!.isNotEmpty
                              ? ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: att.length,
                                  itemBuilder: (context, index) {
                                    return Row(
                                      children: [
                                        Flexible(
                                          child: Text(
                                            att[index].trim() + ":",
                                            overflow: TextOverflow.ellipsis,
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleSmall!
                                                .copyWith(color: lightBlack),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsetsDirectional.only(
                                                  start: 5.0),
                                          child: Text(
                                            val[index],
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleSmall!
                                                .copyWith(
                                                    color: lightBlack,
                                                    fontWeight:
                                                        FontWeight.bold),
                                          ),
                                        )
                                      ],
                                    );
                                  },
                                )
                              : Container(),
                          Row(
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    Icons.star,
                                    color: primary,
                                    size: 12,
                                  ),
                                  Text(
                                    " ${searchProvider!.productList[index].rating!}",
                                    style: Theme.of(context).textTheme.labelSmall,
                                  ),
                                  Text(
                                    " (${searchProvider!.productList[index].noOfRating!})",
                                    style: Theme.of(context).textTheme.labelSmall,
                                  )
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
              searchProvider!.productList[index].availability == "0"
                  ? Text(
                      getTranslated(context, "OutOfStock")!,
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(
                            color: red,
                            fontWeight: FontWeight.bold,
                          ),
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }

  _showContent() {
    return searchProvider!.notificationisnodata
        ? DesignConfiguration.getNoItem(context)
        : NotificationListener<ScrollNotification>(
            child: Column(
              children: <Widget>[
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsetsDirectional.only(
                        bottom: 5, start: 10, end: 10, top: 12),
                    controller: searchProvider!.notificationcontroller,
                    physics: const BouncingScrollPhysics(),
                    itemCount: searchProvider!.productList.length,
                    itemBuilder: (context, index) {
                      Product? item;
                      try {
                        item = searchProvider!.productList.isEmpty
                            ? null
                            : searchProvider!.productList[index];
                        if (searchProvider!.notificationisloadmore &&
                            index == (searchProvider!.productList.length - 1) &&
                            searchProvider!
                                    .notificationcontroller!.position.pixels <=
                                0) {
                          searchProvider!.getProduct(setStateNow, context);
                        }
                      } on Exception catch (_) {}

                      return item == null ? Container() : listItem(index);
                    },
                  ),
                ),
                searchProvider!.notificationisgettingdata
                    ? const Padding(
                        padding: EdgeInsetsDirectional.only(top: 5, bottom: 5),
                        child: CircularProgressIndicator(),
                      )
                    : Container(),
              ],
            ),
          );
  }

  productDeletDialog(
    String productName,
    String id,
  ) async {
    String pName = productName;
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setStater) {
            return AlertDialog(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(circularBorderRadius5),
                ),
              ),
              content: Text(
                "${getTranslated(context, "sure")!} \"  $pName \" ${getTranslated(context, "PRODUCT")!}",
                style: Theme.of(this.context)
                    .textTheme
                    .titleMedium!
                    .copyWith(color: fontColor),
              ),
              actions: <Widget>[
                TextButton(
                    child: Text(
                      getTranslated(context, "LOGOUTNO")!,
                      style: Theme.of(this.context)
                          .textTheme
                          .titleSmall!
                          .copyWith(
                              color: lightBlack, fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    }),
                TextButton(
                  child: Text(
                    getTranslated(context, "LOGOUTYES")!,
                    style: Theme.of(this.context).textTheme.titleSmall!.copyWith(
                        color: fontColor, fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                    Routes.pop(context);
                    searchProvider!.delProductApi(id, context, setStateNow);

                    setState(
                      () {
                        searchProvider!.searchText = "";
                        searchProvider!.getProduct(setStateNow, context);
                      },
                    );
                  },
                )
              ],
            );
          },
        );
      },
    );
  }
}
