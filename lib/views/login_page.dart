import 'dart:async';
import 'dart:io';

import 'package:Clubzey/backend/hive_data.dart';
import 'package:Clubzey/views/dashboard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../backend/auth/userauth.dart';

import '../components/buttons.dart';
import '../components/labels.dart';
import '../components/textfield.dart';

import '../utils/allColors.dart';
import '../utils/fontSize.dart';
import '../utils/helper.dart';
import 'clubs_page.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with WidgetsBindingObserver {
  final _formKey = GlobalKey<FormState>();

  String _email = "";
  FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    WidgetsBinding.instance!.addObserver(this);


  // if(Platform.isAndroid){
  //  getPendingDynamincLink();
  // }
    subo.onData((data) async {
      print(data.link);
      if(data.link!=null){
        var email=await HiveData().getEmail;
        await FirebaseAuth.instance.signInWithEmailLink(
            email: email, emailLink: data.link.toString());
       await  checkUserNameExists(email:email);
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Dashboard()));

      }
      subo.cancel();
    });
  }
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {


 subo.onData((data) async {
   print(data.link);
    if(data.link!=null){
        var email=await HiveData().getEmail;
      await FirebaseAuth.instance.signInWithEmailLink(
          email: email, emailLink: data.link.toString());
      await   checkUserNameExists(email:email);
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Dashboard()));
    }
   subo.cancel();
 });
  }


  StreamSubscription subo=FirebaseDynamicLinks.instance.onLink.listen((dynamicLinkData) async {



  });








  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Center(
          child: _email==''?Form(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Label(
                  text: "Log In",
                  fontSize: FontSize.h1,
                  fontWeight: FontWeight.w600,
                ),
                const SizedBox(
                  height: 20,
                ),
                CustomTextField(
                  title: 'Name',
                  validator: (value) {},
                ),
                CustomTextField(
                  title: 'Email',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    } else if (!Helper().isEmail(email: value)) {
                      return 'Please enter a valid email address';
                    } else {}
                    _email = value.toString().trim();
                    return null;
                  },
                ),
                const SizedBox(
                  height: 15,
                ),

                // Row(
                //   children: [
                //     const Spacer(),
                //     CupertinoButton(
                //       onPressed: () {
                //         Navigator.push(
                //             context,
                //             MaterialPageRoute(
                //                 builder: (context) => ForgotPassword()));
                //       },
                //       padding: EdgeInsets.all(0),
                //       child: Label(
                //         text: 'Forget Password',
                //         color: AllColors().white,
                //         fontSize: FontSize.p2,
                //         fontWeight: FontWeight.w500,
                //         underline: TextDecoration.underline,
                //       ),
                //     ),
                //   ],
                // ),
                const SizedBox(
                  height: 15,
                ),
                FillButton(
                    title: "Log In",
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                      HiveData().addEmail(email: _email);
                      await  UserAuth(context: context).emailAuth(email: _email);



                      }


                        // HiveData().addEmail(email: _email);
                        // await  UserAuth(context: context).emailAuth(email: _email);

setState(() {

});


                    }),
                const SizedBox(
                  height: 20,
                ),


              ],
            ),
          ):Label(text: 'Login link has been sent to your email $_email'),
        ),
      ),
    );
  }

  Future<void> checkUserNameExists({ required String email}) async {
   var snap=await FirebaseFirestore.instance.collection('userData').doc(email).get();

   if(snap.data()==null){
     var user=FirebaseAuth.instance.currentUser;
  await   FirebaseFirestore.instance.collection('userData').doc(email).set({
       "email":email,
       "userId":user!.uid,
       "createdAt":DateTime.now(),

     });
   }else{
     print('found ${snap.data()}');
   }
    
  }


}
