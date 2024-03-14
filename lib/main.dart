import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:provider/provider.dart';
import 'package:wifi/docs.dart';

//navigators
UtilNavigator utilNavG = UtilNavigator();

NavigatorState get navG => utilNavG.nav;

BuildContext get contextG => utilNavG.context;

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  //vertical screen
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  var route = await initSession();
  runApp(MyApp(route));
}

class MyApp extends StatefulWidget {
  final String route;

  const MyApp(this.route, {super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    UtilInfoDevice.getAllInfoDevice();
    FlutterNativeSplash.remove();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: providers,
      child: MaterialApp(
        title: 'Wifi',
        debugShowCheckedModeBanner: false,
        navigatorKey: utilNavG.navigatorKey,
        initialRoute: widget.route,
        routes: routes,
        themeMode: ThemeMode.dark,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: UtilTheme.primary,
            brightness: Brightness.light,
          ),
          primarySwatch: getMaterialColor(UtilTheme.primary),
          primaryColor: UtilTheme.primary,
        ),
        darkTheme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: UtilTheme.primary,
            brightness: Brightness.dark,
          ),
          primarySwatch: getMaterialColor(UtilTheme.primary),
          primaryColor: UtilTheme.primary,
        ),
        builder: (_, child) => PageGlobal(
          child: child,
          onChangeTheme: () => setState(() {}),
        ),
      ),
    );
  }
}

printC(dynamic obj){
  debugPrint("________________________");
  debugPrint("$obj");
  debugPrint("________________________");
}