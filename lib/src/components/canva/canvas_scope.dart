// lib/src/components/canva/canvas_scope.dart
import 'package:flutter/widgets.dart';

import 'canvas_doc.dart';

class CanvasScope extends InheritedNotifier<CanvasDoc> {
  const CanvasScope({
    super.key,
    required CanvasDoc doc,
    required Widget child,
  }) : super(notifier: doc, child: child);

  static CanvasDoc of(BuildContext context, {bool listen = true}) {
    if (listen) {
      final scope = context.dependOnInheritedWidgetOfExactType<CanvasScope>();
      assert(scope != null, 'CanvasScope not found in context');
      return scope!.notifier!;
    } else {
      final element =
          context.getElementForInheritedWidgetOfExactType<CanvasScope>();
      final scope = element?.widget as CanvasScope?;
      assert(scope != null, 'CanvasScope not found in context');
      return scope!.notifier!;
    }
  }
}
