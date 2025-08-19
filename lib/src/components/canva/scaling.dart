import 'package:flutter/material.dart';

/// Converts between the fixed base canvas space and the current rendered space.
/// Store ALL model values in base units. Use this to render and to map gestures.
class CanvasScaleHandler {
  const CanvasScaleHandler({
    required this.baseSize,
    required this.renderSize,
  });

  final Size baseSize;
  final Size renderSize;

  double get sx => renderSize.width / baseSize.width;
  double get sy => renderSize.height / baseSize.height;

  /// With preserved aspect, sx == sy. Use s when scaling fonts, strokes, etc.
  double get s => sx;

  // Base -> Render
  Offset baseToRender(Offset p) => Offset(p.dx * sx, p.dy * sy);
  Size baseToRenderSize(Size z) => Size(z.width * sx, z.height * sy);

  // Render -> Base
  Offset renderToBase(Offset p) => Offset(p.dx / sx, p.dy / sy);
  Offset renderDeltaToBase(Offset d) => Offset(d.dx / sx, d.dy / sy);

  // Helpers
  double fontBaseToRender(double fs) => fs * s;

  CanvasScaleHandler copyWith({
    Size? baseSize,
    Size? renderSize,
  }) {
    return CanvasScaleHandler(
      baseSize: baseSize ?? this.baseSize,
      renderSize: renderSize ?? this.renderSize,
    );
  }

  static CanvasScaleHandler initial() =>
      const CanvasScaleHandler(baseSize: Size(1, 1), renderSize: Size(1, 1));
}
