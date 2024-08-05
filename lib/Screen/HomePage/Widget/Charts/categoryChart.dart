import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../../../../Helper/Color.dart';
import '../../../../Helper/Constant.dart';
import 'Indicator.dart';
import '../../../../Provider/homeProvider.dart';
import '../../../../Widget/validation.dart';
import '../../home.dart';

catChart(
  HomeProvider val,
  BuildContext context,
  Function setState,
) {
  //Size size = MediaQuery.of(context).size;
  //double width = size.width > size.height ? size.height : size.width;
  // double ratio;
  // if (width > 600) {
  //   ratio = 0.5;
  //   // Do something for tablets here
  // } else {
  //   ratio = 0.8;
  //   // Do something for phones
  // }
  return AspectRatio(
    aspectRatio: 1.23,
    child: Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 15,
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(circularBorderRadius15),
          color: Colors.white,
          boxShadow: const [
            BoxShadow(
              color: blarColor,
              offset: Offset(0, 0),
              blurRadius: 4,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                getTranslated(context, "CatWiseCount")!,
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(color: primary),
              ),
            ),
            Expanded(
              child: Row(
                children: <Widget>[
                  const SizedBox(
                    height: 18,
                  ),
                  Expanded(
                    flex: 2,
                    child: AspectRatio(
                      aspectRatio: .8,
                      child: Stack(
                        children: [
                          PieChart(
                            PieChartData(
                              pieTouchData: PieTouchData(
                                touchCallback: (fl, pieTouchResponse) async {
                                  Future.delayed(Duration.zero).then(
                                    (_) async {
                                      final desiredTouch =
                                          pieTouchResponse!.touchedSection
                                                  is! PointerExitEvent &&
                                              pieTouchResponse.touchedSection
                                                  is! PointerUpEvent;
                                      if (desiredTouch &&
                                          pieTouchResponse.touchedSection !=
                                              null) {
                                        touchedIndex = pieTouchResponse
                                            .touchedSection!
                                            .touchedSectionIndex;
                                      } else {
                                        touchedIndex = -1;
                                      }
                                      setState();
                                    },
                                  );
                                },
                              ),
                              borderData: FlBorderData(
                                show: false,
                              ),
                              sectionsSpace: 0,
                              startDegreeOffset: 180,
                              centerSpaceRadius: 40,
                              sections: showingSections(val),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      shrinkWrap: true,
                      itemCount: colorList.length,
                      itemBuilder: (context, i) {
                        return Indicators(
                          color: colorList[i],
                          text: val.catList![i] + " " + val.catCountList![i],
                          textColor:
                              touchedIndex == i ? Colors.black : Colors.grey,
                          isSquare: true,
                        );
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 28,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

List<PieChartSectionData> showingSections(HomeProvider val) {
  return List.generate(
    val.catCountList!.length,
    (i) {
      final isTouched = i == touchedIndex;

      final double fontSize = isTouched ? textFontSize25 : textFontSize16;
      final double radius = isTouched ? 60 : 50;

      return PieChartSectionData(
        color: colorList[i],
        value: double.parse(
          val.catCountList![i].toString(),
        ),
        title: "",
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          color: white,
        ),
      );
    },
  );
}
