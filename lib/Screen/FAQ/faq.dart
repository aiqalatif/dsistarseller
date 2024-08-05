import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sellermultivendor/Screen/FAQ/widget/getFaQIteams.dart';
import '../../Helper/Color.dart';
import '../../Helper/Constant.dart';
import '../../Provider/faqProvider.dart';
import '../../Provider/settingProvider.dart';
import '../../Widget/appBar.dart';
import '../../Widget/desing.dart';
import '../../Widget/networkAvailablity.dart';
import '../../Model/FAQModel/Faqs_Model.dart';
import '../../Model/ProductModel/Product.dart';
import '../../Widget/noNetwork.dart';
import '../../Widget/snackbar.dart';
import '../../Widget/validation.dart';

class AddFAQs extends StatefulWidget {
  final String? id;
  final Product? model;
  const AddFAQs(this.id, this.model, {Key? key}) : super(key: key);
  @override
  _AddFAQsState createState() => _AddFAQsState();
}

FaQProvider? faqProvider;

class _AddFAQsState extends State<AddFAQs> with TickerProviderStateMixin {
  setStateNow() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    faqProvider = Provider.of<FaQProvider>(context, listen: false);
    faqProvider!.initializevariableValues();

    faqProvider!.scrollOffset = 0;
    faqProvider!.getFaQs(context, setStateNow, widget.id!);

    faqProvider!.buttonController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    faqProvider!.scrollController = ScrollController(keepScrollOffset: true);
    faqProvider!.scrollController!.addListener(_transactionscrollListener);

    faqProvider!.buttonSqueezeanimation = Tween(
      begin: width * 0.7,
      end: 50.0,
    ).animate(
      CurvedAnimation(
        parent: faqProvider!.buttonController!,
        curve: const Interval(
          0.0,
          0.150,
        ),
      ),
    );
  }

  _transactionscrollListener() {
    if (faqProvider!.scrollController!.offset >=
            faqProvider!.scrollController!.position.maxScrollExtent &&
        !faqProvider!.scrollController!.position.outOfRange) {
      if (mounted) {
        setState(
          () {
            faqProvider!.scrollLoadmore = true;
            faqProvider!.getFaQs(context, setStateNow, widget.id!);
          },
        );
      }
    }
  }

  newQuestionButtomSheet(
    BuildContext context,
  ) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext ctx) {
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.4,
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
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 15.0,
                  bottom: 30.0,
                  right: 42,
                  left: 42,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          getTranslated(context, 'Add Question')!,
                          style: const TextStyle(
                            color: black,
                            fontWeight: FontWeight.w700,
                            fontFamily: "PlusJakartaSans",
                            fontStyle: FontStyle.normal,
                            fontSize: 16.0,
                          ),
                        ),
                        InkWell(
                          onTap: () => Navigator.pop(context),
                          child: ClipRect(
                            child: Container(
                              width: 20,
                              height: 20,
                              decoration: const BoxDecoration(
                                color: grad2Color,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.close,
                                color: white,
                                size: 15,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Padding(
                      padding: EdgeInsets.only(
                        top: 24.0,
                        bottom: 24.0,
                      ),
                      child: Divider(color: grey3),
                    ),
                    SizedBox(
                      height: 42,
                      child: TextFormField(
                        onFieldSubmitted: (v) {
                          FocusScope.of(context)
                              .requestFocus(faqProvider!.tagsController);
                        },
                        controller: faqProvider!.mobilenumberController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: "Enter Question",
                          labelStyle: TextStyle(
                            color: black,
                            fontSize: 17.0,
                          ),
                          hintStyle: TextStyle(
                            color: grey3,
                            fontWeight: FontWeight.w400,
                            fontFamily: "PlusJakartaSans",
                            fontStyle: FontStyle.normal,
                            fontSize: 14.0,
                          ),
                        ),
                        keyboardType: TextInputType.text,
                        focusNode: faqProvider!.tagsController,
                        onSaved: (String? value) {
                          faqProvider!.tagvalue = value;
                        },
                        onChanged: (String? value) {
                          faqProvider!.tagvalue = value;
                        },
                        style: const TextStyle(
                          color: black,
                          fontSize: 18.0,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      onFieldSubmitted: (v) {
                        FocusScope.of(context)
                            .requestFocus(faqProvider!.ansFocus);
                      },
                      controller: faqProvider!.answerController,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        hintText: getTranslated(
                            context, "Enter Your Answer (Optional)")!,
                        labelStyle: const TextStyle(
                          color: black,
                          fontSize: 17.0,
                        ),
                        hintStyle: const TextStyle(
                          color: grey3,
                          fontWeight: FontWeight.w400,
                          fontFamily: "PlusJakartaSans",
                          fontStyle: FontStyle.normal,
                          fontSize: 14.0,
                        ),
                      ),
                      keyboardType: TextInputType.text,
                      focusNode: faqProvider!.ansFocus,
                      onSaved: (String? value) {
                        faqProvider!.ansValue = value;
                      },
                      onChanged: (String? value) {
                        faqProvider!.ansValue = value;
                      },
                      style: const TextStyle(
                        color: black,
                        fontSize: 18.0,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 28.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                            child: InkWell(
                              onTap: () {
                                if (faqProvider!.tagvalue != '' &&
                                    faqProvider!.tagvalue != null) {
                                  faqProvider!.tagList.clear();
                                  faqProvider!.scrollLoadmore = true;

                                  faqProvider!.addTagAPI(
                                      context, widget.id!, setStateNow);
                                  Navigator.pop(context);
                                  Future.delayed(const Duration(seconds: 2))
                                      .then(
                                    (_) async {
                                      faqProvider!.scrollLoadmore = true;
                                      faqProvider!.scrollOffset = 0;
                                      faqProvider!.getFaQs(
                                        context,
                                        setStateNow,
                                        widget.id!,
                                      );
                                      setStateNow();
                                    },
                                  );
                                } else {
                                  Navigator.pop(context);
                                  setSnackbar(
                                      getTranslated(context,
                                          "Please Add Questions Value")!,
                                      context);
                                }
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: primary,
                                  borderRadius: BorderRadius.circular(
                                      circularBorderRadius5),
                                ),
                                width: 120,
                                height: 40,
                                child: Center(
                                  child: Text(
                                    getTranslated(context, 'Submit')!,
                                    style: const TextStyle(
                                      color: white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  oldQuestionButtomSheet(
    BuildContext context,
    String question,
    String? answer,
    String id,
    int index,
  ) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext ctx) {
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.4,
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
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 15.0,
                  bottom: 30.0,
                  right: 42,
                  left: 42,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          getTranslated(context, "Edit Answer")!,
                          style: const TextStyle(
                            color: black,
                            fontWeight: FontWeight.w700,
                            fontFamily: "PlusJakartaSans",
                            fontStyle: FontStyle.normal,
                            fontSize: 16.0,
                          ),
                        ),
                        InkWell(
                          onTap: () => Navigator.pop(context),
                          child: ClipRect(
                            child: Container(
                              width: 20,
                              height: 20,
                              decoration: const BoxDecoration(
                                color: grad2Color,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.close,
                                color: white,
                                size: 15,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Padding(
                      padding: EdgeInsets.only(
                        top: 24.0,
                        bottom: 24.0,
                      ),
                      child: Divider(color: grey3),
                    ),
                    Text(
                      question,
                      style: const TextStyle(
                          color: black,
                          fontWeight: FontWeight.w400,
                          fontFamily: "PlusJakartaSans",
                          fontStyle: FontStyle.normal,
                          fontSize: 16.0),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      textAlign: TextAlign.center,
                      controller: faqProvider!.listController[index],
                      keyboardType: TextInputType.text,
                      style: const TextStyle(
                        color: black,
                        fontSize: 18.0,
                      ),
                      onChanged: (String? value) {},
                      textInputAction: TextInputAction.next,
                      validator: (val) =>
                          StringValidation.validateMob(val!, context),
                      onSaved: (String? value) {},
                      decoration: InputDecoration(
                        hintText: faqProvider!.tagList[index].answer!.isNotEmpty
                            ? getTranslated(context, "Edit Your Answer")
                            : getTranslated(context, "Enter Your Answer"),
                        hintStyle: const TextStyle(
                          color: grey3,
                          fontWeight: FontWeight.w400,
                          fontFamily: "PlusJakartaSans",
                          fontStyle: FontStyle.normal,
                          fontSize: 14.0,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 28.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                            child: InkWell(
                              onTap: () {
                                if (faqProvider!
                                    .listController[index].text.isEmpty) {
                                  setSnackbar(
                                      getTranslated(
                                          context, "Please Add Your Answer")!,
                                      context);
                                } else {
                                  faqProvider!.editProductFaqAPI(
                                    faqProvider!.tagList[index].id,
                                    faqProvider!.listController[index].text,
                                    context,
                                  );
                                  faqProvider!.tagList.clear();
                                  faqProvider!.scrollLoadmore = true;
                                  Future.delayed(const Duration(seconds: 2))
                                      .then(
                                    (_) async {
                                      faqProvider!.scrollLoadmore = true;
                                      faqProvider!.scrollOffset = 0;
                                      faqProvider!
                                          .getFaQs(context, setStateNow, id);
                                      setStateNow();
                                    },
                                  );
                                }
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: primary,
                                  borderRadius: BorderRadius.circular(
                                      circularBorderRadius5),
                                ),
                                width: 120,
                                height: 40,
                                child: Center(
                                  child: Text(
                                    getTranslated(context, 'Submit')!,
                                    style: const TextStyle(
                                      color: white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: SizedBox(
        height: 40.0,
        width: 40.0,
        child: FittedBox(
          child: FloatingActionButton(
            backgroundColor: newPrimary,
            child: const Icon(
              Icons.add,
              size: 32,
              color: white,
            ),
            onPressed: () {
              newQuestionButtomSheet(context);
            },
          ),
        ),
      ),
      body: isNetworkAvail
          ? _showContent()
          : noInternet(
              context,
              setStateNoInternate,
              faqProvider!.buttonSqueezeanimation,
              faqProvider!.buttonController),
    );
  }

  _showContent() {
    return faqProvider!.scrollNodata
        ? Column(
            children: [
              GradientAppBar(
                widget.model!.name ?? "",
              ),
              SizedBox(
                height: height * 0.9,
                child: DesignConfiguration.getNoItem(context),
              ),
            ],
          )
        : NotificationListener<ScrollNotification>(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GradientAppBar(
                  widget.model!.name ?? "",
                ),
                faqProvider!.scrollGettingData
                    ? Container()
                    : Padding(
                        padding: const EdgeInsets.only(
                          top: 20.0,
                          right: 15.0,
                          left: 15.0,
                        ),
                        child: Text(getTranslated(context, 'Question')!,
                            style: const TextStyle(
                              color: black,
                              fontWeight: FontWeight.w400,
                              fontFamily: "PlusJakartaSans",
                              fontStyle: FontStyle.normal,
                              fontSize: 14.0,
                            ),
                            textAlign: TextAlign.left),
                      ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15.0,
                    vertical: 15.0,
                  ),
                  child: MediaQuery.removePadding(
                    context: context,
                    removeTop: true,
                    child: ListView.builder(
                      controller: faqProvider!.scrollController,
                      shrinkWrap: true,
                      itemCount: faqProvider!.tagList.length,
                      itemBuilder: (context, index) {
                        FaqsModel? item;

                        item = faqProvider!.tagList.isEmpty
                            ? null
                            : faqProvider!.tagList[index];

                        return item == null
                            ? Container()
                            : InkWell(
                                onTap: () {
                                  oldQuestionButtomSheet(
                                    context,
                                    faqProvider!.tagList[index].question!,
                                    faqProvider!.tagList[index].answer,
                                    faqProvider!.tagList[index].id!,
                                    index,
                                  );
                                },
                                child: GetMediaWidget(
                                  index: index,
                                  id: widget.id!,
                                  update: setStateNow,
                                ),
                              );
                      },
                    ),
                  ),
                ),
                faqProvider!.scrollGettingData
                    ? const Padding(
                        padding: EdgeInsetsDirectional.only(
                          top: 5,
                          bottom: 5,
                        ),
                        child: Center(child: CircularProgressIndicator()),
                      )
                    : Container(),
              ],
            ),
          );
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
          ).then(
            (value) {
              setState(
                () {},
              );
            },
          );
        } else {
          await faqProvider!.buttonController!.reverse();
          if (mounted) {
            setState(
              () {},
            );
          }
        }
      },
    );
  }

  Future<void> _playAnimation() async {
    try {
      await faqProvider!.buttonController!.forward();
    } on TickerCanceled {}
  }
}
