import 'package:flutter/material.dart';
import 'package:flutter_meragi_design/src/components/json/json_interface.dart';

class JsonDataManager extends InheritedWidget {
  const JsonDataManager(
      {super.key, required final JsonData jsonData, required super.child})
      : _jsonData = jsonData;
  final JsonData _jsonData;

  JsonData get jsonData => _jsonData;

  static JsonDataManager of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<JsonDataManager>()!;

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => false;
}
