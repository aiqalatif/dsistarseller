import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:sellermultivendor/Screen/ProductPreview/widget/selectedPhoto.dart';
import '../../Helper/Color.dart';
import '../../Helper/Constant.dart';
import '../../Widget/desing.dart';

class ProductPreview extends StatefulWidget {
  final int? pos, secPos, index;
  final bool? list, from;
  final Size? screenSize;
  final String? id, video, videoType;
  final List<String?>? imgList;

  const ProductPreview({
    Key? key,
    this.pos,
    this.secPos,
    this.index,
    this.list,
    this.id,
    this.imgList,
    this.screenSize,
    this.video,
    this.videoType,
    this.from,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => StatePreview();
}

class StatePreview extends State<ProductPreview> {
  late PageController pageController = PageController(
    initialPage: widget.pos!,
  );

  late List<ScrollController> scrollControllers = [];

  late int curPos = widget.pos!;

  void initScrollControllers() {
    double initialPosition = widget.screenSize!.width * (0.4);

    for (var _ in widget.imgList!) {
      scrollControllers.add(
        ScrollController(
          initialScrollOffset: initialPosition,
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    initScrollControllers();
    curPos = widget.pos!;
  }

  @override
  void dispose() {
    super.dispose();
  }

  void onHorizontalDragUpdate(DragUpdateDetails dragUpdateDetails) {
    if (dragUpdateDetails.primaryDelta! != 0.0) {
      double value =
          scrollControllers[curPos].offset - dragUpdateDetails.primaryDelta!;
      if (value >= scrollControllers[curPos].position.maxScrollExtent) {
        double pageControllerValue =
            pageController.offset - dragUpdateDetails.primaryDelta!;

        if (curPos != (widget.imgList!.length - 1)) {
          pageController.jumpTo(pageControllerValue);
        }
      } else {
        if (value < 0.0) {
          double pageControllerValue =
              pageController.offset - dragUpdateDetails.primaryDelta!;
          if (curPos != 0) {
            pageController.jumpTo(pageControllerValue);
          }
        } else {
          scrollControllers[curPos].jumpTo(value);
        }
      }
    }
  }

  void onVerticalDragUpdate(DragUpdateDetails dragUpdateDetails) {}

  @override
  void deactivate() {
    super.deactivate();
  }

  double scaleData = 1.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          widget.video == ''
              ? Stack(
                  children: [
                    Center(
                      child: GestureDetector(
                        onVerticalDragUpdate: onVerticalDragUpdate,
                        onHorizontalDragUpdate: onHorizontalDragUpdate,
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height * (1.0),
                          child: PageView.builder(
                            onPageChanged: (index) {
                              setState(
                                () {
                                  curPos = index;
                                },
                              );
                            },
                            controller: pageController,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: widget.imgList!.length,
                            itemBuilder: (context, index) {
                              return SingleChildScrollView(
                                controller: scrollControllers[index],
                                physics: const NeverScrollableScrollPhysics(),
                                scrollDirection: Axis.horizontal,
                                child: Transform.scale(
                                  scale: scaleData,
                                  child: SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        (1.8),
                                    child: Hero(
                                      tag: widget.list!
                                          ? '${widget.id}'
                                          : "${widget.secPos}${widget.index}",
                                      child: Image.network(
                                        widget.imgList![index]!,
                                        fit: BoxFit.fitHeight,
                                        alignment: Alignment.center,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                    curPos != (widget.imgList!.length - 1)
                        ? Align(
                            alignment: AlignmentDirectional.centerEnd,
                            child: IconButton(
                              onPressed: () {
                                pageController.nextPage(
                                  duration: const Duration(
                                    milliseconds: 500,
                                  ),
                                  curve: Curves.ease,
                                );
                              },
                              icon: Icon(
                                Icons.arrow_forward_ios,
                                color:
                                    Theme.of(context).scaffoldBackgroundColor,
                              ),
                            ),
                          )
                        : const SizedBox(),
                    curPos != 0
                        ? Align(
                            alignment: AlignmentDirectional.centerStart,
                            child: IconButton(
                              color: Theme.of(context).scaffoldBackgroundColor,
                              onPressed: () {
                                pageController.previousPage(
                                    duration: const Duration(milliseconds: 500),
                                    curve: Curves.ease);
                              },
                              icon: const Icon(
                                Icons.arrow_back_ios,
                              ),
                            ),
                          )
                        : const SizedBox(),
                  ],
                )
              : PageView.builder(
                  itemCount: widget.imgList!.length,
                  controller: PageController(initialPage: curPos),
                  onPageChanged: (index) {
                    if (mounted) {
                      setState(
                        () {
                          curPos = index;
                        },
                      );
                    }
                  },
                  itemBuilder: (BuildContext context, int index) {
                    if (index == 1 &&
                        widget.from! &&
                        widget.videoType != null &&
                        widget.video != '') {}
                    return PhotoView(
                      backgroundDecoration: const BoxDecoration(color: white),
                      initialScale: PhotoViewComputedScale.contained * 0.9,
                      minScale: PhotoViewComputedScale.contained * 0.9,
                      maxScale: PhotoViewComputedScale.contained * 1.8,
                      gaplessPlayback: false,
                      customSize: MediaQuery.of(context).size,
                      imageProvider: NetworkImage(
                        widget.imgList![index]!,
                      ),
                    );
                  },
                ),
          Positioned(
            top: 34.0,
            left: 5.0,
            child: Material(
              color: Colors.transparent,
              child: Container(
                margin: const EdgeInsets.all(10),
                decoration: DesignConfiguration.shadow(),
                child: Card(
                  elevation: 0,
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
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 10.0,
            left: 25.0,
            right: 25.0,
            child: SelectedPhoto(
              numberOfDots: widget.imgList!.length,
              photoIndex: curPos,
            ),
          ),
        ],
      ),
    );
  }
}
