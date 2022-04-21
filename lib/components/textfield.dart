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
  final bool ? isPassword;



  const CustomTextField({Key? key,  this.width, this.controller, required this.title, required this.validator, this.textInputType, this.isPassword, })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: isPassword??false,
      obscuringCharacter: "*",
      keyboardType: textInputType,
      controller: controller,
      cursorColor: AllColors.fontBlack,
      style: const TextStyle(
        fontSize: FontSize.p2,
        fontWeight: FontWeight.bold,
      ),
      decoration: InputDecoration(
        labelText: title,
        contentPadding: const EdgeInsets.only(bottom:0),
        errorStyle: TextStyle(fontSize: FontSize.p5),





      ),
      validator: validator,
    );
  }
}
