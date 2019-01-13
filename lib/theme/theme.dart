import 'package:flutter/material.dart';




class MTTheme{

  static const MaterialColor LightTheme = const MaterialColor(
    0x000000,
     const <int, Color>{
      50:  const Color(0xEEEEEE),
      100: const Color(0xEEEEEE),
      200: const Color(0xEEEEEE),
      300: const Color(0xEEEEEE),
      400: const Color(0xEEEEEE),
      500: const Color(0xFFFFFF),
      600: const Color(0xFFFFFF),
      700: const Color(0xFFFFFF),
      800: const Color(0xFFFFFF),
      900: const Color(0xFFFFFF),
    },

  );

  static const lagerTextSize = 30.0;
  static const bigTextSize = 23.0;
  static const normalTextSize = 18.0;
  static const middleTextWhiteSize = 16.0;
  static const smallTextSize = 14.0;
  static const minTextSize = 12.0;

static const LightText = TextStyle(
    color: Color(0xFFFFFF),
    fontSize: normalTextSize,
  );

}


