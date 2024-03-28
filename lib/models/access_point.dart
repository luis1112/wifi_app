import 'package:wifi/docs.dart';

class AccessPoint {
  final String ssid;
  final String bssid;
  final String capabilities;
  final int level;
  final int channelWidth;
  final int chanel;
  final int frequency;
  final int centerFrequency0;
  final int centerFrequency1;
  final String venueName;

  AccessPoint({
    required this.ssid,
    required this.bssid,
    required this.capabilities,
    required this.level,
    required this.channelWidth,
    required this.chanel,
    required this.frequency,
    required this.centerFrequency0,
    required this.centerFrequency1,
    required this.venueName,
  });

  factory AccessPoint.fromJson(Map<String, dynamic> json) {
    return AccessPoint(
      ssid: parseString(json['ssid']),
      bssid: parseString(json['bssid']),
      capabilities: parseString(json['capabilities']),
      level: parseInt(json['level']),
      channelWidth: parseInt(json['channelWidth']),
      chanel: parseInt(json['chanel']),
      frequency: parseInt(json['frequency']),
      centerFrequency0: parseInt(json['centerFrequency0']),
      centerFrequency1: parseInt(json['centerFrequency1']),
      venueName: parseString(json['venueName']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ssid': ssid,
      'bssid': bssid,
      'capabilities': capabilities,
      'level': level,
      'channelWidth': channelWidth,
      'chanel': chanel,
      'frequency': frequency,
      'centerFrequency0': centerFrequency0,
      'centerFrequency1': centerFrequency1,
      'venueName': venueName,
    };
  }
}
