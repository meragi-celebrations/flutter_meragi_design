import 'package:flutter/material.dart';
import 'package:flutter_meragi_design/src/components/canva/ui/dialog_manager.dart';

class DialogManagerScope extends InheritedWidget {
  final DialogManager manager;

  const DialogManagerScope({
    super.key,
    required this.manager,
    required super.child,
  });

  static DialogManager of(BuildContext context) {
    final scope =
        context.dependOnInheritedWidgetOfExactType<DialogManagerScope>();
    assert(scope != null, 'DialogManagerScope not found in context');
    return scope!.manager;
  }

  @override
  bool updateShouldNotify(DialogManagerScope oldWidget) {
    return manager != oldWidget.manager;
  }
}
