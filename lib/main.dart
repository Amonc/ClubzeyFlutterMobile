import 'package:Clubzey/backend/hive_data.dart';
import 'package:Clubzey/utils/allColors.dart';
import 'package:Clubzey/utils/fontSize.dart';
import 'package:Clubzey/views/dashboard.dart';
import 'package:Clubzey/views/login_page.dart';

import 'package:Clubzey/views/splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';

import 'components/labels.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final PendingDynamicLinkData? initialLink = await FirebaseDynamicLinks.instance.getInitialLink();
  print(initialLink);

  runApp(Clubzey());
}

class Clubzey extends StatefulWidget {
  Clubzey({Key? key}) : super(key: key);

  @override
  State<Clubzey> createState() => _ClubzeyState();
}

class _ClubzeyState extends State<Clubzey> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    receiveDynamiclink();

  }
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Clubzey',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: SplashScreen(),
    );
  }

  void receiveDynamiclink() {

  }


}
