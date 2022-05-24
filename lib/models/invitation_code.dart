class SendInvitationCode {
  final Map<String, dynamic> data;

  SendInvitationCode({required this.data});



  String get getRoomId {
    return data['roomId']??'';
  }


  String get getInvitationCode {

    return data['invitationCode']??'';

  }

  String get getClubId{
    return data['clubId']??'';
  }

  DateTime get getCreatedAt {
    return data['createdAt'].toDate();
  }

  int get getShares{
    return data['shares']??'';
  }



  }



