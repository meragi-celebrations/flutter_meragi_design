import 'package:flutter/material.dart';
import 'package:flutter_meragi_design/flutter_meragi_design.dart';
import 'package:flutter_meragi_design/src/components/canva/utils.dart';

class WorkspaceActionBar extends StatelessWidget {
  const WorkspaceActionBar({
    super.key,
    required this.canvasColor,
    required this.onUndo,
    required this.onRedo,
    required this.onColorPick,
    required this.onAddText,
    required this.onAddPalette,
    // Grid
    required this.gridVisible,
    required this.gridSpacing,
    required this.onGridToggle,
    required this.onGridSpacingChanged,
  });

  final Color canvasColor;
  final VoidCallback onUndo;
  final VoidCallback onRedo;
  final ValueChanged<Color> onColorPick;
  final VoidCallback onAddText;
  final VoidCallback onAddPalette;

  // Grid
  final bool gridVisible;
  final double gridSpacing;
  final VoidCallback onGridToggle;
  final ValueChanged<double> onGridSpacingChanged;

  static const _swatches = <Color>[
    Colors.white,
    Color(0xFFF8FAFC),
    Color(0xFFFFFBEB),
    Color(0xFFEFEFEF),
    Color(0xFFFFE4E6),
    Color(0xFFECFEFF),
    Color(0xFFF0FDF4),
  ];

  // Grid Spacing Helper
  static const _gridPresets = <double>[4, 8, 10, 12, 16, 20, 24, 32, 40, 48];

  Future<void> _promptCustomGridSpacing(BuildContext context) async {
    final ctrl = TextEditingController(text: gridSpacing.toStringAsFixed(0));
    final v = await showDialog<double>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Grid spacing'),
        content: TextField(
          controller: ctrl,
          keyboardType: const TextInputType.numberWithOptions(
              decimal: true, signed: false),
          decoration: const InputDecoration(
              isDense: true,
              border: OutlineInputBorder(),
              hintText: 'Spacing in pixels (base units)'),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel')),
          FilledButton(
            onPressed: () {
              final val = double.tryParse(ctrl.text.trim());
              Navigator.pop(context, val);
            },
            child: const Text('Apply'),
          ),
        ],
      ),
    );
    if (v != null && v > 0) onGridSpacingChanged(v);
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        // border: Border.all(color: Colors.black12),
        boxShadow: [
          BoxShadow(
            blurRadius: 5,
            color: const Color(0x33000000),
            offset: const Offset(-2, 3),
          )
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            MDTap.ghost(
                icon: const Icon(PhosphorIconsRegular.arrowArcLeft),
                onPressed: onUndo),
            MDTap.ghost(
                icon: const Icon(PhosphorIconsRegular.arrowArcRight),
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
              child: const Icon(PhosphorIconsRegular.palette),
            ),
            const SizedBox(width: 8),
            MDTap.outline(
              onPressed: onAddText,
              icon: const Icon(PhosphorIconsRegular.textT),
              child: const Text('Text'),
            ),
            const SizedBox(width: 8),
            MDTap.outline(
              onPressed: onAddPalette,
              icon: const Icon(PhosphorIconsRegular.swatches),
              child: const Text('Palette'),
            ),
            const VerticalDivider(width: 12),

            // Grid toggle
            MDTap.ghost(
              onPressed: onGridToggle,
              icon: Icon(gridVisible ? Icons.grid_on : Icons.grid_off),
            ),

            // Grid spacing menu
            PopupMenuButton<double>(
              tooltip: 'Grid spacing',
              onSelected: (v) {
                if (v <= 0) {
                  _promptCustomGridSpacing(context);
                } else {
                  onGridSpacingChanged(v);
                }
              },
              itemBuilder: (_) => [
                for (final v in _gridPresets)
                  PopupMenuItem<double>(
                    value: v,
                    child: Text('${v.toStringAsFixed(0)} px'),
                  ),
                const PopupMenuDivider(),
                const PopupMenuItem<double>(
                  value: -1, // sentinel for custom
                  child: Row(
                    children: [
                      Icon(Icons.edit, size: 18),
                      SizedBox(width: 8),
                      Text('Custom…'),
                    ],
                  ),
                ),
              ],
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.grid_3x3),
                  const SizedBox(width: 6),
                  Text('${gridSpacing.toStringAsFixed(0)}'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
