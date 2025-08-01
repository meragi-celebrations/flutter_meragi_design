import 'package:flutter/material.dart';

class PropertyNotifier<T> extends ValueNotifier<T> {
  PropertyNotifier(super.value);

  bool _disposed = false;

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  @override
  void notifyListeners() {
    if (!_disposed) {
      super.notifyListeners();
    }
  }
}
