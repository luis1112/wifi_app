import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:wifi/docs.dart';

class ItemChartSignal {
  AccessPoint item;
  List<FlSpot> listAux;
  List<FlSpot> list;
  Color color;

  ItemChartSignal(this.item, this.list, this.listAux, this.color);
}
