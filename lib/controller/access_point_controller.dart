import 'dart:convert';

import 'package:wifi/docs.dart';

class AccessPointController {
  String getIdConnection(ItemConnection connection) {
    var bssid = connection.bssid;
    var uuid = connection.uuid;
    return "$bssid-$uuid";
  }

  String getIdAnalysis(DateTime dateTime) {
    return "${dateTime.millisecondsSinceEpoch}";
  }

  Future<void> saveConnection(ItemConnection c) async {
    try {
      if (c.bssid.trim().isEmpty) return;
      var id = getIdConnection(c);
      var docC = fConnections.doc(id);
      await docC.set(c.toJson());
    } catch (err) {
      printC('Error adding ItemConnection ${c.bssid}: $err');
    }
  }

  //save children of connection
  saveAnalysis(ItemConnection c, DateTime dateTime) {
    var id = getIdConnection(c);
    var idAnalysis = getIdAnalysis(dateTime);
    var docRef = fAnalysis(id).doc(idAnalysis);
    docRef.set({
      "uuid": c.uuid,
      "time": dateTime.millisecondsSinceEpoch,
    });
  }

  void saveExternal(
    ItemConnection c,
    ExternalConnection? e,
    DateTime dateTime,
  ) async {
    try {
      if (e == null) return;
      var id = getIdConnection(c);
      var idAnalysis = getIdAnalysis(dateTime);
      var docRef = fAnalysis(id).doc(idAnalysis);
      var subRef = docRef.collection('external');
      var docs = (await subRef.get()).docs;
      var eData = docs.firstOrNull;
      if (eData == null) {
        await subRef.add(e.toJson());
      } else {
        await subRef.doc(eData.id).set(e.toJson());
      }
    } catch (e) {
      printC('Error of save external connection : $e');
    }
  }

  void saveTest(
    ItemConnection c,
    ModelTest? test,
    DateTime dateTime,
  ) async {
    try {
      if (test == null) return;
      var id = getIdConnection(c);
      var idAnalysis = getIdAnalysis(dateTime);
      var docRef = fAnalysis(id).doc(idAnalysis);
      var subRef = docRef.collection('testConnection');
      var docs = (await subRef.get()).docs;
      var eData = docs.firstOrNull;
      if (eData == null) {
        await subRef.add(test.toJson());
      } else {
        await subRef.doc(eData.id).set(test.toJson());
      }
    } catch (e) {
      printC('Error of save test connection : $e');
    }
  }

  void saveSignal(ItemConnection c, DateTime dateTime) async {
    try {
      var id = getIdConnection(c);
      var idAnalysis = getIdAnalysis(dateTime);
      var docRef = fAnalysis(id).doc(idAnalysis);
      var subRef = docRef.collection('signals');
      await subRef.add({
        "signal": c.signal,
        "uuid": c.uuid,
        "time": DateTime.now().millisecondsSinceEpoch,
      });
    } catch (e) {
      printC('Error of save signal: $e');
    }
  }

  void saveAccessPoint(
    ItemConnection c,
    List<AccessPoint> l,
    DateTime dateTime,
  ) async {
    try {
      if (l.isEmpty) return;
      var id = getIdConnection(c);
      var idAnalysis = getIdAnalysis(dateTime);
      var docRef = fAnalysis(id).doc(idAnalysis);
      var subRef = docRef.collection('accessPoints');
      var list = l.map((e) => e.toJson()).toList();
      await subRef.add({
        "list": jsonEncode(list),
        "uuid": c.uuid,
        "time": DateTime.now().millisecondsSinceEpoch,
      });
    } catch (e) {
      printC('Error of save signal: $e');
    }
  }
}
