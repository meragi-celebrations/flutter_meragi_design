// lib/src/components/canva/item_registry.dart
import 'package:flutter/foundation.dart';
import 'package:flutter_meragi_design/src/components/canva/models.dart';

typedef CanvasItemFactory = CanvasItem Function(Map<String, dynamic> json);

class CanvasItemRegistry {
  CanvasItemRegistry._();
  static final Map<String, CanvasItemFactory> _factories = {};

  static void register(String kind, CanvasItemFactory factory) {
    _factories[kind] = factory;
  }

  static CanvasItem decode(Map<String, dynamic> json) {
    final kind = (json['kind'] as String?)?.trim();
    final f = kind != null ? _factories[kind] : null;
    if (f != null) return f(json);
    debugPrint('Unknown CanvasItem kind: $kind');
    return UnknownItem.fromJson(json);
  }
}
