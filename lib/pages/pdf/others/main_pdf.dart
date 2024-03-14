import 'package:flutter/material.dart';
import 'package:wifi/docs.dart';

class MainPdf extends StatelessWidget {
  final Widget? child;

  const MainPdf({super.key, this.child});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wifi',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.light,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: UtilTheme.primary,
          brightness: Brightness.light,
        ),
        primarySwatch: getMaterialColor(UtilTheme.primary),
        primaryColor: UtilTheme.primary,
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: UtilTheme.primary,
          brightness: Brightness.dark,
        ),
        primarySwatch: getMaterialColor(UtilTheme.primary),
        primaryColor: UtilTheme.primary,
      ),
      home: Scaffold(body: child ?? Container()),
    );
  }
}
