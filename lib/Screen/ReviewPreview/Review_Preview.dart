import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:sellermultivendor/Helper/Color.dart';
import '../../Helper/Constant.dart';
import '../../Model/RattingModel/Ratting.dart';
import '../../Widget/desing.dart';

class ReviewPreview extends StatefulWidget {
  final int? index;
  final List<dynamic>? imageList;
  final ProductRatting? RattingModel;

  const ReviewPreview({
    Key? key,
    this.index,
    this.RattingModel,
    this.imageList,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => StatePreview();
}

class StatePreview extends State<ReviewPreview> {
  int? curPos;
  bool flag = true;
  ProductRatting? model;

  @override
  void initState() {
    super.initState();
    curPos = widget.index;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.RattingModel != null) {
      model = widget.RattingModel!;
    }

    return Scaffold(
      body: Hero(
        tag: "${widget.index}",
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: <Widget>[
            PhotoViewGallery.builder(
              scrollPhysics: const BouncingScrollPhysics(),
              builder: (BuildContext context, int index) {
                return PhotoViewGalleryPageOptions(
                  initialScale: PhotoViewComputedScale.contained * 0.9,
                  minScale: PhotoViewComputedScale.contained * 0.9,
                  imageProvider: NetworkImage(
                    widget.imageList![index],
                  ),
                );
              },
              itemCount: widget.imageList!.length,
              loadingBuilder: (context, event) => Center(
                child: SizedBox(
                  width: 20.0,
                  height: 20.0,
                  child: CircularProgressIndicator(
                    color: primary,
                    value: event == null
                        ? 0
                        : event.cumulativeBytesLoaded /
                            event.expectedTotalBytes!,
                  ),
                ),
              ),
              backgroundDecoration: const BoxDecoration(color: white),
              pageController: PageController(initialPage: widget.index!),
              onPageChanged: (index) {
                if (mounted) {
                  setState(
                    () {
                      curPos = index;
                    },
                  );
                }
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
                      borderRadius:
                          BorderRadius.circular(circularBorderRadius5),
                      onTap: () => Navigator.of(context).pop(),
                      child: const Center(
                        child: Icon(
                          Icons.keyboard_arrow_left,
                          color: primary,
                          size: 25,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            widget.RattingModel != null
                ? Container(
                    color: Colors.black87,
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RatingBarIndicator(
                          rating: double.parse(model!.rating!),
                          itemBuilder: (context, index) => const Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          itemCount: 5,
                          itemSize: 12.0,
                          direction: Axis.horizontal,
                        ),
                        model!.comment != null && model!.comment!.isNotEmpty
                            ? SizedBox(
                                width: MediaQuery.of(context).size.width - 20,
                                child: InkWell(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 5.0),
                                    child: Text(
                                      model!.comment ?? '',
                                      style: const TextStyle(color: white),
                                      maxLines: flag ? 2 : null,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  onTap: () {
                                    setState(
                                      () {
                                        flag = !flag;
                                      },
                                    );
                                  },
                                ),
                              )
                            : Container(),
                        SizedBox(
                          width: MediaQuery.of(context).size.width - 20,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                model!.username ?? "",
                                style: const TextStyle(color: white),
                              ),
                              Text(
                                model!.date ?? "",
                                style: const TextStyle(
                                  color: white,
                                  fontSize: textFontSize10,
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                : const SizedBox()
          ],
        ),
      ),
    );
  }
}
