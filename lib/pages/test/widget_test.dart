import 'package:flutter/material.dart';
import 'package:wifi/docs.dart';

Widget itemTest(ModelTest? test) {
  if (test == null) return Container();
  return Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        SizedBox(height: 10.0),
        SizedBox(
          width: 250.0,
          child: Row(
            children: [
              Expanded(
                child: _itemData(
                  'DESCARGA',
                  test.rateDownload,
                  test.unitDownload,
                  test.durationInMillisDownload,
                ),
              ),
              SizedBox(width: 5.0),
              Expanded(
                child: _itemData(
                  'SUBIDA',
                  test.rateUpload,
                  test.unitUpload,
                  test.durationInMillisUpload,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 20.0),
      ],
    ),
  );
}

Widget _itemData(
    String title,
    double rate,
    String unit,
    int durationInMillis,
    ) {
  durationInMillis = durationInMillis;
  return Container(
    padding: const EdgeInsets.all(8.0),
    child: Column(
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 14.0,
          ),
        ),
        Text(
          _getTransferRate(rate, unit),
          style: const TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        if (durationInMillis > 0) ...{
          Text(
            'Tiempo: ${(durationInMillis / 1000).toStringAsFixed(0)} sec(s)',
            style: const TextStyle(
              fontSize: 10.0,
            ),
          ),
        },
      ],
    ),
  );
}

String _getTransferRate(double rate, String unit) {
  unit = unit[0].toUpperCase() + unit.substring(1);
  return "$rate $unit";
}
