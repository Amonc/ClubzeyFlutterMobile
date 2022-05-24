import 'package:Clubzey/backend/dio/club_data.dart';
import 'package:Clubzey/backend/dio/send_invitation_code_data.dart';
import 'package:Clubzey/backend/hive_data.dart';
import 'package:Clubzey/utils/fontSize.dart';
import 'package:Clubzey/views/club_details.dart';
import 'package:Clubzey/views/clubs_page.dart';
import 'package:Clubzey/views/setting_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';

import '../components/labels.dart';
import '../models/invitation_code.dart';
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

    TopicSubscription().calculateSubscription();
    initMessaging();


    

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
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
            BottomNavigationBarItem(icon: Icon(Icons.home), label: ""),
            BottomNavigationBarItem(icon: Icon(Icons.settings), label: ""),
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
    var email = FirebaseAuth.instance.currentUser!.email;
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print(message.data);
      showOverlayNotification((context) {
        return NotificationBadge(
          title: message.notification!.title.toString(),
          body: message.data["userEmail"] == email?message.notification!.body.toString().replaceAll(message.data['username'], "You").replaceAll("has", "have"):message.notification!.body.toString(),
          icon: CupertinoIcons.bell,
          onPressed: () {
            if (message.data["userEmail"] == email) {
              if (message.data["added"] == "true") {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            ClubDetails(clubId: message.data["clubId"])));
              }
            }else{
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          ClubDetails(clubId: message.data["clubId"])));
            }
          },
        );
      }, duration: Duration(milliseconds: 4000));

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }
    });
  }

  updateFcmToken({required String token}) {
    String email = FirebaseAuth.instance.currentUser!.email!;
    FirebaseFirestore.instance
        .collection("userData")
        .doc(email)
        .update({"token": token});
  }
}

class NotificationBadge extends StatelessWidget {
  const NotificationBadge({
    Key? key,
    required this.title,
    required this.body,
    required this.icon,
    required this.onPressed,
  }) : super(key: key);

  final String title, body;
  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      onPressed: onPressed,
      padding: EdgeInsets.all(0),
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        child: SafeArea(
          child: Row(
            children: [
              SizedBox(
                width: 60,
                height: 60,
                child: Center(
                  child: Icon(
                    icon,
                    size: 30,
                    color: Colors.black,
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Label(text: title, fontWeight: FontWeight.bold),
                    Label(
                      text: body,
                      fontSize: FontSize.p4,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
