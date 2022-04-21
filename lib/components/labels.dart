import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Label extends StatelessWidget {
  final String text;
  final double? fontSize;

  final FontWeight? fontWeight;
  final int? maxLine;
  final TextOverflow? overflow;
  final TextAlign? align;
  final Color? color;

  const Label(
      {Key? key,
      required this.text,
      this.fontSize,
      this.fontWeight,
      this.align,
      this.color,
      this.maxLine,
      this.overflow,})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
        style: TextStyle(),
        child: Text(this.text,
            maxLines: this.maxLine ?? 50,
            overflow: overflow ?? TextOverflow.visible,
            textAlign: align ?? TextAlign.left,
            style: TextStyle(
                fontSize: this.fontSize ?? 14,
                fontWeight: this.fontWeight ?? FontWeight.normal,
                color: this.color ?? Colors.black)));
  }
}
