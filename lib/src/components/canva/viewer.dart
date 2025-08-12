import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_meragi_design/src/components/canva/models.dart';
import 'package:flutter_meragi_design/src/components/canva/utils.dart';

/// Read-only viewer for a SimpleCanva document.
class CanvaViewer extends StatelessWidget {
  const CanvaViewer({
    super.key,
    required this.document,
    this.palette = const [],
    this.workspaceColor = const Color(0xFFF3F4F6),
    this.borderRadius = 12,
    this.showShadow = true,
  });

  /// Convenience: construct from a JSON string.
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
    final aspect = _parseAspect(canvasInfo['aspect']) ?? (16 / 9);

    final items = _buildItems(document);

    return Container(
      color: workspaceColor,
      alignment: Alignment.center,
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Fit canvas inside available space, preserving aspect ratio
          double w = constraints.maxWidth;
          double h = w / aspect;
          if (h > constraints.maxHeight) {
            h = constraints.maxHeight;
            w = h * aspect;
          }

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
              ),
            ),
          );

          return SizedBox(
            width: w,
            height: h,
            child:
                IgnorePointer(ignoring: true, child: canvas), // no interaction
          );
        },
      ),
    );
  }

  /// Parse 'W:H' or a number. Returns null if invalid.
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
      final kindStr = (j['kind'] as String?) ?? 'image';
      final kind = CanvasItemKind.values.firstWhere(
        (e) => e.name == kindStr,
        orElse: () => CanvasItemKind.image,
      );

      // Support new nested "props" and legacy flat fields
      final props = (j['props'] as Map?)?.cast<String, dynamic>() ?? const {};

      ImageProvider? provider;
      if (kind == CanvasItemKind.image) {
        final imageId =
            (props['imageId'] as String?) ?? (j['imageId'] as String?);
        if (imageId != null && _paletteById.containsKey(imageId)) {
          provider = _paletteById[imageId]!.provider;
        }
        provider ??= deserializeProvider(props['src'] ?? j['src']);
      }

      items.add(CanvasItem.fromJson(j, provider));
    }
    return items;
  }
}

/// Internal: paints items at absolute positions with clipping handled by parent.
class _CanvasStack extends StatelessWidget {
  const _CanvasStack({
    required this.items,
    required this.canvasSize,
  });

  final List<CanvasItem> items;
  final Size canvasSize;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: canvasSize.width,
      height: canvasSize.height,
      child: Stack(
        clipBehavior: Clip.hardEdge, // clip overflowing items
        children: [
          for (final item in items) _CanvasItemView(item: item),
        ],
      ),
    );
  }
}

class _CanvasItemView extends StatelessWidget {
  const _CanvasItemView({required this.item});

  final CanvasItem item;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: item.position.dx,
      top: item.position.dy,
      width: item.size.width,
      height: item.size.height,
      child: _buildContent(),
    );
  }

  Widget _buildContent() {
    if (item.kind == CanvasItemKind.image) {
      // If provider is null (bad JSON), show nothing.
      final provider = item.provider;
      if (provider == null) return const SizedBox.shrink();
      return Image(image: provider, fit: BoxFit.contain);
    } else {
      // Text
      return Padding(
        padding: const EdgeInsets.all(6),
        child: Align(
          alignment: Alignment.topLeft,
          child: Text(
            item.text ?? '',
            maxLines: null,
            softWrap: true,
            overflow: TextOverflow.visible,
            style: item.toTextStyle(),
          ),
        ),
      );
    }
  }
}
