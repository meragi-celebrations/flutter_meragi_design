import 'package:flutter/material.dart';
import 'package:flutter_meragi_design/src/components/canva/items/item_registry.dart';
import 'package:flutter_meragi_design/src/components/canva/scaling.dart';

enum CanvasItemKind { image, text, palette, shape }

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
  CanvasItem({
    required this.id,
    required this.position,
    required this.size,
    required this.locked,
    required this.rotationDeg,
  });

  final String id;
  Offset position;
  Size size;
  bool locked;
  double rotationDeg;

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

  CanvasItem cloneWith({String? id});

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
  UnknownItem({
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
  CanvasItem cloneWith({String? id}) => UnknownItem(
        id: id ?? this.id,
        position: position,
        size: size,
        locked: locked,
        rotationDeg: rotationDeg,
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
