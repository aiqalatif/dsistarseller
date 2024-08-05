import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../../../Helper/Color.dart';
import '../../../Helper/Constant.dart';
import '../ReviewList.dart';

getRatingBarIndicator(var ratingStar, var totalStars) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 5.0),
    child: RatingBarIndicator(
      textDirection: TextDirection.rtl,
      rating: ratingStar,
      itemBuilder: (context, index) => const Icon(
        Icons.star_rate_rounded,
        color: Colors.amber,
      ),
      itemCount: totalStars,
      itemSize: 20.0,
      direction: Axis.horizontal,
      unratedColor: Colors.transparent,
    ),
  );
}

getRatingIndicator(var totalStar, BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(5.0),
    child: Stack(
      children: [
        Container(
          height: 10,
          width: MediaQuery.of(context).size.width / 3,
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(circularBorderRadius3),
            border: Border.all(
              width: 0.5,
              color: primary,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(circularBorderRadius50),
            color: primary,
          ),
          width: (totalStar / salesProvider!.reviewList.length) *
              MediaQuery.of(context).size.width /
              3,
          height: 10,
        ),
      ],
    ),
  );
}

getTotalStarRating(var totalStar) {
  return SizedBox(
    width: 20,
    height: 20,
    child: Text(
      totalStar,
      style: const TextStyle(
        fontSize: textFontSize10,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}
