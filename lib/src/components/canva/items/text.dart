import 'package:flutter/material.dart';
import 'package:flutter_meragi_design/flutter_meragi_design.dart';
import 'package:flutter_meragi_design/src/components/canva/scaling.dart';
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
    this.fontStrikethrough = false,
    this.decorationStyle = TextDecorationStyle.solid,
    this.decorationColor,
    this.decorationThickness = 1.0,
    this.shadows,
    this.backgroundColor,
    this.textAlign = TextAlign.left,
    this.lineHeight = 1.2,
    this.letterSpacing = 0.0,
    this.wordSpacing = 0.0,
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
  bool fontStrikethrough;
  TextDecorationStyle decorationStyle;
  Color? decorationColor;
  double decorationThickness;
  List<Shadow>? shadows;
  Color? backgroundColor;
  TextAlign textAlign;
  double lineHeight;
  double letterSpacing;
  double wordSpacing;

  @override
  CanvasItemKind get kind => CanvasItemKind.text;

  TextStyle _textStyle() => TextStyle(
        fontSize: fontSize,
        color: fontColor,
        fontWeight: fontWeight,
        fontFamily: fontFamily,
        fontStyle: fontItalic ? FontStyle.italic : FontStyle.normal,
        decoration: TextDecoration.combine([
          if (fontUnderline) TextDecoration.underline,
          if (fontStrikethrough) TextDecoration.lineThrough,
        ]),
        decorationStyle: decorationStyle,
        decorationColor: decorationColor,
        decorationThickness: decorationThickness,
        shadows: shadows,
        backgroundColor: backgroundColor,
        height: lineHeight,
        letterSpacing: letterSpacing,
        wordSpacing: wordSpacing,
      );

  @override
  Widget buildContent(CanvasScaleHandler scale) {
    final pad = 6.0 * scale.s;
    return Padding(
      padding: EdgeInsets.all(pad),
      child: SizedBox.expand(
        child: Text(
          text ?? '',
          textAlign: textAlign,
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
        fontStrikethrough: fontStrikethrough,
        decorationStyle: decorationStyle,
        decorationColor: decorationColor,
        decorationThickness: decorationThickness,
        shadows: shadows,
        backgroundColor: backgroundColor,
        textAlign: textAlign,
        lineHeight: lineHeight,
        letterSpacing: letterSpacing,
        wordSpacing: wordSpacing,
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
        'fst': fontStrikethrough,
        'ds': decorationStyle.index,
        if (decorationColor != null) 'dc': colorToHex(decorationColor!),
        'dt': decorationThickness,
        'sh': shadows?.map((e) => shadowToJson(e)).toList(),
        if (backgroundColor != null) 'bg': colorToHex(backgroundColor!),
        'ta': textAlign.index,
        'lh': lineHeight,
        'ls': letterSpacing,
        'ws': wordSpacing,
      };

  static TextItem fromJson(Map<String, dynamic> j) {
    final p = (j['props'] as Map?)?.cast<String, dynamic>() ?? const {};
    final fc = hexToColor((p['fc'] as String?) ?? '#FF000000') ?? Colors.black;
    final fwVal = (p['fw'] as int?) ?? FontWeight.w600.value;
    final fw = FontWeight.values
        .firstWhere((w) => w.value == fwVal, orElse: () => FontWeight.w600);
    final ta = TextAlign.values[(p['ta'] as int?) ?? 0];
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
      fontStrikethrough: (p['fst'] as bool?) ?? false,
      decorationStyle: TextDecorationStyle.values[(p['ds'] as int?) ?? 0],
      decorationColor: hexToColor(p['dc'] as String? ?? ''),
      decorationThickness: (p['dt'] as num?)?.toDouble() ?? 1.0,
      shadows: (p['sh'] as List?)
          ?.map((e) => shadowFromJson(e))
          .whereType<Shadow>()
          .toList(),
      backgroundColor: hexToColor(p['bg'] as String? ?? ''),
      textAlign: ta,
      lineHeight: (p['lh'] as num?)?.toDouble() ?? 1.2,
      letterSpacing: (p['ls'] as num?)?.toDouble() ?? 0.0,
      wordSpacing: (p['ws'] as num?)?.toDouble() ?? 0.0,
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

  late TextEditingController _textCtrl;
  late double _fontSize;
  late Color _fontColor;
  late FontWeight _fontWeight;
  late bool _italic;
  late bool _underline;
  late bool _strikethrough;
  late TextDecorationStyle _decorationStyle;
  late Color? _decorationColor;
  late double _decorationThickness;
  String? _fontFamily;
  late TextAlign _textAlign;
  late double _lineHeight;
  late double _letterSpacing;
  late double _wordSpacing;
  late List<Shadow> _shadows;
  late Color? _backgroundColor;

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
    _strikethrough = widget.item.fontStrikethrough;
    _decorationStyle = widget.item.decorationStyle;
    _decorationColor = widget.item.decorationColor;
    _decorationThickness = widget.item.decorationThickness;
    _fontFamily = widget.item.fontFamily;
    _textAlign = widget.item.textAlign;
    _lineHeight = widget.item.lineHeight;
    _letterSpacing = widget.item.letterSpacing;
    _wordSpacing = widget.item.wordSpacing;
    _shadows = widget.item.shadows ?? [];
    _backgroundColor = widget.item.backgroundColor;
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
      _strikethrough = widget.item.fontStrikethrough;
      _decorationStyle = widget.item.decorationStyle;
      _decorationColor = widget.item.decorationColor;
      _decorationThickness = widget.item.decorationThickness;
      _fontFamily = widget.item.fontFamily;
      _textAlign = widget.item.textAlign;
      _lineHeight = widget.item.lineHeight;
      _letterSpacing = widget.item.letterSpacing;
      _wordSpacing = widget.item.wordSpacing;
      _shadows = widget.item.shadows ?? [];
      _backgroundColor = widget.item.backgroundColor;
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
      ..fontStrikethrough = _strikethrough
      ..decorationStyle = _decorationStyle
      ..decorationColor = _decorationColor
      ..decorationThickness = _decorationThickness
      ..fontFamily = _fontFamily
      ..textAlign = _textAlign
      ..lineHeight = _lineHeight
      ..letterSpacing = _letterSpacing
      ..wordSpacing = _wordSpacing
      ..shadows = _shadows
      ..backgroundColor = _backgroundColor;
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
      MDSelect<String?>(
        initialValue: _fontFamily,
        options: _fontOptions
            .map((f) => MDOption(value: f, child: Text(f ?? 'System')))
            .toList(),
        onChanged: (v) {
          setState(() => _fontFamily = v);
          _emit();
        },
        selectedOptionBuilder: (context, value) {
          return Text(value ?? 'System');
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
      const SectionTitle('Line height'),
      Row(children: [
        Expanded(
          child: Slider(
            value: _lineHeight.clamp(0.5, 3.0),
            min: 0.5,
            max: 3.0,
            label: _lineHeight.toStringAsFixed(1),
            onChanged: (v) {
              setState(() => _lineHeight = v);
              _emit();
            },
          ),
        ),
        SizedBox(
            width: 48,
            child: Text(_lineHeight.toStringAsFixed(1),
                textAlign: TextAlign.right)),
      ]),
      const SizedBox(height: 12),
      const SectionTitle('Letter spacing'),
      Row(children: [
        Expanded(
          child: Slider(
            value: _letterSpacing.clamp(-10, 10),
            min: -10,
            max: 10,
            label: _letterSpacing.toStringAsFixed(1),
            onChanged: (v) {
              setState(() => _letterSpacing = v);
              _emit();
            },
          ),
        ),
        SizedBox(
            width: 48,
            child: Text(_letterSpacing.toStringAsFixed(1),
                textAlign: TextAlign.right)),
      ]),
      const SizedBox(height: 12),
      const SectionTitle('Word spacing'),
      Row(children: [
        Expanded(
          child: Slider(
            value: _wordSpacing.clamp(-10, 20),
            min: -10,
            max: 20,
            label: _wordSpacing.toStringAsFixed(1),
            onChanged: (v) {
              setState(() => _wordSpacing = v);
              _emit();
            },
          ),
        ),
        SizedBox(
            width: 48,
            child: Text(_wordSpacing.toStringAsFixed(1),
                textAlign: TextAlign.right)),
      ]),
      const SizedBox(height: 12),
      const SectionTitle('Style'),
      Row(children: [
        _StyleToggle(
          tooltip: 'Align left',
          selected: _textAlign == TextAlign.left,
          icon: Icons.format_align_left,
          onTap: () {
            setState(() => _textAlign = TextAlign.left);
            _emit();
          },
        ),
        const SizedBox(width: 4),
        _StyleToggle(
          tooltip: 'Align center',
          selected: _textAlign == TextAlign.center,
          icon: Icons.format_align_center,
          onTap: () {
            setState(() => _textAlign = TextAlign.center);
            _emit();
          },
        ),
        const SizedBox(width: 4),
        _StyleToggle(
          tooltip: 'Align right',
          selected: _textAlign == TextAlign.right,
          icon: Icons.format_align_right,
          onTap: () {
            setState(() => _textAlign = TextAlign.right);
            _emit();
          },
        ),
        const SizedBox(width: 12),
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
        const SizedBox(width: 8),
        _chip('S', selected: _strikethrough, onTap: () {
          setState(() => _strikethrough = !_strikethrough);
          _emit();
        }),
        const Spacer(),
        if (_begun)
          TextButton(onPressed: widget.onEnd, child: const Text('Done')),
      ]),
      const SizedBox(height: 12),
      const SectionTitle('Decoration style'),
      MDSelect<TextDecorationStyle>(
        initialValue: _decorationStyle,
        options: TextDecorationStyle.values
            .map((f) => MDOption(value: f, child: Text(f.name)))
            .toList(),
        onChanged: (v) {
          if (v == null) return;
          setState(() => _decorationStyle = v);
          _emit();
        },
        selectedOptionBuilder: (context, value) {
          return Text(value.name);
        },
      ),
      const SizedBox(height: 12),
      const SectionTitle('Decoration thickness'),
      Row(children: [
        Expanded(
          child: Slider(
            value: _decorationThickness.clamp(0.0, 10.0),
            min: 0.0,
            max: 10.0,
            label: _decorationThickness.toStringAsFixed(1),
            onChanged: (v) {
              setState(() => _decorationThickness = v);
              _emit();
            },
          ),
        ),
        SizedBox(
            width: 48,
            child: Text(_decorationThickness.toStringAsFixed(1),
                textAlign: TextAlign.right)),
      ]),
      const SizedBox(height: 12),
      const SectionTitle('Decoration color'),
      MDTap(
        onPressed: () async {
          final color = await showDialog<Color>(
            context: context,
            builder: (context) => AlertDialog(
              content: MDColorPicker(
                initialColor: _decorationColor,
                onColorChanged: (c) {
                  setState(() => _decorationColor = c);
                  _emit();
                },
                onDone: (c) => Navigator.pop(context, c),
              ),
            ),
          );
          if (color != null) {
            setState(() => _decorationColor = color);
            _emit();
          }
        },
        child: Container(
          height: 48,
          decoration: BoxDecoration(
            color: _decorationColor,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade300),
          ),
        ),
      ),
      const SizedBox(height: 12),
      const SectionTitle('Color'),
      MDTap(
        onPressed: () async {
          final color = await showDialog<Color>(
            context: context,
            builder: (context) => AlertDialog(
              content: MDColorPicker(
                initialColor: _fontColor,
                onColorChanged: (c) {
                  setState(() => _fontColor = c);
                  _emit();
                },
                onDone: (c) => Navigator.pop(context, c),
              ),
            ),
          );
          if (color != null) {
            setState(() => _fontColor = color);
            _emit();
          }
        },
        child: Container(
          height: 48,
          decoration: BoxDecoration(
            color: _fontColor,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade300),
          ),
        ),
      ),
      const SizedBox(height: 12),
      const SectionTitle('Shadow'),
      SwitchListTile(
        value: _shadows.isNotEmpty,
        title: const Text('Enable shadow'),
        onChanged: (v) {
          setState(() {
            if (v) {
              _shadows = [
                const Shadow(
                    color: Colors.black, offset: Offset(2, 2), blurRadius: 4)
              ];
            } else {
              _shadows = [];
            }
          });
          _emit();
        },
      ),
      const SizedBox(height: 12),
      const SectionTitle('Background color'),
      MDTap(
        onPressed: () async {
          final color = await showDialog<Color>(
            context: context,
            builder: (context) => AlertDialog(
              content: MDColorPicker(
                initialColor: _backgroundColor,
                onColorChanged: (c) {
                  setState(() => _backgroundColor = c);
                  _emit();
                },
                onDone: (c) => Navigator.pop(context, c),
              ),
            ),
          );
          if (color != null) {
            setState(() => _backgroundColor = color);
            _emit();
          }
        },
        child: Container(
          height: 48,
          decoration: BoxDecoration(
            color: _backgroundColor,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade300),
          ),
        ),
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
