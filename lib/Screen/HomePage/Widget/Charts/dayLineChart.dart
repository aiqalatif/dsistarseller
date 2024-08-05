import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../../Helper/Color.dart';
import '../../../../Helper/Constant.dart';
import '../../../../Provider/homeProvider.dart';

LineChartData dayData(HomeProvider value) {
  if (value.dayEarning!.isEmpty) {
    value.dayEarning!.add(0);
    value.days!.add(0);
  }
  List<FlSpot> spots = value.dayEarning!.asMap().entries.map(
    (e) {
      return FlSpot(
        double.parse(
          value.days![e.key].toString(),
        ),
        double.parse(
          e.value.toString(),
        ),
      );
    },
  ).toList();

  return LineChartData(
    lineTouchData: const LineTouchData(enabled: true),
    lineBarsData: [
      LineChartBarData(
        spots: spots,
        isCurved: false,
        barWidth: 4,
        color: grad2Color,
        belowBarData: BarAreaData(
          show: true,
          color: primary.withOpacity(0.5),
        ),
        aboveBarData: BarAreaData(
          show: true,
          color: fontColor.withOpacity(0.2),
        ),
        dotData: const FlDotData(
          show: false,
        ),
      ),
    ],
    minY: 0,
    titlesData: FlTitlesData(
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          getTitlesWidget: (value, child) {
            return Text(
              value.toInt().toString(),
              style: const TextStyle(
                color: black,
                fontSize: textFontSize12,
              ),
            );
          },
        ),
      ),
      rightTitles: const AxisTitles(),
      topTitles: const AxisTitles(),
      leftTitles: AxisTitles(
        sideTitles: SideTitles(
          reservedSize: 40,
          showTitles: true,
          getTitlesWidget: (value, child) {
            return Text(
              value.toInt().toString(),
              style: const TextStyle(
                color: black,
                fontSize: 08,
              ),
              maxLines: 1,
            );
          },
        ),
      ),
    ),
    gridData: FlGridData(
      show: true,
      getDrawingHorizontalLine: (value) {
        return FlLine(
          color: fontColor.withOpacity(0.3),
          strokeWidth: 1,
        );
      },
    ),
  );
}
