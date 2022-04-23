import 'dart:async';

import 'package:Clubzey/backend/auth/model/clubzey_user.dart';
import 'package:Clubzey/backend/datastore/auth_data.dart';
import 'package:Clubzey/backend/datastore/club_data.dart';
import 'package:Clubzey/components/pickers.dart';
import 'package:Clubzey/utils/allColors.dart';
import 'package:Clubzey/utils/match_animation.dart';
import 'package:Clubzey/views/add_member.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:rive/rive.dart';

import '../components/labels.dart';
import '../models/club.dart';
import '../utils/fontSize.dart';
import '../utils/helper.dart';

class ClubDetails extends StatefulWidget {
  final Club club;
  final String id;

  ClubDetails({Key? key, required this.club, required this.id})
      : super(key: key);

  @override
  State<ClubDetails> createState() => _ClubDetailsState();
}

class _ClubDetailsState extends State<ClubDetails> {
  int _selectedValue = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: StreamBuilder(
        stream: ClubData().getAClub(id: widget.id),
        builder: (BuildContext context, AsyncSnapshot<Club> snapshot) {
          if (snapshot.data == null) {
            return const Center(
              child: Label(
                text: "No clubs found",
              ),
            );
          }

          Club club = snapshot.data!;

          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 24, right: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Label(
                      text: club.getName,
                      fontSize: FontSize.h3,
                      fontWeight: FontWeight.w800,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Label(
                          text: "Members",
                          fontSize: FontSize.p3,
                          fontWeight: FontWeight.w500,
                        ),
                        CupertinoButton(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 3),
                          color: Colors.deepPurple,
                          minSize: 0,
                          onPressed: () {
                            showMaterialModalBottomSheet(
                              context: context,
                              builder: (context) => Container(
                                height: 400,
                                child: Column(
                                  children: [
                                    SizedBox(height: 20,),
                                    Label(
                                      text: 'Select shares',
                                      fontSize: FontSize.h4,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    SizedBox(height: 20,),
                                    Expanded(
                                      child: SharePicker(initialValue: _selectedValue,onSelectedItemChange: (int value) {
                                        setState(() {
                                          _selectedValue = value;
                                          print(_selectedValue);
                                        });
                                      },),
                                    ),
                                    SizedBox(
                                      height: 50,
                                    ),
                                    CupertinoButton(
                                        onPressed: () {

                                          Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => AddMemberPage(
                                                    club: club, shares: _selectedValue,
                                                  )));
                                        },
                                        padding: EdgeInsets.all(0),
                                        child: Label(
                                          text: 'Continue',
                                          fontSize: FontSize.h4,
                                          fontWeight: FontWeight.bold,
                                        )),
                                    SizedBox(
                                      height: 50,
                                    ),

                                  ],
                                ),
                              ),
                            );
                          },
                          child: const Label(
                            text: "+ add Member",
                            color: AllColors.white,
                            fontSize: FontSize.p3,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 60,
                child: club.getMembers.length > 0
                    ? ListView.builder(
                        padding: const EdgeInsets.only(left: 24),
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: club.getMembers.length,
                        itemBuilder: (BuildContext context, int index) {
                          Color color = AllColors.colors.length - 1 < index
                              ? AllColors
                                  .colors[index % AllColors.colors.length]
                              : AllColors.colors[index];
                          String email = club.getMembers[index];

                          return FutureBuilder(
                            future: AuthData(
                              context: context,
                            ).getAUser(email: email),
                            builder: (BuildContext context,
                                AsyncSnapshot<ClubzeyUser> clubzeyUserData) {
                              if (clubzeyUserData.data == null) {
                                return const SizedBox();
                              }

                              ClubzeyUser user = clubzeyUserData.data!;

                              return CircleAvatar(
                                backgroundColor: color.withOpacity(0.25),
                                child: Label(
                                  text: user.getUsername
                                      .substring(0, 1)
                                      .toUpperCase(),
                                  fontWeight: FontWeight.w900,
                                  color: color,
                                ),
                              );
                            },
                          );
                        },
                      )
                    : const Label(text: 'No members found'),
              ),
              Container(
                  margin: const EdgeInsets.symmetric(horizontal: 24),
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  width: double.maxFinite,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      gradient: AllGradient.ipGradient),
                  child: TimerLabel(
                    club: club,
                  )),
              // Expanded(
              //   child: DrawOneMember(emails: club.getMembers),
              // ),
              // const SizedBox(
              //   height: 100,
              // ),
            ],
          );
        },
      ),
    );
  }
}

class TimerLabel extends StatefulWidget {
  final Club club;

  const TimerLabel({
    Key? key,
    required this.club,
  }) : super(key: key);

  @override
  State<TimerLabel> createState() => _TimerLabelState();
}

class _TimerLabelState extends State<TimerLabel> {
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
    return FutureBuilder(
      future: Helper().formatDuration(dateTime: widget.club.getDrawDate),
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        bool drawEnded = (snapshot.data ?? '') == "Draw ended";
        if (drawEnded) {
          _timer.cancel();
        }
        return Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Label(
              text: snapshot.data ?? '00:00:00',
              color: AllColors.white,
              fontSize: FontSize.h1,
              fontWeight: FontWeight.w600,
            ),
            if (!drawEnded)
              const Label(
                text: "Draw in",
                color: AllColors.yellow,
                fontWeight: FontWeight.w600,
                fontSize: FontSize.p1,
              ),
          ],
        );
      },
    );
  }
}

class DrawOneMember extends StatefulWidget {
  final List<String> emails;

  const DrawOneMember({Key? key, required this.emails}) : super(key: key);

  @override
  State<DrawOneMember> createState() => _DrawOneMemberState();
}

class _DrawOneMemberState extends State<DrawOneMember> {
  int _timerSeconds = 140;
  String _email = "";
  late RiveAnimationController _controller;
  late RiveAnimationController _controller2;
  bool _isPlaying = false;
  Stream<int> timerCount(Duration interval, [int? minCount]) async* {
    int i = _timerSeconds;
    while (true) {
      await Future.delayed(interval);
      yield i--;
      _email = widget.emails.randomItem();

      if (i == minCount) {
        return;
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = OneShotAnimation('loading', autoplay: true, onStop: () {
      _controller.isActive = true;
      setState(() {});
    });
    _controller2 =
        OneShotAnimation('congratulation', autoplay: true, onStop: () {
      _controller2.isActive = true;
      setState(() {});
    });

    _email = widget.emails[0];
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Positioned(
          top: 116,
          child: SizedBox(
              width: 100,
              height: 100,
              child: RiveAnimation.asset(
                'assets/images/square_loading.riv',
                controllers: [_controller],
                onInit: (Artboard artboard) {
                  artboard.forEachComponent(
                    (child) {
                      if (child is Shape) {
                        final Shape shape = child;
                      }
                    },
                  );
                },
              )),
        ),
        StreamBuilder(
          stream: timerCount(Duration(milliseconds: 50), 0),
          builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
            return DrawWidget(email: _email);
          },
        ),

        // Positioned(
        //   top: -100,
        //   child: SizedBox(
        //       width: 400,
        //       height: 400,
        //       child: RiveAnimation.asset(
        //         'assets/images/love_emoji.riv',
        //         controllers: [_controller2],
        //       )),
        // ),
      ],
    );
  }
}

class DrawWidget extends StatelessWidget {
  const DrawWidget({Key? key, required this.email}) : super(key: key);
  final String email;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: email != ''
          ? FutureBuilder(
              future: AuthData(
                context: context,
              ).getAUser(email: email),
              builder: (BuildContext context,
                  AsyncSnapshot<ClubzeyUser> clubzeyUserData) {
                if (clubzeyUserData.data == null) {
                  return const SizedBox();
                }

                ClubzeyUser user = clubzeyUserData.data!;
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 30),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(color: Colors.purple),
                      height: 70,
                      width: 70,
                      child: Center(
                          child: Label(
                        text: user.getUsername.substring(0, 1).toUpperCase(),
                        fontSize: FontSize.h1,
                        fontWeight: FontWeight.w900,
                        color: AllColors.white,
                      )),
                    ),
                    Label(text: user.getUsername)
                  ],
                );
              })
          : SizedBox(),
    );
  }
}



