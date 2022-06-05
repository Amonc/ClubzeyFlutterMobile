import 'package:flutter/material.dart';

class AllColors {
  static const liteBlack = Color(0xff616161);
  static const grey = Color(0xff979EB1);
  static const white = Color(0xffFFFFFF);
  static const fontBlack = Color(0xff313339);
  static const yellow = Color(0xffF6CF34);
  static const liteGrey = Color(0xffE0E0E1);
  static const liteBlue = Color(0xff169CE7);

  static const List<Color> colors = [

    Color(0xffF6CF34),
    Color(0xff66DCA0),
    Color(0xff40A1A7),
    Color(0xff3300FF),
    Color(0xffA400E2),
    Color(0xffF64F34),
    Color(0xff615CA0),


  ];

  static final Map<int, Color> _liteBlueMap = {
    50: liteBlue.withOpacity(0.1),
    100: liteBlue.withOpacity(0.2),
    200: liteBlue.withOpacity(0.3),
    300: liteBlue.withOpacity(0.4),
    400: liteBlue.withOpacity(0.5),
    500: liteBlue.withOpacity(0.6),
    600: liteBlue.withOpacity(0.7),
    700: liteBlue.withOpacity(0.8),
    800: liteBlue.withOpacity(0.9),
    900: liteBlue.withOpacity(1.0),
  };

  static final MaterialColor liteBlueMaterialColor =
  MaterialColor(liteBlue.value, _liteBlueMap);
}

class AllGradient {
  static const LinearGradient greenGradient = LinearGradient(
      colors: [Color(0xff66DCA0), Color(0xff40A1A7)],
      begin: Alignment.bottomRight,
      end: Alignment.topLeft);
  static const LinearGradient ipGradient = LinearGradient(
      colors: [Color(0xff3300FF), Color(0xffA400E2)],
      begin: Alignment.centerRight,
      end: Alignment.centerLeft);
}

