import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

Widget itemChartVelocity(
  List<FlSpot> listPoints,
  int level,
  int limitCount, {
  Brightness brightness = Brightness.light,
}) {
  var dBmMax = -35;
  var dBmMin = -90;
  var dBm = level;
  var percentage = 100 * (1 - (dBmMax - dBm) / (dBmMax - dBmMin));
  percentage = double.parse(percentage.toStringAsFixed(2));
  if (percentage > 100.0) percentage = 100.0;

  return LineChart(
    LineChartData(
      minY: -95,
      maxY: -30,
      minX: 0.0,
      maxX: limitCount + 0.0,
      lineTouchData: const LineTouchData(enabled: false),
      clipData: const FlClipData.all(),
      gridData: const FlGridData(
        show: true,
        drawVerticalLine: true,
      ),
      borderData: FlBorderData(show: false),
      lineBarsData: [
        itemLineVelocity(listPoints, Colors.green),
      ],
      titlesData: FlTitlesData(
        show: true,
        topTitles: const AxisTitles(),
        rightTitles: const AxisTitles(),
        bottomTitles: AxisTitles(
          axisNameWidget: Text("Intensidad de señal: $percentage %"),
        ),
        // leftTitles: const AxisTitles(),
        leftTitles: const AxisTitles(
          sideTitles: SideTitles(
            reservedSize: 44,
            interval: 15,
            showTitles: true,
            getTitlesWidget: rightTitleWidgetsVelocity,
          ),
        ),
      ),
    ),
  );
}

Widget rightTitleWidgetsVelocity(double value, TitleMeta meta) {
  String text = "${value.toInt()}";
  if (value.toInt() == -95) text = '';
  if (value.toInt() == -30) text = 'dBm';
  return Text(text, textAlign: TextAlign.left);
}

LineChartBarData itemLineVelocity(List<FlSpot> points, Color color) {
  return LineChartBarData(
    spots: points,
    dotData: const FlDotData(show: false),
    color: color,
    isCurved: true,
    belowBarData: BarAreaData(
      show: true,
      gradient: LinearGradient(
        colors: [color.withOpacity(0.15), color.withOpacity(0.15)],
      ),
    ),
    barWidth: 2,
  );
}
