// ignore_for_file: prefer_const_constructors

import 'package:Clubzey/backend/dio/send_invitation_code_data.dart';
import 'package:Clubzey/components/buttons.dart';
import 'package:Clubzey/utils/allColors.dart';
import 'package:Clubzey/utils/fontSize.dart';
import 'package:Clubzey/utils/timer.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import '../components/labels.dart';
import '../models/club.dart';

class CreateInvitationPage extends StatefulWidget {
  CreateInvitationPage({Key? key, required this.club, required this.shares})
      : super(key: key);
  final Club club;
  final shares;

  @override
  State<CreateInvitationPage> createState() => _CreateInvitationPageState();
}

class _CreateInvitationPageState extends State<CreateInvitationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Center(
        child: FutureBuilder(
          future: InvitationCodeData()
              .createInvitationCode(club: widget.club, shares: widget.shares),
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Label(
                  text: "One time invitation code",
                  fontWeight: FontWeight.w600,
                ),

                SelectableText(
                  snapshot.data ?? '',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: FontSize.h3,
                      color: Colors.indigoAccent),
                ),
                StreamBuilder(
                  stream: CustomTimer().countStream(30),
                  builder: (BuildContext context, AsyncSnapshot<int> timerSnapshot) {
                    return Column(
                      children: [
                        RichText(
                          text: TextSpan(
                            text: 'Reload after ',
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: FontSize.p1,
                                color: Colors.black),
                            children: <TextSpan>[
                              TextSpan(
                                  text: '${timerSnapshot.data ?? 30} ',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: FontSize.h5,
                                      color: Colors.red)),
                              TextSpan(
                                text: ' seconds',
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: FontSize.p1,
                                    color: Colors.black),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        snapshot.data == 0
                            ? FillButton(
                                width: 130,
                                height: 40,
                                containerColor: Colors.orange.withOpacity(0.4),
                                title: "Reload",
                                onPressed: () {
                                  setState(() {});
                                })
                            : SizedBox(),
                      ],
                    );
                  },
                ),
                SizedBox(
                  height: 30,
                ),
                FillButton(
                    width: 300,
                    height: 40,
                    containerColor: Colors.blue,
                    title: "Send invitation code",
                    onPressed: () {
                      Share.share('${snapshot.data}');
                    }),
              ],
            );
          },
        ),
      ),
    );
  }
}
