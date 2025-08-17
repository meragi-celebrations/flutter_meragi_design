import 'package:flutter/material.dart';

class HueSlider extends StatelessWidget {
  const HueSlider({
    super.key,
    required this.hue,
    required this.onHueChanged,
  });

  final double hue;
  final ValueChanged<double> onHueChanged;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        final RenderBox box = context.findRenderObject() as RenderBox;
        final double localDx = box.globalToLocal(details.globalPosition).dx;
        final double newHue = (localDx / box.size.width) * 360;
        onHueChanged(newHue.clamp(0.0, 360.0));
      },
      child: CustomPaint(
        size: const Size(double.infinity, 20),
        painter: HueSliderPainter(hue),
      ),
    );
  }
}

class HueSliderPainter extends CustomPainter {
  HueSliderPainter(this.hue);

  final double hue;

  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Offset.zero & size;
    const List<Color> colors = [
      Color(0xFFFF0000),
      Color(0xFFFFFF00),
      Color(0xFF00FF00),
      Color(0xFF00FFFF),
      Color(0xFF0000FF),
      Color(0xFFFF00FF),
      Color(0xFFFF0000),
    ];
    final Gradient gradient = LinearGradient(colors: colors);
    canvas.drawRect(rect, Paint()..shader = gradient.createShader(rect));

    final double thumbX = (hue / 360) * size.width;
    final Paint thumbPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawCircle(Offset(thumbX, size.height / 2), 8, thumbPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
