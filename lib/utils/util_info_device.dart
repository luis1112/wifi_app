import 'dart:convert';
import 'dart:io';

import 'package:dart_ipify/dart_ipify.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:safe_device/safe_device.dart';
import 'package:unique_identifier/unique_identifier.dart';
import 'package:wifi/docs.dart';

class UtilInfoDevice {
  static Future<String> getPublicIP() async {
    String ipPublic = "";
    try {
      ipPublic = await Ipify.ipv4();
    } catch (e) {
      ipPublic = "";
    }
    return ipPublic;
  }


  static Future<String> getIPAddress() async {
    String ipAddress = "";
    try {
      var interface = await NetworkInterface.list(
        type: InternetAddressType.IPv4,
      );
      var addresses = interface.first.addresses;
      ipAddress = addresses.first.address;
    } catch (err) {
      ipAddress = "";
    }
    return ipAddress;
  }

  static Future<String> getMac() async {
    String mac = "";
    return mac;
  }

  static Future<bool> isVpnActive() async {
    bool isVpnActive;
    List<NetworkInterface> interfaces = await NetworkInterface.list(
        includeLoopback: false, type: InternetAddressType.any);
    interfaces.isNotEmpty
        ? isVpnActive = interfaces.any((interface) =>
            interface.name.contains("tun") ||
            interface.name.contains("ppp") ||
            interface.name.contains("pptp"))
        : isVpnActive = false;
    return isVpnActive;
  }

  static getSafeDevice() async {
    //
    if (Platform.isAndroid) {
      DeviceInfo.safeIsDevelopMode = await SafeDevice.isDevelopmentModeEnable;
    }
    DeviceInfo.safeIsVpn = await isVpnActive();
  }

  static Future<void> getAllInfoDevice({bool isResetInfo = false}) async {
    if (DeviceInfo.isData && !isResetInfo) return;
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    // DeviceInfo.gms =
    //     await FlutterHmsGmsAvailability.isGmsAvailable; //HUAWEI_COMMENT
    // DeviceInfo.hms =
    //     await FlutterHmsGmsAvailability.isHmsAvailable; //HUAWEI_COMMENT
    DeviceInfo.gms = true;
    DeviceInfo.hms = false;
    if (Platform.isIOS) {
      DeviceInfo.gms = true;
      DeviceInfo.platform = 1;
      IosDeviceInfo iosDevice = await deviceInfo.iosInfo;
      DeviceInfo.brand = "Apple";
      DeviceInfo.model = iosDevice.model;
      DeviceInfo.systemVersion = iosDevice.systemVersion;
      DeviceInfo.operatingSystem = "IOS";
      DeviceInfo.uuid = iosDevice.identifierForVendor ?? "";
    } else if (Platform.isAndroid) {
      DeviceInfo.platform = 0;
      AndroidDeviceInfo androidDeviceInfo = await deviceInfo.androidInfo;
      DeviceInfo.brand = androidDeviceInfo.manufacturer;
      DeviceInfo.model = androidDeviceInfo.model;
      DeviceInfo.systemVersion = androidDeviceInfo.version.release;
      DeviceInfo.operatingSystem = "ANDROID";
      DeviceInfo.uuid = (await UniqueIdentifier.serial) ?? androidDeviceInfo.id;
    }
    if (DeviceInfo.gms && DeviceInfo.hms) DeviceInfo.hms = false;
    if (DeviceInfo.hms) {
      DeviceInfo.platform = 2;
      DeviceInfo.operatingSystem = "HUAWEI";
    }
    DeviceInfo.ipPublic = await getPublicIP();
    DeviceInfo.ipDevice = await getIPAddress();
    DeviceInfo.mac = await getMac();
    //secure device
    DeviceInfo.safeIsRoot = await SafeDevice.isJailBroken;
    DeviceInfo.safeCanMockLocation = await SafeDevice.canMockLocation;
    DeviceInfo.safeIsRealDevice = await SafeDevice.isRealDevice;
    // getSafeDevice();
    //info app
    DeviceInfo.appName = packageInfo.appName;
    DeviceInfo.appVersion = packageInfo.version;
    DeviceInfo.appPackageName = packageInfo.packageName;
    DeviceInfo.appBuildNumber = packageInfo.buildNumber;
    DeviceInfo.appBuildSignature = packageInfo.buildSignature;
    DeviceInfo.appInstallerStore = packageInfo.installerStore ?? "";

    DeviceInfo.isData = true;
    // DeviceInfo.uuid = "testUuid";
    printC(DeviceInfo().toString());
  }

  static Future<ExternalConnection?> getRedInfo(String ipPublic) async {
    try {
      var request = await http.get(Uri.parse("https://ipwho.is/$ipPublic"));
      var body = jsonDecode(request.body);
      return ExternalConnection.fromJson(body);
    } catch (err) {
      return null;
    }
  }
}
