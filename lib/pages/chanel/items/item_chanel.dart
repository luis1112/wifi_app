import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:wifi/docs.dart';

LineChartBarData? listChartChanel(Color color, int chanel, int level) {
  var f = 100 - (level * -1);
  var x = (5.3 * f) / 60;
  var lis20 = itemBarDataChanel([
    const FlSpot(1, 0),
    FlSpot(1.5, x),
    FlSpot(2.5, x),
    const FlSpot(3, 0),
  ], color);
  if (chanel == 20) return lis20;
  var lis40 = itemBarDataChanel([
    const FlSpot(1, 0),
    FlSpot(2, x),
    FlSpot(4, x),
    const FlSpot(5, 0),
  ], color);
  if (chanel == 40) return lis40;
  var lis80 = itemBarDataChanel([
    const FlSpot(3, 0),
    FlSpot(4, x),
    FlSpot(6, x),
    const FlSpot(7, 0),
  ], color);
  if (chanel == 80) return lis80;
  var lis160 = itemBarDataChanel([
    const FlSpot(7, 0),
    FlSpot(8, x),
    FlSpot(10, x),
    const FlSpot(11, 0),
  ], color);
  if (chanel == 80) return lis160;
  return null;
}

Color generateUniqueRandomColor(List<Color> colors, int index, int seed) {
  final random = Random((seed * -1) + (index * 10));
  final r = random.nextInt(256); // Rojo
  final g = random.nextInt(256); // Verde
  final b = random.nextInt(256); // Azul
  var color = Color.fromARGB(255, r, g, b);
  if (colors.contains(color)) {
    color = color.withRed(index * 10);
  }
  return color;
}

LineChartBarData itemBarDataChanel(List<FlSpot> list, Color color) {
  List<Color> colors = [color, color];
  return LineChartBarData(
    spots: list,
    isCurved: true,
    gradient: LinearGradient(colors: colors),
    barWidth: 1,
    isStrokeCapRound: true,
    dotData: const FlDotData(show: false),
    belowBarData: BarAreaData(
      show: true,
      gradient: LinearGradient(
        colors: colors.map((color) => color.withOpacity(0.15)).toList(),
      ),
    ),
  );
}

Widget itemNetworksChanel(List<ItemChartChanel> lineBarsData) {
  return Column(
    children: List.generate(lineBarsData.length, (index) {
      var item = lineBarsData[index];
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

Widget bottomTitleWidgetsChanel(double value, TitleMeta meta, bool isGhz2) {
  String text = "";
  if (value.toInt() == 2) text = '20';
  if (value.toInt() == 3) text = '40';
  if (value.toInt() == 4) text = '60';
  if (value.toInt() == 5) text = '80';
  if (value.toInt() == 6) text = isGhz2 ? '' : '90';
  if (value.toInt() == 7) text = '120';
  // if (value.toInt() == 8) text = '140';
  if (value.toInt() == 8) text = '';
  if (value.toInt() == 9) text = '160';
  return Text(text, textAlign: TextAlign.left);
}

Widget rightTitleWidgetsChanel(double value, TitleMeta meta) {
  String text = "";
  if (value.toInt() == 1) text = '-90';
  if (value.toInt() == 2) text = '-80';
  if (value.toInt() == 3) text = '-70';
  if (value.toInt() == 4) text = '-60';
  if (value.toInt() == 5) text = '-50';
  if (value.toInt() == 6) text = '-40';
  if (value.toInt() == 7) text = 'dBm';
  return Text(text, textAlign: TextAlign.left);
}
