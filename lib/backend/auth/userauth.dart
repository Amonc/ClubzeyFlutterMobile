import 'package:Clubzey/backend/auth/model/clubzey_user.dart';
import 'package:Clubzey/views/clubs_page.dart';
import 'package:Clubzey/views/dashboard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../components/custom_snackbar.dart';
import '../datastore/auth_data.dart';

class UserAuth {
  final ClubzeyUser? clubzeyUser;
  final BuildContext context;

  UserAuth({this.clubzeyUser, required this.context});

emailAuth({required String email}){

  var acs = ActionCodeSettings(
    // URL you want to redirect back to. The domain (www.example.com) for this
    // URL must be whitelisted in the Firebase Console.
      url: 'https://clubzey.web.app',
      // This must be true
      handleCodeInApp: true,
      iOSBundleId: 'aerobola.clubzey',
      androidPackageName: 'aerobola.clubzey',
      // installIfNotAvailable
      androidInstallApp: true,


      // minimumVersion
      androidMinimumVersion: '0');


  FirebaseAuth.instance.sendSignInLinkToEmail(
      email: email, actionCodeSettings: acs)
      .catchError((onError) => print('Error sending email verification $onError'))
      .then((value) => print('Successfully sent email verification'));


}







  // signUp({required String password}) async {
  //   try {
  //     await FirebaseAuth.instance.createUserWithEmailAndPassword(
  //         email: clubzeyUser!.getEmail,
  //         password: password);
  //
  //     var user = FirebaseAuth.instance.currentUser;
  //
  //     clubzeyUser!.setUserId = user!.uid;
  //
  //     await AuthData( context: context)
  //         .createUserData(clubzeyUser: clubzeyUser!);
  //   } on FirebaseAuthException catch (e) {
  //     if (e.code == 'email-already-in-use') {
  //       CustomSnackbar(context: context, text: 'User already exists').show();
  //     } else {
  //       CustomSnackbar(context: context, text: e.code).show();
  //     }
  //   }
  // }
  //
  // signIn({required String email, required String password}) async {
  //   try {
  //     await FirebaseAuth.instance
  //         .signInWithEmailAndPassword(email: email, password: password);
  //     Navigator.pushAndRemoveUntil(
  //         context,
  //         MaterialPageRoute(builder: (context) => Dashboard()),
  //         (route) => false);
  //   } on FirebaseAuthException catch (e) {
  //     if (e.code == 'user-not-found') {
  //       CustomSnackbar(context: context, text: 'User not found').show();
  //     } else if (e.code == 'wrong-password') {
  //       CustomSnackbar(context: context, text: 'Wrong password').show();
  //     }
  //   }
  // }
}
