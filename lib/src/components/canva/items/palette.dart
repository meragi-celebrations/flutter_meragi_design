import 'package:flutter/material.dart';
import 'package:flutter_meragi_design/flutter_meragi_design.dart';
import 'package:flutter_meragi_design/src/components/canva/canvas_scope.dart';
import 'package:flutter_meragi_design/src/components/canva/scaling.dart';
import 'package:flutter_meragi_design/src/components/canva/ui/color_preview.dart';
import 'package:flutter_meragi_design/src/components/canva/ui/common_color_picker.dart';
import 'package:flutter_meragi_design/src/components/canva/ui/dialog_manager_scope.dart';
import 'package:flutter_meragi_design/src/components/canva/ui/draggable_dialog.dart';
import 'package:flutter_meragi_design/src/components/canva/utils.dart';

class PaletteItem extends CanvasItem {
  const PaletteItem({
    required super.id,
    required super.position,
    required super.size,
    List<Color>? paletteColors,
    super.locked = false,
    super.rotationDeg = 0,
  }) : paletteColors = paletteColors ??
            const [Color(0xFF111827), Color(0xFF6B7280), Color(0xFFE5E7EB)];

  final List<Color> paletteColors;

  @override
  CanvasItemKind get kind => CanvasItemKind.palette;

  @override
  Widget buildContent(CanvasScaleHandler scale) {
    final s = scale.s;
    final gap = 4.0 * s;
    final pad = 6.0 * s;
    if (paletteColors.isEmpty) return const SizedBox.shrink();

    final children = <Widget>[];
    for (int i = 0; i < paletteColors.length; i++) {
      if (i > 0) children.add(SizedBox(width: gap));
      children.add(Expanded(child: Container(color: paletteColors[i])));
    }

    return Padding(
      padding: EdgeInsets.all(pad),
      child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch, children: children),
    );
  }

  @override
  Widget buildPropertiesEditor(BuildContext context,
      {required VoidCallback onChangeStart,
      required ValueChanged<CanvasItem> onChanged,
      required VoidCallback onChangeEnd}) {
    return _PalettePropsEditor(
        item: this,
        onBegin: onChangeStart,
        onChange: onChanged,
        onEnd: onChangeEnd);
  }

  @override
  CanvasItem copyWith({
    String? id,
    Offset? position,
    Size? size,
    bool? locked,
    double? rotationDeg,
    List<Color>? paletteColors,
  }) =>
      PaletteItem(
        id: id ?? this.id,
        position: position ?? this.position,
        size: size ?? this.size,
        locked: locked ?? this.locked,
        rotationDeg: rotationDeg ?? this.rotationDeg,
        paletteColors: paletteColors ?? this.paletteColors,
      );

  @override
  Map<String, dynamic> propsToJson() => {
        'colors': [for (final c in paletteColors) colorToHex(c)]
      };

  static PaletteItem fromJson(Map<String, dynamic> j) {
    final p = (j['props'] as Map?)?.cast<String, dynamic>() ?? const {};
    final list = (p['colors'] as List?)?.cast<String>() ?? const <String>[];
    final colors =
        list.map(hexToColor).whereType<Color>().toList(growable: false);
    final safe = colors.isNotEmpty
        ? colors
        : const [Color(0xFF111827), Color(0xFF6B7280), Color(0xFFE5E7EB)];

    return PaletteItem(
      id: (j['id'] as String?) ??
          DateTime.now().microsecondsSinceEpoch.toString(),
      position: Offset(
          (j['x'] as num?)?.toDouble() ?? 0, (j['y'] as num?)?.toDouble() ?? 0),
      size: Size((j['w'] as num?)?.toDouble() ?? 320,
          (j['h'] as num?)?.toDouble() ?? 64),
      locked: (j['locked'] as bool?) ?? false,
      rotationDeg: (j['rot'] as num?)?.toDouble() ?? 0,
      paletteColors: List<Color>.from(safe),
    );
  }
}

/// ---------- Text editors, Palette editors, helpers (unchanged UI) ----------

class _PalettePropsEditor extends StatefulWidget {
  const _PalettePropsEditor({
    required this.item,
    required this.onBegin,
    required this.onChange,
    required this.onEnd,
  });
  final PaletteItem item;
  final VoidCallback onBegin;
  final ValueChanged<CanvasItem> onChange;
  final VoidCallback onEnd;

  @override
  State<_PalettePropsEditor> createState() => _PalettePropsEditorState();
}

class _PalettePropsEditorState extends State<_PalettePropsEditor> {
  final _rows = <_PaletteRow>[];
  bool _begun = false;

  void _begin() {
    if (_begun) return;
    _begun = true;
    widget.onBegin();
  }

  @override
  void initState() {
    super.initState();
    _rebuildRowsFromItem();
  }

  @override
  void didUpdateWidget(covariant _PalettePropsEditor oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.item.id != widget.item.id) {
      if (_begun) {
        widget.onEnd();
        _begun = false;
      }
      _disposeRows();
      _rebuildRowsFromItem();
      setState(() {});
    }
  }

  @override
  void dispose() {
    _disposeRows();
    super.dispose();
  }

  void _disposeRows() {
    for (final r in _rows) {
      r.ctrl.dispose();
    }
    _rows.clear();
  }

  void _rebuildRowsFromItem() {
    for (final c in widget.item.paletteColors) {
      _rows.add(_PaletteRow(initial: colorToHex(c)));
    }
    if (_rows.isEmpty) _rows.add(_PaletteRow(initial: '#FF000000'));
  }

  void _commit() {
    _begin();
    final list = <Color>[];
    for (final r in _rows) {
      final c = hexToColor(r.ctrl.text);
      if (c != null) list.add(c);
    }
    if (list.isEmpty) return;
    final u =
        (widget.item.copyWith() as PaletteItem).copyWith(paletteColors: list);
    widget.onChange(u);
  }

  void _addRow() {
    setState(() => _rows.add(_PaletteRow(initial: '#FFFFFFFF')));
    _commit();
  }

  void _removeRow(int i) {
    if (_rows.length <= 1) return;
    setState(() => _rows.removeAt(i));
    _commit();
  }

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const SectionTitle('Palette'),
      ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: _rows.length,
        itemBuilder: (context, i) {
          final row = _rows[i];
          final preview = hexToColor(row.ctrl.text);
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(children: [
              Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  color: preview ?? Colors.transparent,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    color: preview == null ? Colors.red : Colors.black26,
                    width: 1,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: row.ctrl,
                  decoration: const InputDecoration(
                    isDense: true,
                    border: OutlineInputBorder(),
                    hintText: 'Hex Color',
                  ),
                  onChanged: (_) => _commit(),
                  onSubmitted: (_) => _commit(),
                ),
              ),
              const SizedBox(width: 8),
              ColorPreview(
                color: hexToColor(row.ctrl.text),
                onTap: () {
                  final doc = CanvasScope.of(context, listen: false);
                  final dialogManager = DialogManagerScope.of(context);
                  late DraggableDialog dialog;
                  dialog = DraggableDialog(
                    onClose: () => dialogManager.close(dialog),
                    child: CommonColorPicker(
                      doc: doc,
                      onColorSelected: (c) {
                        row.ctrl.text = colorToHex(c);
                        _commit();
                      },
                      onOpenColorPicker: () {
                        dialogManager.close(dialog);
                        late DraggableDialog colorPickerDialog;
                        colorPickerDialog = DraggableDialog(
                          title: 'Select Color',
                          onClose: () => dialogManager.close(colorPickerDialog),
                          child: MDColorPicker(
                            initialColor: hexToColor(row.ctrl.text),
                            onColorChanged: (c) {
                              row.ctrl.text = colorToHex(c);
                              _commit();
                            },
                            onDone: (c) {
                              doc.applyPatch([
                                {
                                  'type': 'doc.colors.add',
                                  'color': colorToHex(c),
                                }
                              ]);
                              row.ctrl.text = colorToHex(c);
                              _commit();
                              dialogManager.close(colorPickerDialog);
                            },
                          ),
                        );
                        dialogManager.show(colorPickerDialog);
                      },
                    ),
                  );
                  dialogManager.show(dialog);
                },
              ),
              IconButton(
                onPressed: () => _removeRow(i),
                icon: const Icon(Icons.remove_circle_outline),
              ),
            ]),
          );
        },
      ),
      const SizedBox(height: 8),
      Row(children: [
        OutlinedButton.icon(
          onPressed: _addRow,
          icon: const Icon(Icons.add),
          label: const Text('Add color'),
        ),
        const SizedBox(width: 8),
        Text('${_rows.length} color${_rows.length == 1 ? '' : 's'}'),
        const Spacer(),
        if (_begun)
          TextButton(onPressed: widget.onEnd, child: const Text('Done')),
      ]),
    ]);
  }
}

class _PaletteRow {
  _PaletteRow({required String initial})
      : ctrl = TextEditingController(text: initial);
  final TextEditingController ctrl;
}
