import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'items/base.dart';
import 'scaling.dart';

class CanvasGeometry {
  /// Corners in render space in [TL, TR, BR, BL] order.
  static List<Offset> corners(CanvasItem item, CanvasScaleHandler scale) {
    final rect = item.rect;
    final c = scale.baseToRender(rect.center);
    final sz = scale.baseToRenderSize(rect.size);
    final a = item.rotationDeg * math.pi / 180.0;
    final hw = sz.width / 2, hh = sz.height / 2;

    final local = <Offset>[
      Offset(-hw, -hh), // TL
      Offset(hw, -hh), // TR
      Offset(hw, hh), // BR
      Offset(-hw, hh), // BL
    ];

    final ca = math.cos(a), sa = math.sin(a);
    return List.generate(4, (i) {
      final p = local[i];
      final x = p.dx * ca - p.dy * sa;
      final y = p.dx * sa + p.dy * ca;
      return Offset(x, y) + c;
    });
  }

  /// Rotation handle position in render space.
  static Offset rotateHandle(CanvasItem item, CanvasScaleHandler scale,
      {double offset = 30}) {
    final a = item.rotationDeg * math.pi / 180.0;
    final pts = corners(item, scale);
    final topMid = (pts[0] + pts[1]) / 2;
    return topMid + Offset(-math.sin(a), math.cos(a)) * -offset;
  }

  /// Point-in-rotated-rect test (render space).
  static bool hitItem(
      CanvasItem item, CanvasScaleHandler scale, Offset localPosition) {
    final rect = item.rect;
    final c = scale.baseToRender(rect.center);
    final sz = scale.baseToRenderSize(rect.size);
    final a = -item.rotationDeg * math.pi / 180.0; // inverse
    final p = localPosition - c;
    final ca = math.cos(a), sa = math.sin(a);
    final x = p.dx * ca - p.dy * sa;
    final y = p.dx * sa + p.dy * ca;
    const pad = 0.5; // small tolerance
    return x.abs() <= sz.width / 2 + pad && y.abs() <= sz.height / 2 + pad;
  }
}
