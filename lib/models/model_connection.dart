import 'package:wifi/docs.dart';

class ItemConnection {
  final String ssid;
  final String bssid;
  final int signal;
  final String freq;
  final String ipV4;
  final String ipV6;
  final String gateway;
  final String broadcast;
  final String submask;
  final String distance;
  final String latitude;
  final String longitude;
  final String chanelWidth;
  final String chanel;
  final String brandRouter;
  final String uuid;

  ItemConnection({
    this.ssid = "",
    this.bssid = "",
    this.signal = 0,
    this.freq = "",
    this.ipV4 = "",
    this.ipV6 = "",
    this.gateway = "",
    this.broadcast = "",
    this.submask = "",
    this.distance = "",
    this.latitude = "",
    this.longitude = "",
    this.chanelWidth = "",
    this.chanel = "",
    this.brandRouter = "",
    required this.uuid,
  });

  ItemConnection copyWith({
    String? ssid,
    String? bssid,
    int? signal,
    String? freq,
    String? ipV4,
    String? ipV6,
    String? gateway,
    String? broadcast,
    String? submask,
    String? distance,
    String? latitude,
    String? longitude,
    String? chanelWidth,
    String? chanel,
    String? brandRouter,
    String? uuid,
  }) {
    return ItemConnection(
      ssid: ssid ?? this.ssid,
      bssid: bssid ?? this.bssid,
      signal: signal ?? this.signal,
      freq: freq ?? this.freq,
      ipV4: ipV4 ?? this.ipV4,
      ipV6: ipV6 ?? this.ipV6,
      gateway: gateway ?? this.gateway,
      broadcast: broadcast ?? this.broadcast,
      submask: submask ?? this.submask,
      distance: distance ?? this.distance,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      chanelWidth: chanelWidth ?? this.chanelWidth,
      chanel: chanel ?? this.chanel,
      brandRouter: brandRouter ?? this.brandRouter,
      uuid: uuid ?? this.uuid,
    );
  }

  factory ItemConnection.fromJson(Map<String, dynamic> json) {
    return ItemConnection(
      ssid: parseString(json['ssid']),
      bssid: parseString(json['bssid']),
      signal: parseInt(json['signal']),
      freq: parseString(json['freq']),
      ipV4: parseString(json['ipV4']),
      ipV6: parseString(json['ipV6']),
      gateway: parseString(json['gateway']),
      broadcast: parseString(json['broadcast']),
      submask: parseString(json['submask']),
      distance: parseString(json['distance']),
      latitude: parseString(json['latitude']),
      longitude: parseString(json['longitude']),
      chanelWidth: parseString(json['chanelWidth']),
      chanel: parseString(json['chanel']),
      brandRouter: parseString(json['brandRouter']),
      uuid: parseString(json['uuid']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ssid': ssid,
      'bssid': bssid,
      'signal': signal,
      'freq': freq,
      'ipV4': ipV4,
      'ipV6': ipV6,
      'gateway': gateway,
      'broadcast': broadcast,
      'submask': submask,
      'distance': distance,
      'latitude': latitude,
      'longitude': longitude,
      'chanelWidth': chanelWidth,
      'chanel': chanel,
      'brandRouter': brandRouter,
      'uuid': uuid,
    };
  }
}
