import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_meragi_design/flutter_meragi_design.dart';
import 'package:flutter_meragi_design/src/components/canva/scaling.dart';
import 'package:flutter_meragi_design/src/components/canva/utils.dart';

class CanvaViewer extends StatelessWidget {
  const CanvaViewer({
    super.key,
    required this.document,
    this.palette = const [],
    this.workspaceColor = const Color(0xFFF3F4F6),
    this.borderRadius = 12,
    this.showShadow = true,
  });

  factory CanvaViewer.fromJsonString(
    String jsonString, {
    Key? key,
    List<CanvasPaletteImage> palette = const [],
    Color workspaceColor = const Color(0xFFF3F4F6),
    double borderRadius = 12,
    bool showShadow = true,
  }) {
    final doc = jsonDecode(jsonString) as Map<String, dynamic>;
    return CanvaViewer(
      key: key,
      document: doc,
      palette: palette,
      workspaceColor: workspaceColor,
      borderRadius: borderRadius,
      showShadow: showShadow,
    );
  }

  final Map<String, dynamic> document;
  final List<CanvasPaletteImage> palette;
  final Color workspaceColor;
  final double borderRadius;
  final bool showShadow;

  Map<String, CanvasPaletteImage> get _paletteById =>
      {for (final p in palette) p.id: p};

  @override
  Widget build(BuildContext context) {
    final canvasInfo = (document['canvas'] as Map?) ?? const {};
    final colorHex = canvasInfo['color'] as String?;
    final bgColor =
        (colorHex != null ? hexToColor(colorHex) : null) ?? Colors.white;

    // Prefer explicit base size if present
    Size baseSize = const Size(1920, 1080);
    final base = (canvasInfo['base'] as Map?)?.cast<String, dynamic>();
    if (base != null) {
      final bw = (base['w'] as num?)?.toDouble();
      final bh = (base['h'] as num?)?.toDouble();
      if (bw != null && bw > 0 && bh != null && bh > 0) {
        baseSize = Size(bw, bh);
      }
    }

    double aspect = baseSize.width / baseSize.height;
    final parsedAspect = _parseAspect(canvasInfo['aspect']);
    if (parsedAspect != null) {
      aspect = parsedAspect;
      if (base == null) baseSize = Size(1080 * aspect, 1080);
    }

    final items = _buildItems(document);

    return Container(
      color: workspaceColor,
      alignment: Alignment.center,
      child: LayoutBuilder(
        builder: (context, constraints) {
          double w = constraints.maxWidth;
          double h = w / aspect;
          if (h > constraints.maxHeight) {
            h = constraints.maxHeight;
            w = h * aspect;
          }

          final scale = CanvasScaleHandler(
            baseSize: baseSize,
            renderSize: Size(w, h),
          );

          final canvas = Container(
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(borderRadius),
              border: Border.all(color: Colors.black12),
              boxShadow: showShadow
                  ? const [BoxShadow(blurRadius: 18, color: Color(0x33000000))]
                  : null,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(borderRadius),
              child: _CanvasStack(
                items: items,
                canvasSize: Size(w, h),
                scale: scale,
              ),
            ),
          );

          return SizedBox(
            width: w,
            height: h,
            child: IgnorePointer(ignoring: true, child: canvas),
          );
        },
      ),
    );
  }

  double? _parseAspect(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    if (value is String) {
      final s = value.trim();
      if (s.contains(':')) {
        final parts = s.split(':');
        if (parts.length == 2) {
          final a = double.tryParse(parts[0]);
          final b = double.tryParse(parts[1]);
          if (a != null && b != null && b != 0) return a / b;
        }
      } else {
        final v = double.tryParse(s);
        if (v != null && v > 0) return v;
      }
    }
    return null;
  }

  List<CanvasItem> _buildItems(Map<String, dynamic> doc) {
    final raw =
        (doc['items'] as List?)?.cast<Map<String, dynamic>>() ?? const [];
    final items = <CanvasItem>[];
    for (final j in raw) {
      // resolve provider from palette
      ImageProvider? provider;
      final props = (j['props'] as Map?)?.cast<String, dynamic>() ?? const {};
      final imageId =
          (props['imageId'] as String?) ?? (j['imageId'] as String?);
      if (imageId != null && _paletteById.containsKey(imageId)) {
        provider = _paletteById[imageId]!.provider;
      }
      provider ??= deserializeProvider(props['src'] ?? j['src']);

      items.add(CanvasItem.fromJson(j, provider));
    }
    return items;
  }
}

class _CanvasStack extends StatelessWidget {
  const _CanvasStack({
    required this.items,
    required this.canvasSize,
    required this.scale,
  });

  final List<CanvasItem> items;
  final Size canvasSize;
  final CanvasScaleHandler scale;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: canvasSize.width,
      height: canvasSize.height,
      child: Stack(
        clipBehavior: Clip.hardEdge,
        children: [
          for (final item in items)
            _CanvasItemView(
              item: item,
              scale: scale,
            ),
        ],
      ),
    );
  }
}

class _CanvasItemView extends StatelessWidget {
  const _CanvasItemView({required this.item, required this.scale});
  final CanvasItem item;
  final CanvasScaleHandler scale;

  @override
  Widget build(BuildContext context) {
    final pos = scale.baseToRender(item.position);
    final size = scale.baseToRenderSize(item.size);
    final radians = item.rotationDeg * math.pi / 180.0;

    return Positioned(
      left: pos.dx,
      top: pos.dy,
      width: size.width,
      height: size.height,
      child: Center(
        child: Transform.rotate(
          angle: radians,
          alignment: Alignment.center,
          child: SizedBox(
            width: size.width,
            height: size.height,
            child: item.buildContent(scale),
          ),
        ),
      ),
    );
  }
}
