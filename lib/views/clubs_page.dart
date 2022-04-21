import 'dart:async';

import 'package:Clubzey/backend/datastore/club_data.dart';
import 'package:Clubzey/utils/note_slider.dart';
import 'package:Clubzey/views/club_details.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../components/labels.dart';
import '../models/club.dart';
import '../utils/fontSize.dart';

class ClubsPage extends StatelessWidget {
  ClubsPage({Key? key}) : super(key: key);
  // ignore: prefer_final_fields
  String _admin = FirebaseAuth.instance.currentUser!.email!;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: false,
        title: const Padding(
          padding: EdgeInsets.only(left: 16),
          child: Label(
            text: "Clubs",
            fontWeight: FontWeight.bold,
            fontSize: FontSize.h4,
          ),
        ),
      ),
      body: StreamBuilder(
        stream: ClubData().getAllClubs(admin: _admin),
        builder: (BuildContext context, AsyncSnapshot<List<Club>> snapshot) {
          List<Club> clubs = snapshot.data ?? [];

          return ListView.builder(
            itemCount: clubs.length,

            itemBuilder: (BuildContext context, int index) {
              return Column(
                children: [
                  NoteSlider(
                    club: clubs[index],
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  ClubDetails(id: clubs[index].getId, club: clubs[index],)));
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Divider(
                    thickness: 1.5,
                    color: Colors.black.withOpacity(0.1),
                  ),
                ],
              );
            },
          );
        },
      ),


    );
  }
}

class ClubItemCard extends StatefulWidget {

  final Club club;
  final VoidCallback onPressed;

  const ClubItemCard({
    Key? key,
    required this.club,
    required this.onPressed,
  }) : super(key: key);

  @override
  State<ClubItemCard> createState() => _ClubItemCardState();
}

class _ClubItemCardState extends State<ClubItemCard> {


  late Timer _timer;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    String drawIn = "";
    return CupertinoButton(
      onPressed: widget.onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Label(
                  text: "Name: ${widget.club.getName}",
                  fontSize: FontSize.h5,
                  fontWeight: FontWeight.w500,
                ),
                Label(
                  text: "Member: ${widget.club.getMembers.length}",
                  fontSize: FontSize.p2,
                  fontWeight: FontWeight.w500,
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Label(
                  text: "Amount: ${widget.club.getPerAmount.toString()}",
                  fontSize: FontSize.p2,
                  fontWeight: FontWeight.w500,
                ),

                Label(
                  text: "Draw in: $drawIn",
                  color: drawIn == "Draw ended" ? Colors.red : Colors.black,
                  fontSize: FontSize.p3,
                  fontWeight: FontWeight.w500,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
