
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/transactions.dart';

class TransactionData {
  Stream<List<ClubTransaction>> get(
      {required String clubId, required String email}) {
    return FirebaseFirestore.instance
        .collection("transactions")
        .where("clubId", isEqualTo: clubId)
        .where("payor", isEqualTo: email)
        .snapshots()
        .map((event) {
      return event.docs.map((e) => ClubTransaction(data: e.data())).toList();
    });
  }

  createTransaction({required ClubTransaction clubTransaction}){
    FirebaseFirestore.instance.collection("transactions").doc(clubTransaction.getId).set(
      clubTransaction.toMap
        );
  }
}
