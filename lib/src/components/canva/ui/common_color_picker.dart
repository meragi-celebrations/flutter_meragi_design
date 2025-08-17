import 'package:flutter/material.dart';
import 'package:flutter_meragi_design/src/components/canva/canvas_doc.dart';
import 'package:flutter_meragi_design/src/components/canva/items/image.dart';
import 'package:flutter_meragi_design/src/components/canva/scaling.dart';

class CommonColorPicker extends StatelessWidget {
  const CommonColorPicker({
    super.key,
    required this.onColorSelected,
    required this.onOpenColorPicker,
    required this.doc,
  });

  final ValueChanged<Color> onColorSelected;
  final VoidCallback onOpenColorPicker;
  final CanvasDoc doc;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildDocumentColors(context),
        const SizedBox(height: 16),
        _PhotoColors(doc: doc, onColorSelected: onColorSelected),
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
            for (final color in doc.documentColors)
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

class _PhotoColors extends StatelessWidget {
  const _PhotoColors({required this.doc, required this.onColorSelected});

  final CanvasDoc doc;
  final ValueChanged<Color> onColorSelected;

  @override
  Widget build(BuildContext context) {
    final imageItems = doc.items.whereType<ImageItem>().toList();
    if (imageItems.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Photo Colors',
            style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        for (final item in imageItems)
          if (item.extractedColors.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                children: [
                  SizedBox(
                    width: 32,
                    height: 32,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: item.buildContent(
                        CanvasScaleHandler(
                          baseSize: item.size,
                          renderSize: const Size(32, 32),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        for (final color in item.extractedColors)
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
                  ),
                ],
              ),
            ),
      ],
    );
  }
}
