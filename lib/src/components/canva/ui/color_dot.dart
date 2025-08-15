import 'package:flutter/material.dart';

class ColorDot extends StatelessWidget {
  const ColorDot(
      {required this.color, required this.selected, required this.onTap});
  final Color color;
  final bool selected;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    final borderColor =
        color.computeLuminance() < 0.5 ? Colors.white : Colors.black26;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 22,
        height: 22,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(
              color: selected
                  ? Theme.of(context).colorScheme.primary
                  : borderColor,
              width: selected ? 2 : 1),
        ),
      ),
    );
  }
}
