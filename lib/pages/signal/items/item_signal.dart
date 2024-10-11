import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wifi/docs.dart';

Widget itemChartSignal(
  List<ItemChartSignal> listSignal,
  int limitCount,
) {
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
      lineBarsData: List.generate(listSignal.length, (index) {
        var item = listSignal[index];
        return itemLineSignal(item.list, item.color);
      }),
      titlesData: const FlTitlesData(
        show: true,
        topTitles: AxisTitles(),
        rightTitles: AxisTitles(),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            reservedSize: 44,
            showTitles: true,
            interval: 5,
            getTitlesWidget: bottomTitleWidgetsSignal,
          ),
          axisNameWidget: Text("Tiempo(s)"),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            reservedSize: 44,
            interval: 10,
            showTitles: true,
            getTitlesWidget: rightTitleWidgetsSignal,
          ),
          // axisNameWidget: Text("dBm"),
        ),
      ),
    ),
  );
}

Widget rightTitleWidgetsSignal(double value, TitleMeta meta) {
  String text = "${value.toInt()}";
  if (value.toInt() == -95) text = '';
  if (value.toInt() == -30) text = 'dBm';
  return Text(text, textAlign: TextAlign.left);
}

Widget bottomTitleWidgetsSignal(double value, TitleMeta meta) {
  DateTime now = DateTime.now();
  var date = now.copyWith(second: now.second - value.toInt());
  var text = DateFormat('HH:mm:ss').format(date);
  return Text(
    text,
    textAlign: TextAlign.left,
    style: const TextStyle(
      fontSize: 10.0
    ),
  );
}

LineChartBarData itemLineSignal(List<FlSpot> points, Color color) {
  return LineChartBarData(
    spots: points,
    dotData: FlDotData(
      show: true,
      getDotPainter:
          (FlSpot spot, double xPercentage, LineChartBarData bar, int index) {
        return FlDotCirclePainter(
          radius: 2.0,
          strokeWidth: 0.5,
          color: _defaultGetDotColor(spot, xPercentage, bar),
          strokeColor: _defaultGetDotStrokeColor(spot, xPercentage, bar),
        );
      },
    ),
    color: color,
    // gradient: LinearGradient(
    //   colors: [color.withOpacity(0), color],
    //   stops: const [0.1, 1.0],
    // ),
    barWidth: 2,
    isCurved: false,
  );
}

Color _defaultGetDotColor(FlSpot _, xPercentage, bar) {
  return bar.gradient?.colors.first ?? bar.color ?? Colors.blueGrey;
}

Color _defaultGetDotStrokeColor(FlSpot _, xPercentage, bar) {
  Color color = bar.gradient?.colors.first ?? bar.color ?? Colors.blueGrey;
  return color;
}

Widget itemNetworksSignal(List<ItemChartSignal> listSignal) {
  return Column(
    children: List.generate(listSignal.length, (index) {
      var item = listSignal[index];
      return Container(
        margin: const EdgeInsets.only(bottom: 5.0),
        child: Row(
          children: [
            Container(
              height: 12.0,
              width: 12.0,
              decoration: BoxDecoration(
                color: item.color,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 10.0),
            Expanded(
              child: Text(
                "${item.item.ssid} (${item.item.level})",
                style: const TextStyle(fontSize: 15.0),
              ),
            ),
          ],
        ),
      );
    }),
  );
}
