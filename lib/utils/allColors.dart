import 'package:flutter/material.dart';

class AllColors {
  static const liteBlack = Color(0xff666666);
  static const grey = Color(0xff979EB1);
  static const white = Color(0xffFFFFFF);
  static const fontBlack = Color(0xff313339);
  static const yellow = Color(0xffF6CF34);
  static const liteGrey = Color(0xffE0E0E1);

  static const List<Color> colors = [

    Color(0xffF6CF34),
    Color(0xff66DCA0),
    Color(0xff40A1A7),
    Color(0xff3300FF),
    Color(0xffA400E2),
    Color(0xffF64F34),
    Color(0xff615CA0),


  ];
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
