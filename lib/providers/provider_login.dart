import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:wifi/docs.dart';

GoogleSignIn googleSignIn = GoogleSignIn(
  scopes: [
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
  ],
);

class ProviderLogin with ChangeNotifier {
  static ProviderLogin of([BuildContext? context, bool listen = false]) {
    return Provider.of<ProviderLogin>(context ?? contextG, listen: listen);
  }

  notify() => notifyListeners();

  UserModel user = UserModel.fromJson({});

  Future<bool> loginWithGoogle() async {
    try {
      var u = await googleSignIn.signIn();
      var email = u?.email ?? "";
      if (email.contains("@unl.edu.ec")) {
        UserModel userData = UserModel(
          names: u?.displayName ?? "",
          photoUrl: u?.photoUrl ?? "",
          email: u?.email ?? "",
        );
        DeviceModel device = DeviceModel(
          uuid: DeviceInfo.uuid,
          brand: DeviceInfo.brand,
          model: DeviceInfo.model,
        );
        UserController().addUser(userData, device);
        UtilPreference.setUser(userData);
        return true;
      } else {
        await googleSignIn.signOut();
        pvG.showMessage(
            "El correo que deseas ingresar no tiene el dominio de"
            " la Universidad @unl.edu.ec", onTap: () {
          utilNavG.popUntilName(PageLogin.route);
        });
      }
    } catch (error) {
      printC("________________");
      printC(error);
      pvG.showMessage("");
    }
    notify();
    return false;
  }

  navigatorExit() {
    BuildContext context = contextG;
    alertMessage(
      context,
      message:
          "¿Estás seguro de que deseas cerrar sesión de ${DeviceInfo.appName}?",
      title: "Cerrando sesión",
      titleBtnAgree: "Si, cerrar sesión",
      titleBtnCancel: "Cancelar",
      barrierDismissible: true,
      onTap: () async {
        await UtilPreference.deleteUser();
        await googleSignIn.signOut();
        navG.pushNamedAndRemoveUntil(PageLogin.route, (route) => false);
      },
    );
  }
}
