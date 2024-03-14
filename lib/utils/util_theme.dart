import 'package:flutter/material.dart';

class UtilTheme {
  static Color primary = const Color.fromRGBO(74, 157, 34, 1);
  static Color second = const Color.fromRGBO(74, 157, 34, 1);
  static Color cardBlack = const Color.fromRGBO(36, 44, 51, 1);
  static Color cardYellow = const Color.fromRGBO(255, 214, 0, 1);
  static Color cardGrey = const Color.fromRGBO(55, 73, 87, 1);
  static Color borderBottom = primary.withOpacity(0.4);
  static Color blue = const Color.fromRGBO(0, 77, 172, 1.0);

  static Color dark = const Color(0xFF2C2948);
  static Color lineColorSpace = const Color(0xFFD2D1D7);

  //charts
  static const Color contentColorBlue = Color(0xFF2196F3);
  static const Color contentColorPink = Color(0xFFFF3AF2);
}

ThemeMode themeModeApp = ThemeMode.light;

Brightness brightness(context) => Theme.of(context).brightness;

bool brightnessLight(context) => brightness(context) == Brightness.light;

Color colorBrightness(context) =>
    brightnessLight(context) ? Colors.black : Colors.white;

MaterialColor getMaterialColor(Color color) {
  final int red = color.red;
  final int green = color.green;
  final int blue = color.blue;

  final Map<int, Color> shades = {
    50: Color.fromRGBO(red, green, blue, .1),
    100: Color.fromRGBO(red, green, blue, .2),
    200: Color.fromRGBO(red, green, blue, .3),
    300: Color.fromRGBO(red, green, blue, .4),
    400: Color.fromRGBO(red, green, blue, .5),
    500: Color.fromRGBO(red, green, blue, .6),
    600: Color.fromRGBO(red, green, blue, .7),
    700: Color.fromRGBO(red, green, blue, .8),
    800: Color.fromRGBO(red, green, blue, .9),
    900: Color.fromRGBO(red, green, blue, 1),
  };
  return MaterialColor(color.value, shades);
}

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) hexColor = "FF$hexColor";
    int result = int.parse(hexColor, radix: 16);
    return result;
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}
