import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

final ThemeData appTheme = new ThemeData(
    brightness: Brightness.light,
    primarySwatch: MaterialColor(0xFF00E676, AppColors.color),
    primaryColor: MaterialColor(0xFF00E676, AppColors.color),
    primaryColorBrightness: Brightness.light,
    accentColor: Colors.white,
    accentColorBrightness: Brightness.light,
    textSelectionHandleColor: Color(0xFF00E676),
    textSelectionColor: Colors.black12,
    cursorColor: Color(0xFF00E676));

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

const Map<String, Color> AppColorPalette = {
  "primaryGreen": Color(0xFF00E676),
  "defaultAccent": Color(0xFF666666),
  "default": Color(0xFF66666F)
};

/// App Text styles definition
class AppTextStyle {
  TextStyle _homeTitle = TextStyle(
      fontSize: 35.0,
      fontWeight: FontWeight.bold,
      color: AppColorPalette["defaultAccent"]);
  TextStyle _homeTitleLight =
      TextStyle(fontSize: 35.0, color: AppColorPalette["defaultAccent"]);
  TextStyle _appBarTitle =
      TextStyle(fontSize: 22.0, color: AppColorPalette["defaultAccent"]);
  TextStyle _homeTitleAccent = TextStyle(
      fontSize: 35.0,
      fontWeight: FontWeight.bold,
      color: AppColorPalette["primaryGreen"]);
  TextStyle _body =
      TextStyle(fontSize: 17.0, color: AppColorPalette["default"]);
  TextStyle _bodyStrong = TextStyle(
      fontSize: 17.0,
      fontWeight: FontWeight.w700,
      color: AppColorPalette["default"]);
  TextStyle _cardTitle = TextStyle(
      fontSize: 18.0,
      color: AppColorPalette["default"],
      fontWeight: FontWeight.w500);
  TextStyle _cardTitleStrong = TextStyle(
      fontSize: 18.0,
      color: AppColorPalette["default"],
      fontWeight: FontWeight.w700);
  TextStyle _cardSubtitle =
      TextStyle(fontSize: 15.0, color: AppColorPalette["default"]);
  TextStyle _cardSubtitleUnderlined = TextStyle(
      fontSize: 15.0,
      decoration: TextDecoration.underline,
      color: AppColorPalette["default"]);
  TextStyle _cardTrailingAccent = TextStyle(
      fontSize: 14.0,
      color: AppColorPalette["default"],
      fontWeight: FontWeight.w700);
  TextStyle _cardTrailing =
      TextStyle(fontSize: 14.0, color: AppColorPalette["default"]);
  TextStyle _cardTrailingBig =
      TextStyle(fontSize: 16.0, color: AppColorPalette["default"]);
  TextStyle _cardTrailingTiny =
      TextStyle(fontSize: 13.0, color: AppColorPalette["default"]);
  TextStyle _cardTrailingTinyUnderlined = TextStyle(
      fontSize: 13.0,
      decoration: TextDecoration.underline,
      color: AppColorPalette["default"]);
  TextStyle _cardTrailingTinyStrong = TextStyle(
      fontSize: 13.0,
      fontWeight: FontWeight.w700,
      color: AppColorPalette["default"]);
  TextStyle _textButton = TextStyle(fontSize: 15.0, color: Colors.white);
  TextStyle _alertTitle = TextStyle(
      fontSize: 20.0,
      fontWeight: FontWeight.w500,
      color: AppColorPalette["default"]);

  /// Define getters
  TextStyle get homeTitle {
    return _homeTitle;
  }

  TextStyle get appBarTitle {
    return _appBarTitle;
  }

  TextStyle get homeTitleLight {
    return _homeTitleLight;
  }

  TextStyle get homeTitleAccent {
    return _homeTitleAccent;
  }

  TextStyle get body {
    return _body;
  }

  TextStyle get bodyStrong {
    return _bodyStrong;
  }

  TextStyle get cardTitle {
    return _cardTitle;
  }

  TextStyle get cardTitleStrong {
    return _cardTitleStrong;
  }

  TextStyle get cardSubtitle {
    return _cardSubtitle;
  }

  TextStyle get cardSubtitleUnderlined {
    return _cardSubtitleUnderlined;
  }

  TextStyle get cardTrailingAccent {
    return _cardTrailingAccent;
  }

  TextStyle get cardTrailing {
    return _cardTrailing;
  }

  TextStyle get cardTrailingBig {
    return _cardTrailingBig;
  }

  TextStyle get cardTrailingTiny {
    return _cardTrailingTiny;
  }

  TextStyle get cardTrailingTinyStrong {
    return _cardTrailingTinyStrong;
  }

  TextStyle get cardTrailingTinyUnderlined {
    return _cardTrailingTinyUnderlined;
  }

  TextStyle get textButton {
    return _textButton;
  }

  TextStyle get alertTitle {
    return _alertTitle;
  }
}
