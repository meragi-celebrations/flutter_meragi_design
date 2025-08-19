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

  static bool rectIntersectsItem(
      Rect r, CanvasItem item, CanvasScaleHandler scale) {
    final pts = corners(item, scale); // TL, TR, BR, BL in render space

    // 1) any item corner inside the marquee rect
    for (final p in pts) {
      if (r.contains(p)) return true;
    }

    // 2) any rect corner inside the rotated item
    final rectCorners = <Offset>[
      r.topLeft,
      r.topRight,
      r.bottomRight,
      r.bottomLeft
    ];
    for (final c in rectCorners) {
      if (hitItem(item, scale, c)) return true;
    }

    // 3) any edge intersects
    final itemEdges = [
      (pts[0], pts[1]), // top
      (pts[1], pts[2]), // right
      (pts[2], pts[3]), // bottom
      (pts[3], pts[0]), // left
    ];
    final rectEdges = [
      (r.topLeft, r.topRight), // top
      (r.topRight, r.bottomRight), // right
      (r.bottomRight, r.bottomLeft), // bottom
      (r.bottomLeft, r.topLeft), // left
    ];

    for (final e1 in itemEdges) {
      for (final e2 in rectEdges) {
        if (_segmentsIntersect(e1.$1, e1.$2, e2.$1, e2.$2)) return true;
      }
    }

    return false;
  }

// --- private helpers ---

  static double _cross(Offset a, Offset b, Offset c) {
    final ab = b - a;
    final ac = c - a;
    return ab.dx * ac.dy - ab.dy * ac.dx;
  }

  static bool _onSegment(Offset a, Offset b, Offset p) {
    final minX = a.dx <= b.dx ? a.dx : b.dx;
    final maxX = a.dx >= b.dx ? a.dx : b.dx;
    final minY = a.dy <= b.dy ? a.dy : b.dy;
    final maxY = a.dy >= b.dy ? a.dy : b.dy;
    if (p.dx + 1e-6 < minX ||
        p.dx - 1e-6 > maxX ||
        p.dy + 1e-6 < minY ||
        p.dy - 1e-6 > maxY) {
      return false;
    }
    return _cross(a, b, p).abs() < 1e-6;
  }

  static bool _segmentsIntersect(Offset a, Offset b, Offset c, Offset d) {
    final d1 = _cross(a, b, c);
    final d2 = _cross(a, b, d);
    final d3 = _cross(c, d, a);
    final d4 = _cross(c, d, b);

    if ((d1 > 0 && d2 < 0 || d1 < 0 && d2 > 0) &&
        (d3 > 0 && d4 < 0 || d3 < 0 && d4 > 0)) {
      return true; // proper intersection
    }

    // colinear cases
    if (d1.abs() < 1e-6 && _onSegment(a, b, c)) return true;
    if (d2.abs() < 1e-6 && _onSegment(a, b, d)) return true;
    if (d3.abs() < 1e-6 && _onSegment(c, d, a)) return true;
    if (d4.abs() < 1e-6 && _onSegment(c, d, b)) return true;

    return false;
  }
}
