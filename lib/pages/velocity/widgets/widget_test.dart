import 'package:flutter/material.dart';
import 'package:flutter_internet_speed_test/flutter_internet_speed_test.dart';
import 'package:wifi/docs.dart';

class TestPageCustom extends StatefulWidget {
  const TestPageCustom({super.key});

  @override
  State<TestPageCustom> createState() => _TestPageCustomState();
}

class _TestPageCustomState extends State<TestPageCustom> {
  ProviderTest pvT = ProviderTest.of();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      pvT.reset();
    });
  }

  @override
  void dispose() {
    pvT.speedTest.cancelTest();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    pvT = ProviderTest.of(context, true);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            "Test de velocidad".toUpperCase(),
            style: const TextStyle(fontSize: 18.0),
          ),
          const SizedBox(height: 10.0),
          //download
          Card(
            elevation: 5.0,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 15.0,
                horizontal: 20.0,
              ),
              child: Column(
                children: [
                  if (!pvT.testInProgress) ...{
                    itemCircleStart(),
                  } else if (pvT.testUpload != null) ...{
                    itemCircle(pvT.testUpload, Colors.blue),
                  } else ...{
                    itemCircle(pvT.testDownload, Colors.green),
                  },
                ],
              ),
            ),
          ),
          const SizedBox(height: 10.0),
          SizedBox(
            width: 250.0,
            child: Row(
              children: [
                Expanded(
                  child: itemData(
                      'DESCARGA', pvT.downloadProgress, pvT.testDownload),
                ),
                const SizedBox(width: 5.0),
                Expanded(
                  child: itemData('SUBIDA', pvT.uploadProgress, pvT.testUpload),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20.0),
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Text(
              pvT.isServerSelectionInProgress
                  ? 'Seleccionando servidor...'
                  : 'IP: ${pvT.ip ?? '--'} | ASP: ${pvT.asn ?? '--'}'
                      ' ${pvT.isp != null ? '| ISP:${pvT.isp}' : ''}',
              style: const TextStyle(
                fontSize: 12.0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget itemCircle(TestResult? data, Color color) {
    return SizedBox(
      width: 150.0,
      height: 150.0,
      child: CircularPercentage(
        progress: data?.transferRate ?? 0.0,
        progressColor: color,
        text: getTransferRate(data),
      ),
    );
  }

  Widget itemCircleStart() {
    return GestureDetector(
      onTap: () {
        pvT.startScanning();
      },
      child: Container(
        width: 150.0,
        height: 150.0,
        color: Colors.transparent,
        child: const Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 150.0,
              height: 150.0,
              child: CircularProgressIndicator(
                backgroundColor: Colors.green,
                value: 0.0,
              ),
            ),
            Text(
              "Empezar",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 10.0,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget itemData(String title, double progress, TestResult? data) {
    var durationInMillis = data?.durationInMillis ?? 0.0;
    return Card(
      elevation: 5.0,
      child: Container(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.w400,
              ),
            ),
            Text(
              getTransferRate(data),
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
      ),
    );
  }

  String getTransferRate(TestResult? data) {
    if (data == null) return "----";
    var unit = data.unit.name;
    unit = unit[0].toUpperCase() + unit.substring(1);
    return "${data.transferRate} $unit";
  }
}
