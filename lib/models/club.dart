class Club {
 final Map<String, dynamic> data;
String? _id;
  Club({
    required this.data
  });

  Map<String, dynamic> get getData {
    Map<String, dynamic> d= data;
    d['id']=_id;
    return data;
  }

  String get getCreatedBy {
    return data['createdBy'];
  }

  DateTime get getCreatedAt {
    return data['createdAt'].toDate();
  }

  String get getName {
    return data['name']??'';
  }

  double get getPerAmount {
    return data['perAmount']??0;
  }

  DateTime get getDrawDate{
     try{
       return data["drawDate"].toDate();
     }catch(e){
       return data["drawDate"];
     }
  }

  List<String> get getMembers {
    return (data['members']??[]).cast<String>();
  }

  String get getId {
    return _id??data['id'];
  }

  set setId(id) {
    _id = id;
  }
}
