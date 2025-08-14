import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_meragi_design/src/components/canva/scaling.dart';
import 'package:flutter_meragi_design/src/components/canva/utils.dart';

enum CanvasItemKind { image, text, palette }

/// Generic interaction hooks you can provide from the viewer.
/// Items can also override handling by overriding buildViewerContent.
typedef CanvasInteractionTap = void Function(
  BuildContext context,
  CanvasItem item,
  TapUpDetails details,
  CanvasScaleHandler scale,
);

typedef CanvasInteractionTapDown = void Function(
  BuildContext context,
  CanvasItem item,
  TapDownDetails details,
  CanvasScaleHandler scale,
);

typedef CanvasInteractionLongPressStart = void Function(
  BuildContext context,
  CanvasItem item,
  LongPressStartDetails details,
  CanvasScaleHandler scale,
);

typedef CanvasInteractionLongPressEnd = void Function(
  BuildContext context,
  CanvasItem item,
  LongPressEndDetails details,
  CanvasScaleHandler scale,
);

typedef CanvasInteractionNoDetails = void Function(
  BuildContext context,
  CanvasItem item,
  CanvasScaleHandler scale,
);

class CanvasItemInteractions {
  final CanvasInteractionTap? onTap; // primary click or tap
  final CanvasInteractionTapDown? onTapDown; // when you need down-pos
  final CanvasInteractionNoDetails? onDoubleTap; // fast double-tap
  final CanvasInteractionTapDown? onDoubleTapDown; // double-tap with pos
  final CanvasInteractionTap? onSecondaryTap; // right-click or secondary
  final CanvasInteractionLongPressStart? onLongPressStart;
  final CanvasInteractionLongPressEnd? onLongPressEnd;

  const CanvasItemInteractions({
    this.onTap,
    this.onTapDown,
    this.onDoubleTap,
    this.onDoubleTapDown,
    this.onSecondaryTap,
    this.onLongPressStart,
    this.onLongPressEnd,
  });

  bool get hasAny =>
      onTap != null ||
      onTapDown != null ||
      onDoubleTap != null ||
      onDoubleTapDown != null ||
      onSecondaryTap != null ||
      onLongPressStart != null ||
      onLongPressEnd != null;
}

/// Internal generic wrapper that wires GestureDetector to the provided hooks.
class _CanvasItemGestureWrapper extends StatelessWidget {
  const _CanvasItemGestureWrapper({
    required this.item,
    required this.scale,
    required this.child,
    required this.interactions,
  });

  final CanvasItem item;
  final CanvasScaleHandler scale;
  final Widget child;
  final CanvasItemInteractions? interactions;

  @override
  Widget build(BuildContext context) {
    final i = interactions;
    // If no interactions are provided, return the child as-is to avoid extra
    // gesture arena overhead.
    if (i == null || !i.hasAny) return child;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: i.onTapDown == null
          ? null
          : (d) => i.onTapDown!(context, item, d, scale),
      onTapUp:
          i.onTap == null ? null : (d) => i.onTap!(context, item, d, scale),
      onDoubleTap: i.onDoubleTap == null
          ? null
          : () => i.onDoubleTap!(context, item, scale),
      onDoubleTapDown: i.onDoubleTapDown == null
          ? null
          : (d) => i.onDoubleTapDown!(context, item, d, scale),
      onSecondaryTapUp: i.onSecondaryTap == null
          ? null
          : (d) => i.onSecondaryTap!(context, item, d, scale),
      onLongPressStart: i.onLongPressStart == null
          ? null
          : (d) => i.onLongPressStart!(context, item, d, scale),
      onLongPressEnd: i.onLongPressEnd == null
          ? null
          : (d) => i.onLongPressEnd!(context, item, d, scale),
      child: child,
    );
  }
}

/// Polymorphic base item. Subclasses own:
/// - buildContent
/// - buildPropertiesEditor
/// - serialization props
/// - double tap edit flow
abstract class CanvasItem {
  CanvasItem({
    required this.id,
    required this.position,
    required this.size,
    required this.locked,
    required this.rotationDeg,
  });

  final String id;

  /// Mutables kept non-final on purpose to allow fast in-place edits.
  Offset position;
  Size size;
  bool locked;
  double rotationDeg; // degrees 0..360

  CanvasItemKind get kind;

  /// Render content inside the item’s rect (already sized/rotated by caller).
  Widget buildContent(CanvasScaleHandler scale);

  /// Build the item-specific properties editor UI.
  /// Must call onChangeStart once at the beginning of an edit session,
  /// fire onChanged(updated) for every incremental change,
  /// and onChangeEnd at the end.
  Widget buildPropertiesEditor(
    BuildContext context, {
    required VoidCallback onChangeStart,
    required ValueChanged<CanvasItem> onChanged,
    required VoidCallback onChangeEnd,
  });

  /// Viewer-only builder that returns an *interactive* child. By default we
  /// wrap buildContent(...) in a gesture layer so viewers can wire generic
  /// interactions without the editor code path changing.
  ///
  /// Items may override this to customize or block interactions.
  Widget buildViewerContent(
    BuildContext context,
    CanvasScaleHandler scale, {
    CanvasItemInteractions? interactions,
  }) {
    return _CanvasItemGestureWrapper(
      item: this,
      scale: scale,
      interactions: interactions,
      child: buildContent(scale),
    );
  }

  /// Optional per-item gesture editing (like text editor on double tap).
  /// Return an updated item to commit or null to ignore.
  Future<CanvasItem?> handleDoubleTap(BuildContext context) async => null;

  /// Deep clone with a new id (if provided).
  CanvasItem cloneWith({String? id});

  /// ---------- Serialization (shared envelope) ----------
  Map<String, dynamic> toJson(int zIndex) => {
        'id': id,
        'kind': kind.name,
        'x': position.dx,
        'y': position.dy,
        'w': size.width,
        'h': size.height,
        'z': zIndex,
        'locked': locked,
        'rot': rotationDeg,
        'props': propsToJson(),
      };

  Map<String, dynamic> propsToJson();

  /// Factory decode. Centralized kind switch is acceptable and isolated here.
  static CanvasItem fromJson(
    Map<String, dynamic> json,
    ImageProvider? providerFromOutside,
  ) {
    final kindStr = (json['kind'] as String?) ?? 'image';
    final kind = CanvasItemKind.values.firstWhere(
      (e) => e.name == kindStr,
      orElse: () => CanvasItemKind.image,
    );

    switch (kind) {
      case CanvasItemKind.image:
        return ImageItem.fromJson(json, providerFromOutside);
      case CanvasItemKind.text:
        return TextItem.fromJson(json);
      case CanvasItemKind.palette:
        return PaletteItem.fromJson(json);
    }
  }
}

/// ---------------- Image ----------------

class ImageItem extends CanvasItem {
  ImageItem({
    required super.id,
    required this.imageId,
    required this.provider,
    required super.position,
    required super.size,
    super.locked = false,
    this.radiusTL = 0,
    this.radiusTR = 0,
    this.radiusBL = 0,
    this.radiusBR = 0,
    super.rotationDeg = 0,
  });

  final String? imageId;
  final ImageProvider? provider;

  double radiusTL;
  double radiusTR;
  double radiusBL;
  double radiusBR;

  @override
  CanvasItemKind get kind => CanvasItemKind.image;

  @override
  Widget buildContent(CanvasScaleHandler scale) {
    if (provider == null) return const SizedBox.shrink();
    final s = scale.s;
    final br = BorderRadius.only(
      topLeft: Radius.circular(radiusTL * s),
      topRight: Radius.circular(radiusTR * s),
      bottomLeft: Radius.circular(radiusBL * s),
      bottomRight: Radius.circular(radiusBR * s),
    );
    return ClipRRect(
      borderRadius: br,
      clipBehavior: Clip.antiAlias,
      child: Image(image: provider!, fit: BoxFit.cover),
    );
  }

  @override
  Widget buildPropertiesEditor(
    BuildContext context, {
    required VoidCallback onChangeStart,
    required ValueChanged<CanvasItem> onChanged,
    required VoidCallback onChangeEnd,
  }) {
    return _ImagePropsEditor(
      item: this,
      onBegin: onChangeStart,
      onChange: onChanged,
      onEnd: onChangeEnd,
    );
  }

  @override
  CanvasItem cloneWith({String? id}) => ImageItem(
        id: id ?? this.id,
        imageId: imageId,
        provider: provider,
        position: position,
        size: size,
        locked: locked,
        radiusTL: radiusTL,
        radiusTR: radiusTR,
        radiusBL: radiusBL,
        radiusBR: radiusBR,
        rotationDeg: rotationDeg,
      );

  @override
  Map<String, dynamic> propsToJson() => {
        if (imageId != null) 'imageId': imageId,
        if (provider != null) 'src': serializeProvider(provider!),
        'radii': {
          'tl': radiusTL,
          'tr': radiusTR,
          'bl': radiusBL,
          'br': radiusBR,
        },
      };

  static ImageItem fromJson(
    Map<String, dynamic> json,
    ImageProvider? providerFromOutside,
  ) {
    final props = (json['props'] as Map?)?.cast<String, dynamic>() ?? const {};
    ImageProvider? provider = providerFromOutside;
    provider ??= deserializeProvider(props['src'] ?? json['src']);

    final rmap = (props['radii'] as Map?)?.cast<String, dynamic>() ?? const {};
    return ImageItem(
      id: (json['id'] as String?) ??
          DateTime.now().microsecondsSinceEpoch.toString(),
      imageId: (props['imageId'] as String?) ?? (json['imageId'] as String?),
      provider: provider,
      position: Offset(
        (json['x'] as num?)?.toDouble() ?? 0,
        (json['y'] as num?)?.toDouble() ?? 0,
      ),
      size: Size(
        (json['w'] as num?)?.toDouble() ?? 100,
        (json['h'] as num?)?.toDouble() ?? 100,
      ),
      locked: (json['locked'] as bool?) ?? false,
      rotationDeg: (json['rot'] as num?)?.toDouble() ?? 0,
      radiusTL: (rmap['tl'] as num?)?.toDouble() ?? 0,
      radiusTR: (rmap['tr'] as num?)?.toDouble() ?? 0,
      radiusBL: (rmap['bl'] as num?)?.toDouble() ?? 0,
      radiusBR: (rmap['br'] as num?)?.toDouble() ?? 0,
    );
  }
}

class _ImagePropsEditor extends StatefulWidget {
  const _ImagePropsEditor({
    required this.item,
    required this.onBegin,
    required this.onChange,
    required this.onEnd,
  });

  final ImageItem item;
  final VoidCallback onBegin;
  final ValueChanged<CanvasItem> onChange;
  final VoidCallback onEnd;

  @override
  State<_ImagePropsEditor> createState() => _ImagePropsEditorState();
}

class _ImagePropsEditorState extends State<_ImagePropsEditor> {
  late TextEditingController _tl;
  late TextEditingController _tr;
  late TextEditingController _bl;
  late TextEditingController _br;
  bool _linkAll = false;
  bool _begun = false;

  void _begin() {
    if (_begun) return;
    _begun = true;
    widget.onBegin();
  }

  @override
  void initState() {
    super.initState();
    _tl = TextEditingController(text: widget.item.radiusTL.toStringAsFixed(0));
    _tr = TextEditingController(text: widget.item.radiusTR.toStringAsFixed(0));
    _bl = TextEditingController(text: widget.item.radiusBL.toStringAsFixed(0));
    _br = TextEditingController(text: widget.item.radiusBR.toStringAsFixed(0));
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
    _begin();
    final u = widget.item.cloneWith() as ImageItem;

    double vtl = tl ?? double.tryParse(_tl.text.trim()) ?? u.radiusTL;
    double vtr = tr ?? double.tryParse(_tr.text.trim()) ?? u.radiusTR;
    double vbl = bl ?? double.tryParse(_bl.text.trim()) ?? u.radiusBL;
    double vbr = br ?? double.tryParse(_br.text.trim()) ?? u.radiusBR;

    if (_linkAll) {
      final uni = tl ?? tr ?? bl ?? br ?? vtl;
      vtl = vtr = vbl = vbr = uni;
      _tl.text = uni.toStringAsFixed(0);
      _tr.text = uni.toStringAsFixed(0);
      _bl.text = uni.toStringAsFixed(0);
      _br.text = uni.toStringAsFixed(0);
    }

    final maxR =
        0.5 * (u.size.width < u.size.height ? u.size.width : u.size.height);
    u
      ..radiusTL = vtl.clamp(0, maxR)
      ..radiusTR = vtr.clamp(0, maxR)
      ..radiusBL = vbl.clamp(0, maxR)
      ..radiusBR = vbr.clamp(0, maxR);

    widget.onChange(u);
  }

  Widget _num(String label, TextEditingController c, VoidCallback done) {
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
        onChanged: (_) => _commit(),
        onSubmitted: (_) => done(),
        onEditingComplete: done,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const _SectionTitle('Image'),
      const SizedBox(height: 6),
      Row(
        children: [
          Switch(
              value: _linkAll, onChanged: (v) => setState(() => _linkAll = v)),
          const SizedBox(width: 6),
          const Text('Link all corners'),
          const Spacer(),
          if (_begun)
            TextButton(onPressed: widget.onEnd, child: const Text('Done')),
        ],
      ),
      const SizedBox(height: 8),
      const _SectionTitle('Corner radius'),
      Row(children: [
        _num('Top-Left', _tl, () {}),
        const SizedBox(width: 8),
        _num('Top-Right', _tr, () {}),
      ]),
      const SizedBox(height: 8),
      Row(children: [
        _num('Bottom-Left', _bl, () {}),
        const SizedBox(width: 8),
        _num('Bottom-Right', _br, () {}),
      ]),
      if (_linkAll) ...[
        const SizedBox(height: 8),
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
    ]);
  }
}

/// ---------------- Text ----------------

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
  Future<CanvasItem?> handleDoubleTap(BuildContext context) async {
    if (locked) return null;
    final updated = await showDialog<TextItem>(
      context: context,
      builder: (context) => _TextEditorDialog(initial: this),
    );
    return updated;
  }

  @override
  Widget buildPropertiesEditor(
    BuildContext context, {
    required VoidCallback onChangeStart,
    required ValueChanged<CanvasItem> onChanged,
    required VoidCallback onChangeEnd,
  }) {
    return _TextPropsEditor(
      item: this,
      onBegin: onChangeStart,
      onChange: onChanged,
      onEnd: onChangeEnd,
    );
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

  static TextItem fromJson(Map<String, dynamic> json) {
    final props = (json['props'] as Map?)?.cast<String, dynamic>() ?? const {};
    final fc =
        hexToColor((props['fc'] as String?) ?? '#FF000000') ?? Colors.black;
    final fwVal = (props['fw'] as int?) ?? FontWeight.w600.value;
    final fw = FontWeight.values.firstWhere(
      (w) => w.value == fwVal,
      orElse: () => FontWeight.w600,
    );
    return TextItem(
      id: (json['id'] as String?) ??
          DateTime.now().microsecondsSinceEpoch.toString(),
      position: Offset(
        (json['x'] as num?)?.toDouble() ?? 0,
        (json['y'] as num?)?.toDouble() ?? 0,
      ),
      size: Size(
        (json['w'] as num?)?.toDouble() ?? 220,
        (json['h'] as num?)?.toDouble() ?? 88,
      ),
      locked: (json['locked'] as bool?) ?? false,
      rotationDeg: (json['rot'] as num?)?.toDouble() ?? 0,
      text: (props['text'] as String?) ?? 'Text',
      fontSize: (props['fs'] as num?)?.toDouble() ?? 24,
      fontColor: fc,
      fontWeight: fw,
      fontFamily: (props['ff'] as String?),
      fontItalic: (props['fi'] as bool?) ?? false,
      fontUnderline: (props['fu'] as bool?) ?? false,
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
      const _SectionTitle('Text'),
      TextField(
        controller: _textCtrl,
        maxLines: 5,
        minLines: 3,
        onChanged: (_) => _emit(),
        decoration: const InputDecoration(
          isDense: true,
          border: OutlineInputBorder(),
          hintText: 'Your text...',
        ),
      ),
      const SizedBox(height: 12),
      const _SectionTitle('Font'),
      InputDecorator(
        decoration:
            const InputDecoration(border: OutlineInputBorder(), isDense: true),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String?>(
            value: _fontFamily,
            isDense: true,
            items: _fontOptions
                .map((f) => DropdownMenuItem<String?>(
                    value: f, child: Text(f ?? 'System')))
                .toList(),
            onChanged: (v) {
              setState(() => _fontFamily = v);
              _emit();
            },
          ),
        ),
      ),
      const SizedBox(height: 12),
      const _SectionTitle('Size'),
      Row(children: [
        Expanded(
          child: Slider(
            value: _fontSize.clamp(8, 144),
            min: 8,
            max: 144,
            divisions: 136,
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
      const _SectionTitle('Style'),
      Row(
        children: [
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
        ],
      ),
      const SizedBox(height: 12),
      const _SectionTitle('Color'),
      Wrap(
        spacing: 6,
        runSpacing: 6,
        children: [
          for (final c in _swatches)
            _ColorDot(
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

class _TextEditorDialog extends StatefulWidget {
  const _TextEditorDialog({required this.initial});
  final TextItem initial;

  @override
  State<_TextEditorDialog> createState() => _TextEditorDialogState();
}

class _TextEditorDialogState extends State<_TextEditorDialog> {
  late TextEditingController _ctrl;
  late double _fontSize;
  late Color _fontColor;
  late FontWeight _fontWeight;
  late bool _italic;
  late bool _underline;
  String? _fontFamily;

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
  static const _fontOptions = <String?>[
    null,
    'Inter',
    'Roboto',
    'Montserrat',
    'Merriweather',
    'Poppins'
  ];

  @override
  void initState() {
    super.initState();
    _ctrl = TextEditingController(text: widget.initial.text ?? '');
    _fontSize = widget.initial.fontSize;
    _fontColor = widget.initial.fontColor;
    _fontWeight = widget.initial.fontWeight;
    _italic = widget.initial.fontItalic;
    _underline = widget.initial.fontUnderline;
    _fontFamily = widget.initial.fontFamily;
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final previewStyle = TextStyle(
      fontSize: _fontSize,
      color: _fontColor,
      fontWeight: _fontWeight,
      fontStyle: _italic ? FontStyle.italic : FontStyle.normal,
      decoration: _underline ? TextDecoration.underline : TextDecoration.none,
      fontFamily: _fontFamily,
      height: 1.2,
    );

    return AlertDialog(
      title: const Text('Edit text'),
      content: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 520),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _ctrl,
              autofocus: true,
              maxLines: null,
              decoration: const InputDecoration(
                hintText: 'Enter text',
                border: OutlineInputBorder(),
                isDense: true,
              ),
            ),
            const SizedBox(height: 12),
            Row(children: [
              Expanded(
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Font',
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String?>(
                      value: _fontFamily,
                      isDense: true,
                      items: _fontOptions
                          .map((f) => DropdownMenuItem<String?>(
                                value: f,
                                child: Text(f ?? 'System'),
                              ))
                          .toList(),
                      onChanged: (v) => setState(() => _fontFamily = v),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(children: [
                      const Text('Size'),
                      const SizedBox(width: 8),
                      Text(_fontSize.toStringAsFixed(0)),
                    ]),
                    Slider(
                      value: _fontSize.clamp(8, 144),
                      min: 8,
                      max: 144,
                      divisions: 136,
                      label: _fontSize.toStringAsFixed(0),
                      onChanged: (v) => setState(() => _fontSize = v),
                    ),
                  ],
                ),
              ),
            ]),
            const SizedBox(height: 12),
            Row(children: [
              _StyleToggle(
                tooltip: 'Bold',
                selected: _fontWeight.index >= FontWeight.w600.index,
                icon: Icons.format_bold,
                onTap: () {
                  setState(() {
                    _fontWeight = _fontWeight.index >= FontWeight.w600.index
                        ? FontWeight.w400
                        : FontWeight.w700;
                  });
                },
              ),
              const SizedBox(width: 8),
              _StyleToggle(
                tooltip: 'Italic',
                selected: _italic,
                icon: Icons.format_italic,
                onTap: () => setState(() => _italic = !_italic),
              ),
              const SizedBox(width: 8),
              _StyleToggle(
                tooltip: 'Underline',
                selected: _underline,
                icon: Icons.format_underline,
                onTap: () => setState(() => _underline = !_underline),
              ),
              const Spacer(),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: [
                  for (final c in _swatches)
                    _ColorDot(
                      color: c,
                      selected: c.value == _fontColor.value,
                      onTap: () => setState(() => _fontColor = c),
                    ),
                ],
              ),
            ]),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              constraints: const BoxConstraints(minHeight: 64),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                border: Border.all(color: Colors.black12),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(_ctrl.text, style: previewStyle),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel')),
        FilledButton(
          onPressed: () {
            final updated = (widget.initial.cloneWith() as TextItem)
              ..text = _ctrl.text.trim()
              ..fontSize = _fontSize
              ..fontColor = _fontColor
              ..fontWeight = _fontWeight
              ..fontFamily = _fontFamily
              ..fontItalic = _italic
              ..fontUnderline = _underline;
            Navigator.pop(context, updated);
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}

class _StyleToggle extends StatelessWidget {
  const _StyleToggle({
    required this.tooltip,
    required this.selected,
    required this.icon,
    required this.onTap,
  });

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

/// ---------------- Palette ----------------

class PaletteItem extends CanvasItem {
  PaletteItem({
    required super.id,
    required super.position,
    required super.size,
    List<Color>? paletteColors,
    super.locked = false,
    super.rotationDeg = 0,
  }) : paletteColors = paletteColors ??
            const [Color(0xFF111827), Color(0xFF6B7280), Color(0xFFE5E7EB)];

  List<Color> paletteColors;

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
  Widget buildPropertiesEditor(
    BuildContext context, {
    required VoidCallback onChangeStart,
    required ValueChanged<CanvasItem> onChanged,
    required VoidCallback onChangeEnd,
  }) {
    return _PalettePropsEditor(
      item: this,
      onBegin: onChangeStart,
      onChange: onChanged,
      onEnd: onChangeEnd,
    );
  }

  @override
  CanvasItem cloneWith({String? id}) => PaletteItem(
        id: id ?? this.id,
        position: position,
        size: size,
        paletteColors: List<Color>.from(paletteColors),
        locked: locked,
        rotationDeg: rotationDeg,
      );

  @override
  Map<String, dynamic> propsToJson() => {
        'colors': [for (final c in paletteColors) colorToHex(c)],
      };

  static PaletteItem fromJson(Map<String, dynamic> json) {
    final props = (json['props'] as Map?)?.cast<String, dynamic>() ?? const {};
    final list = (props['colors'] as List?)?.cast<String>() ?? const <String>[];
    final colors = list
        .map((h) => hexToColor(h))
        .whereType<Color>()
        .toList(growable: false);
    final safe = colors.isNotEmpty
        ? colors
        : const [Color(0xFF111827), Color(0xFF6B7280), Color(0xFFE5E7EB)];

    return PaletteItem(
      id: (json['id'] as String?) ??
          DateTime.now().microsecondsSinceEpoch.toString(),
      position: Offset(
        (json['x'] as num?)?.toDouble() ?? 0,
        (json['y'] as num?)?.toDouble() ?? 0,
      ),
      size: Size(
        (json['w'] as num?)?.toDouble() ?? 320,
        (json['h'] as num?)?.toDouble() ?? 64,
      ),
      locked: (json['locked'] as bool?) ?? false,
      rotationDeg: (json['rot'] as num?)?.toDouble() ?? 0,
      paletteColors: List<Color>.from(safe),
    );
  }
}

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
    for (final c in widget.item.paletteColors) {
      _rows.add(_PaletteRow(initial: _colorToHex(c)));
    }
    if (_rows.isEmpty) _rows.add(_PaletteRow(initial: '#FF000000'));
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
    _begin();
    final list = <Color>[];
    for (final r in _rows) {
      final c = _parseHex(r.ctrl.text);
      if (c != null) list.add(c);
    }
    if (list.isEmpty) return;
    final u = widget.item.cloneWith() as PaletteItem..paletteColors = list;
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
                  onChanged: (_) => _commit(),
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

/// Small helpers reused in editors
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
            color:
                selected ? Theme.of(context).colorScheme.primary : borderColor,
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

/// Optional helper if you ever need to pretty print items alone
String encodeItemsPretty(List<CanvasItem> items) =>
    const JsonEncoder.withIndent('  ').convert([
      for (int i = 0; i < items.length; i++) items[i].toJson(i),
    ]);
