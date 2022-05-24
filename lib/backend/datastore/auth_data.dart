import 'package:Clubzey/backend/auth/model/clubzey_user.dart';
import 'package:Clubzey/views/clubs_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';

class AuthData {
  final BuildContext context;


  AuthData({required this.context});

  createUserData({required ClubzeyUser clubzeyUser}) async {
    await FirebaseFirestore.instance
        .collection("userData")
        .doc(clubzeyUser.getEmail)
        .set({
      "email": clubzeyUser.getEmail,
      "userId": clubzeyUser.getUserId,
      "username": clubzeyUser.getUsername,
      "createdAt": DateTime.now()
    });

    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => ClubsPage()));
  }

  Future<ClubzeyUser> getAUser({required String email}) async {
    DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection("userData")
        .doc(email)
        .get();

    if (snapshot.data() != null) {
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

      return ClubzeyUser(data: data);
    }
    else{
      return ClubzeyUser(data: {});
    }
  }
}
