import 'package:Clubzey/backend/dio/club_data.dart';
import 'package:Clubzey/backend/dio/send_invitation_code_data.dart';
import 'package:Clubzey/components/buttons.dart';
import 'package:Clubzey/components/labels.dart';
import 'package:Clubzey/models/invitation_code.dart';
import 'package:Clubzey/utils/fontSize.dart';
import 'package:Clubzey/views/dashboard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pinput/pinput.dart';

import '../models/club.dart';

class JoinWithCodePage extends StatefulWidget {
  JoinWithCodePage({
    Key? key,
  }) : super(key: key);



  @override
  State<JoinWithCodePage> createState() => _JoinWithCodePageState();
}

class _JoinWithCodePageState extends State<JoinWithCodePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Label(
                text: "Enter your invitation code",
                fontSize: FontSize.h4,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
              SizedBox(
                height: 30,
              ),
              Pinput(
                inputFormatters: [ UpperCaseTextFormatter(),],
                  length: 8,


                  keyboardType: TextInputType.text,


                  onCompleted: (val) async {
                    Map<String ,dynamic>? data = (await InvitationCodeData().checkInvitationCode(invitationCode: val.toUpperCase()));

                   if(data!=null){
                   await  ClubData().addMember(clubId: data['clubId'], shares: data['shares']);
                   await FirebaseFirestore.instance.collection("invitationRoom").doc(data['id']).delete();



                   Navigator.push(context, MaterialPageRoute(builder: (context)=>Dashboard()));


                   }else{

                     print('not Correct');

                   }



                  }),

            ],
          ),
        ),
      ),
    );
  }
}
class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}