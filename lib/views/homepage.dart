// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:async';

import 'package:Clubzey/backend/dio/club_data.dart';
import 'package:Clubzey/utils/note_slider.dart';
import 'package:Clubzey/views/club_details.dart';
import 'package:Clubzey/views/create_club.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../components/labels.dart';
import '../models/club.dart';
import '../utils/allColors.dart';
import '../utils/fontSize.dart';
import '../utils/zey_icons.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);
  // ignore: prefer_final_fields
  String _admin = FirebaseAuth.instance.currentUser!.email!;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: false,
        title: Padding(
          padding: EdgeInsets.only(left: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
        ),
        actions: [
          CupertinoButton(
            padding: EdgeInsets.only(right: 20),
            minSize: 0,
            onPressed: () {},
            child: CircleAvatar(
                backgroundColor: AllColors.liteWhite,
                child: Icon(
                  ZeyIcons.ic_person,
                  color: AllColors.grey,
                )),
          ),
        ],
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: SizedBox()),
              CupertinoButton(
                padding: EdgeInsets.all(0),
                minSize: 0,
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => CreateClub()));
                },
                child: Stack(
                  children: [
                    SvgPicture.asset("assets/images/ic_blue_container.svg"),
                    Positioned(
                      top: 0,
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                              width: 80,
                              child: Label(
                                text: "Create Club",
                                color: AllColors.white,
                                fontWeight: FontWeight.bold,
                              )),
                          SizedBox(
                            width: 10,
                          ),
                          Icon(
                            ZeyIcons.ic_create_club,
                            color: AllColors.white,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Expanded(child: SizedBox()),
              CupertinoButton(
                padding: EdgeInsets.all(0),
                minSize: 0,
                onPressed: () {},
                child: Stack(
                  children: [
                    SvgPicture.asset("assets/images/ic_grey_container.svg"),
                    Positioned(
                      top: 0,
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Label(
                            text: "Join",
                            color: AllColors.fontGrey,
                            fontWeight: FontWeight.bold,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Icon(
                            ZeyIcons.ic_join_club,
                            color: AllColors.fontGrey,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Expanded(child: SizedBox()),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Label(
                text: "My Clubs",
                color: AllColors.fontGrey,
                fontWeight: FontWeight.w500,
              ),
              CupertinoButton(
                  padding: EdgeInsets.all(0),
                  minSize: 0,
                  onPressed: () {},
                  child: Icon(
                    Icons.edit,
                    color: AllColors.fontGrey,
                  )),
            ],
          ),
          Expanded(
            child: StreamBuilder(
              stream: ClubData().getAllClubs(admin: _admin),
              builder:
                  (BuildContext context, AsyncSnapshot<List<Club>> snapshot) {
                List<Club> clubs = snapshot.data ?? [];

                return ListView.builder(
                  itemCount: clubs.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      children: [
                        ClubItemCard(
                          club: clubs[index],
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ClubDetails(
                                          clubId: clubs[index].getId,
                                        )));
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
          ),
        ],
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
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: AllColors.liteBlack,
                offset: Offset(2, 2),
                spreadRadius: 2,
                blurRadius: 12,
            blurStyle: BlurStyle.outer),
          ]),
      child: CupertinoButton(
        onPressed: widget.onPressed,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Stack(
            children: [
              Positioned(
                  top: 0,
                  right: -5,
                  child: Image.asset(
                    "assets/images/ic_club_image.png",
                    scale: 3.5,
                  )),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(CupertinoIcons.arrow_right),
                  SizedBox(
                    height: 10,
                  ),
                  Label(
                    text: widget.club.getName,
                    fontSize: FontSize.h5,
                    fontWeight: FontWeight.w500,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Label(
                    text: "Member: ${widget.club.getMembers.length}",
                    fontSize: FontSize.p2,
                    fontWeight: FontWeight.w500,
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
                        color:
                            drawIn == "Draw ended" ? Colors.red : Colors.black,
                        fontSize: FontSize.p3,
                        fontWeight: FontWeight.w500,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
