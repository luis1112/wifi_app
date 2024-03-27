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
  Duration _duration = const Duration(seconds: 30);
  Timer? _timerOtp;
  bool isTransfer = false;

  initSave() async {
    if (isTransfer) return;
    printC("EMPEZANDO A GUARDAR INFORMACION");
    Duration duration = const Duration(seconds: 30);
    _duration = duration;
    _timerOtp?.cancel();
    int secondsProgress = duration.inSeconds;
    int seconds = duration.inSeconds;
    DateTime now1 = DateTime.now();
    isTransfer = true;
    //save
    saveDataFirebase();
    //save test
    ProviderTest.of().startScanning();
    _timerOtp = Timer.periodic(const Duration(seconds: 2), (Timer timer) {
      DateTime now2 = DateTime.now();
      int secondPassed = now2.difference(now1).inSeconds;
      secondsProgress = seconds - secondPassed;
      _duration = Duration(seconds: secondsProgress);
      if (secondsProgress <= 0) {
        timer.cancel();
        isTransfer = false;
      }
      notifyListeners();
      //save
      saveDataFirebase();
    });
  }

  saveDataFirebase() {
    //save connection
    var pvC = ProviderConnection.of();
    if (pvC.isEnabled && pvC.wifiConnected) {
      printC("GUARDANDO INFORMACIÓN");
      accessC.saveConnection(pvC.connection, pvC.external);
      accessC.saveSignalConnection(pvC.connection);
      accessC.saveAccessPointConnection(pvC.connection, pvC.accessPoints);
    }
  }

  String get formatMinutes {
    return _duration.toString().substring(2, 7);
  }
}
