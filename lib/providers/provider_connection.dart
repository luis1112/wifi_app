import 'dart:async';
import 'dart:math';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:wifi/docs.dart';
import 'package:wifi_iot/wifi_iot.dart';
import 'package:wifi_scan/wifi_scan.dart';

class ProviderConnection with ChangeNotifier {
  static ProviderConnection of([BuildContext? context, bool listen = false]) {
    return Provider.of<ProviderConnection>(context ?? contextG, listen: listen);
  }

  notify() => notifyListeners();

  bool isEnabled = false;
  bool wifiConnected = false;
  bool mobileDataConnected = false;
  ExternalConnection? external;

  //WiFiAccessPoint
  List<AccessPoint> accessPoints = [];
  ItemConnection connection = ItemConnection(uuid: DeviceInfo.uuid);

  //chanel
  bool isActiveNetwork = false;
  TypeChanel? typeChanel;
  List<ItemChartChanel> lineBarsData = [];
  Timer? timerChanel;

  //signal
  int limitCount = 30;
  TypeChanel? typeSignal;
  List<ItemChartSignal> listSignal = [];
  Timer? timerSignal;
  DateTime nowAfterSignal = DateTime.now();

  //velocity
  Timer? timerVelocity;
  DateTime nowAfterVelocity = DateTime.now();
  List<FlSpot> listPointsAux = [];
  List<FlSpot> listPoints = [];
  int level = 0;

  String get getTypeConnection {
    String value = "WiFi - ${wifiConnected ? "Conectado" : "Desconectado"}\n"
        "Datos móviles - ${mobileDataConnected ? "Conectado" : "Desconectado"}";
    return value;
  }

  initListen() {
    initEnabled();
    initConnected();
  }

  int limit = 30;

  initEnabled() async {
    isEnabled = await WiFiForIoTPlugin.isEnabled();
    notify();
    if (isEnabled) {
      if (wifiConnected) getDataConnection();
      await startScan();
    }
  }

  getDataConnection() {
    //ssid
    WiFiForIoTPlugin.getSSID().then((v) {
      connection = connection.copyWith(ssid: v);
      notify();
    });
    //signal
    WiFiForIoTPlugin.getCurrentSignalStrength().then((v) {
      if (v != null) {
        connection = connection.copyWith(signal: v);
        var distance = calculateDistanceRouter(v);
        connection = connection.copyWith(distance: "$distance metros");
      }
      notify();
    });
    //freq
    WiFiForIoTPlugin.getFrequency().then((v) {
      var freq = (v ?? 2422);
      var channel = calculateChannel(freq);
      connection = connection.copyWith(
        freq: "${(freq / 1000).toStringAsFixed(2)} GHZ",
        chanel: channel,
      );
      notify();
    });
    final info = NetworkInfo();
    //bssid
    info.getWifiBSSID().then((v) async {
      connection = connection.copyWith(bssid: v);
      if (v != null) {
        var chanelWidth = getChanelWidthWifi(v);
        var brandRouter = await UtilInfoDevice.getBrandRouter(v);
        connection = connection.copyWith(
          chanelWidth: chanelWidth,
          brandRouter: brandRouter,
        );
      }
      notify();
    });
    //ipV4
    info.getWifiIP().then((v) {
      connection = connection.copyWith(ipV4: v);
      notify();
    });
    //ipV6
    info.getWifiIPv6().then((v) {
      connection = connection.copyWith(ipV6: v);
      notify();
    });
    //gateway
    info.getWifiGatewayIP().then((v) {
      connection = connection.copyWith(gateway: v);
      notify();
    });
    //broadcast
    info.getWifiBroadcast().then((v) {
      connection = connection.copyWith(broadcast: v);
      notify();
    });
    //submask
    info.getWifiSubmask().then((v) {
      connection = connection.copyWith(submask: v);
      notify();
    });
    //location
    connection = connection.copyWith(latitude: external?.latitude.toString());
    connection = connection.copyWith(longitude: external?.longitude.toString());
    connection = connection.copyWith(uuid: DeviceInfo.uuid);
    //save in firebase
    // printC(connection.toJson());
  }

  double calculateDistanceRouter(int rssi) {
    // Constantes para el modelo de pérdida de ruta (Path Loss Model)
    double n = 2; // Exponente de atenuación (generalmente entre 2 y 4)
    double A = -50; // Valor de referencia del RSSI a 1 metro de distancia

    // Fórmula para calcular la distancia
    double distancia = pow(10, ((A - rssi) / (10 * n))).toDouble();
    return double.parse(distancia.toStringAsFixed(2));
  }

  String? getChanelWidthWifi(String bssid) {
    var v = accessPoints.where((e) => e.bssid == bssid).firstOrNull;
    var channelWidth = v?.channelWidth;
    if (channelWidth != null) return "$channelWidth mhz";
    return null;
  }

  String calculateChannel(int frequency) {
    if (frequency >= 2412 && frequency <= 2484) {
      return ((frequency - 2412) ~/ 5 + 1).toString();
    } else if (frequency >= 5180 && frequency <= 5825) {
      return (((frequency - 5180) ~/ 5) + 36).toString();
    }
    return 'Desconocido';
  }

  initConnected() {
    Connectivity().onConnectivityChanged.listen((event) async {
      mobileDataConnected = event == ConnectivityResult.mobile;
      if (event == ConnectivityResult.wifi) {
        UtilInfoDevice.getAllInfoDevice();
        startScan();
        getDataConnection();
        wifiConnected = true;
        external = await UtilInfoDevice.getRedInfo(DeviceInfo.ipPublic);
      } else {
        wifiConnected = false;
        accessPoints = [];
        external = null;
        connection = ItemConnection(uuid: DeviceInfo.uuid);
      }
      notify();
    });
  }

  startScan() async {
    var can = await WiFiScan.instance.canGetScannedResults();
    if (can == CanGetScannedResults.yes) {
      var points = await WiFiScan.instance.getScannedResults();
      // int.parse("${e.channelWidth.name ??20}".replaceAll("mhz", ""));
      accessPoints = points.map((e) {
        var chanel = "${e.channelWidth?.name ?? 20}".replaceAll("mhz", "");
        return AccessPoint(
          ssid: e.ssid,
          bssid: e.bssid,
          capabilities: e.capabilities,
          level: e.level,
          channelWidth: parseInt(chanel, 20),
          frequency: e.frequency,
          centerFrequency0: e.centerFrequency0 ?? 2400,
          centerFrequency1: e.centerFrequency1 ?? 2400,
          venueName: e.venueName ?? "",
        );
      }).toList();
      notify();
    }
  }

  //chanel
  initChanel() {
    timerChanel?.cancel();
    timerChanel =
        Timer.periodic(const Duration(milliseconds: 2500), (timer) async {
      await initEnabled();
      obtainChartChanel();
    });
  }

  obtainChartChanel() {
    var access = accessPoints.where((e) {
      return e.ssid.trim().isNotEmpty;
    }).toList();
    access = access.where((e) {
      if (e.frequency < 5000 && typeChanel == TypeChanel.ghz2) return true;
      if (e.frequency >= 5000 && typeChanel == TypeChanel.ghz5) return true;
      if (typeChanel == null) return true;
      return false;
    }).toList();
    List<ItemChartChanel> listAux = [];
    for (var e in access) {
      var chanel = e.channelWidth;
      // var chanel =
      // int.parse("${e.channelWidth.name ??20}".replaceAll("mhz", ""));
      var color = generateUniqueRandomColor(
        listAux.map((e) => e.color).toList(),
        access.indexOf(e),
        e.level,
      );
      // var eAux = lineBarsData.where((i) => i.item.ssid == e.ssid).firstOrNull;
      // color = eAux?.color ?? color;
      var item = listChartChanel(color, chanel, e.level);
      if (item != null) {
        listAux.add(ItemChartChanel(e, item, color));
      }
    }
    lineBarsData = listAux;
  }

  // signal
  initSignal() {
    timerSignal?.cancel();
    timerSignal =
        Timer.periodic(const Duration(milliseconds: 2500), (timer) async {
      await initEnabled();
      obtainChartSignal();
    });
  }

  obtainChartSignal() {
    var nowBefore = DateTime.now();
    var diff = nowBefore.difference(nowAfterSignal).inSeconds;
    if (diff >= limitCount) {
      nowAfterSignal = DateTime.now();
    }
    var access = accessPoints.where((e) {
      return e.ssid.trim().isNotEmpty;
    }).toList();
    // accessPoints = pvC.accessPoints;
    access = access.where((e) {
      if (e.frequency < 5000 && typeSignal == TypeChanel.ghz2) return true;
      if (e.frequency >= 5000 && typeSignal == TypeChanel.ghz5) return true;
      if (typeSignal == null) return true;
      return false;
    }).toList();
    List<ItemChartSignal> listAdd = [];
    // var e = pvC.accessPoints[0];
    for (var e in access) {
      var listAux = listSignal.where((el) => el.item.bssid == e.bssid).toList();
      List<FlSpot> listPointsAux = listAux.isNotEmpty ? listAux[0].listAux : [];
      listPointsAux.add(
          FlSpot(nowBefore.millisecondsSinceEpoch + 0.0, e.level.toDouble()));
      listPointsAux = listPointsAux.where((e) {
        var datePoint = DateTime.fromMillisecondsSinceEpoch(e.x.toInt());
        var diffAux = nowBefore.difference(datePoint).inSeconds;
        return diffAux <= limitCount;
      }).toList();
      List<FlSpot> listPoints = [];
      for (var point in listPointsAux) {
        var datePoint = DateTime.fromMillisecondsSinceEpoch(point.x.toInt());
        var diffAux = nowBefore.difference(datePoint).inSeconds;
        listPoints.add(FlSpot(diffAux + 0.0, point.y));
      }
      var color = generateUniqueRandomColor(
        listAdd.map((e) => e.color).toList(),
        access.indexOf(e),
        e.level,
      );
      // var eAux = listSignal.where((i) => i.item.ssid == e.ssid).firstOrNull;
      // color = eAux?.color ?? color;
      listAdd.add(ItemChartSignal(e, listPoints, listPointsAux, color));
    }
    listSignal = listAdd;
  }

  // velocity
  initVelocity() {
    timerVelocity?.cancel();
    timerVelocity =
        Timer.periodic(const Duration(milliseconds: 2000), (timer) async {
      await initEnabled();
      obtainChartVelocity();
      notify();
    });
  }

  obtainChartVelocity() async {
    //if conectado
    if (!wifiConnected) return;
    var level = await WiFiForIoTPlugin.getCurrentSignalStrength();
    if (level == null) return; //if null
    this.level = level;

    var nowBefore = DateTime.now();
    var diff = nowBefore.difference(nowAfterVelocity).inSeconds;
    if (diff >= limitCount) {
      nowAfterVelocity = DateTime.now();
    }
    listPointsAux
        .add(FlSpot(nowBefore.millisecondsSinceEpoch + 0.0, level.toDouble()));
    listPointsAux = listPointsAux.where((e) {
      var datePoint = DateTime.fromMillisecondsSinceEpoch(e.x.toInt());
      var diffAux = nowBefore.difference(datePoint).inSeconds;
      return diffAux <= limitCount;
    }).toList();
    listPoints = [];
    for (var point in listPointsAux) {
      var datePoint = DateTime.fromMillisecondsSinceEpoch(point.x.toInt());
      var diffAux = nowBefore.difference(datePoint).inSeconds;
      listPoints.add(FlSpot(diffAux + 0.0, point.y));
    }
  }
}
