import 'dart:ui';

import 'package:flutter/material.dart';

import '../backend/auth/model/clubzey_user.dart';
import 'labels.dart';

class LetterAvatar extends StatelessWidget {
  const LetterAvatar({
    Key? key,
    required this.color,
    required this.user,
  }) : super(key: key);

  final Color color;
  final ClubzeyUser user;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: color.withOpacity(0.25),
      child: Label(
        text: user.getUsername
            .substring(0, 1)
            .toUpperCase(),
        fontWeight: FontWeight.w900,
        color: color,
      ),
    );
  }
}