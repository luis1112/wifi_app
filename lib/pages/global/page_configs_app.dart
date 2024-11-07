import 'package:flutter/material.dart';
import 'package:wifi/docs.dart';

alertConfigPassword(BuildContext context, Function onSuccess) async {
  String pass = "";
  var res = await alertChild(
    context,
    child: Padding(
      padding: const EdgeInsets.all(30.0),
      child: Column(
        children: [
          TextField(
            obscureText: true,
            decoration: const InputDecoration(labelText: "Contraseña"),
            onChanged: (v) {
              pass = v;
            },
          ),
          const SizedBox(height: 20.0),
          BtnC(
            title: "Continuar",
            onTap: () {
              bool isCorrect = pass == "unl123123";
              navG.pop(isCorrect);
            },
          ),
        ],
      ),
    ),
  );
  if (res is bool && res) {
    onSuccess();
  }
}
