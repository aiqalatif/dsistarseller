import 'package:intl/intl.dart';

class ProductRatting {
  String? id, userid, productid, rating, comment, username, date, userProfile;
  List<String>? Images;
  ProductRatting({
    this.id,
    this.userid,
    this.productid,
    this.rating,
    this.comment,
    this.username,
    this.date,
    this.Images,
    this.userProfile,
  });

  factory ProductRatting.fromJson(Map<String, dynamic> json) {
    List<String> images = List<String>.from(
      json["images"],
    );
    return ProductRatting(
        id: json['id'],
        userid: json['user_id'],
        productid: json['product_id'],
        rating: json['rating'],
        comment: json['comment'],
        username: json['user_name'],
        Images: images,
        userProfile: json["user_profile"],
        date: json['date'] != null
            ? DateFormat('dd-MM-yyyy').format(
                DateTime.parse(
                  json['data_added'],
                ),
              )
            : '');
  }
}

class imgModel {
  int? index;
  String? img;

  imgModel({this.index, this.img});

  factory imgModel.fromJson(int i, String image) {
    return imgModel(index: i, img: image);
  }
}

class ReviewImg {
  String? totalImg;
  List<ProductRatting>? productRating;

  ReviewImg({this.totalImg, this.productRating});

  factory ReviewImg.fromJson(Map<String, dynamic> json) {
    var reviewImg = (json["product_rating"] as List?);
    List<ProductRatting> reviewList = [];
    if (reviewImg == null || reviewImg.isEmpty) {
      reviewList = [];
    } else {
      reviewList =
          reviewImg.map((data) => ProductRatting.fromJson(data)).toList();
    }

    return ReviewImg(
      totalImg: json["total_images"],
      productRating: reviewList,
    );
  }
}
