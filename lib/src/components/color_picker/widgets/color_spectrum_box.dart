import 'package:flutter/material.dart' hide HSVColor;

import '../utils/color_utils.dart' as cv;

class ColorSpectrumBox extends StatelessWidget {
  const ColorSpectrumBox({
    super.key,
    required this.hsvColor,
    required this.onColorChanged,
  });

  final cv.HSVColor hsvColor;
  final ValueChanged<cv.HSVColor> onColorChanged;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (details) {
        final RenderBox box = context.findRenderObject() as RenderBox;
        final Offset localOffset = box.globalToLocal(details.globalPosition);
        final double newSaturation =
            (localOffset.dx / box.size.width).clamp(0.0, 1.0);
        final double newValue =
            (1 - localOffset.dy / box.size.height).clamp(0.0, 1.0);
        onColorChanged(cv.HSVColor(hsvColor.h, newSaturation, newValue));
      },
      child: CustomPaint(
        size: const Size(double.infinity, 200),
        painter: ColorSpectrumPainter(hsvColor),
      ),
    );
  }
}

class ColorSpectrumPainter extends CustomPainter {
  ColorSpectrumPainter(this.hsvColor);

  final cv.HSVColor hsvColor;

  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Offset.zero & size;
    final Gradient saturationGradient = LinearGradient(
      colors: [
        Colors.white,
        cv.HSVColor.fromAHSV(1.0, hsvColor.h, 1.0, 1.0),
      ],
    );
    final Gradient valueGradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Colors.transparent,
        Colors.black,
      ],
    );
    canvas.drawRect(
        rect, Paint()..shader = saturationGradient.createShader(rect));
    canvas.drawRect(rect, Paint()..shader = valueGradient.createShader(rect));

    final double thumbX = hsvColor.s * size.width;
    final double thumbY = (1 - hsvColor.v) * size.height;
    final Paint thumbPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawCircle(Offset(thumbX, thumbY), 8, thumbPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
