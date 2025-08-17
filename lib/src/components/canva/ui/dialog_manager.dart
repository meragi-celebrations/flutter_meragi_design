import 'package:flutter/material.dart';

class DialogManager extends ChangeNotifier {
  final List<Widget> _dialogs = [];

  List<Widget> get dialogs => List.unmodifiable(_dialogs);

  void show(Widget dialog) {
    _dialogs.add(dialog);
    notifyListeners();
  }

  void close(Widget dialog) {
    _dialogs.remove(dialog);
    notifyListeners();
  }
}
