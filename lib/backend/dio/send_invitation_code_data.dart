import 'dart:math';

import 'package:Clubzey/models/invitation_code.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:uuid/uuid.dart';


import '../../models/club.dart';
import '../../utils/helper.dart';
import '../api.dart';

class InvitationCodeData{
 Future<String> createInvitationCode({required Club club, required int shares}) async {

    try {
      String code=Uuid().v4().substring(0,8).toUpperCase();
      Response response = await Dio().post('${API.url}/sendInvitationCode', data: {

        "id":club.getId,
        "invitationCode":code ,
        "clubId":club.getId,
        "shares":shares.toString()


      });
      return code;
    } catch (e) {
      print(e);
      return '';
    }


  }
  
  Future checkInvitationCode({required String invitationCode}) async {

  QuerySnapshot snapshot=await FirebaseFirestore.instance.collection("invitationRoom").where('invitationCode',isEqualTo: invitationCode).get();

 return snapshot.docs.length==0?null:snapshot.docs.first.data();







   
  }



}