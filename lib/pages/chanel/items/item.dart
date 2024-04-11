import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:wifi/docs.dart';

LineChartData itemChartChanel(List<ItemChartChanel> lineBarsData) {
  bool isGhz2 = lineBarsData.where((e) => e.item.channelWidth <= 40).isNotEmpty;
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
          interval: 1,
          getTitlesWidget: (value, meta) {
            return bottomTitleWidgetsChanel(value, meta, isGhz2);
          },
        ),
        axisNameWidget: const Text("Ancho de banda"),
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
    // maxX: 11,
    maxX: isGhz2 ? 6 : 8,
    minY: 0,
    maxY: 7,
    lineTouchData: const LineTouchData(enabled: false),
    lineBarsData: lineBarsData.map((e) => e.line).toList(),
  );
}
