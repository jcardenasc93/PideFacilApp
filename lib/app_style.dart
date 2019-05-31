import 'package:flutter/material.dart';

final ThemeData AppTheme = new ThemeData(
  brightness: Brightness.light,
  primarySwatch: MaterialColor(0xFF58B368, AppColors.color),
  primaryColor: MaterialColor(0xFF58B368, AppColors.color),
  primaryColorBrightness: Brightness.light,
  accentColor: Colors.white,
  accentColorBrightness: Brightness.light,
);

class AppColors {
  AppColors._();

  static Map<int, Color> color = {
    50: Color.fromRGBO(136, 14, 79, .1),
    100: Color.fromRGBO(136, 14, 79, .2),
    200: Color.fromRGBO(136, 14, 79, .3),
    300: Color.fromRGBO(136, 14, 79, .4),
    400: Color.fromRGBO(136, 14, 79, .5),
    500: Color.fromRGBO(136, 14, 79, .6),
    600: Color.fromRGBO(136, 14, 79, .7),
    700: Color.fromRGBO(136, 14, 79, .8),
    800: Color.fromRGBO(136, 14, 79, .9),
    900: Color.fromRGBO(136, 14, 79, 1),
  };
}
