import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CanvasPaletteImage {
  final String id;
  final String
      srcUri; // e.g. asset://images/a.png, https://..., data:image/png;base64,...
  final ImageProvider? preview; // optional – for sidebar thumbnail
  final Size? preferredSize;
  const CanvasPaletteImage({
    required this.id,
    required this.srcUri,
    this.preview,
    this.preferredSize,
  });
}

class PaletteSidebar extends StatelessWidget {
  const PaletteSidebar({
    super.key,
    required this.palette,
    required this.sidebarWidth,
  });

  final List<CanvasPaletteImage> palette;
  final double sidebarWidth;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: sidebarWidth,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(right: BorderSide(color: Colors.grey.shade300)),
        ),
        child: ListView.separated(
          padding: const EdgeInsets.all(8),
          itemCount: palette.length,
          separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemBuilder: (context, i) => _paletteDraggable(palette[i]),
        ),
      ),
    );
  }

  Widget _paletteDraggable(CanvasPaletteImage p) {
    final thumb = _thumbForPalette(p);
    final feedback = Material(
      elevation: 4,
      color: Colors.transparent,
      child: ConstrainedBox(
        constraints: const BoxConstraints.tightFor(width: 96, height: 96),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.black12),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Opacity(opacity: 0.9, child: thumb),
          ),
        ),
      ),
    );
    if (_immediateDragPlatform()) {
      return Draggable<CanvasPaletteImage>(
        data: p,
        dragAnchorStrategy: pointerDragAnchorStrategy,
        feedback: feedback,
        childWhenDragging: Opacity(opacity: 0.35, child: thumb),
        child: thumb,
      );
    } else {
      return LongPressDraggable<CanvasPaletteImage>(
        data: p,
        dragAnchorStrategy: pointerDragAnchorStrategy,
        feedback: feedback,
        childWhenDragging: Opacity(opacity: 0.35, child: thumb),
        child: thumb,
      );
    }
  }

  Widget _thumbForPalette(CanvasPaletteImage p) {
    final prov = p.preview ?? _derivePreview(p.srcUri);
    return AspectRatio(
      aspectRatio: 1,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.black12),
          boxShadow: const [BoxShadow(blurRadius: 2, color: Colors.black12)],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: prov != null
              ? Image(image: prov, fit: BoxFit.cover)
              : const Center(child: Icon(Icons.image_outlined)),
        ),
      ),
    );
  }

  ImageProvider? _derivePreview(String src) {
    try {
      if (src.startsWith('asset://')) {
        return AssetImage(src.substring('asset://'.length));
      } else if (src.startsWith('http://') || src.startsWith('https://')) {
        return NetworkImage(src);
      } else if (src.startsWith('data:image/')) {
        final comma = src.indexOf(',');
        if (comma > 0) {
          final b64 = src.substring(comma + 1);
          return MemoryImage(base64Decode(b64));
        }
      }
    } catch (_) {}
    return null;
  }

  bool _immediateDragPlatform() {
    if (kIsWeb) return true;
    switch (defaultTargetPlatform) {
      case TargetPlatform.macOS:
      case TargetPlatform.windows:
      case TargetPlatform.linux:
        return true;
      default:
        return false;
    }
  }
}
