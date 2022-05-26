import 'dart:io';

import 'package:Clubzey/components/custom_snackbar.dart';
import 'package:Clubzey/models/invitation_code.dart';
import 'package:Clubzey/utils/allColors.dart';
import 'package:Clubzey/views/dashboard.dart';
import 'package:Clubzey/views/create_invitation_code_page.dart';
import 'package:Clubzey/views/join_with_code_page.dart';
import 'package:Clubzey/views/qr_code_scanner.dart';
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
import 'clubs_page.dart';

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
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Label(
          text: "Create Club",
          fontWeight: FontWeight.bold,
          fontSize: FontSize.h4,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Center(
          child: Form(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomTextField(
                  title: "Club Name",
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
                const SizedBox(
                  height: 20,
                ),
                Container(
                  height: 60,
                  width: double.maxFinite,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    border: Border.all(color: Colors.blue),
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
                const Label(
                  text: 'Or',
                  fontSize: FontSize.p3,
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
