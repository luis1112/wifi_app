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
  TypeChanel? typeChannel;
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
    if (wifiConnected) {
      return "WiFi - ${wifiConnected ? "Conectado" : "Desconectado"}";
    } else {
      return "Datos móviles - ${mobileDataConnected ? "Conectado" : "Desconectado"}";
    }
  }

  initListen() {
    initEnabled();
    initConnected();
    //listen graph
    initChanel();
    initVelocity();
    initSignal();
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
      var channel = calculateChannel(freq, false);
      connection = connection.copyWith(
        freq: "${(freq / 1000).toStringAsFixed(4)} GHz",
        chanel: channel,
      );
      notify();
    });
    final info = NetworkInfo();
    //bssid
    info.getWifiBSSID().then((v) async {
      connection = connection.copyWith(bssid: v);
      if (v != null) {
        var chanelWidth = getChanelWidthWifi(accessPoints, v);
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

  initConnected() {
    Connectivity().onConnectivityChanged.listen((event) async {
      mobileDataConnected = event.contains(ConnectivityResult.mobile);
      if (event.contains(ConnectivityResult.wifi)) {
        await UtilInfoDevice.getAllInfoDevice(isResetInfo: true);
        startScan();
        getDataConnection();
        wifiConnected = true;
        external = await UtilInfoDevice.getRedInfo();
        // test
        ProviderTest.of().startScanning();
      } else {
        wifiConnected = false;
        accessPoints = [];
        external = null;
        connection = ItemConnection(uuid: DeviceInfo.uuid);
        // test
        ProviderTest.of().reset();
      }
      notify();
    });
  }

  startScan() async {
    var can = await WiFiScan.instance.canGetScannedResults();
    if (can == CanGetScannedResults.yes) {
      var points = await WiFiScan.instance.getScannedResults();
      accessPoints = points.map((e) {
        var chanel = "${e.channelWidth?.name ?? 20}".replaceAll("mhz", "");
        return AccessPoint(
          ssid: e.ssid,
          bssid: e.bssid,
          capabilities: e.capabilities,
          level: e.level,
          channelWidth: parseInt(chanel, 20),
          frequency: e.frequency,
          chanel: calculateChannel(e.frequency, false),
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

  obtainChartChanel() async {
    var access = accessPoints.where((e) {
      return e.ssid.trim().isNotEmpty;
    }).toList();
    access = access.where((e) {
      if (e.frequency < 5000 && typeChannel == TypeChanel.ghz2) return true;
      if (e.frequency >= 5000 && typeChannel == TypeChanel.ghz5) return true;
      if (typeChannel == null) return true;
      return false;
    }).toList();
    List<ItemChartChanel> listAux = [];
    for (var e in access) {
      var channel = calculateChannel(e.frequency, true);
      var key = 'color-${e.ssid}';
      // await deleteStringPreference(key);
      var colorHex = await getStringPreference(key);
      Color color;
      if (colorHex == null) {
        color = generateUniqueRandomColor(
          listAux.map((e) => e.color).toList(),
          access.indexOf(e),
          e.level,
        );
        setStringPreference(key, UtilTheme.toHex(color));
      } else {
        color = HexColor(colorHex);
      }
      var item =
          listChartChanel(color, channel, e.level, e.channelWidth, typeChannel);
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
