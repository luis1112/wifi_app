import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:wifi/docs.dart';

LineChartBarData? listChartChanel(
    Color color, int chanel, int level, TypeChanel? type) {
  var f = 100 - (level * -1);
  var y = (5.3 * f) / 60;

  if (type == TypeChanel.ghz5) {
    var chanelAux = channels5G[chanel];
    if (chanelAux == null) return null;
    var x1 = chanelAux - 2.0;
    var x2 = chanelAux - 1.0;
    var x3 = chanelAux + 1.0;
    var x4 = chanelAux + 2.0;
    return itemBarDataChanel([
      FlSpot(x1, 0),
      FlSpot(x2, y),
      FlSpot(x3, y),
      FlSpot(x4, 0),
    ], color);
  }

  var channels2G = List.generate(14, (i) => i + 1);
  if (channels2G.contains(chanel)) {
    var x1 = chanel - 2.0;
    var x2 = chanel - 1.0;
    var x3 = chanel + 1.0;
    var x4 = chanel + 2.0;
    return itemBarDataChanel([
      FlSpot(x1, 0),
      FlSpot(x2, y),
      FlSpot(x3, y),
      FlSpot(x4, 0),
    ], color);
  }
  return null;
}

Color generateUniqueRandomColor(List<Color> colors, int index, int seed) {
  final random = Random((seed * -1) + (index * 10));
  final r = random.nextInt(256);
  final g = random.nextInt(256);
  final b = random.nextInt(256);
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

Widget bottomTitleWidgetsChanel(
    double value, TitleMeta meta, TypeChanel? type) {
  if (type != TypeChanel.ghz5) return Text("${value.toInt()}");
  String text = chanel5GInverted[value.toInt()]?.toString() ?? "";
  return Text(text, textAlign: TextAlign.left);
}

Map<int, int> channels5G = {
  36: 2,
  40: 3,
  44: 4,
  48: 5,
  //
  52: 6,
  56: 7,
  60: 8,
  64: 9,
  //
  100: 10,
  104: 11,
  108: 12,
  112: 13,
  116: 14,
  120: 15,
  124: 16,
  128: 17,
  132: 18,
  136: 19,
  140: 20,
  144: 21,
  //
  149: 22,
  153: 23,
  157: 24,
  161: 25,
  165: 26,
};

Map<int, int> get chanel5GInverted => {
      2: 36,
      // 3: 40,
      4: 44,
      // 5: 48,
      //
      6: 52,
      // 7: 56,
      8: 60,
      // 9: 64,
      //
      10: 100,
      // 11: 104,
      // 12: 108,
      // 13: 112,
      14: 116,
      // 15: 120,
      // 16: 124,
      // 17: 128,
      18: 132,
      // 19: 136,
      // 20: 140,
      // 21: 144,
      //
      22: 149,
      // 23: 153,
      // 24: 157,
      // 25: 161,
      26: 165,
    };
