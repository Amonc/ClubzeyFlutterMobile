class UserPayment{
  final Map<String,dynamic> data;

  UserPayment({required this.data});

  String get getClubId{
    return data['clubId'];
  }


  DateTime get updatedAt{
try{
  return data['updatedAt'];
}catch (e){
  return data['updatedAt'].toDate();
}
  }

List get getPayments{
    return data['payments'].map((e) =>PaymentDetails(data: e)).toList()??[];
}



}


class PaymentDetails{
  final Map<String,dynamic> data;

  PaymentDetails({required this.data});

  String get getEmail{
    return data['email'];
  }

  double get getPaid{
    return data['paid'].toDouble();
  }

  double get getTotalStock{
    return data['totalStock'].toDouble();
  }



}

