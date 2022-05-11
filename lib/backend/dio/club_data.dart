import 'package:Clubzey/backend/api.dart';
import 'package:Clubzey/backend/auth/model/clubzey_user.dart';
import 'package:Clubzey/backend/hive_data.dart';
import 'package:Clubzey/models/encrypted_id.dart';
import 'package:Clubzey/models/user_payment.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../../models/club.dart';

class ClubData {
  createClub({required Club club, required int shares}) async {
    var data = club.getData;

    await FirebaseFirestore.instance
        .collection("clubs")
        .doc(club.getId)
        .set(data);

    await addMember(clubId: club.getId, shares: shares);
  }

  Stream<List<Club>> getAllClubs({required String admin}) {
    Stream<QuerySnapshot> snapshot = FirebaseFirestore.instance
        .collection('clubs')
        .where("members", arrayContains: admin)
        .snapshots();
    return snapshot.map((event) {
      return event.docs.map((element) {
        Map<String, dynamic> data = element.data() as Map<String, dynamic>;
        Club club=Club(data: data);


        return club;
      }).toList();
    });
  }

  Future<List<Club>> getAllClubsOnce({required String admin}) async{
   var snapshot = await FirebaseFirestore.instance
        .collection('clubs')
        .where("members", arrayContains: admin)
        .get();
   return snapshot.docs.map((element) {

     Map<String, dynamic> data = element.data() as Map<String, dynamic>;

     Club club=Club(data: data);


     return club;
   }).toList();

}
  Stream<Club> getAClub({required String id}) {
    Stream<DocumentSnapshot> snapshot =
        FirebaseFirestore.instance.collection('clubs').doc(id).snapshots();

    return snapshot.map((event) {
      if (event.data() != null) {
        Map<String, dynamic> data = event.data() as Map<String, dynamic>;
        return Club(data: data);
      } else {
        return Club(data: {});
      }
    });
  }

  addMemberFromQR({required EncryptedId encryptedId}) async {
    String email = FirebaseAuth.instance.currentUser!.email!;
    try {
      Response response = await Dio().post('${API.url}/addMember', data: {
        "clubId": encryptedId.getId,
        "shares": encryptedId.getShares,
        "memberEmail": email,
      });
      print(response.data);
    } catch (e) {
      print(e);
    }
  }

  addMember({required String clubId, required int shares}) async {
    String email = FirebaseAuth.instance.currentUser!.email!;
    try {
      Response response = await Dio().post('${API.url}/addMember', data: {
        "clubId": clubId,
        "shares": shares,
        "memberEmail": email,
      });
      print(response.data);
    } catch (e) {
      print(e);
    }
  }

  Stream<UserPayment> getPayments({required String clubId}) {
    return FirebaseFirestore.instance
        .collection("clubs")
        .doc(clubId)
        .collection("payment")
        .doc("payment")
        .snapshots()
        .map((event)  {

    if (event.data() != null) {
        Map<String, dynamic> data = event.data() as Map<String, dynamic>;
        return UserPayment(data: data);
      } else {
    return UserPayment(data: {});
    }
    });
  }

  // Future<List<ClubzeyUser>> getMembers({required List<String> emails }) async {
  //    List<ClubzeyUser> members=[];
  //     emails.forEach((e) async {
  //     var snapshot = await FirebaseFirestore.instance.collection("userData").doc(e).get();
  //
  //       members.add(ClubzeyUser(data: snapshot.data()??{}));
  //    });
  //
  //    return members;
  //  }

}
