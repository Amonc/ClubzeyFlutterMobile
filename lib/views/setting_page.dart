import 'package:Clubzey/components/labels.dart';
import 'package:Clubzey/utils/allColors.dart';
import 'package:Clubzey/utils/fontSize.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'login_page.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        elevation: 0,
        centerTitle: true,
        title: const Padding(
          padding: EdgeInsets.only(right: 16),
          child: Label(
            text: "Setting",
            fontWeight: FontWeight.bold,
            fontSize: FontSize.h4,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Center(
          child: CupertinoButton(
              onPressed: () {
                _logout(context);
              },
              color: Colors.teal.withOpacity(0.7),
              alignment: Alignment.center,
              child: const Label(
                text: "Log out",
                color: Colors.white,
                fontSize: FontSize.p1,
              )),
        ),
      ),
    );

  }
  Future _logout(context) async {
    await FirebaseAuth.instance.signOut().then((value) =>
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => LoginPage()),
                (route) => false));
  }
}
