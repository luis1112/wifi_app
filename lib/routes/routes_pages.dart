import 'package:wifi/docs.dart';
import 'package:flutter/material.dart';

Map<String, WidgetBuilder> get routes => <String, WidgetBuilder>{
      PageLogin.route: (_) => const PageLogin(),
      PageInit.route: (_) => const PageInit(),
  PageInform.route: (_) => const PageInform(),
    };
