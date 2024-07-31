import 'package:hive/hive.dart';

class RequestCache {
  Box box = Hive.box('meragi_crud_requests');

  dynamic get(String key) {
    dynamic cachedValue = box.get(key);
    if (cachedValue != null) {
      if (isExpired(cachedValue['expiry'] ?? 0)) {
        return null;
      }
      return cachedValue['value'];
    }
    return null;
  }

  void put(String key, dynamic value,
      {Duration duration = const Duration(minutes: 5)}) {
    Map<String, dynamic> map = {
      "expiry": _createMillisecondsFromDurationAndNow(duration),
      "value": value
    };

    box.put(key, map);
  }

  void delete(String key) {
    box.delete(key);
  }

  int _createMillisecondsFromDurationAndNow(Duration duration) =>
      DateTime.now().millisecondsSinceEpoch + duration.inMilliseconds;

  bool isExpired(value) => value - DateTime.now().millisecondsSinceEpoch <= 0;
}
