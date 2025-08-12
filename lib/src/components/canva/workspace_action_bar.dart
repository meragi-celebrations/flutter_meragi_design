import 'package:flutter/material.dart';
import 'package:flutter_meragi_design/src/components/canva/utils.dart';

class WorkspaceActionBar extends StatelessWidget {
  const WorkspaceActionBar({
    super.key,
    required this.selectedCount,
    required this.canvasColor,
    required this.onUndo,
    required this.onRedo,
    required this.onColorPick,
    required this.onAddText,
    required this.onDelete,
    required this.onDuplicate,
    required this.onFront,
    required this.onBack,
    required this.onAlignLeft,
    required this.onAlignHCenter,
    required this.onAlignRight,
    required this.onAlignTop,
    required this.onAlignVCenter,
    required this.onAlignBottom,
    required this.onLockToggle,
  });

  final int selectedCount;
  final Color canvasColor;
  final VoidCallback onUndo;
  final VoidCallback onRedo;
  final ValueChanged<Color> onColorPick;
  final VoidCallback onAddText;

  final VoidCallback onDelete;
  final VoidCallback onDuplicate;
  final VoidCallback onFront;
  final VoidCallback onBack;
  final VoidCallback onAlignLeft;
  final VoidCallback onAlignHCenter;
  final VoidCallback onAlignRight;
  final VoidCallback onAlignTop;
  final VoidCallback onAlignVCenter;
  final VoidCallback onAlignBottom;
  final VoidCallback onLockToggle;

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
              onPressed: onUndo,
            ),
            IconButton(
              tooltip: 'Redo',
              icon: const Icon(Icons.redo),
              onPressed: onRedo,
            ),
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
            if (selectedCount > 0) ...[
              const VerticalDivider(width: 12),
              Text(
                '$selectedCount selected',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              IconButton(
                tooltip: 'Delete',
                icon: const Icon(Icons.delete_outline),
                onPressed: onDelete,
              ),
              IconButton(
                tooltip: 'Duplicate',
                icon: const Icon(Icons.control_point_duplicate_outlined),
                onPressed: onDuplicate,
              ),
              const VerticalDivider(width: 12),
              IconButton(
                tooltip: 'Bring to front',
                icon: const Icon(Icons.flip_to_front_outlined),
                onPressed: onFront,
              ),
              IconButton(
                tooltip: 'Send to back',
                icon: const Icon(Icons.flip_to_back_outlined),
                onPressed: onBack,
              ),
              const VerticalDivider(width: 12),
              IconButton(
                tooltip: 'Align left',
                icon: const Icon(Icons.align_horizontal_left),
                onPressed: onAlignLeft,
              ),
              IconButton(
                tooltip: 'Align center',
                icon: const Icon(Icons.align_horizontal_center),
                onPressed: onAlignHCenter,
              ),
              IconButton(
                tooltip: 'Align right',
                icon: const Icon(Icons.align_horizontal_right),
                onPressed: onAlignRight,
              ),
              IconButton(
                tooltip: 'Align top',
                icon: const Icon(Icons.align_vertical_top),
                onPressed: onAlignTop,
              ),
              IconButton(
                tooltip: 'Align middle',
                icon: const Icon(Icons.align_vertical_center),
                onPressed: onAlignVCenter,
              ),
              IconButton(
                tooltip: 'Align bottom',
                icon: const Icon(Icons.align_vertical_bottom),
                onPressed: onAlignBottom,
              ),
              const VerticalDivider(width: 12),
              IconButton(
                tooltip: 'Lock or unlock',
                icon: const Icon(Icons.lock_open),
                onPressed: onLockToggle,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
