import 'package:flutter/material.dart';

class MDLoadingIndicator extends StatelessWidget {
  final double radius, strokeWidth;
  final Color color;
  const MDLoadingIndicator(
      {Key? key,
      this.radius = 20,
      this.color = Colors.white,
      this.strokeWidth = 2})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: radius,
      width: radius,
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(color),
        strokeWidth: strokeWidth,
      ),
    );
  }
}
