import 'package:flutter/material.dart';

class ColorPreview extends StatelessWidget {
  const ColorPreview({
    super.key,
    required this.color,
  });

  final Color color;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(48, 48),
      painter: CheckerboardPainter(),
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: Theme.of(context).dividerColor,
          ),
        ),
      ),
    );
  }
}

class CheckerboardPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()..color = const Color(0xFFCCCCCC);
    const double checkerSize = 8;
    for (double i = 0; i < size.width; i += checkerSize) {
      for (double j = 0; j < size.height; j += checkerSize) {
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
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
