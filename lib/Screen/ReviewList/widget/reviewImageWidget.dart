import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../Helper/Color.dart';
import '../../../Widget/desing.dart';
import '../../ReviewGallery/Review_Gallery.dart';
import '../../ReviewPreview/Review_Preview.dart';
import '../ReviewList.dart';

class ReviewImageWidget extends StatelessWidget {
  const ReviewImageWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return salesProvider!.revImgList.isNotEmpty
        ? SizedBox(
            height: 100,
            child: ListView.builder(
              itemCount: salesProvider!.revImgList.length > 5
                  ? 5
                  : salesProvider!.revImgList.length,
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              physics: const AlwaysScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
                  child: InkWell(
                    onTap: () async {
                      if (index == 4) {
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (context) => ReviewGallary(
                              imageList: salesProvider!.revImgList,
                            ),
                          ),
                        );
                      } else {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder: (_, __, ___) => ReviewPreview(
                              index: index,
                              imageList: salesProvider!.revImgList,
                              RattingModel: salesProvider!.reviewList[index],
                            ),
                          ),
                        );
                      }
                    },
                    child: Stack(
                      children: [
                        DesignConfiguration.getCacheNotworkImage(
                          boxFit: BoxFit.cover,
                          context: context,
                          heightvalue: 100,
                          placeHolderSize: 80,
                          imageurlString: salesProvider!.revImgList[index].img!,
                          widthvalue: 80,
                        ),
                        index == 4
                            ? Container(
                                height: 100.0,
                                width: 80.0,
                                color: black,
                                child: Center(
                                  child: Text(
                                    '+${salesProvider!.revImgList.length - 5}',
                                    style: const TextStyle(
                                      color: white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              )
                            : Container()
                      ],
                    ),
                  ),
                );
              },
            ),
          )
        : Container();
  }
}
