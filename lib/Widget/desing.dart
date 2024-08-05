import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sellermultivendor/Widget/validation.dart';
import '../Helper/Color.dart';
import 'parameterString.dart';

class DesignConfiguration {
  static setSvgPath(String name) {
    return 'assets/images/SVG/$name.svg';
  }

  static setPngPath(String name) {
    return 'assets/images/PNG/$name.png';
  }

  static setLottiePath(String name) {
    return 'assets/animation/$name.json';
  }

  static placeHolder(double height) {
    return AssetImage(
      setPngPath('placeholder'),
    );
  }

  static String? getPriceFormat(
    BuildContext context,
    double price,
  ) {
    return NumberFormat.currency(
      locale: Platform.localeName,
      name: supportedLocale,
      symbol: CUR_CURRENCY,
      decimalDigits: int.parse(Decimal_Digits),
    ).format(price).toString();
  }

  static erroWidget(double size) {
    return Image.asset(
      setPngPath('placeholder'),
      height: size,
      width: size,
    );
  }

  //for no iteam
  static Widget getNoItem(BuildContext context) {
    return Center(
      child: Text(
        getTranslated(context, "noItem")!,
      ),
    );
  }

// progress
  static Widget showCircularProgress(
    bool isProgress,
    Color color,
  ) {
    if (isProgress) {
      return Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(color),
        ),
      );
    }
    return const SizedBox(
      height: 0.0,
      width: 0.0,
    );
  }

// Container Decoration
  static back() {
    return const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [grad1Color, grad2Color],
        stops: [0, 1],
      ),
    );
  }

  static getCacheNotworkImage({
    required String imageurlString,
    required BuildContext context,
    required BoxFit? boxFit,
    required double? heightvalue,
    required double? widthvalue,
    required double? placeHolderSize,
  }) {
    return FadeInImage.assetNetwork(
      image: imageurlString,
      placeholder: DesignConfiguration.setPngPath('placeholder'),
      width: widthvalue,
      height: heightvalue,
      fit: boxFit,
      fadeInDuration: const Duration(
        milliseconds: 150,
      ),
      fadeOutDuration: const Duration(
        milliseconds: 150,
      ),
/*      imageCacheHeight: 50,
      imageCacheWidth: 50,*/
      fadeInCurve: Curves.linear,
      fadeOutCurve: Curves.linear,
      imageErrorBuilder: (context, error, stackTrace) {
        return Container(
          child: DesignConfiguration.erroWidget(placeHolderSize ?? 50),
        );
      },
    );

    /* CachedNetworkImage(
      imageUrl: imageurlString,
      placeholder: (context, url) {
        return DesignConfiguration.erroWidget(placeHolderSize ?? 50);
      },
      errorWidget: (context, error, stackTrace) {
        return Container(
          child: DesignConfiguration.erroWidget(placeHolderSize ?? 50),
        );
      },
      fadeInCurve: Curves.linear,
      fadeOutCurve: Curves.linear,
      fadeInDuration: const Duration(
        milliseconds: 150,
      ),
      fadeOutDuration: const Duration(
        milliseconds: 150,
      ),
      fit: boxFit,
      height: heightvalue,
      width: widthvalue,
    );*/
  }

// Container Decoration
  static shadow() {
    return const BoxDecoration(
      boxShadow: [
        BoxShadow(
          color: white,
        )
      ],
    );
  }
}
