import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_meragi_design/src/components/canva/items/item_registry.dart';
import 'package:flutter_meragi_design/src/components/canva/scaling.dart';

enum CanvasItemKind { image, text, palette, shape }

class Handle {
  const Handle({
    required this.key,
    required this.alignment,
    this.cursor = SystemMouseCursors.basic,
  });

  final String key;
  final Alignment alignment;
  final MouseCursor cursor;
}

typedef CanvasInteractionTap = void Function(
  BuildContext context,
  CanvasItem item,
  TapUpDetails details,
  CanvasScaleHandler scale,
);
typedef CanvasInteractionTapDown = void Function(
  BuildContext context,
  CanvasItem item,
  TapDownDetails details,
  CanvasScaleHandler scale,
);
typedef CanvasInteractionLongPressStart = void Function(
  BuildContext context,
  CanvasItem item,
  LongPressStartDetails details,
  CanvasScaleHandler scale,
);
typedef CanvasInteractionLongPressEnd = void Function(
  BuildContext context,
  CanvasItem item,
  LongPressEndDetails details,
  CanvasScaleHandler scale,
);
typedef CanvasInteractionNoDetails = void Function(
  BuildContext context,
  CanvasItem item,
  CanvasScaleHandler scale,
);

class CanvasItemInteractions {
  final CanvasInteractionTap? onTap;
  final CanvasInteractionTapDown? onTapDown;
  final CanvasInteractionNoDetails? onDoubleTap;
  final CanvasInteractionTapDown? onDoubleTapDown;
  final CanvasInteractionTap? onSecondaryTap;
  final CanvasInteractionLongPressStart? onLongPressStart;
  final CanvasInteractionLongPressEnd? onLongPressEnd;

  const CanvasItemInteractions({
    this.onTap,
    this.onTapDown,
    this.onDoubleTap,
    this.onDoubleTapDown,
    this.onSecondaryTap,
    this.onLongPressStart,
    this.onLongPressEnd,
  });

  bool get hasAny =>
      onTap != null ||
      onTapDown != null ||
      onDoubleTap != null ||
      onDoubleTapDown != null ||
      onSecondaryTap != null ||
      onLongPressStart != null ||
      onLongPressEnd != null;
}

class _CanvasItemGestureWrapper extends StatelessWidget {
  const _CanvasItemGestureWrapper({
    required this.item,
    required this.scale,
    required this.child,
    required this.interactions,
  });

  final CanvasItem item;
  final CanvasScaleHandler scale;
  final Widget child;
  final CanvasItemInteractions? interactions;

  @override
  Widget build(BuildContext context) {
    final i = interactions;
    if (i == null || !i.hasAny) return child;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: i.onTapDown == null
          ? null
          : (d) => i.onTapDown!(context, item, d, scale),
      onTapUp:
          i.onTap == null ? null : (d) => i.onTap!(context, item, d, scale),
      onDoubleTap: i.onDoubleTap == null
          ? null
          : () => i.onDoubleTap!(context, item, scale),
      onDoubleTapDown: i.onDoubleTapDown == null
          ? null
          : (d) => i.onDoubleTapDown!(context, item, d, scale),
      onSecondaryTapUp: i.onSecondaryTap == null
          ? null
          : (d) => i.onSecondaryTap!(context, item, d, scale),
      onLongPressStart: i.onLongPressStart == null
          ? null
          : (d) => i.onLongPressStart!(context, item, d, scale),
      onLongPressEnd: i.onLongPressEnd == null
          ? null
          : (d) => i.onLongPressEnd!(context, item, d, scale),
      child: child,
    );
  }
}

/// Base class – agnostic of subclasses.
abstract class CanvasItem {
  const CanvasItem({
    required this.id,
    required this.position,
    required this.size,
    required this.locked,
    required this.rotationDeg,
  });

  final String id;
  final Offset position;
  final Size size;
  final bool locked;
  final double rotationDeg;

  Rect get rect =>
      Rect.fromLTWH(position.dx, position.dy, size.width, size.height);

  CanvasItemKind get kind;

  Widget buildContent(CanvasScaleHandler scale);

  Widget buildViewerContent(
    BuildContext context,
    CanvasScaleHandler scale, {
    CanvasItemInteractions? interactions,
  }) {
    return _CanvasItemGestureWrapper(
      item: this,
      scale: scale,
      interactions: interactions,
      child: buildContent(scale),
    );
  }

  Widget buildPropertiesEditor(
    BuildContext context, {
    required VoidCallback onChangeStart,
    required ValueChanged<CanvasItem> onChanged,
    required VoidCallback onChangeEnd,
  });

  Future<CanvasItem?> handleDoubleTap(BuildContext context) async => null;

  List<Handle> getHandles() => const [
        // corners
        Handle(
          key: 'topLeft',
          alignment: Alignment.topLeft,
          cursor: SystemMouseCursors.resizeUpLeftDownRight,
        ),
        Handle(
          key: 'topRight',
          alignment: Alignment.topRight,
          cursor: SystemMouseCursors.resizeUpRightDownLeft,
        ),
        Handle(
          key: 'bottomRight',
          alignment: Alignment.bottomRight,
          cursor: SystemMouseCursors.resizeUpLeftDownRight,
        ),
        Handle(
          key: 'bottomLeft',
          alignment: Alignment.bottomLeft,
          cursor: SystemMouseCursors.resizeUpRightDownLeft,
        ),

        // new mid-edge handles
        Handle(
          key: 'top',
          alignment: Alignment.topCenter,
          cursor: SystemMouseCursors.resizeUpDown,
        ),
        Handle(
          key: 'right',
          alignment: Alignment.centerRight,
          cursor: SystemMouseCursors.resizeLeftRight,
        ),
        Handle(
          key: 'bottom',
          alignment: Alignment.bottomCenter,
          cursor: SystemMouseCursors.resizeUpDown,
        ),
        Handle(
          key: 'left',
          alignment: Alignment.centerLeft,
          cursor: SystemMouseCursors.resizeLeftRight,
        ),
      ];

  CanvasItem resizeWithHandle(
    String handleKey,
    Offset deltaBase, // per-frame delta in BASE space
    CanvasScaleHandler scale, // kept for signature
  ) {
    final a = rotationDeg * math.pi / 180.0;
    final ca = math.cos(a), sa = math.sin(a);

    // Local unit axes in BASE space
    final axisX = Offset(ca, sa); // width direction
    final axisY = Offset(-sa, ca); // height direction

    // Center & half extents
    final center = position + Offset(size.width / 2, size.height / 2);
    final hx = size.width / 2;
    final hy = size.height / 2;

    // Corners (BASE)
    final tl = center + axisX * (-hx) + axisY * (-hy);
    final tr = center + axisX * (hx) + axisY * (-hy);
    final br = center + axisX * (hx) + axisY * (hy);
    final bl = center + axisX * (-hx) + axisY * (hy);

    // Edge midpoints (BASE)
    final topMid = center + axisY * (-hy);
    final rightMid = center + axisX * (hx);
    final bottomMid = center + axisY * (hy);
    final leftMid = center + axisX * (-hx);

    // Pick moved vs fixed anchors
    Offset moved, fixed;
    bool edgeOnly = false;
    switch (handleKey) {
      case 'topLeft':
        moved = tl;
        fixed = br;
        break;
      case 'topRight':
        moved = tr;
        fixed = bl;
        break;
      case 'bottomRight':
        moved = br;
        fixed = tl;
        break;
      case 'bottomLeft':
        moved = bl;
        fixed = tr;
        break;

      case 'top':
        moved = topMid;
        fixed = bottomMid;
        edgeOnly = true;
        break;
      case 'right':
        moved = rightMid;
        fixed = leftMid;
        edgeOnly = true;
        break;
      case 'bottom':
        moved = bottomMid;
        fixed = topMid;
        edgeOnly = true;
        break;
      case 'left':
        moved = leftMid;
        fixed = rightMid;
        edgeOnly = true;
        break;

      default:
        return this;
    }

    // Project delta onto the handle's NORMAL to kill sideways drift
    Offset effectiveDelta = deltaBase;
    if (edgeOnly) {
      final normal =
          (handleKey == 'left' || handleKey == 'right') ? axisX : axisY;
      final d = deltaBase.dx * normal.dx + deltaBase.dy * normal.dy; // dot
      effectiveDelta = normal * d; // keep only normal component
    }

    // Move handle, recompute center from moved/fixed
    final movedNew = moved + effectiveDelta;
    final centerNew = (movedNew + fixed) * 0.5;
    final halfVec = movedNew - centerNew;

    // Project half vector onto local axes for new extents
    double halfW = (halfVec.dx * axisX.dx + halfVec.dy * axisX.dy).abs();
    double halfH = (halfVec.dx * axisY.dx + halfVec.dy * axisY.dy).abs();

    if (edgeOnly) {
      if (handleKey == 'left' || handleKey == 'right') {
        halfH = hy; // width only
      } else {
        halfW = hx; // height only
      }
    }

    const minSize = 1.0;
    final w = math.max(2 * halfW, minSize);
    final h = math.max(2 * halfH, minSize);

    final newPos = Offset(centerNew.dx - w / 2, centerNew.dy - h / 2);
    return copyWith(position: newPos, size: Size(w, h));
  }

  CanvasItem copyWith({
    String? id,
    Offset? position,
    Size? size,
    bool? locked,
    double? rotationDeg,
  });

  Map<String, dynamic> toJson(int zIndex) => {
        'id': id,
        'kind': kind.name,
        'x': position.dx,
        'y': position.dy,
        'w': size.width,
        'h': size.height,
        'z': zIndex,
        'locked': locked,
        'rot': rotationDeg,
        'props': propsToJson(),
      };

  Map<String, dynamic> propsToJson();

  static CanvasItem fromJson(Map<String, dynamic> json) =>
      CanvasItemRegistry.decode(json);
}

/// ---------- Unknown (fallback) ----------
class UnknownItem extends CanvasItem {
  const UnknownItem({
    required super.id,
    required super.position,
    required super.size,
    required super.locked,
    required super.rotationDeg,
    required this.raw,
  });

  final Map<String, dynamic> raw;

  @override
  CanvasItemKind get kind => CanvasItemKind.values.firstWhere(
        (e) => e.name == (raw['kind'] as String? ?? 'unknown'),
        orElse: () => CanvasItemKind.image,
      );

  @override
  Widget buildContent(CanvasScaleHandler scale) {
    return Container(
      color: Colors.grey.shade100,
      alignment: Alignment.center,
      child: Text(
        'Unknown kind: ${raw['kind']}',
        style:
            TextStyle(color: Colors.grey.shade700, fontStyle: FontStyle.italic),
      ),
    );
  }

  @override
  Widget buildPropertiesEditor(BuildContext context,
      {required VoidCallback onChangeStart,
      required ValueChanged<CanvasItem> onChanged,
      required VoidCallback onChangeEnd}) {
    return const SizedBox.shrink();
  }

  @override
  CanvasItem copyWith({
    String? id,
    Offset? position,
    Size? size,
    bool? locked,
    double? rotationDeg,
  }) =>
      UnknownItem(
        id: id ?? this.id,
        position: position ?? this.position,
        size: size ?? this.size,
        locked: locked ?? this.locked,
        rotationDeg: rotationDeg ?? this.rotationDeg,
        raw: Map<String, dynamic>.from(raw),
      );

  @override
  Map<String, dynamic> propsToJson() =>
      (raw['props'] as Map?)?.cast<String, dynamic>() ?? {};
  static UnknownItem fromJson(Map<String, dynamic> j) => UnknownItem(
        id: (j['id'] as String?) ??
            DateTime.now().microsecondsSinceEpoch.toString(),
        position: Offset((j['x'] as num?)?.toDouble() ?? 0,
            (j['y'] as num?)?.toDouble() ?? 0),
        size: Size((j['w'] as num?)?.toDouble() ?? 100,
            (j['h'] as num?)?.toDouble() ?? 100),
        locked: (j['locked'] as bool?) ?? false,
        rotationDeg: (j['rot'] as num?)?.toDouble() ?? 0,
        raw: Map<String, dynamic>.from(j),
      );
}

class SectionTitle extends StatelessWidget {
  const SectionTitle(this.text);
  final String text;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.w700),
      ),
    );
  }
}
