import 'package:encrypt/encrypt.dart';

class Encryption{


  final iv = IV.fromLength(16);
  final encrypter = Encrypter(AES(Key.fromUtf8('1111111111111111')));
  Encrypted encrypted({required String code}) {
    return encrypter.encrypt(code, iv: iv);
  }


  String decrypted({required Encrypted encrypted}){
    return  encrypter.decrypt(encrypted, iv: iv);
  }

}