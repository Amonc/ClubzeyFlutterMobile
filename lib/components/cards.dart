import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../utils/fontSize.dart';
import '../utils/helper.dart';
import 'avatars.dart';
import 'labels.dart';

class TransactionCard extends StatelessWidget {
  const TransactionCard({
    Key? key,
    required this.cycle,
    required this.transId,
    required this.amount,
    required this.createdAt,
  }) : super(key: key);

  final int cycle;
  final String transId;
  final double amount;
  final DateTime createdAt;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        child: Row(
          children: [
            Container(
                height: 60,
                width: 60,
                child: LetterAvatar(
                  color: Colors.grey,
                  letter: cycle.toString(),
                  fontSize: FontSize.h3,
                )),
            SizedBox(
              width: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Label(
                  text: 'Transaction ID',
                  fontSize: FontSize.p2,
                  fontWeight: FontWeight.w500,
                ),
                Label(
                  text: transId,
                  fontSize: FontSize.p4,
                  fontWeight: FontWeight.w300,
                ),
              ],
            ),
            Spacer(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Label(
                  text:
                  "${Helper().getFormattedTime(dateTime: createdAt)}  |  ${Helper().getFormattedDateTime(dateTime: createdAt)}",
                  fontSize: FontSize.p5,
                  fontWeight: FontWeight.w500,
                ),
                SizedBox(
                  height: 10,
                ),
                Label(
                  text: amount.toString(),
                  fontSize: FontSize.p2,
                  fontWeight: FontWeight.w500,
                  color: amount>0?Colors.teal:Colors.red,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}