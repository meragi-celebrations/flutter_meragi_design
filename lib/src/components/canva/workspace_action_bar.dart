// lib/src/components/canva/workspace_action_bar.dart
import 'package:flutter/material.dart';
import 'package:flutter_meragi_design/flutter_meragi_design.dart';
import 'package:flutter_meragi_design/src/components/canva/items/shape.dart';
import 'package:flutter_meragi_design/src/components/canva/utils.dart';

import '../canva/canvas_doc.dart';
import '../canva/canvas_scope.dart';

class WorkspaceActionBar extends StatelessWidget {
  const WorkspaceActionBar({super.key});

  static const _swatches = <Color>[
    Colors.white,
    Color(0xFFF8FAFC),
    Color(0xFFFFFBEB),
    Color(0xFFEFEFEF),
    Color(0xFFFFE4E6),
    Color(0xFFECFEFF),
    Color(0xFFF0FDF4),
  ];

  static const _gridPresets = <double>[4, 8, 10, 12, 16, 20, 24, 32, 40, 48];

  Future<void> _promptCustomGridSpacing(
      BuildContext context, CanvasDoc doc) async {
    final ctrl =
        TextEditingController(text: doc.gridSpacing.toStringAsFixed(0));
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
    if (v != null && v > 0) {
      doc.applyPatch([
        {
          'type': 'canvas.update',
          'changes': {'gridSpacing': v}
        }
      ]);
    }
  }

  @override
  Widget build(BuildContext context) {
    final doc = CanvasScope.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
              blurRadius: 5, color: Color(0x33000000), offset: Offset(-2, 3))
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            MDTap.ghost(
              icon: const Icon(PhosphorIconsRegular.arrowArcLeft),
              onPressed: doc.undo,
            ),
            MDTap.ghost(
              icon: const Icon(PhosphorIconsRegular.arrowArcRight),
              onPressed: doc.redo,
            ),
            const VerticalDivider(width: 12),

            const Text('Canvas'),
            const SizedBox(width: 6),
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: doc.canvasColor,
                border: Border.all(color: Colors.black26),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(width: 6),
            PopupMenuButton<Color>(
              tooltip: 'Pick canvas color',
              onSelected: (c) => doc.applyPatch([
                {
                  'type': 'canvas.update',
                  'changes': {'color': colorToHex(c)}
                }
              ]),
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
              onPressed: () {
                final id = doc.newId();
                final item = TextItem(
                  id: id,
                  text: 'Double-click to edit',
                  position: const Offset(60, 60),
                  size: const Size(240, 96),
                );
                doc.beginUndoGroup('Add Text');
                doc.applyPatch([
                  {'type': 'insert', 'item': item.toJson(0)},
                  {
                    'type': 'selection.set',
                    'ids': [id]
                  },
                ]);
                doc.commitUndoGroup();
              },
              icon: const Icon(PhosphorIconsRegular.textT),
              child: const Text('Text'),
            ),
            const SizedBox(width: 8),
            MDTap.outline(
              onPressed: () {
                final id = doc.newId();
                final item = PaletteItem(
                  id: id,
                  paletteColors: const [
                    Color(0xFF111827),
                    Color(0xFF6B7280),
                    Color(0xFFE5E7EB)
                  ],
                  position: const Offset(60, 60),
                  size: const Size(320, 64),
                );
                doc.beginUndoGroup('Add Palette');
                doc.applyPatch([
                  {'type': 'insert', 'item': item.toJson(0)},
                  {
                    'type': 'selection.set',
                    'ids': [id]
                  },
                ]);
                doc.commitUndoGroup();
              },
              icon: const Icon(PhosphorIconsRegular.swatches),
              child: const Text('Palette'),
            ),
            const SizedBox(width: 8),
            PopupMenuButton<ShapeType>(
              tooltip: 'Add Shape',
              onSelected: (shapeType) {
                final id = doc.newId();
                final item = ShapeItem(
                  id: id,
                  shapeType: shapeType,
                  position: const Offset(60, 60),
                  size: const Size(120, 120),
                );
                doc.beginUndoGroup('Add Shape');
                doc.applyPatch([
                  {'type': 'insert', 'item': item.toJson(0)},
                  {
                    'type': 'selection.set',
                    'ids': [id]
                  },
                ]);
                doc.commitUndoGroup();
              },
              itemBuilder: (_) => [
                for (final type in ShapeType.values)
                  PopupMenuItem<ShapeType>(
                    value: type,
                    child: Text(type.name),
                  ),
              ],
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(PhosphorIconsRegular.square),
                  SizedBox(width: 6),
                  Text('Shape'),
                ],
              ),
            ),
            const VerticalDivider(width: 12),

            // Grid
            MDTap.ghost(
              onPressed: () => doc.applyPatch([
                {
                  'type': 'canvas.update',
                  'changes': {'gridVisible': !doc.gridVisible}
                }
              ]),
              icon: Icon(doc.gridVisible ? Icons.grid_on : Icons.grid_off),
            ),
            PopupMenuButton<double>(
              tooltip: 'Grid spacing',
              onSelected: (v) {
                if (v <= 0) {
                  _promptCustomGridSpacing(context, doc);
                } else {
                  doc.applyPatch([
                    {
                      'type': 'canvas.update',
                      'changes': {'gridSpacing': v}
                    }
                  ]);
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
                  value: -1,
                  child: Row(
                    children: [
                      Icon(Icons.edit, size: 18),
                      SizedBox(width: 8),
                      Text('Custom…')
                    ],
                  ),
                ),
              ],
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.grid_3x3),
                  const SizedBox(width: 6),
                  Text('${doc.gridSpacing.toStringAsFixed(0)}'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
