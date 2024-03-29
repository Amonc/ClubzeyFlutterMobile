import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../utils/fontSize.dart';
import '../utils/allColors.dart';
import 'labels.dart';

class FillButton extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;
  final Color? containerColor, textColor;
  final double? height, fontSize;
  final FontWeight? fontWeight;
  final double? width;

  const FillButton(
      {Key? key,
      required this.title,
      required this.onPressed,
      this.containerColor,
      this.textColor,
      this.height,
      this.fontWeight,
      this.fontSize,
      this.width})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
        padding: EdgeInsets.all(0),
        onPressed: onPressed,
        child: Container(
            width: width ?? null,
            padding: const EdgeInsets.symmetric(horizontal: 15),
            alignment: Alignment.center,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: containerColor??AllColors.liteBlue, width: 2),
                color: (containerColor ?? AllColors.liteBlue)
            ),
            height: height ?? 45,
            child: Label(
              text: title,
              color: textColor ?? AllColors.white,
              fontWeight: fontWeight ?? FontWeight.normal,
              fontSize: fontSize ?? FontSize.p1,
            )));
  }
}
