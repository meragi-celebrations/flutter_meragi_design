import 'package:flutter/material.dart';

class CommonColorPicker extends StatelessWidget {
  const CommonColorPicker({
    super.key,
    required this.onColorSelected,
    required this.onOpenColorPicker,
    this.documentColors = const [],
  });

  final ValueChanged<Color> onColorSelected;
  final VoidCallback onOpenColorPicker;
  final List<Color> documentColors;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildDocumentColors(context),
        const SizedBox(height: 16),
        _buildSolidColors(context),
      ],
    );
  }

  Widget _buildDocumentColors(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Document Colors',
            style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            GestureDetector(
              onTap: onOpenColorPicker,
              child: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: const Icon(Icons.add, size: 16),
              ),
            ),
            for (final color in documentColors)
              GestureDetector(
                onTap: () => onColorSelected(color),
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                    border: color == Colors.white
                        ? Border.all(color: Colors.grey.shade300)
                        : null,
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildSolidColors(BuildContext context) {
    const solidColors = [
      Colors.black,
      Colors.white,
      Colors.red,
      Colors.green,
      Colors.blue,
      Colors.yellow,
      Colors.orange,
      Colors.purple,
      Colors.pink,
      Colors.teal,
      Colors.brown,
      Colors.grey,
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Solid Colors',
            style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final color in solidColors)
              GestureDetector(
                onTap: () => onColorSelected(color),
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                    border: color == Colors.white
                        ? Border.all(color: Colors.grey.shade300)
                        : null,
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}
