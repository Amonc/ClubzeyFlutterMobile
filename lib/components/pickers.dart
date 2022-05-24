import 'package:flutter/cupertino.dart';

import '../utils/fontSize.dart';
import 'labels.dart';

class SharePicker extends StatelessWidget {
  final int initialValue;
  final onSelectedItemChange;
  const SharePicker({Key? key, required this.initialValue, this.onSelectedItemChange}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoPicker(
      magnification: 1.2,
      itemExtent: 40,
      scrollController:
      FixedExtentScrollController(
          initialItem: initialValue),
      onSelectedItemChanged: onSelectedItemChange,
      children: List.generate(10, (v) => v)
          .toList()
          .map((e) => Label(
        text: (e + 1).toString(),
        fontSize: FontSize.h2,
      ))
          .toList(),
    );
  }
}
