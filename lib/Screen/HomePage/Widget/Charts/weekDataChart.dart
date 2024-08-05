import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../../Helper/Color.dart';
import '../../../../Provider/homeProvider.dart';

LineChartData weekData(HomeProvider val) {
  if (val.weekEarning!.isEmpty) {
    val.weekEarning!.add(0);
    val.weeks!.add(0);
  }
  List<FlSpot> spots = val.weekEarning!.asMap().entries.map(
    (e) {
      return FlSpot(
        double.parse(
          e.key.toString(),
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
        barWidth: 2,
        color: primary,
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
            print(
                "week value: ${val.weeks!}******${val.weeks![value.toInt()].toString()}" +
                    value.toString());
            return Text(
              val.weeks![value.toInt()].toString(),
              style: const TextStyle(
                color: black,
                fontSize: 08,
              ),
            );
          },
        ),
      ),
      rightTitles: const AxisTitles(),
      topTitles: const AxisTitles(),
      leftTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 40,
          getTitlesWidget: (value, child) {
            if (value.toInt() == child.max) {
              return const SizedBox.shrink();
            } else {
              return Text(
                value.toInt().toString(),
                style: const TextStyle(
                  color: black,
                  fontSize: 08,
                ),
              );
            }
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

/* LineChartData weekData(HomeProvider val) {
  if (val.weekEarning!.isEmpty) {
    val.weekEarning!.add(0);
    val.weeks!.add(0);
  }
  List<FlSpot> spots = val.weekEarning!.asMap().entries.map(
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
    lineTouchData: LineTouchData(enabled: true),
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
        dotData: FlDotData(
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
            return Expanded(
              child: Text(
                val.weeks![value.toInt()].toString(),
                overflow: TextOverflow.ellipsis,
                maxLines: 3,
                style: const TextStyle(
                  color: black,
                  fontSize: textFontSize12,
                ),
              ),
            );
          },
        ),
      ),
      rightTitles: AxisTitles(),
      topTitles: AxisTitles(),
      leftTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          getTitlesWidget: (value, child) {
            return Text(
              value.toInt().toString(),
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
 */