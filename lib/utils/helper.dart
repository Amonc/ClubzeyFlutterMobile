import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:ntp/ntp.dart';

class Helper{
  List<String> _months = [
    "Jan",
    "Feb",
    "Mar",
    "Apr",
    "May",
    "Jun",
    "Jul",
    "Aug",
    "Sep",
    "Oct",
    "Nov",
    "Dec"
  ];
  bool isEmail({required String email}) {
    return RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
  }
  
  String getFormattedTime({required DateTime dateTime}){
    String am_pm = dateTime.hour < 12 ? "AM" : "PM";
    int hour = dateTime.hour == 0
        ? 12
        : (dateTime.hour < 13 ? dateTime.hour : dateTime.hour - 12);
  int minute=dateTime.minute;


    return "${hour<10?"0$hour":hour}:${minute<10?"0$minute":minute} $am_pm";
  }

  String getFormattedDateTime({required DateTime dateTime}){
    String am_pm = dateTime.hour < 12 ? "AM" : "PM";
    int hour = dateTime.hour == 0
        ? 12
        : (dateTime.hour < 13 ? dateTime.hour : dateTime.hour - 12);

    return "${_months[dateTime.month - 1]} ${dateTime.day} ";
  }
  
  Future<String> formatDuration({required DateTime dateTime}) async {
    DateTime now= await getActualDateTime();
    if(dateTime.isBefore(now)){
      return "Draw ended";
    }

   int hours= dateTime.difference(now).inHours;
   int minutes= dateTime.difference(now.add(Duration(hours: hours))).inMinutes;
   int seconds = dateTime.difference(now.add(Duration(minutes: hours*60+minutes))).inSeconds;

    return "${hours<10?"0$hours":hours}:${minutes<10?"0$minutes":minutes}:${seconds<10?"0$seconds":seconds}";
  }

  Future<DateTime> getActualDateTime()async{
    bool internetWorking= await _tryConnection();
    if (internetWorking) {

      return await NTP.now();

    }else{

      return DateTime.now();
    }


  }
  Future<bool> _tryConnection() async {
    try {
      final response = await InternetAddress.lookup('www.google.com');

     return response.isNotEmpty;

    } on SocketException catch (e) {
      print(e);
    return false;

    }
  }
  getSixDigitCode(){

    return "${Random(). nextInt(10)}${Random(). nextInt(10)}${Random(). nextInt(10)}${Random(). nextInt(10)}${Random(). nextInt(10)}${Random(). nextInt(10)}";
  }
} 

extension Midnight on DateTime{
  toMidnight(){
    return DateTime(year, month, day);
  }
}

extension RandomListItem<T> on List<T> {
  T randomItem() {
    return this[Random().nextInt(length)];
  }



}