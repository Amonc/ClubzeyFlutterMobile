import 'package:Clubzey/utils/allColors.dart';
import 'package:Clubzey/views/qr_code_scanner.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:uuid/uuid.dart';

import '../backend/datastore/club_data.dart';
import '../components/buttons.dart';
import '../components/labels.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
                          color: _drawDate == null ? Colors.blue : Colors.indigo,
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
                        ClubData().createClub(club: club);

                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ClubsPage()));
                      }
                    }),
                const SizedBox(height: 10,),
                const Label(text: 'Or',fontSize: FontSize.p3,),
                const SizedBox(height: 10,),

                FillButton(title: "Join Club", containerColor: AllColors.fontBlack,onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> QrCodeScanner()));
                },)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
