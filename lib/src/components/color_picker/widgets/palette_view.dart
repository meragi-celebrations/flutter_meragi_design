import 'package:flutter/material.dart';

class PaletteView extends StatelessWidget {
  const PaletteView({
    super.key,
    required this.colors,
    required this.onColorSelected,
  });

  final List<Color> colors;
  final ValueChanged<Color> onColorSelected;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final color in colors)
          GestureDetector(
            onTap: () => onColorSelected(color),
            child: Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  color: Colors.grey.shade300,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
