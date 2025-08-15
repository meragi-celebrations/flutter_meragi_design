import 'package:flutter/material.dart';
import 'package:flutter_meragi_design/src/components/canva/items/base.dart';
import 'package:flutter_meragi_design/src/components/canva/scaling.dart';
import 'package:flutter_meragi_design/src/components/canva/ui/color_dot.dart';
import 'package:flutter_meragi_design/src/components/canva/utils.dart';

class TextItem extends CanvasItem {
  TextItem({
    required super.id,
    required super.position,
    required super.size,
    this.text,
    this.fontSize = 24,
    this.fontColor = Colors.black,
    this.fontWeight = FontWeight.w600,
    this.fontFamily,
    this.fontItalic = false,
    this.fontUnderline = false,
    super.locked = false,
    super.rotationDeg = 0,
  });

  String? text;
  double fontSize;
  Color fontColor;
  FontWeight fontWeight;
  String? fontFamily;
  bool fontItalic;
  bool fontUnderline;

  @override
  CanvasItemKind get kind => CanvasItemKind.text;

  TextStyle _textStyle() => TextStyle(
        fontSize: fontSize,
        color: fontColor,
        fontWeight: fontWeight,
        fontFamily: fontFamily,
        fontStyle: fontItalic ? FontStyle.italic : FontStyle.normal,
        decoration:
            fontUnderline ? TextDecoration.underline : TextDecoration.none,
        height: 1.2,
      );

  @override
  Widget buildContent(CanvasScaleHandler scale) {
    final pad = 6.0 * scale.s;
    return Padding(
      padding: EdgeInsets.all(pad),
      child: Align(
        alignment: Alignment.topLeft,
        child: Text(
          text ?? '',
          maxLines: null,
          softWrap: true,
          overflow: TextOverflow.visible,
          textScaleFactor: 1.0,
          style: _textStyle().copyWith(fontSize: fontSize * scale.s),
        ),
      ),
    );
  }

  @override
  Widget buildPropertiesEditor(BuildContext context,
      {required VoidCallback onChangeStart,
      required ValueChanged<CanvasItem> onChanged,
      required VoidCallback onChangeEnd}) {
    return _TextPropsEditor(
        item: this,
        onBegin: onChangeStart,
        onChange: onChanged,
        onEnd: onChangeEnd);
  }

  @override
  CanvasItem cloneWith({String? id}) => TextItem(
        id: id ?? this.id,
        position: position,
        size: size,
        text: text,
        fontSize: fontSize,
        fontColor: fontColor,
        fontWeight: fontWeight,
        fontFamily: fontFamily,
        fontItalic: fontItalic,
        fontUnderline: fontUnderline,
        locked: locked,
        rotationDeg: rotationDeg,
      );

  @override
  Map<String, dynamic> propsToJson() => {
        'text': text ?? '',
        'fs': fontSize,
        'fc': colorToHex(fontColor),
        'fw': fontWeight.value,
        if (fontFamily != null) 'ff': fontFamily,
        'fi': fontItalic,
        'fu': fontUnderline,
      };

  static TextItem fromJson(Map<String, dynamic> j) {
    final p = (j['props'] as Map?)?.cast<String, dynamic>() ?? const {};
    final fc = hexToColor((p['fc'] as String?) ?? '#FF000000') ?? Colors.black;
    final fwVal = (p['fw'] as int?) ?? FontWeight.w600.value;
    final fw = FontWeight.values
        .firstWhere((w) => w.value == fwVal, orElse: () => FontWeight.w600);
    return TextItem(
      id: (j['id'] as String?) ??
          DateTime.now().microsecondsSinceEpoch.toString(),
      position: Offset(
          (j['x'] as num?)?.toDouble() ?? 0, (j['y'] as num?)?.toDouble() ?? 0),
      size: Size((j['w'] as num?)?.toDouble() ?? 220,
          (j['h'] as num?)?.toDouble() ?? 88),
      locked: (j['locked'] as bool?) ?? false,
      rotationDeg: (j['rot'] as num?)?.toDouble() ?? 0,
      text: (p['text'] as String?) ?? 'Text',
      fontSize: (p['fs'] as num?)?.toDouble() ?? 24,
      fontColor: fc,
      fontWeight: fw,
      fontFamily: (p['ff'] as String?),
      fontItalic: (p['fi'] as bool?) ?? false,
      fontUnderline: (p['fu'] as bool?) ?? false,
    );
  }
}

class _TextPropsEditor extends StatefulWidget {
  const _TextPropsEditor({
    required this.item,
    required this.onBegin,
    required this.onChange,
    required this.onEnd,
  });

  final TextItem item;
  final VoidCallback onBegin;
  final ValueChanged<CanvasItem> onChange;
  final VoidCallback onEnd;

  @override
  State<_TextPropsEditor> createState() => _TextPropsEditorState();
}

class _TextPropsEditorState extends State<_TextPropsEditor> {
  static const _fontOptions = <String?>[
    null,
    'Inter',
    'Roboto',
    'Montserrat',
    'Merriweather',
    'Poppins'
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

  late TextEditingController _textCtrl;
  late double _fontSize;
  late Color _fontColor;
  late FontWeight _fontWeight;
  late bool _italic;
  late bool _underline;
  String? _fontFamily;

  bool _begun = false;
  void _begin() {
    if (_begun) return;
    _begun = true;
    widget.onBegin();
  }

  @override
  void initState() {
    super.initState();
    _textCtrl = TextEditingController(text: widget.item.text ?? '');
    _fontSize = widget.item.fontSize;
    _fontColor = widget.item.fontColor;
    _fontWeight = widget.item.fontWeight;
    _italic = widget.item.fontItalic;
    _underline = widget.item.fontUnderline;
    _fontFamily = widget.item.fontFamily;
  }

  @override
  void didUpdateWidget(covariant _TextPropsEditor oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.item.id != widget.item.id) {
      if (_begun) {
        widget.onEnd();
        _begun = false;
      }
      _textCtrl.text = widget.item.text ?? '';
      _fontSize = widget.item.fontSize;
      _fontColor = widget.item.fontColor;
      _fontWeight = widget.item.fontWeight;
      _italic = widget.item.fontItalic;
      _underline = widget.item.fontUnderline;
      _fontFamily = widget.item.fontFamily;
      setState(() {});
    }
  }

  @override
  void dispose() {
    _textCtrl.dispose();
    super.dispose();
  }

  void _emit() {
    _begin();
    final u = widget.item.cloneWith() as TextItem
      ..text = _textCtrl.text
      ..fontSize = _fontSize
      ..fontColor = _fontColor
      ..fontWeight = _fontWeight
      ..fontItalic = _italic
      ..fontUnderline = _underline
      ..fontFamily = _fontFamily;
    widget.onChange(u);
  }

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const SectionTitle('Text'),
      TextField(
        controller: _textCtrl,
        maxLines: 5,
        minLines: 3,
        decoration:
            const InputDecoration(border: OutlineInputBorder(), isDense: true),
        onChanged: (_) => _emit(),
      ),
      const SizedBox(height: 12),
      const SectionTitle('Font'),
      DropdownButtonFormField<String?>(
        value: _fontFamily,
        decoration:
            const InputDecoration(isDense: true, border: OutlineInputBorder()),
        items: _fontOptions
            .map((f) => DropdownMenuItem(value: f, child: Text(f ?? 'System')))
            .toList(),
        onChanged: (v) {
          setState(() => _fontFamily = v);
          _emit();
        },
      ),
      const SizedBox(height: 12),
      const SectionTitle('Size'),
      Row(children: [
        Expanded(
          child: Slider(
            value: _fontSize.clamp(8, 144),
            min: 8,
            max: 144,
            label: _fontSize.toStringAsFixed(0),
            onChanged: (v) {
              setState(() => _fontSize = v);
              _emit();
            },
          ),
        ),
        SizedBox(
            width: 48,
            child:
                Text(_fontSize.toStringAsFixed(0), textAlign: TextAlign.right)),
      ]),
      const SizedBox(height: 12),
      const SectionTitle('Style'),
      Row(children: [
        _chip('B', selected: _fontWeight.index >= FontWeight.w600.index,
            onTap: () {
          setState(() {
            _fontWeight = _fontWeight.index >= FontWeight.w600.index
                ? FontWeight.w400
                : FontWeight.w700;
          });
          _emit();
        }),
        const SizedBox(width: 8),
        _chip('I', selected: _italic, onTap: () {
          setState(() => _italic = !_italic);
          _emit();
        }),
        const SizedBox(width: 8),
        _chip('U', selected: _underline, onTap: () {
          setState(() => _underline = !_underline);
          _emit();
        }),
        const Spacer(),
        if (_begun)
          TextButton(onPressed: widget.onEnd, child: const Text('Done')),
      ]),
      const SizedBox(height: 12),
      const SectionTitle('Color'),
      Wrap(
        spacing: 6,
        runSpacing: 6,
        children: [
          for (final c in _swatches)
            ColorDot(
              color: c,
              selected: c.value == _fontColor.value,
              onTap: () {
                setState(() => _fontColor = c);
                _emit();
              },
            ),
        ],
      ),
    ]);
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

class _StyleToggle extends StatelessWidget {
  const _StyleToggle(
      {required this.tooltip,
      required this.selected,
      required this.icon,
      required this.onTap});
  final String tooltip;
  final bool selected;
  final IconData icon;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    final bg = selected
        ? Theme.of(context).colorScheme.primary.withOpacity(0.12)
        : Colors.transparent;
    final fg = selected ? Theme.of(context).colorScheme.primary : null;
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
                color: selected
                    ? Theme.of(context).colorScheme.primary
                    : Colors.black12),
          ),
          child: Icon(icon, size: 20, color: fg),
        ),
      ),
    );
  }
}
