import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:wifi/docs.dart';

LineChartData itemChartChanel(List<ItemChartChanel> lineBarsData) {
  return LineChartData(
    gridData: const FlGridData(
      show: true,
      drawVerticalLine: true,
      horizontalInterval: 1,
      verticalInterval: 1,
    ),
    titlesData: const FlTitlesData(
      show: true,
      topTitles: AxisTitles(
        sideTitles: SideTitles(showTitles: false),
      ),
      rightTitles: AxisTitles(
        sideTitles: SideTitles(showTitles: false),
      ),
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 30,
          interval: 1,
          getTitlesWidget: bottomTitleWidgetsChanel,
        ),
        axisNameWidget: Text("Ancho de banda"),
      ),
      leftTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 30,
          interval: 1,
          getTitlesWidget: rightTitleWidgetsChanel,
        ),
      ),
    ),
    borderData: FlBorderData(
      show: false,
      border: Border.all(color: const Color(0xff37434d)),
    ),
    minX: 0,
    // maxX: 11,
    maxX: 6,
    minY: 0,
    maxY: 7,
    lineTouchData: const LineTouchData(enabled: false),
    lineBarsData: lineBarsData.map((e) => e.line).toList(),
  );
}
