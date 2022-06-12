// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:async';

import 'package:Clubzey/backend/dio/club_data.dart';
import 'package:Clubzey/utils/helper.dart';
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
              CupertinoButton(
                padding: EdgeInsets.only(left: 9),
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
                padding: EdgeInsets.only(right: 9),
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
                    return ClubItemCard(
                      club: clubs[index],
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ClubDetails(
                                      clubId: clubs[index].getId,
                                    )));
                      },
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
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: AllColors.liteBlack.withOpacity(0.4),
                offset: Offset(0, 0),
                spreadRadius: 2,
                blurRadius: 12,
                blurStyle: BlurStyle.outer),
          ]),
      child: CupertinoButton(
        padding: EdgeInsets.all(0),
        minSize: 0,
        onPressed: widget.onPressed,
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    CupertinoIcons.arrow_right,
                    shadows: [
                      BoxShadow(
                          offset: Offset(0, 0),
                          color: Colors.blue,
                          spreadRadius: 1,
                          blurRadius: 4)
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Label(
                    text: widget.club.getName,
                    fontSize: FontSize.h4,
                    fontWeight: FontWeight.w500,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Label(
                    text: "Share price: ${widget.club.getPerAmount}",
                    fontSize: FontSize.p3,
                    fontWeight: FontWeight.w300,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Label(
                            text: "Prize money:",
                            fontSize: FontSize.p4,
                            color: AllColors.liteGrey,
                          ),
                          Label(
                            text:
                                "${widget.club.getPerAmount * widget.club.getMembers.length}",
                            fontSize: FontSize.p2,
                            fontWeight: FontWeight.w500,
                            color: Colors.blue,
                          ),
                        ],
                      ),
                      Expanded(child: SizedBox()),
                      Row(
                        children: [
                          DateTimeCard(
                            dateTime:
                                '${widget.club.getCreatedAt.toString().substring(0,11)}',
                            title: 'Day',
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Positioned(
                top: 0,
                right: 0,
                child: Image.asset(
                  "assets/images/ic_club_image.png",
                  scale: 3.5,
                )),
          ],
        ),
      ),
    );
  }
}

class DateTimeCard extends StatelessWidget {
  final String dateTime, title;

  const DateTimeCard({Key? key, required this.dateTime, required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Label(
          text: dateTime,
          color: AllColors.grey,
          fontSize: FontSize.p2,
          fontWeight: FontWeight.w900,
          align: TextAlign.center,
        ),
        Label(
          text: title,
          color: AllColors.grey,
          fontSize: 7,
          fontWeight: FontWeight.w500,
          align: TextAlign.center,
        ),
      ],
    );
  }
}
