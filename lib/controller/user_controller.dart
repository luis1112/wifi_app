import 'package:wifi/docs.dart';

class UserController {
  void addUser(UserModel user, DeviceModel device) async {
    try {
      var docU = fUsers.doc(user.email);
      var u = (await docU.get());
      if (!u.exists) await docU.set(user.toJson());
      addDevice(user, device);
    } catch (e) {
      printC('Error adding user to Firestore: $e');
    }
  }

  void addDevice(UserModel user, DeviceModel device) async {
    try {
      var docRef = fUsers.doc(user.email);
      var subRef = docRef.collection('devices');
      await subRef.doc(device.uuid).set(device.toJson());
    } catch (e) {
      printC('Error of save device : $e');
    }
  }
}
