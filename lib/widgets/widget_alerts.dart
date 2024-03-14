import 'package:wifi/docs.dart';
import 'package:flutter/material.dart';

alertMessage(
  BuildContext context, {
  String? message,
  String? title,
  Widget? imageFooter,
  Widget? imageHeader,
  String? titleBtnAgree,
  String? titleBtnCancel,
  bool barrierDismissible = false,
  bool isActions = false,
  Color borderColor = Colors.transparent,
  Function? onTap,
  Function? onTapCancel,
}) async {
  var val = await showDialog(
    context: context,
    barrierDismissible: barrierDismissible,
    builder: (BuildContext context) {
      return AlertDialog(
        contentPadding: const EdgeInsets.only(
          top: 10.0,
          bottom: 10.0,
          left: 15.0,
          right: 15.0,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
          side: BorderSide(
            color: borderColor,
            width: 2.5,
          ),
        ),
        content: SizedBox(
          width: 500.0,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const SizedBox(height: 10.0),
                imageHeader ?? Container(),
                if (title != null) ...[
                  Container(
                    alignment: Alignment.center,
                    child: Text(title),
                  ),
                  const SizedBox(height: 20.0),
                ],
                if (message != null) ...[
                  Text(
                    message,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16.0),
                  ),
                ],
                imageFooter ?? Container(),
                if (!isActions) ...[
                  const SizedBox(height: 20.0),
                  BtnC(
                    title: titleBtnAgree ?? 'Aceptar',
                    onTap: () {
                      if (onTap == null) {
                        Navigator.of(context).pop();
                      } else {
                        onTap();
                      }
                    },
                  ),
                  if (titleBtnCancel != null) ...[
                    const SizedBox(height: 10.0),
                    Container(
                      margin: const EdgeInsets.only(right: 15.0, left: 15.0),
                      child: BtnText(
                        titleBtnCancel,
                        onTap: () {
                          if (onTapCancel == null) {
                            Navigator.of(context).pop();
                          } else {
                            onTapCancel();
                          }
                        },
                      ),
                    ),
                  ],
                ],
              ],
            ),
          ),
        ),
        actionsAlignment: MainAxisAlignment.end,
        actionsPadding: const EdgeInsets.all(8.0),
        actions: !isActions
            ? null
            : [
                if (titleBtnCancel != null) ...[
                  BtnText(
                    titleBtnCancel,
                    onTap: () {
                      if (onTapCancel == null) {
                        Navigator.of(context).pop();
                      } else {
                        onTapCancel();
                      }
                    },
                  ),
                ],
                BtnText(
                  titleBtnAgree ?? 'Aceptar',
                  onTap: () {
                    if (onTap == null) {
                      Navigator.of(context).pop();
                    } else {
                      onTap();
                    }
                  },
                ),
              ],
      );
    },
  );
  return val;
}

alertChild(
  BuildContext context, {
  bool barrierDismissible = true,
  Widget? child,
}) async {
  return await showDialog(
    context: context,
    barrierDismissible: barrierDismissible,
    builder: (BuildContext context) {
      return AlertDialog(
        contentPadding: const EdgeInsets.all(10.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        content: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: child ?? Container(),
          ),
        ),
      );
    },
  );
}
