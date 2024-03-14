import 'dart:convert';

import 'package:wifi/docs.dart';

class AccessPointController {

  String getIdConnection(ItemConnection connection) {
    var bssid = connection.bssid;
    var uuid = connection.uuid;
    return "$bssid-$uuid";
  }

  void saveConnection(ItemConnection c, ExternalConnection? e) async {
    try {
      if (c.bssid.trim().isEmpty) return;
      var id = getIdConnection(c);
      var docC = fConnections.doc(id);
      await docC.set(c.toJson());
      saveExternalConnection(c, e);
    } catch (err) {
      printC('Error adding ItemConnection ${c.bssid}: $err');
    }
  }

  void saveExternalConnection(ItemConnection c, ExternalConnection? e) async {
    try {
      if (e == null) return;
      var id = getIdConnection(c);
      var docRef = fConnections.doc(id);
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

  void saveTestConnection(ItemConnection c, ModelTest? test) async {
    try {
      if (test == null) return;
      var id = getIdConnection(c);
      var docRef = fConnections.doc(id);
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


  void saveSignalConnection(ItemConnection connection) async {
    try {
      var id = getIdConnection(connection);
      var docRef = fConnections.doc(id);
      var subRef = docRef.collection('signals');
      await subRef.add({
        "signal": connection.signal,
        "uuid": connection.uuid,
        "time": DateTime.now().millisecondsSinceEpoch,
      });
    } catch (e) {
      printC('Error of save signal: $e');
    }
  }

  void saveAccessPointConnection(ItemConnection c, List<AccessPoint> l) async {
    try {
      if (l.isEmpty) return;
      var id = getIdConnection(c);
      var docRef = fConnections.doc(id);
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
