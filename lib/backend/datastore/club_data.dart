

import 'package:Clubzey/backend/auth/model/clubzey_user.dart';
import 'package:Clubzey/models/encrypted_id.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../models/club.dart';

class ClubData {
  createClub({required Club club}) async {
    var data = club.getData;

    await FirebaseFirestore.instance
        .collection("clubs")
        .doc(club.getId)
        .set(data);
  }

  Stream<List<Club>> getAllClubs({required String admin}) {
   Stream<QuerySnapshot> snapshot = FirebaseFirestore.instance.collection('clubs').where("members",arrayContains: admin).snapshots();
    return snapshot.map((event) {
      return event.docs.map((element) {
        Map<String, dynamic> data = element.data() as Map<String, dynamic>;
        print(data['name']);
        return Club(data: data);
      }).toList();
    });
  }

  Stream<Club>getAClub({required String id})  {
    Stream<DocumentSnapshot> snapshot = FirebaseFirestore.instance.collection('clubs').doc(id).snapshots();

  return  snapshot.map((event) {
      if(event.data()!=null){
        Map<String,dynamic> data= event.data() as Map<String,dynamic>;
        return Club(data: data);
      }else{
       return Club(data: {});
      }

    });
  }



  addMember({required EncryptedId encryptedId }) async {
    String email= FirebaseAuth.instance.currentUser!.email!;
    await FirebaseFirestore.instance.collection('clubs').doc(encryptedId.getId).update({
      "members":FieldValue.arrayUnion([email])
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
