import 'package:flutter/material.dart';
import 'package:flutter_meragi_design/flutter_meragi_design.dart';
import 'package:flutter_meragi_design/src/components/canva/canvas_scope.dart';
import 'package:flutter_meragi_design/src/components/canva/scaling.dart';
import 'package:flutter_meragi_design/src/components/canva/ui/color_preview.dart';
import 'package:flutter_meragi_design/src/components/canva/ui/common_color_picker.dart';
import 'package:flutter_meragi_design/src/components/canva/ui/dialog_manager_scope.dart';
import 'package:flutter_meragi_design/src/components/canva/ui/draggable_dialog.dart';
import 'package:flutter_meragi_design/src/components/canva/utils.dart';

enum PaletteType { rectangle, circle }

class PaletteItem extends CanvasItem {
  PaletteItem({
    required super.id,
    required super.position,
    required super.size,
    List<Color>? paletteColors,
    this.paletteType = PaletteType.rectangle,
    super.locked = false,
    super.rotationDeg = 0,
  }) : paletteColors = paletteColors ??
            const [Color(0xFF111827), Color(0xFF6B7280), Color(0xFFE5E7EB)];

  List<Color> paletteColors;
  PaletteType paletteType;

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
      Widget colorWidget = Container(color: paletteColors[i]);
      if (paletteType == PaletteType.circle) {
        colorWidget = ClipOval(child: colorWidget);
      }
      children.add(Expanded(child: colorWidget));
    }

    return Padding(
      padding: EdgeInsets.all(pad),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: children,
      ),
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
  CanvasItem cloneWith({String? id}) => PaletteItem(
        id: id ?? this.id,
        position: position,
        size: size,
        paletteColors: List<Color>.from(paletteColors),
        paletteType: paletteType,
        locked: locked,
        rotationDeg: rotationDeg,
      );

  @override
  Map<String, dynamic> propsToJson() => {
        'colors': [for (final c in paletteColors) colorToHex(c)],
        'type': paletteType.name,
      };

  static PaletteItem fromJson(Map<String, dynamic> j) {
    final p = (j['props'] as Map?)?.cast<String, dynamic>() ?? const {};
    final list = (p['colors'] as List?)?.cast<String>() ?? const <String>[];
    final colors =
        list.map(hexToColor).whereType<Color>().toList(growable: false);
    final type =
        p['type'] == 'circle' ? PaletteType.circle : PaletteType.rectangle;
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
      paletteType: type,
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
  late PaletteType _type = widget.item.paletteType;
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
      setState(() => _type = widget.item.paletteType);
    }
  }

  @override
  void dispose() {
    _disposeRows();
    super.dispose();
  }

  void _disposeRows() {
    _rows.clear();
  }

  void _rebuildRowsFromItem() {
    for (final c in widget.item.paletteColors) {
      _rows.add(_PaletteRow(color: c));
    }
    if (_rows.isEmpty) {
      _rows.add(_PaletteRow(color: const Color(0xFF000000)));
    }
  }

  void _commit() {
    _begin();
    final list = <Color>[];
    for (final r in _rows) {
      list.add(r.color);
    }
    if (list.isEmpty) return;
    final u = widget.item.cloneWith() as PaletteItem
      ..paletteColors = list
      ..paletteType = _type;
    widget.onChange(u);
  }

  void _addRow() {
    setState(() => _rows.add(_PaletteRow(color: const Color(0xFFFFFFFF))));
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
      const SizedBox(height: 16),
      MDSelect<PaletteType>(
        onChanged: (v) {
          if (v == null) return;
          setState(() => _type = v);
          _commit();
        },
        initialValue: _type,
        options: const [
          MDOption(value: PaletteType.rectangle, child: Text('Rectangle')),
          MDOption(value: PaletteType.circle, child: Text('Circle')),
        ],
        selectedOptionBuilder: (context, value) {
          return Text(value.name[0].toUpperCase() + value.name.substring(1));
        },
      ),
      const SizedBox(height: 16),
      ReorderableListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: _rows.length,
        buildDefaultDragHandles: false,
        onReorder: (oldIndex, newIndex) {
          setState(() {
            if (newIndex > oldIndex) {
              newIndex -= 1;
            }
            final item = _rows.removeAt(oldIndex);
            _rows.insert(newIndex, item);
            _commit();
          });
        },
        itemBuilder: (context, i) {
          final row = _rows[i];
          return Padding(
            key: ValueKey(row),
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(children: [
              ReorderableDragStartListener(
                index: i,
                child: MouseRegion(
                  cursor: SystemMouseCursors.grab,
                  child: const Icon(Icons.drag_handle),
                ),
              ),
              const SizedBox(width: 8),
              ColorPreview(
                color: row.color,
                onTap: () {
                  final doc = CanvasScope.of(context, listen: false);
                  final dialogManager = DialogManagerScope.of(context);
                  late DraggableDialog dialog;
                  dialog = DraggableDialog(
                    onClose: () => dialogManager.close(dialog),
                    child: CommonColorPicker(
                      doc: doc,
                      onColorSelected: (c) {
                        setState(() => row.color = c);
                        _commit();
                      },
                      onOpenColorPicker: () {
                        dialogManager.close(dialog);
                        late DraggableDialog colorPickerDialog;
                        colorPickerDialog = DraggableDialog(
                          title: 'Select Color',
                          onClose: () => dialogManager.close(colorPickerDialog),
                          child: MDColorPicker(
                            initialColor: row.color,
                            onColorChanged: (c) {
                              setState(() => row.color = c);
                              _commit();
                            },
                            onDone: (c) {
                              doc.applyPatch([
                                {
                                  'type': 'doc.colors.add',
                                  'color': colorToHex(c),
                                }
                              ]);
                              setState(() => row.color = c);
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
              const Spacer(),
              SizedBox(
                width: 24,
                child: MDTap.ghost(
                  padding: EdgeInsets.zero,
                  onPressed: () => _removeRow(i),
                  size: ShadButtonSize.sm,
                  icon: const Icon(PhosphorIconsRegular.minusCircle),
                ),
              ),
            ]),
          );
        },
      ),
      const SizedBox(height: 8),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          MDTap.outline(
            onPressed: _addRow,
            size: ShadButtonSize.sm,
            icon: const Icon(PhosphorIconsRegular.plus),
            child: const Text('Add color'),
          ),
          const SizedBox(width: 8),
          Text('${_rows.length} color${_rows.length == 1 ? '' : 's'}'),
        ],
      ),
    ]);
  }
}

class _PaletteRow {
  _PaletteRow({required this.color});
  Color color;
}
