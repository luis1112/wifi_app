import 'dart:math';

import 'package:wifi/docs.dart';

double calculateDistanceRouter(int rssi) {
  // Constantes para el modelo de pérdida de ruta (Path Loss Model)
  double n = 2; // Exponente de atenuación (generalmente entre 2 y 4)
  double A = -50; // Valor de referencia del RSSI a 1 metro de distancia

  // Fórmula para calcular la distancia
  double distancia = pow(10, ((A - rssi) / (10 * n))).toDouble();
  return double.parse(distancia.toStringAsFixed(2));
}

String? getChanelWidthWifi(List<AccessPoint> accessPoints, String bssid) {
  var v = accessPoints.where((e) => e.bssid == bssid).firstOrNull;
  var channelWidth = v?.channelWidth;
  if (channelWidth != null) return "$channelWidth MHz";
  return null;
}

int calculateChannel(int frequency) {
  if (frequency >= 2412 && frequency <= 2484) {
    return ((frequency - 2412) ~/ 5 + 3).toInt();
  } else if (frequency >= 5180 && frequency <= 5825) {
    return (((frequency - 5180) ~/ 5) + 36).toInt();
  }
  return 0;
}
