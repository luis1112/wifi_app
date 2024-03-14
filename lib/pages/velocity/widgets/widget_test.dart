import 'package:flutter/material.dart';
import 'package:flutter_internet_speed_test/flutter_internet_speed_test.dart';
import 'package:wifi/docs.dart';

class TestPageCustom extends StatefulWidget {
  const TestPageCustom({super.key});

  @override
  State<TestPageCustom> createState() => _TestPageCustomState();
}

class _TestPageCustomState extends State<TestPageCustom> {
  final internetSpeedTest = FlutterInternetSpeedTest()..enableLog();

  bool _testInProgress = false;
  double _downloadProgress = 0.0;
  double _uploadProgress = 0.0;
  TestResult? testDownload;
  TestResult? testUpload;
  bool _isServerSelectionInProgress = false;

  String? _ip;
  String? _asn;
  String? _isp;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      reset();
    });
  }

  @override
  void dispose() {
    internetSpeedTest.cancelTest();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                  if (!_testInProgress) ...{
                    itemCircleStart(),
                  } else if (testUpload != null) ...{
                    itemCircle(testUpload, Colors.blue),
                  } else ...{
                    itemCircle(testDownload, Colors.green),
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
                  child: itemData('DESCARGA', _downloadProgress, testDownload),
                ),
                const SizedBox(width: 5.0),
                Expanded(
                  child: itemData('SUBIDA', _uploadProgress, testUpload),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20.0),
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Text(
              _isServerSelectionInProgress
                  ? 'Seleccionando servidor...'
                  : 'IP: ${_ip ?? '--'} | ASP: ${_asn ?? '--'}'
                      ' ${_isp != null ? '| ISP:$_isp' : ''}',
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
        startScanning();
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

  void reset() {
    setState(() {
      _testInProgress = false;
      _downloadProgress = 0.0;
      _uploadProgress = 0.0;

      testDownload = null;
      testUpload = null;

      _ip = null;
      _asn = null;
      _isp = null;
    });
  }

  startScanning() async {
    reset();
    await internetSpeedTest.startTesting(
      onStarted: () {
        setState(() => _testInProgress = true);
      },
      onCompleted: (TestResult d, TestResult u) {
        setState(() {
          testDownload = d;
          _downloadProgress = 100.0;
        });
        setState(() {
          _uploadProgress = 100.0;
          _testInProgress = false;
        });
        ModelTest test = ModelTest(
          rateDownload: d.transferRate,
          unitDownload: d.unit.name,
          durationInMillisDownload: d.durationInMillis,
          rateUpload: u.transferRate,
          unitUpload: u.unit.name,
          durationInMillisUpload: u.durationInMillis,
        );
        var pvC = ProviderConnection.of();
        AccessPointController().saveTestConnection(pvC.connection, test);
      },
      onProgress: (double percent, TestResult data) {
        setState(() {
          if (data.type == TestType.download) {
            testDownload = data;
            _downloadProgress = percent;
          } else {
            testUpload = data;
            _uploadProgress = percent;
          }
        });
      },
      onError: (String errorMessage, String speedTestError) {
        reset();
      },
      onDefaultServerSelectionInProgress: () {
        setState(() {
          _isServerSelectionInProgress = true;
        });
      },
      onDefaultServerSelectionDone: (Client? client) {
        setState(() {
          _isServerSelectionInProgress = false;
          _ip = client?.ip;
          _asn = client?.asn;
          _isp = client?.isp;
        });
      },
      onDownloadComplete: (TestResult data) {
        setState(() {
          testDownload = data;
        });
      },
      onUploadComplete: (TestResult data) {
        setState(() {
          testUpload = data;
        });
      },
      onCancel: () {
        reset();
      },
    );
  }

  String getTransferRate(TestResult? data) {
    if (data == null) return "----";
    var unit = data.unit.name;
    unit = unit[0].toUpperCase() + unit.substring(1);
    return "${data.transferRate} $unit";
  }
}
