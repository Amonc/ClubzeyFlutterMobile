

import 'package:Clubzey/views/clubs_page.dart';
import 'package:Clubzey/views/setting_page.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

import 'package:flutter/material.dart';

import '../utils/allColors.dart';
import 'create_club.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {

   List<Widget> _pages = [
     ClubsPage(),
     SettingPage(),
   ];

  int _selectedIndex = 0;

@override
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseDynamicLinks.instance.onLink.listen((dynamicLinkData) {
       print( dynamicLinkData.link.path);
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
}
