import 'package:wifi/docs.dart';

class ModelTest {
  final double rateDownload;
  final String unitDownload;
  final int durationInMillisDownload;
  final double rateUpload;
  final String unitUpload;
  final int durationInMillisUpload;

  ModelTest({
    required this.rateDownload,
    required this.unitDownload,
    required this.durationInMillisDownload,
    required this.rateUpload,
    required this.unitUpload,
    required this.durationInMillisUpload,
  });

  factory ModelTest.fromJson(Map<String, dynamic> json) {
    return ModelTest(
      rateDownload: parseDouble(json['rateDownload']),
      unitDownload: parseString(json['unitDownload']),
      durationInMillisDownload: parseInt(json['durationInMillisDownload']),
      rateUpload: parseDouble(json['rateUpload']),
      unitUpload: parseString(json['unitUpload']),
      durationInMillisUpload: parseInt(json['durationInMillisUpload']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'rateDownload': rateDownload,
      'unitDownload': unitDownload,
      'durationInMillisDownload': durationInMillisDownload,
      'rateUpload': rateUpload,
      'unitUpload': unitUpload,
      'durationInMillisUpload': durationInMillisUpload,
    };
  }
}
