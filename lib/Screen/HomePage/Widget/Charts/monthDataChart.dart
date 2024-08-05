import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../../Helper/Color.dart';
import '../../../../Provider/homeProvider.dart';

LineChartData monthData(HomeProvider val) {
  if (val.monthEarning!.isEmpty) {
    val.monthEarning!.add(0);
    val.months!.add(0);
  }
  List<FlSpot> spots = val.monthEarning!.asMap().entries.map(
    (e) {
      return FlSpot(
        double.parse(e.key.toString()),
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
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          getTitlesWidget: (value, child) {
            return Text(
              val.months![value.toInt()].toString(),
              style: const TextStyle(
                color: black,
                fontSize: 08,
              ),
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
