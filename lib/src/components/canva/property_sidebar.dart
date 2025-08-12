// properties_sidebar.dart
import 'package:flutter/material.dart';
import 'package:flutter_meragi_design/src/components/canva/models.dart';

class PropertiesSidebar extends StatefulWidget {
  const PropertiesSidebar({
    super.key,
    required this.item,
    required this.onChangeStart,
    required this.onChanged,
    required this.onChangeEnd,
  });

  /// Selected item (only when exactly one is selected), else null.
  final CanvasItem? item;

  /// Called once at the start of a change session (for undo).
  final VoidCallback onChangeStart;

  /// Called on every live change with the updated item.
  final ValueChanged<CanvasItem> onChanged;

  /// Called when editing session ends (selection changes / done).
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

  static const _fontOptions = <String?>[
    null, // System
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
    _textCtrl = TextEditingController(text: widget.item?.text ?? '');
    _fontSize = widget.item?.fontSize ?? 24;
    _fontColor = widget.item?.fontColor ?? Colors.black;
    _fontWeight = widget.item?.fontWeight ?? FontWeight.w600;
    _italic = widget.item?.fontItalic ?? false;
    _underline = widget.item?.fontUnderline ?? false;
    _fontFamily = widget.item?.fontFamily;
  }

  @override
  void didUpdateWidget(covariant PropertiesSidebar oldWidget) {
    super.didUpdateWidget(oldWidget);

    // If selected item changed (by id), end session and rebuild local state.
    if (oldWidget.item?.id != widget.item?.id) {
      if (_begun) {
        widget.onChangeEnd();
        _begun = false;
      }

      // Recreate controller ONLY when selection changes.
      _textCtrl.dispose();
      _textCtrl = TextEditingController(text: widget.item?.text ?? '');

      // Sync other fields
      _fontSize = widget.item?.fontSize ?? 24;
      _fontColor = widget.item?.fontColor ?? Colors.black;
      _fontWeight = widget.item?.fontWeight ?? FontWeight.w600;
      _italic = widget.item?.fontItalic ?? false;
      _underline = widget.item?.fontUnderline ?? false;
      _fontFamily = widget.item?.fontFamily;
      return;
    }

    // Same item id: do NOT recreate controller.
    if (widget.item != null) {
      // If parent sent new text (e.g., undo/redo), update text preserving caret.
      final newText = widget.item!.text ?? '';
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

      // Keep style fields in sync without setState (no visual change needed here).
      _fontSize = widget.item!.fontSize;
      _fontColor = widget.item!.fontColor;
      _fontWeight = widget.item!.fontWeight;
      _italic = widget.item!.fontItalic;
      _underline = widget.item!.fontUnderline;
      _fontFamily = widget.item!.fontFamily;
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
  }

  @override
  void dispose() {
    if (_begun) widget.onChangeEnd();
    _textCtrl.dispose();
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
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(left: BorderSide(color: Colors.grey.shade300)),
      ),
      child: SafeArea(
        top: false,
        bottom: false,
        child: item == null
            ? _EmptyPanel()
            : SingleChildScrollView(
                padding: const EdgeInsets.all(12),
                child: switch (item.kind) {
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
                        _fontWeight = _fontWeight.index >= FontWeight.w600.index
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
                  CanvasItemKind.image => _ImageProperties(item: item),
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
        'Select one item to edit its properties',
        style: TextStyle(color: Colors.grey.shade600),
        textAlign: TextAlign.center,
      ),
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
            border: OutlineInputBorder(),
            isDense: true,
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String?>(
              value: fontFamily,
              isDense: true,
              items: fontOptions
                  .map((f) => DropdownMenuItem<String?>(
                        value: f,
                        child: Text(f ?? 'System'),
                      ))
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
              child: Text(
                fontSize.toStringAsFixed(0),
                textAlign: TextAlign.right,
              ),
            ),
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
                onTap: () => onColorPicked(c),
              ),
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
          border: Border.all(
            color: selected ? Colors.blue : Colors.black12,
          ),
          color: selected ? Colors.blue.withOpacity(0.1) : Colors.transparent,
        ),
        child: Text(label, style: const TextStyle(fontWeight: FontWeight.w700)),
      ),
    );
  }
}

class _ImageProperties extends StatelessWidget {
  const _ImageProperties({required this.item});
  final CanvasItem item;

  @override
  Widget build(BuildContext context) {
    // Placeholder for future image props
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionTitle('Image'),
        Text(
          'No editable properties yet.',
          style: TextStyle(color: Colors.grey.shade600),
        ),
      ],
    );
  }
}

class _ColorDot extends StatelessWidget {
  const _ColorDot({
    required this.color,
    required this.selected,
    required this.onTap,
  });

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
            width: selected ? 2 : 1,
          ),
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
