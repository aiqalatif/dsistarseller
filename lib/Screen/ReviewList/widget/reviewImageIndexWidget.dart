import 'package:flutter/material.dart';
import '../../../Helper/Constant.dart';
import '../../../Widget/desing.dart';
import '../../ProductPreview/Product_Preview.dart';
import '../ReviewList.dart';

class ReviwImageWidgetIndex extends StatelessWidget {
  final int i;
  const ReviwImageWidgetIndex({
    Key? key,
    required this.i,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: salesProvider!.reviewList[i].Images!.isNotEmpty ? 100 : 0,
      child: ListView.builder(
        itemCount: salesProvider!.reviewList[i].Images!.length,
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return Padding(
            padding:
                const EdgeInsetsDirectional.only(end: 10, bottom: 5.0, top: 5),
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (_, __, ___) => ProductPreview(
                      pos: index,
                      secPos: 0,
                      index: 0,
                      id: "$index${salesProvider!.reviewList[i].id}",
                      imgList: salesProvider!.reviewList[i].Images,
                      list: true,
                      from: false,
                      screenSize: MediaQuery.of(context).size,
                    ),
                  ),
                );
              },
              child: Hero(
                tag: '$index${salesProvider!.reviewList[i].id}',
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(circularBorderRadius5),
                  child: DesignConfiguration.getCacheNotworkImage(
                    boxFit: BoxFit.cover,
                    context: context,
                    heightvalue: 100,
                    placeHolderSize: 50,
                    imageurlString: salesProvider!.reviewList[i].Images![index],
                    widthvalue: 100,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
