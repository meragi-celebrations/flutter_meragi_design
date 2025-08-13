import 'package:flutter/material.dart';
import 'package:flutter_meragi_design/src/components/canva/utils.dart';

enum CanvasItemKind { image, text, palette }

class CanvasPaletteImage {
  final String id;
  final ImageProvider provider;
  final Size? preferredSize;
  const CanvasPaletteImage({
    required this.id,
    required this.provider,
    this.preferredSize,
  });
}

class CanvasItem {
  final String id;
  final CanvasItemKind kind;

  // IMAGE fields
  final String? imageId;
  final ImageProvider? provider;

  // TEXT fields
  String? text;
  double fontSize;
  Color fontColor;
  FontWeight fontWeight;
  String? fontFamily;
  bool fontItalic;
  bool fontUnderline;

  // PALETTE fields
  List<Color> paletteColors;

  // Common fields
  Offset position;
  Size size;
  bool locked;

  // Image corner radii in base units
  double radiusTL;
  double radiusTR;
  double radiusBL;
  double radiusBR;

  CanvasItem({
    required this.id,
    required this.kind,
    this.imageId,
    this.provider,
    this.text,
    this.fontSize = 24,
    this.fontColor = Colors.black,
    this.fontWeight = FontWeight.w600,
    this.fontFamily,
    this.fontItalic = false,
    this.fontUnderline = false,
    List<Color>? paletteColors,
    required this.position,
    required this.size,
    this.locked = false,
    this.radiusTL = 0,
    this.radiusTR = 0,
    this.radiusBL = 0,
    this.radiusBR = 0,
  }) : paletteColors = paletteColors ??
            const [
              Color(0xFF111827), // gray-900
              Color(0xFF6B7280), // gray-500
              Color(0xFFE5E7EB), // gray-200
            ];

  TextStyle toTextStyle() => TextStyle(
        fontSize: fontSize,
        color: fontColor,
        fontWeight: fontWeight,
        fontFamily: fontFamily,
        fontStyle: fontItalic ? FontStyle.italic : FontStyle.normal,
        decoration:
            fontUnderline ? TextDecoration.underline : TextDecoration.none,
        height: 1.2,
      );

  TextStyle toRenderTextStyle(double scale) {
    return toTextStyle().copyWith(fontSize: fontSize * scale);
  }

  CanvasItem copy() => CanvasItem(
        id: id,
        kind: kind,
        imageId: imageId,
        provider: provider,
        text: text,
        fontSize: fontSize,
        fontColor: fontColor,
        fontWeight: fontWeight,
        fontFamily: fontFamily,
        fontItalic: fontItalic,
        fontUnderline: fontUnderline,
        paletteColors: List<Color>.from(paletteColors),
        position: position,
        size: size,
        locked: locked,
        radiusTL: radiusTL,
        radiusTR: radiusTR,
        radiusBL: radiusBL,
        radiusBR: radiusBR,
      );

  Map<String, dynamic> toJson(int zIndex) => {
        'id': id,
        'kind': kind.name,
        'x': position.dx,
        'y': position.dy,
        'w': size.width,
        'h': size.height,
        'z': zIndex,
        'locked': locked,
        'props': _toProps(),
      };

  Map<String, dynamic> _toProps() {
    switch (kind) {
      case CanvasItemKind.image:
        return {
          if (imageId != null) 'imageId': imageId,
          if (provider != null) 'src': serializeProvider(provider!),
          'radii': {
            'tl': radiusTL,
            'tr': radiusTR,
            'bl': radiusBL,
            'br': radiusBR,
          },
        };
      case CanvasItemKind.text:
        return {
          'text': text ?? '',
          'fs': fontSize,
          'fc': colorToHex(fontColor),
          'fw': fontWeight.value,
          if (fontFamily != null) 'ff': fontFamily,
          'fi': fontItalic,
          'fu': fontUnderline,
        };
      case CanvasItemKind.palette:
        return {
          'colors': [for (final c in paletteColors) colorToHex(c)],
        };
    }
  }

  static CanvasItem fromJson(
    Map<String, dynamic> json,
    ImageProvider? providerFromOutside,
  ) {
    final kindStr = (json['kind'] as String?) ?? 'image';
    final kind = CanvasItemKind.values.firstWhere(
      (e) => e.name == kindStr,
      orElse: () => CanvasItemKind.image,
    );

    final props = (json['props'] as Map?)?.cast<String, dynamic>() ?? const {};

    final id = (json['id'] as String?) ??
        DateTime.now().microsecondsSinceEpoch.toString();
    final pos = Offset(
      (json['x'] as num?)?.toDouble() ?? 0,
      (json['y'] as num?)?.toDouble() ?? 0,
    );
    final size = Size(
      (json['w'] as num?)?.toDouble() ?? 100,
      (json['h'] as num?)?.toDouble() ?? 100,
    );
    final locked = (json['locked'] as bool?) ?? false;

    if (kind == CanvasItemKind.image) {
      final imageId =
          (props['imageId'] as String?) ?? (json['imageId'] as String?);
      ImageProvider? provider = providerFromOutside;
      provider ??= deserializeProvider(props['src'] ?? json['src']);

      final rmap =
          (props['radii'] as Map?)?.cast<String, dynamic>() ?? const {};
      final rtl = (rmap['tl'] as num?)?.toDouble() ?? 0;
      final rtr = (rmap['tr'] as num?)?.toDouble() ?? 0;
      final rbl = (rmap['bl'] as num?)?.toDouble() ?? 0;
      final rbr = (rmap['br'] as num?)?.toDouble() ?? 0;

      return CanvasItem(
        id: id,
        kind: kind,
        imageId: imageId,
        provider: provider,
        position: pos,
        size: size,
        locked: locked,
        radiusTL: rtl,
        radiusTR: rtr,
        radiusBL: rbl,
        radiusBR: rbr,
      );
    } else if (kind == CanvasItemKind.text) {
      final txt =
          (props['text'] as String?) ?? (json['text'] as String?) ?? 'Text';
      final fs = (props['fs'] as num?)?.toDouble() ??
          (json['fs'] as num?)?.toDouble() ??
          24;
      final fcHex =
          (props['fc'] as String?) ?? (json['fc'] as String?) ?? '#FF000000';
      final fc = hexToColor(fcHex) ?? Colors.black;
      final fwVal = (props['fw'] as int?) ??
          (json['fw'] as int?) ??
          FontWeight.w600.value;
      final fw = FontWeight.values.firstWhere(
        (w) => w.value == fwVal,
        orElse: () => FontWeight.w600,
      );
      final ff = (props['ff'] as String?) ?? (json['ff'] as String?);
      final fi = (props['fi'] as bool?) ?? (json['fi'] as bool?) ?? false;
      final fu = (props['fu'] as bool?) ?? (json['fu'] as bool?) ?? false;

      return CanvasItem(
        id: id,
        kind: kind,
        text: txt,
        fontSize: fs,
        fontColor: fc,
        fontWeight: fw,
        fontFamily: ff,
        fontItalic: fi,
        fontUnderline: fu,
        position: pos,
        size: size,
        locked: locked,
      );
    } else {
      final list =
          (props['colors'] as List?)?.cast<String>() ?? const <String>[];
      final colors = list
          .map((h) => hexToColor(h))
          .whereType<Color>()
          .toList(growable: false);
      final safe = colors.isNotEmpty
          ? colors
          : const [Color(0xFF111827), Color(0xFF6B7280), Color(0xFFE5E7EB)];
      return CanvasItem(
        id: id,
        kind: kind,
        paletteColors: List<Color>.from(safe),
        position: pos,
        size: size,
        locked: locked,
      );
    }
  }
}
