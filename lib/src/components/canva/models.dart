import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_meragi_design/flutter_meragi_design.dart';
import 'package:flutter_meragi_design/src/components/canva/items/item_registry.dart';

import 'scaling.dart';
import 'ui/number_input.dart';
import 'utils.dart';

enum CanvasItemKind { image, text, palette }

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
  final CanvasInteractionTap? onTap;
  final CanvasInteractionTapDown? onTapDown;
  final CanvasInteractionNoDetails? onDoubleTap;
  final CanvasInteractionTapDown? onDoubleTapDown;
  final CanvasInteractionTap? onSecondaryTap;
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

/// Base class – agnostic of subclasses.
abstract class CanvasItem {
  CanvasItem({
    required this.id,
    required this.position,
    required this.size,
    required this.locked,
    required this.rotationDeg,
  });

  final String id;
  Offset position;
  Size size;
  bool locked;
  double rotationDeg;

  CanvasItemKind get kind;

  Widget buildContent(CanvasScaleHandler scale);

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

  Widget buildPropertiesEditor(
    BuildContext context, {
    required VoidCallback onChangeStart,
    required ValueChanged<CanvasItem> onChanged,
    required VoidCallback onChangeEnd,
  });

  Future<CanvasItem?> handleDoubleTap(BuildContext context) async => null;

  CanvasItem cloneWith({String? id});

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

  static CanvasItem fromJson(Map<String, dynamic> json) =>
      CanvasItemRegistry.decode(json);
}

/// ---------- Unknown (fallback) ----------
class UnknownItem extends CanvasItem {
  UnknownItem({
    required super.id,
    required super.position,
    required super.size,
    required super.locked,
    required super.rotationDeg,
    required this.raw,
  });

  final Map<String, dynamic> raw;

  @override
  CanvasItemKind get kind => CanvasItemKind.values.firstWhere(
        (e) => e.name == (raw['kind'] as String? ?? 'unknown'),
        orElse: () => CanvasItemKind.image,
      );

  @override
  Widget buildContent(CanvasScaleHandler scale) {
    return Container(
      color: Colors.grey.shade100,
      alignment: Alignment.center,
      child: Text(
        'Unknown kind: ${raw['kind']}',
        style:
            TextStyle(color: Colors.grey.shade700, fontStyle: FontStyle.italic),
      ),
    );
  }

  @override
  Widget buildPropertiesEditor(BuildContext context,
      {required VoidCallback onChangeStart,
      required ValueChanged<CanvasItem> onChanged,
      required VoidCallback onChangeEnd}) {
    return const SizedBox.shrink();
  }

  @override
  CanvasItem cloneWith({String? id}) => UnknownItem(
        id: id ?? this.id,
        position: position,
        size: size,
        locked: locked,
        rotationDeg: rotationDeg,
        raw: Map<String, dynamic>.from(raw),
      );

  @override
  Map<String, dynamic> propsToJson() =>
      (raw['props'] as Map?)?.cast<String, dynamic>() ?? {};
  static UnknownItem fromJson(Map<String, dynamic> j) => UnknownItem(
        id: (j['id'] as String?) ??
            DateTime.now().microsecondsSinceEpoch.toString(),
        position: Offset((j['x'] as num?)?.toDouble() ?? 0,
            (j['y'] as num?)?.toDouble() ?? 0),
        size: Size((j['w'] as num?)?.toDouble() ?? 100,
            (j['h'] as num?)?.toDouble() ?? 100),
        locked: (j['locked'] as bool?) ?? false,
        rotationDeg: (j['rot'] as num?)?.toDouble() ?? 0,
        raw: Map<String, dynamic>.from(j),
      );
}

/// ---------- Image ----------
class ImageItem extends CanvasItem {
  ImageItem({
    required super.id,
    required super.position,
    required super.size,
    this.src = '',
    this.radiusTL = 0,
    this.radiusTR = 0,
    this.radiusBL = 0,
    this.radiusBR = 0,
    super.locked = false,
    super.rotationDeg = 0,
  });

  String src;
  double radiusTL, radiusTR, radiusBL, radiusBR;

  ImageProvider? _cachedProvider;
  String? _cachedSrcKey;

  @override
  CanvasItemKind get kind => CanvasItemKind.image;

  ImageProvider? _resolveProvider() {
    if (src.isEmpty) return null;
    if (_cachedProvider != null && _cachedSrcKey == src) return _cachedProvider;

    try {
      if (src.startsWith('asset://')) {
        final path = src.substring('asset://'.length);
        _cachedProvider = AssetImage(path);
      } else if (src.startsWith('data:image/')) {
        final comma = src.indexOf(',');
        if (comma > 0) {
          final b64 = src.substring(comma + 1);
          final bytes = base64Decode(b64);
          _cachedProvider = MemoryImage(bytes);
        }
      } else if (src.startsWith('http://') || src.startsWith('https://')) {
        _cachedProvider = NetworkImage(src);
      } else {
        // Unknown scheme – leave null
        _cachedProvider = null;
      }
    } catch (_) {
      _cachedProvider = null;
    }
    _cachedSrcKey = src;
    return _cachedProvider;
  }

  @override
  Widget buildContent(CanvasScaleHandler scale) {
    final p = _resolveProvider();
    final s = scale.s;
    final br = BorderRadius.only(
      topLeft: Radius.circular(radiusTL * s),
      topRight: Radius.circular(radiusTR * s),
      bottomLeft: Radius.circular(radiusBL * s),
      bottomRight: Radius.circular(radiusBR * s),
    );

    if (p == null) {
      return ClipRRect(
        borderRadius: br,
        child: Container(
          color: Colors.grey.shade200,
          alignment: Alignment.center,
          child: const Icon(Icons.broken_image_outlined, size: 28),
        ),
      );
    }

    return ClipRRect(
      borderRadius: br,
      clipBehavior: Clip.antiAlias,
      child: Image(image: p, fit: BoxFit.cover),
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
        position: position,
        size: size,
        src: src,
        radiusTL: radiusTL,
        radiusTR: radiusTR,
        radiusBL: radiusBL,
        radiusBR: radiusBR,
        locked: locked,
        rotationDeg: rotationDeg,
      );

  @override
  Map<String, dynamic> propsToJson() => {
        'src': src,
        'radii': {
          'tl': radiusTL,
          'tr': radiusTR,
          'bl': radiusBL,
          'br': radiusBR
        },
      };

  static ImageItem fromJson(Map<String, dynamic> j) {
    final props = (j['props'] as Map?)?.cast<String, dynamic>() ?? const {};
    final r = (props['radii'] as Map?)?.cast<String, dynamic>() ?? const {};
    return ImageItem(
      id: (j['id'] as String?) ??
          DateTime.now().microsecondsSinceEpoch.toString(),
      position: Offset(
          (j['x'] as num?)?.toDouble() ?? 0, (j['y'] as num?)?.toDouble() ?? 0),
      size: Size((j['w'] as num?)?.toDouble() ?? 100,
          (j['h'] as num?)?.toDouble() ?? 100),
      locked: (j['locked'] as bool?) ?? false,
      rotationDeg: (j['rot'] as num?)?.toDouble() ?? 0,
      src: (props['src'] as String?) ?? '',
      radiusTL: (r['tl'] as num?)?.toDouble() ?? 0,
      radiusTR: (r['tr'] as num?)?.toDouble() ?? 0,
      radiusBL: (r['bl'] as num?)?.toDouble() ?? 0,
      radiusBR: (r['br'] as num?)?.toDouble() ?? 0,
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
  void didUpdateWidget(covariant _ImagePropsEditor oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.item.id != widget.item.id) {
      // end any active edit session from previous item
      if (_begun) {
        widget.onEnd();
        _begun = false;
      }
      // refresh controllers with the new item's values
      _tl.text = widget.item.radiusTL.toStringAsFixed(0);
      _tr.text = widget.item.radiusTR.toStringAsFixed(0);
      _bl.text = widget.item.radiusBL.toStringAsFixed(0);
      _br.text = widget.item.radiusBR.toStringAsFixed(0);
      _linkAll = false;
      setState(() {});
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

  void _commit() {
    _begin();
    final u = widget.item.cloneWith() as ImageItem;

    double vtl = double.tryParse(_tl.text.trim()) ?? u.radiusTL;
    double vtr = double.tryParse(_tr.text.trim()) ?? u.radiusTR;
    double vbl = double.tryParse(_bl.text.trim()) ?? u.radiusBL;
    double vbr = double.tryParse(_br.text.trim()) ?? u.radiusBR;

    if (_linkAll) {
      final uni = vtl;
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

  Widget _num(Widget prefix, TextEditingController c) {
    return CanvaNumberProperty(
      controller: c,
      prefix: prefix,
      onChanged: (_) => _commit(),
      onSubmitted: (_) => _commit(),
      onEditingComplete: _commit,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const _SectionTitle('Image'),
      const SizedBox(height: 8),
      Row(
        children: [
          MDToggle(
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
        _num(const Text('TL'), _tl),
        const SizedBox(width: 8),
        _num(const Text('TR'), _tr),
      ]),
      const SizedBox(height: 8),
      Row(children: [
        _num(const Text('BL'), _bl),
        const SizedBox(width: 8),
        _num(const Text('BR'), _br),
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
            _commit();
          },
        ),
      ],
    ]);
  }
}

/// ---------- Text ----------
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

/// ---------- Palette ----------
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
        locked: locked,
        rotationDeg: rotationDeg,
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
      const _SectionTitle('Text'),
      TextField(
        controller: _textCtrl,
        maxLines: 5,
        minLines: 3,
        decoration:
            const InputDecoration(border: OutlineInputBorder(), isDense: true),
        onChanged: (_) => _emit(),
      ),
      const SizedBox(height: 12),
      const _SectionTitle('Font'),
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
      const _SectionTitle('Size'),
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
      const _SectionTitle('Style'),
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
              color: selected
                  ? Theme.of(context).colorScheme.primary
                  : borderColor,
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
        child: Text(text, style: const TextStyle(fontWeight: FontWeight.w700)));
  }
}

/// Register built-in kinds. Call once at startup.
void registerBuiltInCanvasItems() {
  CanvasItemRegistry.register(CanvasItemKind.image.name, ImageItem.fromJson);
  CanvasItemRegistry.register(CanvasItemKind.text.name, TextItem.fromJson);
  CanvasItemRegistry.register(
      CanvasItemKind.palette.name, PaletteItem.fromJson);
}
