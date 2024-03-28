import 'package:flutter_internet_speed_test/flutter_internet_speed_test.dart';
import 'package:wifi/docs.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProviderTest with ChangeNotifier {
  static ProviderTest of([BuildContext? context, bool listen = false]) {
    return Provider.of<ProviderTest>(context ?? contextG, listen: listen);
  }

  notify() => notifyListeners();

  FlutterInternetSpeedTest speedTest = FlutterInternetSpeedTest()..disableLog();

  bool testInProgress = false;
  double downloadProgress = 0.0;
  double uploadProgress = 0.0;
  TestResult? testDownload;
  TestResult? testUpload;
  bool isServerSelectionInProgress = false;

  String? ip;
  String? asn;
  String? isp;

  //model
  ModelTest? test;

  void reset() {
    // if (speedTest.isTestInProgress()) speedTest.cancelTest();
    speedTest = FlutterInternetSpeedTest()..disableLog();
    testInProgress = false;
    downloadProgress = 0.0;
    uploadProgress = 0.0;

    testDownload = null;
    testUpload = null;

    ip = null;
    asn = null;
    isp = null;
    notify();
  }

  startScanning() async {
    if (speedTest.isTestInProgress()) return null;
    reset();
    await speedTest.startTesting(
      onStarted: () {
        testInProgress = true;
        notify();
      },
      onCompleted: (TestResult d, TestResult u) {
        testDownload = d;
        downloadProgress = 100.0;
        //
        uploadProgress = 100.0;
        testInProgress = false;
        notify();
        test = ModelTest(
          rateDownload: d.transferRate,
          unitDownload: d.unit.name,
          durationInMillisDownload: d.durationInMillis,
          rateUpload: u.transferRate,
          unitUpload: u.unit.name,
          durationInMillisUpload: u.durationInMillis,
        );
      },
      onProgress: (double percent, TestResult data) {
        if (data.type == TestType.download) {
          testDownload = data;
          downloadProgress = percent;
        } else {
          testUpload = data;
          uploadProgress = percent;
        }
        notify();
      },
      onError: (String errorMessage, String speedTestError) {
        reset();
      },
      onDefaultServerSelectionInProgress: () {
        isServerSelectionInProgress = true;
        notify();
      },
      onDefaultServerSelectionDone: (Client? client) {
        isServerSelectionInProgress = false;
        ip = client?.ip;
        asn = client?.asn;
        isp = client?.isp;
        notify();
      },
      onDownloadComplete: (TestResult data) {
        testDownload = data;
        notify();
      },
      onUploadComplete: (TestResult data) {
        testUpload = data;
        notify();
      },
      onCancel: () {
        reset();
      },
    );
  }
}
