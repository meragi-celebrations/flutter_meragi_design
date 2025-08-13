import 'package:flutter/material.dart';
import 'package:flutter_meragi_design/src/components/canva/utils.dart';

class WorkspaceActionBar extends StatelessWidget {
  const WorkspaceActionBar({
    super.key,
    required this.canvasColor,
    required this.onUndo,
    required this.onRedo,
    required this.onColorPick,
    required this.onAddText,
  });

  final Color canvasColor;
  final VoidCallback onUndo;
  final VoidCallback onRedo;
  final ValueChanged<Color> onColorPick;
  final VoidCallback onAddText;

  static const _swatches = <Color>[
    Colors.white,
    Color(0xFFF8FAFC),
    Color(0xFFFFFBEB),
    Color(0xFFEFEFEF),
    Color(0xFFFFE4E6),
    Color(0xFFECFEFF),
    Color(0xFFF0FDF4),
  ];

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(blurRadius: 8, color: Colors.black26)],
        border: Border.all(color: Colors.black12),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
                tooltip: 'Undo',
                icon: const Icon(Icons.undo),
                onPressed: onUndo),
            IconButton(
                tooltip: 'Redo',
                icon: const Icon(Icons.redo),
                onPressed: onRedo),
            const VerticalDivider(width: 12),
            const Text('Canvas'),
            const SizedBox(width: 6),
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: canvasColor,
                border: Border.all(color: Colors.black26),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(width: 6),
            PopupMenuButton<Color>(
              tooltip: 'Pick canvas color',
              onSelected: onColorPick,
              itemBuilder: (_) => [
                for (final c in _swatches)
                  PopupMenuItem<Color>(
                    value: c,
                    child: Row(
                      children: [
                        Container(
                          width: 16,
                          height: 16,
                          decoration: BoxDecoration(
                            color: c,
                            border: Border.all(color: Colors.black26),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(colorToHex(c)),
                      ],
                    ),
                  ),
              ],
              child: const Icon(Icons.palette_outlined),
            ),
            const SizedBox(width: 8),
            ElevatedButton.icon(
              onPressed: onAddText,
              icon: const Icon(Icons.text_fields),
              label: const Text('Text'),
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: Colors.white,
                foregroundColor: Colors.black87,
                side: const BorderSide(color: Colors.black12),
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
