
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../utils/allColors.dart';
import 'labels.dart';



class CustomSnackbar {
  final BuildContext context;
  final String text;


  CustomSnackbar({required this.context, required this.text});

// Find the ScaffoldMessenger in the widget tree
// and use it to show a SnackBar.
  show(){
    final snackBar = SnackBar(
        backgroundColor: AllColors.fontBlack,
        content: Label(text: this.text, color: AllColors.white, ));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}