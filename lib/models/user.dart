import 'package:wifi/docs.dart';

class UserModel {
  final String names;
  final String photoUrl;
  final String email;
  final String rol;

  UserModel({
    required this.names,
    required this.photoUrl,
    required this.email,
    this.rol = "app,web",
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      names: parseString(json['names']),
      photoUrl: parseString(json['photoUrl']),
      email: parseString(json['email']),
      rol: parseString(json['rol']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'names': names,
      'email': email,
      'rol': rol,
    };
  }
}
