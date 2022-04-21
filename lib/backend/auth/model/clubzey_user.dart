

import 'package:uuid/uuid.dart';

class ClubzeyUser{
  String? _userId;
  final Map<String, dynamic> data;

  ClubzeyUser({required this.data});

  String get getUserId{
    return _userId??data['userId']??Uuid().v4();
  }

  set setUserId(String id){
    _userId=id;
  }

  String get getEmail{
    return data["email"];
  }

  String get getUsername{
    return data["username"];
  }

  DateTime get getCreatedAt{
try{
  return data['createdAt'];
}catch(e){
  return data['createdAt'].toDate();
}
  }
}