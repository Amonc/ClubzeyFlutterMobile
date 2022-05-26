import 'dart:io';

import 'package:Clubzey/backend/dio/club_data.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
class EmailHiveData {
  Future<Box> initHive() async {
    await Hive.initFlutter();

    return await Hive.openBox('emailBox');
  }

  addEmail({required String email}) async {
    Box box = await initHive();
    await box.put("email", email);
  }
  deleteEmail() async {
    Box box = await initHive();
    box.delete("email");

  }
  Future<String> get getEmail async {
    Box box = await initHive();

    return (await box.get("email"))??'';


  }


}


class TopicSubscription{

  Future<Box> initHive() async {
    await Hive.initFlutter();

    return await Hive.openBox('subscriptionBox');
  }


  Future<List> get subscriptionMembersList async {
    Box box = await initHive();

    return (await box.get("subscriptionMembersList"))??[];
  }

  calculateSubscription() async{


    if(!kIsWeb){
      var admin=FirebaseAuth.instance.currentUser!.email;
      List newSubscriptions= (await ClubData().getAllClubsOnce(admin: admin!)).map((e) => e.getId).toList();

      List oldSubscriptions=await subscriptionMembersList;

      List unSubscriptions=oldSubscriptions.toSet().difference(newSubscriptions.toSet()).toList();

      unSubscriptions.forEach((s) {
        FirebaseMessaging.instance.unsubscribeFromTopic(s);
      });
      updateSubscription(subscriptions: newSubscriptions);
    }





  }



  updateSubscription({required List subscriptions}) async {
    if(!kIsWeb) {
      subscriptions.forEach((s) {
        FirebaseMessaging.instance.subscribeToTopic(s);
      });
      Box box = await initHive();
      print(subscriptions);
      await box.put("subscriptionMembersList", subscriptions);
    }



  }

}
