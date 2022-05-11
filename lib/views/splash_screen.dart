
import 'package:Clubzey/utils/allColors.dart';
import 'package:Clubzey/views/dashboard.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../components/labels.dart';
import '../utils/fontSize.dart';
import 'login_page.dart';




class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _checkLoggedIn();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(

      body: Padding(
        padding: EdgeInsets.all(24),
        child: Center(
          child: Label(
            text: "Clubzey",
            fontSize: FontSize.h1,
            fontWeight: FontWeight.w600,
            color: AllColors.fontBlack,
          ),
        ),
      ),
    );
  }

  _checkLoggedIn() async {
    NotificationSettings settings = await FirebaseMessaging.instance.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    print('User granted permission: ${settings.authorizationStatus}');
    // _initDynamicLinks(context);
    var user = FirebaseAuth.instance.currentUser;
    await Future.delayed(Duration(seconds: 1));
    if (user != null) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => Dashboard()),
              (route) => false);
    } else {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
              (route) => false);
    }
  }
}