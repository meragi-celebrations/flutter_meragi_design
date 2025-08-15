import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_meragi_design/src/components/canva/items/base.dart';
import 'package:flutter_meragi_design/src/components/canva/scaling.dart';
import 'package:flutter_meragi_design/src/components/canva/ui/number_input.dart';
import 'package:flutter_meragi_design/src/components/fields/toggle.dart';

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
    this.borderEnabled = false,
    this.borderWidth = 0,
    Color? borderColor,
    super.locked = false,
    super.rotationDeg = 0,
  }) : borderColor = borderColor ?? const Color(0xFF000000);

  String src;
  double radiusTL, radiusTR, radiusBL, radiusBR;

  // Border
  bool borderEnabled;
  double borderWidth; // logical px at base scale
  Color borderColor;

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

    final double bw =
        borderEnabled ? (borderWidth * s).clamp(0, 5000).toDouble() : 0;

    Widget inner;
    if (p == null) {
      inner = Container(
        color: Colors.grey.shade200,
        alignment: Alignment.center,
        child: const Icon(Icons.broken_image_outlined, size: 28),
      );
    } else {
      inner = Image(image: p, fit: BoxFit.cover);
    }

    return Container(
      decoration: BoxDecoration(
        borderRadius: br,
        border: bw > 0 ? Border.all(color: borderColor, width: bw) : null,
      ),
      child: ClipRRect(
        borderRadius: br,
        clipBehavior: Clip.antiAlias,
        child: inner,
      ),
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
        borderEnabled: borderEnabled,
        borderWidth: borderWidth,
        borderColor: borderColor,
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
          'br': radiusBR,
        },
        'border': {
          'enabled': borderEnabled,
          'width': borderWidth,
          'color': _colorToHex(borderColor),
        },
      };

  static ImageItem fromJson(Map<String, dynamic> j) {
    final props = (j['props'] as Map?)?.cast<String, dynamic>() ?? const {};
    final r = (props['radii'] as Map?)?.cast<String, dynamic>() ?? const {};
    final b = (props['border'] as Map?)?.cast<String, dynamic>() ?? const {};

    return ImageItem(
      id: (j['id'] as String?) ??
          DateTime.now().microsecondsSinceEpoch.toString(),
      position: Offset(
        (j['x'] as num?)?.toDouble() ?? 0,
        (j['y'] as num?)?.toDouble() ?? 0,
      ),
      size: Size(
        (j['w'] as num?)?.toDouble() ?? 100,
        (j['h'] as num?)?.toDouble() ?? 100,
      ),
      locked: (j['locked'] as bool?) ?? false,
      rotationDeg: (j['rot'] as num?)?.toDouble() ?? 0,
      src: (props['src'] as String?) ?? '',
      radiusTL: (r['tl'] as num?)?.toDouble() ?? 0,
      radiusTR: (r['tr'] as num?)?.toDouble() ?? 0,
      radiusBL: (r['bl'] as num?)?.toDouble() ?? 0,
      radiusBR: (r['br'] as num?)?.toDouble() ?? 0,
      borderEnabled: (b['enabled'] as bool?) ?? false,
      borderWidth: (b['width'] as num?)?.toDouble() ?? 0,
      borderColor: _parseHexColor((b['color'] as String?) ?? '#000000'),
    );
  }

  // ---------- helpers ----------

  static String _colorToHex(Color c, {bool includeAlpha = true}) {
    final a = includeAlpha ? c.alpha.toRadixString(16).padLeft(2, '0') : '';
    final r = c.red.toRadixString(16).padLeft(2, '0');
    final g = c.green.toRadixString(16).padLeft(2, '0');
    final b = c.blue.toRadixString(16).padLeft(2, '0');
    return '#${includeAlpha ? a : ''}$r$g$b'.toUpperCase();
  }

  static Color _parseHexColor(String input) {
    var hex = input.trim();
    if (hex.startsWith('#')) hex = hex.substring(1);
    if (hex.length == 6) hex = 'FF$hex'; // assume opaque
    if (hex.length != 8) return const Color(0xFF000000);
    final val = int.tryParse(hex, radix: 16) ?? 0xFF000000;
    return Color(val);
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
  late TextEditingController _bw; // border width
  late TextEditingController _bc; // border color hex

  bool _borderEnabled = false;
  bool _linkAll = false;
  bool _begun = false;

  // queued commit to avoid mouse tracker re-entrancy
  ImageItem? _queued;
  bool _scheduled = false;

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
    _bw =
        TextEditingController(text: widget.item.borderWidth.toStringAsFixed(0));
    _bc = TextEditingController(
        text: ImageItem._colorToHex(widget.item.borderColor));
    _borderEnabled = widget.item.borderEnabled;
  }

  @override
  void didUpdateWidget(covariant _ImagePropsEditor oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.item.id != widget.item.id) {
      if (_begun) {
        _begun = false;
        widget.onEnd();
      }
      _tl.text = widget.item.radiusTL.toStringAsFixed(0);
      _tr.text = widget.item.radiusTR.toStringAsFixed(0);
      _bl.text = widget.item.radiusBL.toStringAsFixed(0);
      _br.text = widget.item.radiusBR.toStringAsFixed(0);
      _bw.text = widget.item.borderWidth.toStringAsFixed(0);
      _bc.text = ImageItem._colorToHex(widget.item.borderColor);
      _borderEnabled = widget.item.borderEnabled;
      _linkAll = false;
    }
  }

  @override
  void dispose() {
    _tl.dispose();
    _tr.dispose();
    _bl.dispose();
    _br.dispose();
    _bw.dispose();
    _bc.dispose();
    super.dispose();
  }

  void _deliverQueued() {
    _scheduled = false;
    final u = _queued;
    _queued = null;
    if (!mounted || u == null) return;
    widget.onChange(u);
  }

  void _queueChange(ImageItem u) {
    _queued = u;
    if (_scheduled) return;
    _scheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) => _deliverQueued());
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

    final bw = (double.tryParse(_bw.text.trim()) ?? u.borderWidth)
        .clamp(0, 5000)
        .toDouble();
    final bc = ImageItem._parseHexColor(_bc.text.trim());

    u
      ..borderEnabled = _borderEnabled
      ..borderWidth = bw
      ..borderColor = bc;

    _queueChange(u);
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

  // No Expanded/Flexible/Spacer here; avoids ParentDataWidget misuse.
  Widget _borderColorField() {
    final color = ImageItem._parseHexColor(_bc.text);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: Colors.black12),
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          child: TextField(
            controller: _bc,
            decoration: const InputDecoration(
              labelText: 'Color (hex)',
              hintText: '#RRGGBB or #AARRGGBB',
              isDense: true,
              border: OutlineInputBorder(),
            ),
            onChanged: (_) => _commit(),
            onSubmitted: (_) => _commit(),
          ),
        ),
      ],
    );
  }

  Text _h(String text) => Text(text,
      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12));

  @override
  Widget build(BuildContext context) {
    final maxRadius = ((widget.item.size.width < widget.item.size.height
                ? widget.item.size.width
                : widget.item.size.height) /
            2)
        .clamp(1.0, 5000.0);
    final sliderVal = double.tryParse(_tl.text) ?? 0.0;

    // Safe inside any scrollable parent
    return ListView(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      children: [
        // Header row without Spacer/Expanded
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(children: [
              MDToggle(
                value: _linkAll,
                onChanged: (v) => setState(() => _linkAll = v),
              ),
              const SizedBox(width: 6),
              const Text('Link all corners'),
            ]),
            if (_begun)
              TextButton(
                onPressed: () {
                  if (_begun) {
                    _begun = false;
                    widget.onEnd();
                  }
                  setState(() {});
                },
                child: const Text('Done'),
              ),
          ],
        ),
        const SizedBox(height: 8),
        _h('Corner radius'),
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
            value: sliderVal.clamp(0.0, maxRadius.toDouble()),
            min: 0.0,
            max: maxRadius.toDouble(),
            onChanged: (v) {
              setState(() {
                final t = v.toStringAsFixed(0);
                _tl.text = t;
                _tr.text = t;
                _bl.text = t;
                _br.text = t;
              });
              _commit(); // queued
            },
          ),
        ],
        const SizedBox(height: 12),
        _h('Border'),
        Row(
          children: [
            MDToggle(
              value: _borderEnabled,
              onChanged: (v) {
                setState(() => _borderEnabled = v);
                _commit(); // queued
              },
            ),
            const SizedBox(width: 6),
            const Text('Enable border'),
          ],
        ),
        const SizedBox(height: 8),
        if (_borderEnabled) ...[
          _num(const Text('Width'), _bw),
          const SizedBox(height: 8),
          _borderColorField(),
        ],
      ],
    );
  }
}
