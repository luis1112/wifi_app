import 'package:wifi/docs.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

ProviderGlobal get pvG => ProviderGlobal.of();

class ProviderGlobal with ChangeNotifier {
  static ProviderGlobal of([BuildContext? context, bool listen = false]) {
    return Provider.of<ProviderGlobal>(context ?? contextG, listen: listen);
  }

  notify() => notifyListeners();


  bool isDialogAlert = false;


  showMessage(
    String? message, {
    String? messageAlter,
    Function? onTap,
    String replaceFrom = "",
    String replace = "",
    String? title,
    Widget? imageFooter,
    Widget? imageHeader,
    String? titleBtnAgree,
  }) async {
    String messageNow = messageAlter ?? (message ?? errorMessage);
    messageNow = messageNow.replaceAll(replaceFrom, replace);
    if (messageNow.trim().isEmpty) messageNow = errorMessage;
    onLoad(false);
    if (!isDialogAlert) {
      isDialogAlert = true;
      await alertMessage(
        contextG,
        message: messageNow,
        borderColor: Colors.transparent,
        titleBtnAgree: titleBtnAgree,
        title: title,
        imageFooter: imageFooter,
        imageHeader: imageHeader,
        isActions: true,
        onTap: () async {
          if (onTap != null) {
            onTap();
          } else {
            navG.pop();
          }
        },
      );
      isDialogAlert = false;
    }
  }



}
