import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveData {
  Future<Box> initHive() async {
    await Hive.initFlutter();

    return await Hive.openBox('emailBox');
  }

  addEmail({required String email}) async {
    Box box = await initHive();
    await box.put("email", email);
  }
  deleteEmail() async {
    Box box = await initHive();
    box.delete("email");

  }
  Future<String> get getEmail async {
    Box box = await initHive();

    return (await box.get("email"))??'';


  }
}
