import 'package:flutter/material.dart';
import 'package:flutter_meragi_design/src/components/canva/scaling.dart';

class GridPainter extends CustomPainter {
  GridPainter({
    required this.spacingBase,
    required this.scale,
    this.color = const Color(0x1F000000),
    this.boldEvery = 4,
  });

  final double spacingBase; // in BASE units
  final CanvasScaleHandler scale;
  final Color color;
  final int boldEvery;

  @override
  void paint(Canvas canvas, Size size) {
    final spacingRender = spacingBase * scale.s;
    if (spacingRender < 4) return; // avoid overdraw if tiny

    final paintMinor = Paint()
      ..color = color
      ..strokeWidth = 1;
    final paintMajor = Paint()
      ..color = color.withOpacity((color.opacity * 1.6).clamp(0, 1))
      ..strokeWidth = 1;

    final cols = (size.width / spacingRender).ceil();
    final rows = (size.height / spacingRender).ceil();

    // verticals
    for (int i = 0; i <= cols; i++) {
      final x = (i * spacingRender).floorToDouble() + 0.5;
      final p = (boldEvery > 0 && i % boldEvery == 0) ? paintMajor : paintMinor;
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), p);
    }

    // horizontals
    for (int j = 0; j <= rows; j++) {
      final y = (j * spacingRender).floorToDouble() + 0.5;
      final p = (boldEvery > 0 && j % boldEvery == 0) ? paintMajor : paintMinor;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), p);
    }
  }

  @override
  bool shouldRepaint(covariant GridPainter old) {
    return spacingBase != old.spacingBase ||
        scale.renderSize != old.scale.renderSize ||
        color.value != old.color.value ||
        boldEvery != old.boldEvery;
  }
}
