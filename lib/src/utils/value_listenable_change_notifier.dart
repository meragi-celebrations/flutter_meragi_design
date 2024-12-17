import 'package:flutter/foundation.dart';

class ValueListenableChangeNotifier<T> extends ChangeNotifier implements ValueListenable<T> {
  T _value;
  ValueListenableChangeNotifier({required T value}) : _value = value;

  setValue(T newValue, {bool notifyListener = true}) {
    if (_value == newValue) {
      return;
    }
    _value = newValue;
    if (notifyListener) notifyListeners();
  }

  @override
  T get value => _value;
}
