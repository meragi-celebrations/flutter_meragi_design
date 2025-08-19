// lib/src/components/canva/property_sidebar.dart
import 'package:flutter/material.dart';
import 'package:flutter_meragi_design/flutter_meragi_design.dart';
import 'package:flutter_meragi_design/src/components/canva/ui/number_input.dart';

import 'canvas_doc.dart';
import 'canvas_scope.dart';

class PropertiesSidebar extends StatefulWidget {
  const PropertiesSidebar({super.key});

  @override
  State<PropertiesSidebar> createState() => _PropertiesSidebarState();
}

class _PropertiesSidebarState extends State<PropertiesSidebar> {
  bool _begun = false;

  late TextEditingController _xCtrl;
  late TextEditingController _yCtrl;
  late TextEditingController _wCtrl;
  late TextEditingController _hCtrl;
  late TextEditingController _rotCtrl;

  @override
  void initState() {
    super.initState();
    _xCtrl = TextEditingController();
    _yCtrl = TextEditingController();
    _wCtrl = TextEditingController();
    _hCtrl = TextEditingController();
    _rotCtrl = TextEditingController();
  }

  @override
  void dispose() {
    if (_begun) {
      final doc = CanvasScope.of(context, listen: false);
      doc.commitUndoGroup();
    }
    _xCtrl.dispose();
    _yCtrl.dispose();
    _wCtrl.dispose();
    _hCtrl.dispose();
    _rotCtrl.dispose();
    super.dispose();
  }

  void _beginIfNeeded(CanvasDoc doc, String label) {
    if (_begun) return;
    _begun = true;
    doc.beginUndoGroup(label);
  }

  void _endIfNeeded(CanvasDoc doc) {
    if (!_begun) return;
    _begun = false;
    doc.commitUndoGroup();
  }

  @override
  Widget build(BuildContext context) {
    final doc = CanvasScope.of(context);
    final count = doc.selectedCount;
    final item = count == 1 ? doc.itemById(doc.selectedIds.first) : null;

    // keep controllers in sync
    if (item != null) {
      _xCtrl.text = item.position.dx.toStringAsFixed(0);
      _yCtrl.text = item.position.dy.toStringAsFixed(0);
      _wCtrl.text = item.size.width.toStringAsFixed(0);
      _hCtrl.text = item.size.height.toStringAsFixed(0);
      _rotCtrl.text = item.rotationDeg.toStringAsFixed(0);
    }

    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(left: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: switch (count) {
          0 => _EmptyPanel(),
          int c when c > 1 => _ActionsOnly(
              count: c,
              onDelete: () => _deleteSelected(doc),
              onDuplicate: () => _duplicateSelected(doc),
              onFront: () => _bringToFront(doc),
              onBack: () => _sendToBack(doc),
              onAlignLeft: () => _alignLeft(doc),
              onAlignHCenter: () => _alignHCenter(doc),
              onAlignRight: () => _alignRight(doc),
              onAlignTop: () => _alignTop(doc),
              onAlignVCenter: () => _alignVCenter(doc),
              onAlignBottom: () => _alignBottom(doc),
              onAlignCanvasHCenter: () => _alignCanvasHCenter(doc),
              onAlignCanvasVCenter: () => _alignCanvasVCenter(doc),
              onLockToggle: () => _toggleLock(doc),
              onDistributeHorizontally: () => _distributeHorizontally(doc),
              onDistributeVertically: () => _distributeVertically(doc),
            ),
          _ => SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _ActionsOnly(
                    count: 1,
                    onDelete: () => _deleteSelected(doc),
                    onDuplicate: () => _duplicateSelected(doc),
                    onFront: () => _bringToFront(doc),
                    onBack: () => _sendToBack(doc),
                    onAlignLeft: () => _alignLeft(doc),
                    onAlignHCenter: () => _alignHCenter(doc),
                    onAlignRight: () => _alignRight(doc),
                    onAlignTop: () => _alignTop(doc),
                    onAlignVCenter: () => _alignVCenter(doc),
                    onAlignBottom: () => _alignBottom(doc),
                    onAlignCanvasHCenter: () => _alignCanvasHCenter(doc),
                    onAlignCanvasVCenter: () => _alignCanvasVCenter(doc),
                    onLockToggle: () => _toggleLock(doc),
                    onDistributeHorizontally: () =>
                        _distributeHorizontally(doc),
                    onDistributeVertically: () => _distributeVertically(doc),
                  ),
                  MDDivider(),
                  const _SectionTitle('Item'),
                  _GenericItemProps(
                    xCtrl: _xCtrl,
                    yCtrl: _yCtrl,
                    wCtrl: _wCtrl,
                    hCtrl: _hCtrl,
                    rotCtrl: _rotCtrl,
                    onRectCommit: (dx, dy, w, h) {
                      final it = item;
                      if (it == null) return;
                      _beginIfNeeded(doc, 'Edit geometry');
                      doc.applyPatch([
                        {
                          'type': 'update',
                          'id': it.id,
                          'changes': {
                            'position': {'x': dx, 'y': dy},
                            'size': {'w': w, 'h': h},
                          }
                        }
                      ]);
                    },
                    onRotateCommit: (deg) {
                      final it = item;
                      if (it == null) return;
                      _beginIfNeeded(doc, 'Rotate');
                      doc.applyPatch([
                        {
                          'type': 'update',
                          'id': it.id,
                          'changes': {'rotationDeg': deg}
                        }
                      ]);
                    },
                    onEnd: () {
                      _endIfNeeded(doc);
                    },
                  ),
                  MDDivider(),
                  const SizedBox(height: 12),
                  if (item != null)
                    item.buildPropertiesEditor(
                      context,
                      onChangeStart: () => _beginIfNeeded(doc, 'Edit props'),
                      onChanged: (updated) {
                        doc.applyPatch([
                          {'type': 'replace', 'item': updated.toJson(0)}
                        ]);
                      },
                      onChangeEnd: () => _endIfNeeded(doc),
                    ),
                ],
              ),
            ),
        },
      ),
    );
  }

  // Actions implemented purely with patches

  void _deleteSelected(CanvasDoc doc) {
    final ids = doc.selectedIds.toList();
    if (ids.isEmpty) return;
    doc.beginUndoGroup('Delete');
    doc.applyPatch([
      for (final id in ids) {'type': 'remove', 'id': id},
      {'type': 'selection.set', 'ids': <String>[]},
    ]);
    doc.commitUndoGroup();
  }

  void _duplicateSelected(CanvasDoc doc) {
    final ids = doc.selectedIds.toList();
    if (ids.isEmpty) return;

    final newJsons = <Map<String, dynamic>>[];
    for (final id in ids) {
      final src = doc.itemById(id);
      final dup = src.copyWith(
        id: doc.newId(),
        position: src.position + const Offset(12, 12),
        locked: false,
      );
      newJsons.add(dup.toJson(0));
    }

    doc.beginUndoGroup('Duplicate');
    doc.applyPatch([
      for (final j in newJsons) {'type': 'insert', 'item': j, 'index': null},
      {
        'type': 'selection.set',
        'ids': newJsons.map((e) => e['id'] as String).toList(),
      }
    ]);
    doc.commitUndoGroup();
  }

  void _bringToFront(CanvasDoc doc) {
    final ids = doc.selectedIds.toList();
    if (ids.isEmpty) return;
    doc.beginUndoGroup('Bring front');
    // Remove then re-insert at end to preserve relative order
    final items = [
      for (final id in doc.items.map((e) => e.id))
        if (ids.contains(id)) doc.itemById(id)
    ];
    doc.applyPatch([
      for (final it in items) {'type': 'remove', 'id': it.id},
      for (final it in items)
        {'type': 'insert', 'item': it.toJson(0), 'index': null},
      {'type': 'selection.set', 'ids': ids},
    ]);
    doc.commitUndoGroup();
  }

  void _sendToBack(CanvasDoc doc) {
    final ids = doc.selectedIds.toList();
    if (ids.isEmpty) return;
    doc.beginUndoGroup('Send back');
    final items = [
      for (final id in doc.items.map((e) => e.id))
        if (ids.contains(id)) doc.itemById(id)
    ];
    doc.applyPatch([
      for (final it in items) {'type': 'remove', 'id': it.id},
      // insert at start in the same relative order
      for (int i = 0; i < items.length; i++)
        {'type': 'insert', 'item': items[i].toJson(0), 'index': i},
      {'type': 'selection.set', 'ids': ids},
    ]);
    doc.commitUndoGroup();
  }

  void _toggleLock(CanvasDoc doc) {
    final ids = doc.selectedIds.toList();
    if (ids.isEmpty) return;
    final anyUnlocked = ids.any((id) => !doc.itemById(id).locked);
    doc.beginUndoGroup('Lock toggle');
    doc.applyPatch([
      for (final id in ids)
        {
          'type': 'update',
          'id': id,
          'changes': {'locked': anyUnlocked}
        }
    ]);
    doc.commitUndoGroup();
  }

  void _alignLeft(CanvasDoc doc) {
    final ids = doc.selectedIds.toList();
    if (ids.length < 2) return;
    final left = ids
        .map((id) => doc.itemById(id).position.dx)
        .reduce((a, b) => a < b ? a : b);
    doc.beginUndoGroup('Align left');
    doc.applyPatch([
      for (final id in ids)
        {
          'type': 'update',
          'id': id,
          'changes': {
            'position': {'x': left, 'y': doc.itemById(id).position.dy}
          }
        }
    ]);
    doc.commitUndoGroup();
  }

  void _alignTop(CanvasDoc doc) {
    final ids = doc.selectedIds.toList();
    if (ids.length < 2) return;
    final top = ids
        .map((id) => doc.itemById(id).position.dy)
        .reduce((a, b) => a < b ? a : b);
    doc.beginUndoGroup('Align top');
    doc.applyPatch([
      for (final id in ids)
        {
          'type': 'update',
          'id': id,
          'changes': {
            'position': {'x': doc.itemById(id).position.dx, 'y': top}
          }
        }
    ]);
    doc.commitUndoGroup();
  }

  void _alignRight(CanvasDoc doc) {
    final ids = doc.selectedIds.toList();
    if (ids.length < 2) return;
    final right = ids.map((id) {
      final it = doc.itemById(id);
      return it.position.dx + it.size.width;
    }).reduce((a, b) => a > b ? a : b);
    doc.beginUndoGroup('Align right');
    doc.applyPatch([
      for (final id in ids)
        {
          'type': 'update',
          'id': id,
          'changes': {
            'position': {
              'x': right - doc.itemById(id).size.width,
              'y': doc.itemById(id).position.dy
            }
          }
        }
    ]);
    doc.commitUndoGroup();
  }

  void _alignBottom(CanvasDoc doc) {
    final ids = doc.selectedIds.toList();
    if (ids.length < 2) return;
    final bottom = ids.map((id) {
      final it = doc.itemById(id);
      return it.position.dy + it.size.height;
    }).reduce((a, b) => a > b ? a : b);
    doc.beginUndoGroup('Align bottom');
    doc.applyPatch([
      for (final id in ids)
        {
          'type': 'update',
          'id': id,
          'changes': {
            'position': {
              'x': doc.itemById(id).position.dx,
              'y': bottom - doc.itemById(id).size.height
            }
          }
        }
    ]);
    doc.commitUndoGroup();
  }

  void _alignHCenter(CanvasDoc doc) {
    final ids = doc.selectedIds.toList();
    if (ids.length < 2) return;
    final cx = ids.map((id) {
          final it = doc.itemById(id);
          return it.position.dx + it.size.width / 2;
        }).reduce((a, b) => a + b) /
        ids.length;
    doc.beginUndoGroup('Align center');
    doc.applyPatch([
      for (final id in ids)
        {
          'type': 'update',
          'id': id,
          'changes': {
            'position': {
              'x': cx - doc.itemById(id).size.width / 2,
              'y': doc.itemById(id).position.dy
            }
          }
        }
    ]);
    doc.commitUndoGroup();
  }

  void _alignVCenter(CanvasDoc doc) {
    final ids = doc.selectedIds.toList();
    if (ids.length < 2) return;
    final cy = ids.map((id) {
          final it = doc.itemById(id);
          return it.position.dy + it.size.height / 2;
        }).reduce((a, b) => a + b) /
        ids.length;
    doc.beginUndoGroup('Align middle');
    doc.applyPatch([
      for (final id in ids)
        {
          'type': 'update',
          'id': id,
          'changes': {
            'position': {
              'x': doc.itemById(id).position.dx,
              'y': cy - doc.itemById(id).size.height / 2
            }
          }
        }
    ]);
    doc.commitUndoGroup();
  }

  void _alignCanvasHCenter(CanvasDoc doc) {
    final ids = doc.selectedIds.toList();
    if (ids.isEmpty) return;
    final cx = doc.baseSize.width / 2;
    doc.beginUndoGroup('Center in canvas H');
    doc.applyPatch([
      for (final id in ids)
        {
          'type': 'update',
          'id': id,
          'changes': {
            'position': {
              'x': cx - doc.itemById(id).size.width / 2,
              'y': doc.itemById(id).position.dy
            }
          }
        }
    ]);
    doc.commitUndoGroup();
  }

  void _alignCanvasVCenter(CanvasDoc doc) {
    final ids = doc.selectedIds.toList();
    if (ids.isEmpty) return;
    final cy = doc.baseSize.height / 2;
    doc.beginUndoGroup('Center in canvas V');
    doc.applyPatch([
      for (final id in ids)
        {
          'type': 'update',
          'id': id,
          'changes': {
            'position': {
              'x': doc.itemById(id).position.dx,
              'y': cy - doc.itemById(id).size.height / 2
            }
          }
        }
    ]);
    doc.commitUndoGroup();
  }

  void _distributeHorizontally(CanvasDoc doc) {
    final ids = doc.selectedIds.toList();
    if (ids.length < 2) return;

    final items = ids.map((id) => doc.itemById(id)).toList();
    items.sort((a, b) => a.position.dx.compareTo(b.position.dx));

    final minX =
        items.map((e) => e.position.dx).reduce((a, b) => a < b ? a : b);
    final maxX = items
        .map((e) => e.position.dx + e.size.width)
        .reduce((a, b) => a > b ? a : b);

    final totalWidth =
        items.fold<double>(0, (sum, item) => sum + item.size.width);
    final totalSpace = maxX - minX;

    if (items.length <= 1) return;
    final gap = (totalSpace - totalWidth) / (items.length - 1);
    if (!gap.isFinite) return;

    doc.beginUndoGroup('Distribute horizontally');

    double currentX = minX;
    final patches = <Map<String, dynamic>>[];
    for (final item in items) {
      patches.add({
        'type': 'update',
        'id': item.id,
        'changes': {
          'position': {'x': currentX, 'y': item.position.dy}
        }
      });
      currentX += item.size.width + gap;
    }

    doc.applyPatch(patches);
    doc.commitUndoGroup();
  }

  void _distributeVertically(CanvasDoc doc) {
    final ids = doc.selectedIds.toList();
    if (ids.length < 2) return;

    final items = ids.map((id) => doc.itemById(id)).toList();
    items.sort((a, b) => a.position.dy.compareTo(b.position.dy));

    final minY =
        items.map((e) => e.position.dy).reduce((a, b) => a < b ? a : b);
    final maxY = items
        .map((e) => e.position.dy + e.size.height)
        .reduce((a, b) => a > b ? a : b);

    final totalHeight =
        items.fold<double>(0, (sum, item) => sum + item.size.height);
    final totalSpace = maxY - minY;

    if (items.length <= 1) return;
    final gap = (totalSpace - totalHeight) / (items.length - 1);
    if (!gap.isFinite) return;

    doc.beginUndoGroup('Distribute vertically');

    double currentY = minY;
    final patches = <Map<String, dynamic>>[];
    for (final item in items) {
      patches.add({
        'type': 'update',
        'id': item.id,
        'changes': {
          'position': {'x': item.position.dx, 'y': currentY}
        }
      });
      currentY += item.size.height + gap;
    }

    doc.applyPatch(patches);
    doc.commitUndoGroup();
  }
}

class _EmptyPanel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        '',
        style: TextStyle(color: Colors.grey.shade600),
        textAlign: TextAlign.center,
      ),
    );
  }
}

class _ActionsOnly extends StatelessWidget {
  const _ActionsOnly({
    required this.count,
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
    required this.onAlignCanvasHCenter,
    required this.onAlignCanvasVCenter,
    required this.onLockToggle,
    required this.onDistributeHorizontally,
    required this.onDistributeVertically,
  });

  final int count;
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
  final VoidCallback onAlignCanvasHCenter;
  final VoidCallback onAlignCanvasVCenter;
  final VoidCallback onLockToggle;
  final VoidCallback onDistributeHorizontally;
  final VoidCallback onDistributeVertically;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionTitle('Actions'),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _iconBtn(PhosphorIconsRegular.trash, 'Delete', onDelete),
            _iconBtn(PhosphorIconsRegular.copy, 'Duplicate', onDuplicate),
            _iconBtn(
                PhosphorIconsRegular.lockOpen, 'Lock/Unlock', onLockToggle),
            _iconBtn(Icons.flip_to_front_outlined, 'Bring front', onFront),
            _iconBtn(Icons.flip_to_back_outlined, 'Send back', onBack),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(color: Colors.grey.shade50),
              child: Row(
                children: [
                  _iconBtn(PhosphorIconsRegular.alignLeft, 'Align left',
                      onAlignLeft),
                  _iconBtn(PhosphorIconsRegular.alignCenterHorizontal,
                      'Align center', onAlignHCenter),
                  _iconBtn(PhosphorIconsRegular.alignRight, 'Align right',
                      onAlignRight),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(color: Colors.grey.shade50),
              child: Row(
                children: [
                  _iconBtn(
                      PhosphorIconsRegular.alignTop, 'Align top', onAlignTop),
                  _iconBtn(PhosphorIconsRegular.alignCenterVertical,
                      'Align middle', onAlignVCenter),
                  _iconBtn(PhosphorIconsRegular.alignBottom, 'Align bottom',
                      onAlignBottom),
                ],
              ),
            ),
          ]
              .map((w) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4), child: w))
              .toList(),
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _iconBtn(Icons.horizontal_distribute, 'Distribute horizontally',
                onDistributeHorizontally),
            _iconBtn(Icons.vertical_distribute, 'Distribute vertically',
                onDistributeVertically),
            _iconBtn(Icons.center_focus_strong, 'Center horizontally in canvas',
                onAlignCanvasHCenter),
            _iconBtn(Icons.center_focus_weak, 'Center vertically in canvas',
                onAlignCanvasVCenter),
          ],
        ),
        const SizedBox(height: 6),
        Text(count == 1 ? '1 selected' : '$count selected',
            style: const TextStyle(fontWeight: FontWeight.w600)),
      ],
    );
  }

  Widget _iconBtn(IconData icon, String tip, VoidCallback onTap) {
    return MDTap.ghost(
      onPressed: onTap,
      icon: Icon(icon),
      size: ShadButtonSize.sm,
    );
  }
}

class _GenericItemProps extends StatefulWidget {
  const _GenericItemProps({
    required this.xCtrl,
    required this.yCtrl,
    required this.wCtrl,
    required this.hCtrl,
    required this.rotCtrl,
    required this.onRectCommit,
    required this.onRotateCommit,
    required this.onEnd,
  });

  final TextEditingController xCtrl, yCtrl, wCtrl, hCtrl, rotCtrl;
  final void Function(double x, double y, double w, double h) onRectCommit;
  final void Function(double rotationDeg) onRotateCommit;
  final VoidCallback onEnd;

  @override
  State<_GenericItemProps> createState() => _GenericItemPropsState();
}

class _GenericItemPropsState extends State<_GenericItemProps> {
  void _commitRect() {
    final dx = double.tryParse(widget.xCtrl.text.trim()) ?? 0;
    final dy = double.tryParse(widget.yCtrl.text.trim()) ?? 0;
    final w = double.tryParse(widget.wCtrl.text.trim()) ?? 1;
    final h = double.tryParse(widget.hCtrl.text.trim()) ?? 1;
    widget.onRectCommit(dx, dy, w, h);
  }

  void _commitRot() {
    double r = double.tryParse(widget.rotCtrl.text.trim()) ?? 0;
    r = r % 360;
    if (r < 0) r += 360;
    widget.rotCtrl.text = r.toStringAsFixed(0);
    widget.onRotateCommit(r);
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Row(children: [
        CanvaNumberProperty(
          controller: widget.xCtrl,
          prefix: const Text('X'),
          onSubmitted: (_) => _commitRect(),
          onEditingComplete: _commitRect,
        ),
        const SizedBox(width: 8),
        CanvaNumberProperty(
          controller: widget.yCtrl,
          prefix: const Text('Y'),
          onSubmitted: (_) => _commitRect(),
          onEditingComplete: _commitRect,
        ),
      ]),
      const SizedBox(height: 8),
      Row(children: [
        CanvaNumberProperty(
          controller: widget.wCtrl,
          prefix: const Text('W'),
          onSubmitted: (_) => _commitRect(),
          onEditingComplete: _commitRect,
        ),
        const SizedBox(width: 8),
        CanvaNumberProperty(
          controller: widget.hCtrl,
          prefix: const Text('H'),
          onSubmitted: (_) => _commitRect(),
          onEditingComplete: _commitRect,
        ),
      ]),
      const SizedBox(height: 8),
      Row(children: [
        CanvaNumberProperty(
          controller: widget.rotCtrl,
          prefix: const Text('Rotation°'),
          onSubmitted: (_) => _commitRot(),
          onEditingComplete: _commitRot,
        ),
      ]),
      Slider(
        value: double.tryParse(widget.rotCtrl.text) ?? 0,
        min: 0,
        max: 360,
        onChanged: (v) {
          widget.rotCtrl.text = v.toStringAsFixed(0);
          _commitRot();
        },
        onChangeEnd: (_) => widget.onEnd(),
      ),
    ]);
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);
  final String text;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.w700)),
    );
  }
}
