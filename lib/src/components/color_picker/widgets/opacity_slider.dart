import 'package:flutter/material.dart' hide HSVColor;

import '../utils/color_utils.dart';

class OpacitySlider extends StatelessWidget {
  const OpacitySlider({
    super.key,
    required this.hsvColor,
    required this.opacity,
    required this.onOpacityChanged,
  });

  final HSVColor hsvColor;
  final double opacity;
  final ValueChanged<double> onOpacityChanged;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        final RenderBox box = context.findRenderObject() as RenderBox;
        final double localDx = box.globalToLocal(details.globalPosition).dx;
        final double newOpacity = (localDx / box.size.width);
        onOpacityChanged(newOpacity.clamp(0.0, 1.0));
      },
      child: CustomPaint(
        size: const Size(double.infinity, 20),
        painter: OpacitySliderPainter(hsvColor, opacity),
      ),
    );
  }
}

class OpacitySliderPainter extends CustomPainter {
  OpacitySliderPainter(this.hsvColor, this.opacity);

  final HSVColor hsvColor;
  final double opacity;

  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Offset.zero & size;

    _drawCheckerboard(canvas, rect);

    final Gradient gradient = LinearGradient(
      colors: [
        hsvColor.toColor().withOpacity(0),
        hsvColor.toColor().withOpacity(1),
      ],
    );
    canvas.drawRect(rect, Paint()..shader = gradient.createShader(rect));

    final double thumbX = opacity * size.width;
    final Paint thumbPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawCircle(Offset(thumbX, size.height / 2), 8, thumbPaint);
  }

  void _drawCheckerboard(Canvas canvas, Rect rect) {
    final Paint paint = Paint()..color = const Color(0xFFCCCCCC);
    const double checkerSize = 4;
    for (double i = 0; i < rect.width; i += checkerSize) {
      for (double j = 0; j < rect.height; j += checkerSize) {
        if ((i / checkerSize).floor() % 2 == (j / checkerSize).floor() % 2) {
          canvas.drawRect(
            Rect.fromLTWH(i, j, checkerSize, checkerSize),
            paint,
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
