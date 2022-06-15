// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:io';

import 'package:Clubzey/components/custom_snackbar.dart';
import 'package:Clubzey/models/invitation_code.dart';
import 'package:Clubzey/utils/allColors.dart';
import 'package:Clubzey/views/dashboard.dart';
import 'package:Clubzey/views/create_invitation_code_page.dart';
import 'package:Clubzey/views/join_with_code_page.dart';
import 'package:Clubzey/views/qr_code_scanner.dart';
import 'package:Clubzey/views/setting_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:uuid/uuid.dart';

import '../backend/dio/club_data.dart';
import '../components/buttons.dart';
import '../components/labels.dart';
import '../components/pickers.dart';
import '../components/textfield.dart';
import '../models/club.dart';
import '../utils/fontSize.dart';
import '../utils/zey_icons.dart';
import 'homepage.dart';

class CreateClub extends StatefulWidget {
  const CreateClub({Key? key}) : super(key: key);


  @override
  State<CreateClub> createState() => _CreateClubState();
}

class _CreateClubState extends State<CreateClub> {
  final _formKey = GlobalKey<FormState>();

  String _clubName = " ";

  double _perAmount = 0;

  DateTime? _drawDate;

  String _admin = FirebaseAuth.instance.currentUser!.email!;

  int _selectedValue = 0;



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: true,
        centerTitle: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Label(
              text: "Welcome !",
              fontWeight: FontWeight.normal,
              color: AllColors.fontGrey,
              fontSize: FontSize.p3,
            ),
            Label(
              text: "User Name",
              fontWeight: FontWeight.w500,
              color: AllColors.fontGrey,
              fontSize: FontSize.p1,
            ),
          ],
        ),
        actions: [
          CupertinoButton(
            padding: EdgeInsets.only(right: 20),
            minSize: 0,
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context)=> SettingPage()));
            },
            child: CircleAvatar(
                backgroundColor: AllColors.liteWhite,
                child: Icon(
                  ZeyIcons.ic_person,
                  color: AllColors.grey,
                )),
          ),
        ],
      ),
      body: SingleChildScrollView(

        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Form(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 80,),
                Label(
                  text: "Create Club !",
                  fontWeight: FontWeight.bold,
                  fontSize: FontSize.h1,
                ),
                SizedBox(height: 10,),
                Label(text: "Total members and prizemoney will be calculated and fixed on the first draw of a cycle. "
                    "A cycle ends when all the shareholders get paid."),
                SizedBox(height: 20,),
                CustomTextField(
                  title: "Club Name",
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue)
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your club name';
                    } else if (value.toString().length < 3) {
                      return 'Name must be 3 characters';
                    }
                    _clubName = value.toString().trim();
                    return null;
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                CustomTextField(
                  textInputType: TextInputType.number,
                  title: "Per Amount",

                  suffixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(

                        height: 45,
                        width: 1,
                        color: Colors.black.withOpacity(0.4),
                      ),
                      SizedBox(width: 10,),

                      Icon(ZeyIcons.ic_money, size: 20, color: Colors.black.withOpacity(0.7),),
                      SizedBox(width: 10,),
                    ],
                  ),
                  border: OutlineInputBorder(
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter Per Amount';
                    } else if (double.parse(value) < 100) {
                      return 'Amount must be at least 3 digits long';
                    }

                    try {
                      _perAmount = double.parse(value);
                    } catch (e) {
                      print("Unsupported character");
                    }

                    return null;
                  },
                ),

                 SizedBox(
                  height: 20,
                ),
                Container(
                  width: double.maxFinite,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    border: Border.all(color: AllColors.grey),
                    borderRadius: const BorderRadius.all(
                      const Radius.circular(5),
                    ),
                  ),
                  child: TextButton(

                    onPressed: () {
                      DatePicker.showDateTimePicker(context,
                          showTitleActions: true, onChanged: (date) {
                        print('change $date in time zone ' +
                            date.timeZoneOffset.inHours.toString());
                      }, onConfirm: (date) {
                        setState(() {
                          _drawDate = date;
                        });
                      }, currentTime: DateTime.now());
                    },
                    child: Text(
                      _drawDate == null
                          ? 'Select Draw Date'
                          : _drawDate.toString().substring(0, 10),
                      style: TextStyle(
                          color:
                              _drawDate == null ? Colors.blue : Colors.indigo,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                FillButton(
                    title: "Create",
                    fontWeight: FontWeight.bold,
                    containerColor: AllColors.liteBlue,
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        if (_drawDate == null) {
                          CustomSnackbar(
                                  context: context,
                                  text: 'Please select a draw date')
                              .show();
                        } else {
                          showMaterialModalBottomSheet(
                            context: context,
                            builder: (context) => Container(
                              height: 400,
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Label(
                                    text: 'Select your shares',
                                    fontSize: FontSize.h4,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Expanded(
                                    child: SharePicker(
                                      initialValue: _selectedValue,
                                      onSelectedItemChange: (int value) {
                                        setState(() {
                                          _selectedValue = value;
                                          print(_selectedValue);
                                        });
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    height: 50,
                                  ),
                                  CupertinoButton(
                                      onPressed: () {
                                        Club club = Club(data: {
                                          "name": _clubName,
                                          "perAmount": _perAmount,
                                          "drawDate": _drawDate,
                                          "members": [_admin],
                                          "createdAt": DateTime.now(),
                                          "createdBy": _admin,
                                        });
                                        var id = const Uuid().v4();
                                        club.setId = id;
                                        ClubData().createClub(
                                            club: club,
                                            shares: _selectedValue + 1);

                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    Dashboard()));
                                      },
                                      padding: EdgeInsets.all(0),
                                      child: Label(
                                        text: 'Continue',
                                        fontSize: FontSize.h4,
                                        fontWeight: FontWeight.bold,
                                      )),
                                  SizedBox(
                                    height: 50,
                                  ),
                                ],
                              ),
                            ),
                          );
                        }
                      }
                    }),
                const SizedBox(
                  height: 10,
                ),

                const SizedBox(
                  height: 10,
                ),
               if(Platform.isAndroid || Platform.isIOS ) FillButton(
                  title: "Join using scanner",
                  containerColor: AllColors.fontBlack,
                  onPressed: () {


                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                Platform.isAndroid && Platform.isIOS
                                    ? QrCodeScanner()
                                    : JoinWithCodePage()
                                       ));
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                FillButton(
                  title: "Join using invitation code",
                  containerColor: AllColors.fontBlack,
                  onPressed: () {

                    Navigator.push(context, MaterialPageRoute(builder: (context)=>JoinWithCodePage()));



                  },
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
