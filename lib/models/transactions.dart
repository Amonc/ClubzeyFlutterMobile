import 'dart:ffi';

class ClubTransaction{

  final Map<String, dynamic> data;

  ClubTransaction({required this.data});


  Map<String, dynamic> get toMap{
    return  {
      "id":getId,
      "clubId":getClubId,
      "amount":getAmount,
      "createdAt":createAt,
      "payor":getPayor,
      "cycle":getCycle
    };
  }

  String get getId{
    return data['id'];
  }

  String get getClubId{
    return data['clubId'];
  }

  double get getAmount{
    return (data['amount']??0).toDouble();
  }

  String get getPayor{

    return data["payor"];
  }

  DateTime get createAt{
    try{
      return data['createdAt'];
    }catch (e){
      return data['createdAt'].toDate();
    }
  }

  int get getCycle{
    return data['cycle'];
  }




}