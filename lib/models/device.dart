import 'package:wifi/docs.dart';

class DeviceModel {
  final String uuid;
  final String brand;
  final String model;

  DeviceModel({
    required this.uuid,
    required this.brand,
    required this.model,
  });

  factory DeviceModel.fromJson(Map<String, dynamic> json) {
    return DeviceModel(
      uuid: parseString(json['uuid']),
      brand: parseString(json['brand']),
      model: parseString(json['model']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uuid': uuid,
      'brand': brand,
      'model': model,
    };
  }
}
