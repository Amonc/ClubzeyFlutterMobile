

import 'package:Clubzey/backend/dio/club_data.dart';
import 'package:Clubzey/views/clubs_page.dart';
import 'package:Clubzey/views/setting_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';


import '../utils/allColors.dart';
import 'create_club.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
// initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project




   List<Widget> _pages = [
     ClubsPage(),
     SettingPage(),
   ];
  onDidReceiveLocalNotification(
      int id, String title, String body, String payload) async {
    // display a dialog with the notification details, tap ok to go to another page
    showDialog(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Text(title),
        content: Text(body),

      ),
    );
  }
  int _selectedIndex = 0;

@override
  void initState() {
    // TODO: implement initState
    super.initState();


    initMessaging();

    FirebaseDynamicLinks.instance.onLink.listen((dynamicLinkData) {
  String dynamiclinkdata=dynamicLinkData.link.path.replaceAll('/', '');
  print(dynamiclinkdata);
  List<String> data=dynamiclinkdata.split("*");

  ClubData().addMember(clubId: data[0], shares: int.parse(data[1]));

    }).onError((error) {
      print(error.toString());
    });


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex] ,
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.teal,
          type: BottomNavigationBarType.fixed,
          onTap: (int index) {
            setState(() {
              _selectedIndex = index;
            });
          },

          selectedItemColor: AllColors.white,
          unselectedItemColor: Colors.black.withOpacity(0.4),
          currentIndex: _selectedIndex,
          showSelectedLabels: false,
          showUnselectedLabels: false,

          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: ""

            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: ""


            ),
          ]),
      floatingActionButton: FloatingActionButton(
        elevation: 0,
        backgroundColor: Colors.green,
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const CreateClub()));
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Future<void> initMessaging() async {
    // var token= await  FirebaseMessaging.instance.getToken();
    // updateFcmToken(token: token!);



    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }
    });


  }

  updateFcmToken({required String token}){
  String email=FirebaseAuth.instance.currentUser!.email!;
  FirebaseFirestore.instance.collection("userData").doc(email).update({"token":token});

  }
}
