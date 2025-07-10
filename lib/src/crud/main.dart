import 'package:hive_ce_flutter/hive_flutter.dart';

class MeragiCrud {
  static Future<void> initCache() async {
    await Hive.initFlutter();
    await Hive.openBox('meragi_crud_requests');
  }
}
