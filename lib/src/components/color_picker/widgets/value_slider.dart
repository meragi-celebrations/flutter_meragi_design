import 'package:flutter/material.dart' hide HSVColor;

import '../utils/color_utils.dart';

class ValueSlider extends StatelessWidget {
  const ValueSlider({
    super.key,
    required this.hsvColor,
    required this.onValueChanged,
  });

  final HSVColor hsvColor;
  final ValueChanged<double> onValueChanged;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        final RenderBox box = context.findRenderObject() as RenderBox;
        final double localDx = box.globalToLocal(details.globalPosition).dx;
        final double newValue = (localDx / box.size.width);
        onValueChanged(newValue.clamp(0.0, 1.0));
      },
      child: CustomPaint(
        size: const Size(double.infinity, 20),
        painter: ValueSliderPainter(hsvColor),
      ),
    );
  }
}

class ValueSliderPainter extends CustomPainter {
  ValueSliderPainter(this.hsvColor);

  final HSVColor hsvColor;

  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Offset.zero & size;
    final Gradient gradient = LinearGradient(
      colors: [
        HSVColor.fromAHSV(1, hsvColor.h, hsvColor.s, 0),
        HSVColor.fromAHSV(1, hsvColor.h, hsvColor.s, 1),
      ],
    );
    canvas.drawRect(rect, Paint()..shader = gradient.createShader(rect));

    final double thumbX = hsvColor.v * size.width;
    final Paint thumbPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawCircle(Offset(thumbX, size.height / 2), 8, thumbPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
