import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:wifi/docs.dart';

LineChartData itemChartChanel(
    List<ItemChartChanel> lineBarsData, TypeChanel? type) {
  return LineChartData(
    gridData: const FlGridData(
      show: true,
      drawVerticalLine: true,
      horizontalInterval: 1,
      verticalInterval: 1,
    ),
    titlesData: FlTitlesData(
      show: true,
      topTitles: const AxisTitles(
        sideTitles: SideTitles(showTitles: false),
      ),
      rightTitles: const AxisTitles(
        sideTitles: SideTitles(showTitles: false),
      ),
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 30,
          interval: type == TypeChanel.ghz5 ? 1 : 1,
          getTitlesWidget: (double value, TitleMeta meta) =>
              bottomTitleWidgetsChanel(value, meta, type),
        ),
        axisNameWidget: const Text("Canales"),
      ),
      leftTitles: const AxisTitles(
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
    maxX: type == TypeChanel.ghz5 ? 26 : 14,
    minY: 0,
    maxY: 7,
    lineTouchData: const LineTouchData(enabled: false),
    lineBarsData: lineBarsData.map((e) => e.line).toList(),
  );
}
