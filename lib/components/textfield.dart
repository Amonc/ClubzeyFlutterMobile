// ignore_for_file: prefer_const_constructors

import 'package:Clubzey/utils/zey_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../utils/fontSize.dart';
import '../utils/allColors.dart';

class CustomTextField extends StatelessWidget {
  final double? width;
  final String title;
  final FormFieldValidator validator;
  final TextInputType? textInputType;
  final TextEditingController? controller;
  final bool? isPassword;
  final InputBorder? border;
  final Icon? prefixIcon;
  final Widget ? suffixIcon;

  CustomTextField({
    Key? key,
    this.width,
    this.controller,
    required this.title,
    required this.validator,
    this.textInputType,
    this.isPassword,
    this.border,
    this.prefixIcon,
    this.suffixIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: isPassword ?? false,
      obscuringCharacter: "*",
      keyboardType: textInputType,
      controller: controller,
      cursorColor: AllColors.fontBlack,
      style: const TextStyle(
        fontSize: FontSize.p2,
        fontWeight: FontWeight.bold,
      ),
      decoration: InputDecoration(
        labelStyle:
            TextStyle(fontSize: FontSize.p4, fontWeight: FontWeight.w500),
        labelText: title,
        contentPadding: const EdgeInsets.only(bottom: 0, left: 10),
        errorStyle: TextStyle(fontSize: FontSize.p5),
        border: border,
        prefixIcon: prefixIcon,
       suffixIcon: suffixIcon,
      ),
      validator: validator,
    );
  }
}
