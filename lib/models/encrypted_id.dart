class EncryptedId{
  final List<String> code;

  EncryptedId({required this.code});

  String get getId{
    return code[0];
  }
  DateTime get getDateTime{
    return DateTime.parse(code[1]);
  }

int get share{
    return int.parse(code[2]);
  }

}