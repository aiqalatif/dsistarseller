import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sellermultivendor/Provider/settingProvider.dart';
import 'package:sellermultivendor/Screen/ReviewList/widget/ReviewBodyWidget.dart';
import 'package:sellermultivendor/Widget/validation.dart';
import '../../Provider/reviewListProvider.dart';
import '../../Widget/appBar.dart';
import '../../Model/ProductModel/Product.dart';
import '../../Widget/simmerEffect.dart';

class ReviewList extends StatefulWidget {
  final String? id;
  final Product? model;

  const ReviewList(this.id, this.model, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return StateRate();
  }
}

ReviewListProvider? salesProvider;

class StateRate extends State<ReviewList> {
  setStateNow() {
    setState(() {});
  }

  @override
  void initState() {
    salesProvider = Provider.of<ReviewListProvider>(context, listen: false);
    salesProvider!.initializeVariable();
    salesProvider!.getReview(widget.id!, setStateNow, context);
    salesProvider!.controller.addListener(_scrollListener);
    super.initState();
  }

  _scrollListener() {
    if (salesProvider!.controller.offset >=
            salesProvider!.controller.position.maxScrollExtent &&
        !salesProvider!.controller.position.outOfRange) {
      if (mounted) {
        if (mounted) {
          setState(
            () {
              salesProvider!.isLoadingmore = true;
              if (salesProvider!.offset < salesProvider!.total) {
                salesProvider!.getReview(widget.id!, setStateNow, context);
              }
            },
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: salesProvider!.scaffoldKey,
      body: !salesProvider!.isLoading
          ? salesProvider!.userComment != "00.00"
              ? ReviewBody(update: setStateNow)
              : Column(
                  children: [
                    GradientAppBar(
                      getTranslated(context, "Customer Reviews")!,
                    ),
                    SizedBox(
                      height: height * 0.9,
                      child: Center(
                        child: Text(
                          getTranslated(context, "No Ratting Found...!")!,
                        ),
                      ),
                    ),
                  ],
                )
          : const ShimmerEffect(),
    );
  }
}
