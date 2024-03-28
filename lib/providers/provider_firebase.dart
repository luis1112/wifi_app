import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wifi/docs.dart';

class ProviderFirebase with ChangeNotifier {
  static ProviderFirebase of([BuildContext? context, bool listen = false]) {
    return Provider.of<ProviderFirebase>(context ?? contextG, listen: listen);
  }

  notify() => notifyListeners();
  AccessPointController accessC = AccessPointController();

  //
  Duration _duration = const Duration(seconds: 60);
  Timer? _timerOtp;
  bool isTransfer = false;
  DateTime dateTimeAnalysis = DateTime.now();
  int secondPassed = 0;

  initSave() async {
    if (isTransfer) return;
    printC("EMPEZANDO A GUARDAR INFORMACION");
    Duration duration = const Duration(seconds: 60);
    _duration = duration;
    _timerOtp?.cancel();
    int secondsProgress = duration.inSeconds;
    int seconds = duration.inSeconds;
    DateTime now1 = DateTime.now();
    dateTimeAnalysis = now1;
    isTransfer = true;
    secondPassed = 0;
    notify();
    //save
    int secondSave = 0;
    saveDataFirebase();
    //save test
    ProviderTest.of().startScanning();
    _timerOtp = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      DateTime now2 = DateTime.now();
      secondPassed = now2.difference(now1).inSeconds;
      secondsProgress = seconds - secondPassed;
      _duration = Duration(seconds: secondsProgress);
      if (secondsProgress <= 0) {
        timer.cancel();
        isTransfer = false;
      }
      notifyListeners();
      //save for each 2 seconds
      secondSave++;
      if (secondSave == 2) {
        secondSave = 0;
        saveDataFirebase();
      }
    });
  }

  saveDataFirebase() async {
    var pvC = ProviderConnection.of();
    var pvT = ProviderTest.of();
    var c = pvC.connection;
    var dateTime = dateTimeAnalysis;
    if (!pvC.wifiConnected) return; //for not connected
    //save connection
    printC("GUARDANDO INFORMACIÓN");
    await accessC.saveConnection(pvC.connection);
    //save analysis
    accessC.saveAnalysis(c, dateTime);
    accessC.saveTest(c, pvT.test, dateTime);
    accessC.saveExternal(c, pvC.external, dateTime);
    //save 30 seconds
    if (secondPassed <= 30) {
      accessC.saveSignal(c, dateTime);
      accessC.saveAccessPoint(c, pvC.accessPoints, dateTime);
    }
  }

  String get formatMinutes {
    try {
      return _duration.toString().substring(2, 7);
    } catch (e) {
      return "";
    }
  }
}
