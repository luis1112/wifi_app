import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:wifi/docs.dart';

LineChartBarData? listChartChanel(
    Color color, int chanel, int level, int channelWidth, TypeChanel? type) {
  var f = 100 - (level * -1);
  var y = (5.3 * f) / 60;

  if (type == TypeChanel.ghz5) {
    var chanelAux = channels5G[chanel];
    if (chanelAux == null) return null;
    Map<int, List<double>> overlappingChannels5G20MHz = {
      36: [36, 36],
      40: [40, 40],
      44: [44, 44],
      48: [48, 48],
      52: [52, 52],
      56: [56, 56],
      60: [60, 60],
      64: [64, 64],
      100: [100, 100],
      104: [104, 104],
      108: [108, 108],
      112: [112, 112],
      116: [116, 116],
      120: [120, 120],
      124: [124, 124],
      128: [128, 128],
      132: [132, 132],
      136: [136, 136],
      140: [140, 140],
      144: [144, 144],
      149: [149, 149],
      153: [153, 153],
      157: [157, 157],
      161: [161, 161],
      165: [165, 165],
    };
    Map<int, List<double>> overlappingChannels5G40MHz = {
      36: [36, 40],
      40: [36, 44],
      44: [40, 48],
      48: [44, 48],
      52: [52, 56],
      56: [52, 60],
      60: [56, 64],
      64: [60, 64],
      100: [100, 104],
      104: [100, 108],
      108: [104, 112],
      112: [108, 112],
      116: [116, 120],
      120: [116, 124],
      124: [120, 128],
      128: [124, 128],
      132: [132, 136],
      136: [132, 140],
      140: [136, 144],
      144: [140, 144],
      149: [149, 153],
      153: [149, 157],
      157: [153, 161],
      161: [157, 161],
      165: [165, 165],
    };
    Map<int, List<double>> overlappingChannels5G80MHz = {
      36: [36, 48],
      40: [36, 48],
      44: [36, 48],
      48: [36, 48],
      52: [52, 64],
      56: [52, 64],
      60: [52, 64],
      64: [52, 64],
      100: [100, 112],
      104: [100, 112],
      108: [100, 112],
      112: [100, 112],
      116: [116, 128],
      120: [116, 128],
      124: [116, 128],
      128: [116, 128],
      132: [132, 144],
      136: [132, 144],
      140: [132, 144],
      144: [132, 144],
      149: [149, 161],
      153: [149, 161],
      157: [149, 161],
      161: [149, 161],
      165: [165, 165],
    };
    Map<int, List<double>> overlappingChannels5G160MHz = {
      36: [36, 64],
      40: [36, 64],
      44: [36, 64],
      48: [36, 64],
      52: [36, 64],
      56: [36, 64],
      60: [36, 64],
      64: [36, 64],

      100: [100, 128],
      104: [100, 128],
      108: [100, 128],
      112: [100, 128],
      116: [100, 128],
      120: [100, 128],
      124: [100, 128],
      128: [100, 128],

      132: [132, 144],
      // En algunos países 160 MHz puede no usar esta parte.
      136: [132, 144],
      140: [132, 144],
      144: [132, 144],

      149: [149, 165],
      // Este es más raro en 160 MHz, pero se puede usar en algunos lugares.
      153: [149, 165],
      157: [149, 165],
      161: [149, 165],
      165: [149, 165],
    };

    var minChanel = overlappingChannels5G20MHz[chanel]?[0];
    var maxChanel = overlappingChannels5G20MHz[chanel]?[1];
    if (channelWidth == 40) {
      minChanel = overlappingChannels5G40MHz[chanel]?[0];
      maxChanel = overlappingChannels5G40MHz[chanel]?[1];
    } else if (channelWidth == 80) {
      minChanel = overlappingChannels5G80MHz[chanel]?[0];
      maxChanel = overlappingChannels5G80MHz[chanel]?[1];
    } else if (channelWidth >= 160) {
      minChanel = overlappingChannels5G160MHz[chanel]?[0];
      maxChanel = overlappingChannels5G160MHz[chanel]?[1];
    }
    if (minChanel == null || maxChanel == null) return null;
    minChanel = channels5G[minChanel];
    maxChanel = channels5G[maxChanel];
    if (minChanel == null || maxChanel == null) return null;
    var inter = (maxChanel - minChanel) / 4;

    var x1 = minChanel;
    var x2 = minChanel + inter;
    var x3 = maxChanel - inter;
    var x4 = maxChanel;

    // printC("x1 = $x1\nx4 =$x4");

    // var x1 = chanelAux - 1.0;
    // var x2 = chanelAux - 0.5;
    // var x3 = chanelAux + 0.5;
    // var x4 = chanelAux + 1.0;
    return itemBarDataChanel([
      FlSpot(x1, 0),
      FlSpot(x2, y),
      FlSpot(x3, y),
      FlSpot(x4, 0),
    ], color);
  }

  var channels2G = List.generate(14, (i) => i + 1);
  if (channels2G.contains(chanel)) {
    //canales solapadas de acuerdo a canal y ancho de banda
    Map<int, List<double>> overlappingChannels = {
      1: [2, 5],
      2: [1, 6],
      3: [1, 7],
      4: [1, 8],
      5: [1, 9],
      6: [2, 10],
      7: [3, 11],
      8: [4, 12],
      9: [5, 13],
      10: [6, 14],
      11: [7, 14],
      12: [8, 14],
      13: [9, 14],
      14: [10, 13]
    };
    var minChanel = overlappingChannels[chanel]?[0];
    var maxChanel = overlappingChannels[chanel]?[1];
    if (minChanel == null || maxChanel == null) return null;
    var inter = (maxChanel - minChanel) / 4;

    var x1 = minChanel;
    var x2 = minChanel + inter;
    var x3 = maxChanel - inter;
    var x4 = maxChanel;

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
  // final random = Random((seed * -1) + (index * 10));
  final random = Random();

  // Lista de colores únicos y bien diferenciados
  const List<Color> uniqueColors = [
    Color(0xFFFF0000), // Rojo
    Color(0xFFFFA500), // Naranja
    Color(0xFFFFFF00), // Amarillo
    Color(0xFF00FF00), // Verde
    Color(0xFF00FFFF), // Cian
    Color(0xFF0000FF), // Azul
    Color(0xFF800080), // Púrpura
    Color(0xFFFF00FF), // Magenta
    Color(0xFF964B00), // Marrón
    Color(0xFF808080), // Gris
    Color(0xFFFFFFFF), // Blanco
  ];

  // Filtrar los colores no utilizados
  final availableColors =
      uniqueColors.where((c) => !colors.contains(c)).toList();
  Color color;

  if (availableColors.isNotEmpty) {
    // Si hay colores únicos disponibles, elige uno al azar
    color = availableColors[random.nextInt(availableColors.length)];
  } else {
    // Si se agotan, generar un color completamente diferente
    color = _generateCompletelyDifferentColor(colors, random);
  }

  return color;
}

Color _generateCompletelyDifferentColor(List<Color> colors, Random random) {
  Color color;
  const saturation = 0.9;
  const lightness = 0.5;
  const minDifference = 150; // Diferencia mínima para asegurar que sea único
  int attempts = 0;
  const maxAttempts = 100;

  do {
    final hue = random.nextInt(360);
    color =
        HSLColor.fromAHSL(1.0, hue.toDouble(), saturation, lightness).toColor();
    attempts++;

    // Si se alcanzan muchos intentos sin éxito, fuerza un cambio drástico
    if (attempts >= maxAttempts) {
      final forcedHue = (hue + 180 + random.nextInt(90)) % 360;
      color =
          HSLColor.fromAHSL(1.0, forcedHue.toDouble(), saturation, lightness)
              .toColor();
      break;
    }
  } while (colors.any((c) => _isColorSimilar(c, color, minDifference)));

  return color;
}

bool _isColorSimilar(Color c1, Color c2, int threshold) {
  final rDiff = c1.red - c2.red;
  final gDiff = c1.green - c2.green;
  final bDiff = c1.blue - c2.blue;
  final distance = sqrt(rDiff * rDiff + gDiff * gDiff + bDiff * bDiff);
  return distance < threshold;
}

LineChartBarData itemBarDataChanel(List<FlSpot> list, Color color) {
  List<Color> colors = [color, color];
  return LineChartBarData(
    spots: list,
    isCurved: true,
    gradient: LinearGradient(colors: colors),
    barWidth: 1.8,
    isStrokeCapRound: true,
    dotData: const FlDotData(show: false),
    belowBarData: BarAreaData(
      show: true,
      gradient: LinearGradient(
        colors: colors.map((color) => color.withOpacity(0.05)).toList(),
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

Map<int, double> channels5G = {
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
