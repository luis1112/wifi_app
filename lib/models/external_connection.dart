import 'package:wifi/docs.dart';

class ExternalConnection {
  String continent;
  String country;
  String capital;
  String city;
  String ip;
  double latitude;
  String continentCode;
  String countryCode;
  ConnectionRedInfo connection;
  String postal;
  String region;
  String regionCode;
  double longitude;

  ExternalConnection({
    required this.continent,
    required this.country,
    required this.capital,
    required this.city,
    required this.ip,
    required this.latitude,
    required this.continentCode,
    required this.countryCode,
    required this.connection,
    required this.postal,
    required this.region,
    required this.regionCode,
    required this.longitude,
  });

  factory ExternalConnection.fromJson(Map<dynamic, dynamic> json) =>
      ExternalConnection(
        continent: json["continent"] ?? "",
        country: json["country"] ?? "",
        capital: json["capital"] ?? "",
        city: json["city"] ?? "",
        ip: json["ip"] ?? "",
        latitude: double.parse("${json["latitude"] ?? 0.0}"),
        longitude: double.parse("${json["longitude"] ?? 0.0}"),
        continentCode: json["continent_code"] ?? "",
        countryCode: json["country_code"] ?? "",
        connection: ConnectionRedInfo.fromJson(json["connection"] ?? {}),
        postal: json["postal"] ?? "",
        region: json["region"] ?? "",
        regionCode: json["region_code"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "continent": continent,
        "country": country,
        "capital": capital,
        "city": city,
        "ip": ip,
        "latitude": latitude,
        "continent_code": continentCode,
        "country_code": countryCode,
        "connection": connection.toJson(),
        "postal": postal,
        "region": region,
        "region_code": regionCode,
        "longitude": longitude,
      };
}

class ConnectionRedInfo {
  ConnectionRedInfo({
    required this.isp,
    required this.domain,
    required this.asn,
  });

  String isp;
  String domain;
  int asn;

  factory ConnectionRedInfo.fromJson(Map<dynamic, dynamic> json) =>
      ConnectionRedInfo(
        isp: json["isp"] ?? "",
        domain: json["domain"] ?? "",
        asn: parseInt(json["asn"]),
      );

  Map<dynamic, dynamic> toJson() => {
        "isp": isp,
        "domain": domain,
        "asn": asn,
      };
}
