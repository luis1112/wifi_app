import 'dart:convert';

class DeviceInfo {
  static bool isData = false;
  static String brand = "";
  static String model = "";
  static String systemVersion = "";
  static String operatingSystem = "";
  static String ipDevice = "";
  static String ipPublic = "";
  static String mac = "";
  static String uuid = "";
  static String phoneNumber = "";
  static bool gms = false;
  static bool hms = false;
  static int platform = 0;

  //secure device
  static bool safeIsRoot = false;
  static bool safeCanMockLocation = false;
  static bool safeIsRealDevice = false;
  static bool safeIsDevelopMode = false;
  static bool safeIsVpn = false;

  //info app
  static String appName = "";
  static String appVersion = "";
  static String appPackageName = "";
  static String appBuildNumber = "";
  static String appBuildSignature = "";
  static String appInstallerStore = "";

  //device info location
  static String countryCode = "";
  static String country = "";
  static double lat = 0.0;
  static double lng = 0.0;

  static Map<String, dynamic> toJson() {
    Map<String, dynamic> device = {
      'brand': brand,
      'model': model,
      'systemVersion': systemVersion,
      'operatingSystem': operatingSystem,
      'ipDevice': ipDevice,
      'ipPublic': ipPublic,
      'mac': mac,
      'uuid': uuid,
      'phoneNumber': phoneNumber,
      'gms': gms,
      'hms': hms,
      'platform': platform,
      //for safe
      'safeIsRoot': safeIsRoot,
      'safeCanMockLocation': safeCanMockLocation,
      'safeIsRealDevice': safeIsRealDevice,
      'safeIsDevelopMode': safeIsDevelopMode,
      'safeIsVpn': safeIsVpn,
      //for app
      'appName': appName,
      'appVersion': appVersion,
      'appPackageName': appPackageName,
      'appBuildNumber': appBuildNumber,
      'appBuildSignature': appBuildSignature,
      'appInstallerStore': appInstallerStore,
      //device location
      'countryCode': countryCode,
      'country': country,
      'lat': lat,
      'lng': lng,
    };
    return device;
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}
