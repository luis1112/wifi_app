import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wifi/models/user.dart';

class UtilPreference {
  static String stateEmpty = "stateEmpty";

  //empty
  static Future<bool> setUser(UserModel item) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(stateEmpty, json.encode(item.toJson()));
  }

  static Future<UserModel?> getUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? data = prefs.getString(stateEmpty);
    if (data != null) return UserModel.fromJson(json.decode(data));
    return null;
  }

  static Future<bool> deleteUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.remove(stateEmpty);
  }

}


