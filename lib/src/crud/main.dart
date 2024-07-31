import 'package:hive_flutter/hive_flutter.dart';

class MeragiCrud {
  static initCache() async {
    await Hive.initFlutter();
    await Hive.openBox('meragi_crud_requests');
  }
}
