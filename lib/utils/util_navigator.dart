import 'package:flutter/material.dart';

class UtilNavigator {
  GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  BuildContext get context => navigatorKey.currentContext!;

  Size get getSize => MediaQuery.of(context).size;

  String? get currentPage {
    String? route;
    nav.popUntil((routeState) {
      route = routeState.settings.name;
      return true;
    });
    return route;
  }

  NavigatorState get nav => Navigator.of(context);

  //navigator widget
  pushW(Widget w) => nav.push(_getRW(w));

  pushReplacementW(Widget w) => nav.pushReplacement(_getRW(w));

  //navigator extra
  popUntilName(String r) => nav.popUntil(ModalRoute.withName(r));

  popFirst() {
    while (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
  }

  Object? arguments(BuildContext context) =>
      ModalRoute.of(context)?.settings.arguments;

  //aux
  MaterialPageRoute _getRW(Widget w) => MaterialPageRoute(builder: (_) => w);
}
