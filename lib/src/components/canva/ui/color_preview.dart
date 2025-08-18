import 'package:flutter/material.dart';

class ColorPreview extends StatelessWidget {
  const ColorPreview({
    super.key,
    this.color,
    required this.onTap,
  });

  final Color? color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade300),
        ),
      ),
    );
  }
}
