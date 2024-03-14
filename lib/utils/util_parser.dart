import 'dart:convert';

import 'package:flutter/material.dart';


double parseDouble(val, [double def = 0.0]) {
  try {
    var v = "${val ?? 0.0}".trim();
    v = v.replaceAll(r"$", "");
    v = v.replaceAll("#", "");
    return double.parse(v);
  } catch (err) {
    return def;
  }
}

int parseInt(val, [int def = 0]) {
  try {
    return int.parse("${val ?? 0.0}");
  } catch (err) {
    return def;
  }
}

DateTime parseDateTime(val, [DateTime? def]) {
  DateTime defAux = (def ?? DateTime.now());
  try {
    return DateTime.parse("${val ?? defAux.toIso8601String()}");
  } catch (err) {
    return defAux;
  }
}

bool parseBool(val, [bool def = false]) {
  if (val is bool) return val;
  return def;
}

String parseString(val, [String def = ""]) {
  if (val != null) return "$val";
  return def;
}

List<dynamic> parseList(val, [List<dynamic> def = const []]) {
  if (val is List) return val;
  return def;
}

Map<dynamic, dynamic> parseMap(val, [Map<dynamic, dynamic> def = const {}]) {
  if (val is Map) return val;
  //if string map
  if (val is String) {
    try {
      return jsonDecode(val);
    } catch (err) {
      debugPrint("$err");
    }
  }
  //default
  return def;
}
