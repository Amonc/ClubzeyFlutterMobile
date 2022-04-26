import 'dart:ui';

import 'package:Clubzey/utils/fontSize.dart';
import 'package:flutter/material.dart';

import '../backend/auth/model/clubzey_user.dart';
import 'labels.dart';

class LetterAvatar extends StatelessWidget {
  const LetterAvatar({
    Key? key,
    required this.color,
 this.fontSize, required this.letter,
  }) : super(key: key);

  final Color color;

  final double? fontSize;
  final String letter;



  @override
  Widget build(BuildContext context) {
    return CircleAvatar(

      backgroundColor: color.withOpacity(0.25),
      child: FittedBox(

        child: Label(

          text: letter.toUpperCase(),
          fontWeight: FontWeight.w900,
          fontSize: fontSize??FontSize.p1,

          color: color,
        ),
      ),
    );
  }
}