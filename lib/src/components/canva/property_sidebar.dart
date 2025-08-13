import 'package:flutter/material.dart';
import 'package:flutter_meragi_design/src/components/canva/models.dart';

class PropertiesSidebar extends StatefulWidget {
  const PropertiesSidebar({
    super.key,
    required this.item,
    required this.selectedCount,
    // actions
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
    // property change lifecycle
    required this.onChangeStart,
    required this.onChanged,
    required this.onChangeEnd,
  });

  /// Selected item when exactly one is selected, else null.
  final CanvasItem? item;
  final int selectedCount;

  // Actions for selection (apply to 1 or many)
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

  // Property change lifecycle
  final VoidCallback onChangeStart;
  final ValueChanged<CanvasItem> onChanged;
  final VoidCallback onChangeEnd;

  @override
  State<PropertiesSidebar> createState() => _PropertiesSidebarState();
}

class _PropertiesSidebarState extends State<PropertiesSidebar> {
  bool _begun = false;

  // Text state
  late TextEditingController _textCtrl;
  late double _fontSize;
  late Color _fontColor;
  late FontWeight _fontWeight;
  late bool _italic;
  late bool _underline;
  String? _fontFamily;

  // Generic geom controllers (single selection only)
  late TextEditingController _xCtrl;
  late TextEditingController _yCtrl;
  late TextEditingController _wCtrl;
  late TextEditingController _hCtrl;

  static const _fontOptions = <String?>[
    null,
    'Inter',
    'Roboto',
    'Montserrat',
    'Merriweather',
    'Poppins',
  ];

  static const _swatches = <Color>[
    Colors.black,
    Colors.white,
    Color(0xFF111827),
    Color(0xFF374151),
    Color(0xFF6B7280),
    Color(0xFFEF4444),
    Color(0xFFF59E0B),
    Color(0xFF10B981),
    Color(0xFF3B82F6),
    Color(0xFF8B5CF6),
  ];

  @override
  void initState() {
    super.initState();
    _initFromItem(widget.item);
  }

  @override
  void didUpdateWidget(covariant PropertiesSidebar oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Selection changed to a different single item
    if (oldWidget.item?.id != widget.item?.id) {
      if (_begun) {
        widget.onChangeEnd();
        _begun = false;
      }
      _disposeCtrls();
      _initFromItem(widget.item);
      return;
    }

    // Same single item id: sync from parent changes (undo/redo)
    if (widget.item != null) {
      final it = widget.item!;
      // text field caret-friendly update
      final newText = it.text ?? '';
      if (newText != _textCtrl.text) {
        final sel = _textCtrl.selection;
        final atEnd = sel.baseOffset == _textCtrl.text.length;
        _textCtrl.value = TextEditingValue(
          text: newText,
          selection: atEnd
              ? TextSelection.collapsed(offset: newText.length)
              : TextSelection.collapsed(
                  offset: sel.baseOffset.clamp(0, newText.length),
                ),
        );
      }
      _fontSize = it.fontSize;
      _fontColor = it.fontColor;
      _fontWeight = it.fontWeight;
      _italic = it.fontItalic;
      _underline = it.fontUnderline;
      _fontFamily = it.fontFamily;

      // generic geom
      _xCtrl.text = it.position.dx.toStringAsFixed(0);
      _yCtrl.text = it.position.dy.toStringAsFixed(0);
      _wCtrl.text = it.size.width.toStringAsFixed(0);
      _hCtrl.text = it.size.height.toStringAsFixed(0);
    }
  }

  void _initFromItem(CanvasItem? item) {
    _textCtrl = TextEditingController(text: item?.text ?? '');
    _fontSize = item?.fontSize ?? 24;
    _fontColor = item?.fontColor ?? Colors.black;
    _fontWeight = item?.fontWeight ?? FontWeight.w600;
    _italic = item?.fontItalic ?? false;
    _underline = item?.fontUnderline ?? false;
    _fontFamily = item?.fontFamily;

    _xCtrl = TextEditingController(
        text: (item?.position.dx ?? 0).toStringAsFixed(0));
    _yCtrl = TextEditingController(
        text: (item?.position.dy ?? 0).toStringAsFixed(0));
    _wCtrl =
        TextEditingController(text: (item?.size.width ?? 0).toStringAsFixed(0));
    _hCtrl = TextEditingController(
        text: (item?.size.height ?? 0).toStringAsFixed(0));
  }

  void _disposeCtrls() {
    _textCtrl.dispose();
    _xCtrl.dispose();
    _yCtrl.dispose();
    _wCtrl.dispose();
    _hCtrl.dispose();
  }

  @override
  void dispose() {
    if (_begun) widget.onChangeEnd();
    _disposeCtrls();
    super.dispose();
  }

  void _beginIfNeeded() {
    if (_begun) return;
    _begun = true;
    widget.onChangeStart();
  }

  void _emit(CanvasItem base, void Function(CanvasItem) apply) {
    _beginIfNeeded();
    final updated = base.copy();
    apply(updated);
    widget.onChanged(updated);
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    final count = widget.selectedCount;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(left: BorderSide(color: Colors.grey.shade300)),
      ),
      child: SafeArea(
        top: false,
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: switch (count) {
            0 => _EmptyPanel(),
            // Multi-select: actions only
            int c when c > 1 => _ActionsOnly(
                count: c,
                onDelete: widget.onDelete,
                onDuplicate: widget.onDuplicate,
                onFront: widget.onFront,
                onBack: widget.onBack,
                onAlignLeft: widget.onAlignLeft,
                onAlignHCenter: widget.onAlignHCenter,
                onAlignRight: widget.onAlignRight,
                onAlignTop: widget.onAlignTop,
                onAlignVCenter: widget.onAlignVCenter,
                onAlignBottom: widget.onAlignBottom,
                onLockToggle: widget.onLockToggle,
              ),
            // Single select: actions + generic + specific
            _ => SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _ActionsOnly(
                      count: 1,
                      onDelete: widget.onDelete,
                      onDuplicate: widget.onDuplicate,
                      onFront: widget.onFront,
                      onBack: widget.onBack,
                      onAlignLeft: widget.onAlignLeft,
                      onAlignHCenter: widget.onAlignHCenter,
                      onAlignRight: widget.onAlignRight,
                      onAlignTop: widget.onAlignTop,
                      onAlignVCenter: widget.onAlignVCenter,
                      onAlignBottom: widget.onAlignBottom,
                      onLockToggle: widget.onLockToggle,
                    ),
                    const SizedBox(height: 12),
                    const _SectionTitle('Item'),
                    _GenericItemProps(
                      xCtrl: _xCtrl,
                      yCtrl: _yCtrl,
                      wCtrl: _wCtrl,
                      hCtrl: _hCtrl,
                      onCommit: (dx, dy, w, h) {
                        if (item == null) return;
                        _emit(item, (u) {
                          u
                            ..position = Offset(dx, dy)
                            ..size = Size(w < 1 ? 1 : w, h < 1 ? 1 : h);
                        });
                      },
                    ),
                    const SizedBox(height: 12),
                    switch (item!.kind) {
                      CanvasItemKind.text => _TextProperties(
                          item: item,
                          textCtrl: _textCtrl,
                          fontOptions: _fontOptions,
                          swatches: _swatches,
                          fontSize: _fontSize,
                          fontColor: _fontColor,
                          fontWeight: _fontWeight,
                          italic: _italic,
                          underline: _underline,
                          fontFamily: _fontFamily,
                          onTextChanged: (v) {
                            _beginIfNeeded();
                            _emit(item, (u) => u.text = v);
                          },
                          onFontChanged: (v) => setState(() {
                            _fontFamily = v;
                            _emit(item, (u) => u.fontFamily = v);
                          }),
                          onSizeChanged: (v) => setState(() {
                            _fontSize = v;
                            _emit(item, (u) => u.fontSize = v);
                          }),
                          onBoldToggle: () => setState(() {
                            _fontWeight =
                                _fontWeight.index >= FontWeight.w600.index
                                    ? FontWeight.w400
                                    : FontWeight.w700;
                            _emit(item, (u) => u.fontWeight = _fontWeight);
                          }),
                          onItalicToggle: () => setState(() {
                            _italic = !_italic;
                            _emit(item, (u) => u.fontItalic = _italic);
                          }),
                          onUnderlineToggle: () => setState(() {
                            _underline = !_underline;
                            _emit(item, (u) => u.fontUnderline = _underline);
                          }),
                          onColorPicked: (c) => setState(() {
                            _fontColor = c;
                            _emit(item, (u) => u.fontColor = c);
                          }),
                        ),
                      CanvasItemKind.image => _ImageProperties(
                          item: item,
                          onChange: (u) {
                            _beginIfNeeded();
                            widget.onChanged(u);
                          },
                        ),
                      CanvasItemKind.palette => _PaletteProperties(
                          item: item,
                          onChange: (u) {
                            _beginIfNeeded();
                            widget.onChanged(u);
                          },
                        ),
                    }
                  ],
                ),
              ),
          },
        ),
      ),
    );
  }
}

class _EmptyPanel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Select items to see actions and properties',
        style: TextStyle(color: Colors.grey.shade600),
        textAlign: TextAlign.center,
      ),
    );
  }
}

/// Actions section shown for both single and multi selection
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
    required this.onLockToggle,
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
  final VoidCallback onLockToggle;

  @override
  Widget build(BuildContext context) {
    final many = count > 1;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionTitle('Actions'),
        Row(
          children: [
            _iconBtn(Icons.delete_outline, 'Delete', onDelete),
            _iconBtn(Icons.control_point_duplicate_outlined, 'Duplicate',
                onDuplicate),
            _iconBtn(Icons.lock_open, 'Lock/Unlock', onLockToggle),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            _iconBtn(Icons.flip_to_front_outlined, 'Bring front', onFront),
            _iconBtn(Icons.flip_to_back_outlined, 'Send back', onBack),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            _iconBtn(Icons.align_horizontal_left, 'Align left',
                many ? onAlignLeft : null),
            _iconBtn(Icons.align_horizontal_center, 'Align center',
                many ? onAlignHCenter : null),
            _iconBtn(Icons.align_horizontal_right, 'Align right',
                many ? onAlignRight : null),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            _iconBtn(Icons.align_vertical_top, 'Align top',
                many ? onAlignTop : null),
            _iconBtn(Icons.align_vertical_center, 'Align middle',
                many ? onAlignVCenter : null),
            _iconBtn(Icons.align_vertical_bottom, 'Align bottom',
                many ? onAlignBottom : null),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          count == 1 ? '1 selected' : '$count selected',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  Widget _iconBtn(IconData icon, String tip, VoidCallback? onTap) {
    return IconButton(
      tooltip: tip,
      onPressed: onTap,
      icon: Icon(icon),
      color: onTap == null ? Colors.black26 : null,
    );
  }
}

/// Generic item geometry editor for single selection
class _GenericItemProps extends StatefulWidget {
  const _GenericItemProps({
    required this.xCtrl,
    required this.yCtrl,
    required this.wCtrl,
    required this.hCtrl,
    required this.onCommit,
  });

  final TextEditingController xCtrl, yCtrl, wCtrl, hCtrl;
  final void Function(double x, double y, double w, double h) onCommit;

  @override
  State<_GenericItemProps> createState() => _GenericItemPropsState();
}

class _GenericItemPropsState extends State<_GenericItemProps> {
  void _commit() {
    final dx = double.tryParse(widget.xCtrl.text.trim()) ?? 0;
    final dy = double.tryParse(widget.yCtrl.text.trim()) ?? 0;
    final w = double.tryParse(widget.wCtrl.text.trim()) ?? 1;
    final h = double.tryParse(widget.hCtrl.text.trim()) ?? 1;
    widget.onCommit(dx, dy, w, h);
  }

  Widget _numField(String label, TextEditingController ctrl) {
    return Expanded(
      child: TextField(
        controller: ctrl,
        keyboardType:
            const TextInputType.numberWithOptions(decimal: true, signed: true),
        decoration: InputDecoration(
          labelText: label,
          isDense: true,
          border: const OutlineInputBorder(),
        ),
        onSubmitted: (_) => _commit(),
        onEditingComplete: _commit,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(children: [
          _numField('X', widget.xCtrl),
          const SizedBox(width: 8),
          _numField('Y', widget.yCtrl),
        ]),
        const SizedBox(height: 8),
        Row(children: [
          _numField('W', widget.wCtrl),
          const SizedBox(width: 8),
          _numField('H', widget.hCtrl),
        ]),
      ],
    );
  }
}

class _TextProperties extends StatelessWidget {
  const _TextProperties({
    required this.item,
    required this.textCtrl,
    required this.fontOptions,
    required this.swatches,
    required this.fontSize,
    required this.fontColor,
    required this.fontWeight,
    required this.italic,
    required this.underline,
    required this.fontFamily,
    required this.onTextChanged,
    required this.onFontChanged,
    required this.onSizeChanged,
    required this.onBoldToggle,
    required this.onItalicToggle,
    required this.onUnderlineToggle,
    required this.onColorPicked,
  });

  final CanvasItem item;
  final TextEditingController textCtrl;
  final List<String?> fontOptions;
  final List<Color> swatches;

  final double fontSize;
  final Color fontColor;
  final FontWeight fontWeight;
  final bool italic;
  final bool underline;
  final String? fontFamily;

  final ValueChanged<String> onTextChanged;
  final ValueChanged<String?> onFontChanged;
  final ValueChanged<double> onSizeChanged;
  final VoidCallback onBoldToggle;
  final VoidCallback onItalicToggle;
  final VoidCallback onUnderlineToggle;
  final ValueChanged<Color> onColorPicked;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionTitle('Text'),
        TextField(
          controller: textCtrl,
          maxLines: 5,
          minLines: 3,
          onChanged: onTextChanged,
          decoration: const InputDecoration(
            isDense: true,
            border: OutlineInputBorder(),
            hintText: 'Your text...',
          ),
        ),
        const SizedBox(height: 12),
        const _SectionTitle('Font'),
        InputDecorator(
          decoration: const InputDecoration(
              border: OutlineInputBorder(), isDense: true),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String?>(
              value: fontFamily,
              isDense: true,
              items: fontOptions
                  .map((f) => DropdownMenuItem<String?>(
                      value: f, child: Text(f ?? 'System')))
                  .toList(),
              onChanged: onFontChanged,
            ),
          ),
        ),
        const SizedBox(height: 12),
        const _SectionTitle('Size'),
        Row(
          children: [
            Expanded(
              child: Slider(
                value: fontSize.clamp(8, 144),
                min: 8,
                max: 144,
                divisions: 136,
                label: fontSize.toStringAsFixed(0),
                onChanged: onSizeChanged,
              ),
            ),
            SizedBox(
                width: 48,
                child: Text(fontSize.toStringAsFixed(0),
                    textAlign: TextAlign.right)),
          ],
        ),
        const SizedBox(height: 12),
        const _SectionTitle('Style'),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _chip('B',
                selected: fontWeight.index >= FontWeight.w600.index,
                onTap: onBoldToggle),
            _chip('I', selected: italic, onTap: onItalicToggle),
            _chip('U', selected: underline, onTap: onUnderlineToggle),
          ],
        ),
        const SizedBox(height: 12),
        const _SectionTitle('Color'),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: [
            for (final c in swatches)
              _ColorDot(
                  color: c,
                  selected: c.value == fontColor.value,
                  onTap: () => onColorPicked(c)),
          ],
        ),
      ],
    );
  }

  Widget _chip(String label,
      {required bool selected, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: selected ? Colors.blue : Colors.black12),
          color: selected ? Colors.blue.withOpacity(0.1) : Colors.transparent,
        ),
        child: Text(label, style: const TextStyle(fontWeight: FontWeight.w700)),
      ),
    );
  }
}

class _ImageProperties extends StatefulWidget {
  const _ImageProperties({required this.item, required this.onChange});

  final CanvasItem item;
  final ValueChanged<CanvasItem> onChange;

  @override
  State<_ImageProperties> createState() => _ImagePropertiesState();
}

class _ImagePropertiesState extends State<_ImageProperties> {
  late TextEditingController _tl;
  late TextEditingController _tr;
  late TextEditingController _bl;
  late TextEditingController _br;

  bool _linkAll = false; // when on, keep 4 corners equal

  @override
  void initState() {
    super.initState();
    _tl = TextEditingController(text: widget.item.radiusTL.toStringAsFixed(0));
    _tr = TextEditingController(text: widget.item.radiusTR.toStringAsFixed(0));
    _bl = TextEditingController(text: widget.item.radiusBL.toStringAsFixed(0));
    _br = TextEditingController(text: widget.item.radiusBR.toStringAsFixed(0));
  }

  @override
  void didUpdateWidget(covariant _ImageProperties oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.item.id != widget.item.id) {
      _tl.text = widget.item.radiusTL.toStringAsFixed(0);
      _tr.text = widget.item.radiusTR.toStringAsFixed(0);
      _bl.text = widget.item.radiusBL.toStringAsFixed(0);
      _br.text = widget.item.radiusBR.toStringAsFixed(0);
    }
  }

  @override
  void dispose() {
    _tl.dispose();
    _tr.dispose();
    _bl.dispose();
    _br.dispose();
    super.dispose();
  }

  void _commit({double? tl, double? tr, double? bl, double? br}) {
    final base = widget.item.copy();

    // parse with fallback to current
    double vtl = tl ?? double.tryParse(_tl.text.trim()) ?? base.radiusTL;
    double vtr = tr ?? double.tryParse(_tr.text.trim()) ?? base.radiusTR;
    double vbl = bl ?? double.tryParse(_bl.text.trim()) ?? base.radiusBL;
    double vbr = br ?? double.tryParse(_br.text.trim()) ?? base.radiusBR;

    if (_linkAll) {
      final uni = tl ?? tr ?? bl ?? br ?? vtl;
      vtl = vtr = vbl = vbr = uni;
      _tl.text = uni.toStringAsFixed(0);
      _tr.text = uni.toStringAsFixed(0);
      _bl.text = uni.toStringAsFixed(0);
      _br.text = uni.toStringAsFixed(0);
    }

    // Clamp to half of item size so corners are valid
    final maxR = 0.5 *
        (base.size.width < base.size.height
            ? base.size.width
            : base.size.height);
    vtl = vtl.clamp(0, maxR);
    vtr = vtr.clamp(0, maxR);
    vbl = vbl.clamp(0, maxR);
    vbr = vbr.clamp(0, maxR);

    base
      ..radiusTL = vtl
      ..radiusTR = vtr
      ..radiusBL = vbl
      ..radiusBR = vbr;

    widget.onChange(base);
  }

  Widget _num(String label, TextEditingController c, void Function() onDone) {
    return Expanded(
      child: TextField(
        controller: c,
        keyboardType:
            const TextInputType.numberWithOptions(decimal: true, signed: false),
        decoration: InputDecoration(
          labelText: label,
          isDense: true,
          border: const OutlineInputBorder(),
        ),
        onSubmitted: (_) => onDone(),
        onEditingComplete: onDone,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionTitle('Image'),
        const SizedBox(height: 6),
        Row(
          children: [
            Switch(
              value: _linkAll,
              onChanged: (v) => setState(() => _linkAll = v),
            ),
            const SizedBox(width: 6),
            const Text('Link all corners'),
          ],
        ),
        const SizedBox(height: 8),
        const _SectionTitle('Corner radius'),
        Row(
          children: [
            _num('Top-Left', _tl, () => _commit()),
            const SizedBox(width: 8),
            _num('Top-Right', _tr, () => _commit()),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            _num('Bottom-Left', _bl, () => _commit()),
            const SizedBox(width: 8),
            _num('Bottom-Right', _br, () => _commit()),
          ],
        ),
        const SizedBox(height: 8),
        // Quick slider to set all corners when linked
        if (_linkAll)
          Slider(
            value: double.tryParse(_tl.text) ?? 0,
            min: 0,
            max: ((widget.item.size.width < widget.item.size.height
                        ? widget.item.size.width
                        : widget.item.size.height) /
                    2)
                .clamp(1, 5000),
            onChanged: (v) {
              setState(() {
                _tl.text = v.toStringAsFixed(0);
                _tr.text = v.toStringAsFixed(0);
                _bl.text = v.toStringAsFixed(0);
                _br.text = v.toStringAsFixed(0);
              });
              _commit(tl: v);
            },
          ),
      ],
    );
  }
}

class _ColorDot extends StatelessWidget {
  const _ColorDot(
      {required this.color, required this.selected, required this.onTap});
  final Color color;
  final bool selected;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    final borderColor =
        color.computeLuminance() < 0.5 ? Colors.white : Colors.black26;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 22,
        height: 22,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(
              color: selected ? Colors.blue : borderColor,
              width: selected ? 2 : 1),
        ),
      ),
    );
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

class _PaletteProperties extends StatefulWidget {
  const _PaletteProperties({required this.item, required this.onChange});
  final CanvasItem item;
  final ValueChanged<CanvasItem> onChange;

  @override
  State<_PaletteProperties> createState() => _PalettePropertiesState();
}

class _PalettePropertiesState extends State<_PaletteProperties> {
  final _rows = <_PaletteRow>[];

  @override
  void initState() {
    super.initState();
    for (final c in widget.item.paletteColors) {
      _rows.add(_PaletteRow(initial: _colorToHex(c)));
    }
    if (_rows.isEmpty) _rows.add(_PaletteRow(initial: '#FF000000'));
  }

  @override
  void didUpdateWidget(covariant _PaletteProperties oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.item.id != widget.item.id) {
      _rows
        ..clear()
        ..addAll(widget.item.paletteColors
            .map((c) => _PaletteRow(initial: _colorToHex(c))));
      if (_rows.isEmpty) _rows.add(_PaletteRow(initial: '#FF000000'));
      setState(() {});
    }
  }

  @override
  void dispose() {
    for (final r in _rows) {
      r.ctrl.dispose();
    }
    super.dispose();
  }

  String _colorToHex(Color c) =>
      '#${c.value.toRadixString(16).padLeft(8, '0').toUpperCase()}';

  Color? _parseHex(String s) {
    try {
      var hex = s.replaceAll('#', '').trim();
      if (hex.length == 6) hex = 'FF$hex';
      final v = int.parse(hex, radix: 16);
      return Color(v);
    } catch (_) {
      return null;
    }
  }

  void _commit() {
    final list = <Color>[];
    for (final r in _rows) {
      final c = _parseHex(r.ctrl.text);
      if (c != null) list.add(c);
    }
    if (list.isEmpty) return;
    final u = widget.item.copy()..paletteColors = list;
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
      const _SectionTitle('Palette'),
      ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: _rows.length,
        itemBuilder: (context, i) {
          final row = _rows[i];
          final preview = _parseHex(row.ctrl.text);
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
                    labelText: 'Hex color',
                    hintText: '#RRGGBB or #AARRGGBB',
                  ),
                  onSubmitted: (_) => _commit(),
                  onEditingComplete: _commit,
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                tooltip: 'Remove',
                icon: const Icon(Icons.remove_circle_outline),
                onPressed: () => _removeRow(i),
              ),
            ]),
          );
        },
      ),
      const SizedBox(height: 8),
      Row(children: [
        ElevatedButton.icon(
          onPressed: _addRow,
          icon: const Icon(Icons.add),
          label: const Text('Add color'),
          style: ElevatedButton.styleFrom(
            elevation: 0,
            backgroundColor: Colors.white,
            foregroundColor: Colors.black87,
            side: const BorderSide(color: Colors.black12),
          ),
        ),
        const SizedBox(width: 8),
        Text('${_rows.length} color${_rows.length == 1 ? '' : 's'}'),
      ]),
    ]);
  }
}

class _PaletteRow {
  _PaletteRow({required String initial})
      : ctrl = TextEditingController(text: initial);
  final TextEditingController ctrl;
}
