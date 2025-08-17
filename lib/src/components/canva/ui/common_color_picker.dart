import 'package:colornames/colornames.dart';
import 'package:flutter/material.dart';
import 'package:flutter_meragi_design/flutter_meragi_design.dart';
import 'package:flutter_meragi_design/src/components/canva/canvas_doc.dart';
import 'package:flutter_meragi_design/src/components/canva/items/image.dart';
import 'package:flutter_meragi_design/src/components/canva/scaling.dart';

const CIRCLE_SIZE = 45.0;

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
    return MDPanel(
      width: 350,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildDocumentColors(context),
          const SizedBox(height: 16),
          _PhotoColors(doc: doc, onColorSelected: onColorSelected),
          const SizedBox(height: 16),
          _buildSolidColors(context),
        ],
      ),
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
            MDGestureDetector(
              onTap: onOpenColorPicker,
              child: Container(
                width: CIRCLE_SIZE,
                height: CIRCLE_SIZE,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: const Icon(Icons.add, size: CIRCLE_SIZE / 2),
              ),
            ),
            for (final color in doc.documentColors)
              _ColorSwatch(color: color, onColorSelected: onColorSelected),
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
              _ColorSwatch(color: color, onColorSelected: onColorSelected),
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
                    width: CIRCLE_SIZE,
                    height: CIRCLE_SIZE,
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
                          _ColorSwatch(
                              color: color, onColorSelected: onColorSelected),
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

class _ColorSwatch extends StatefulWidget {
  const _ColorSwatch({
    required this.color,
    required this.onColorSelected,
  });

  final Color color;
  final ValueChanged<Color> onColorSelected;

  @override
  State<_ColorSwatch> createState() => _ColorSwatchState();
}

class _ColorSwatchState extends State<_ColorSwatch> {
  bool _isHovered = false;

  String get hexColor =>
      '#${widget.color.value.toRadixString(16).substring(2).toUpperCase()}';

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: '${widget.color.colorName}\n$hexColor',
      child: MDGestureDetector(
        onTap: () => widget.onColorSelected(widget.color),
        child: MouseRegion(
          onEnter: (_) => setState(() => _isHovered = true),
          onExit: (_) => setState(() => _isHovered = false),
          child: Container(
            width: CIRCLE_SIZE,
            height: CIRCLE_SIZE,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: widget.color == Colors.white
                  ? Border.all(color: Colors.grey.shade300)
                  : Border.all(color: widget.color),
            ),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              margin: EdgeInsets.all(_isHovered ? 3.0 : 0.0),
              decoration: BoxDecoration(
                color: widget.color,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
