import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_meragi_design/src/components/canva/items/base.dart';
import 'package:flutter_meragi_design/src/components/canva/scaling.dart';
import 'package:flutter_meragi_design/src/components/canva/ui/slider_with_input.dart';
import 'package:flutter_meragi_design/src/components/fields/toggle.dart';
import 'package:flutter_meragi_design/src/theme/theme.dart';

enum BorderStyle { none, solid, dashed, moreDashed, dotted }

class ImageItem extends CanvasItem {
  const ImageItem({
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
    this.borderStyle = BorderStyle.solid,
    Color? borderColor,
    super.locked = false,
    super.rotationDeg = 0,
    this.opacity = 1.0,
    this.extractedColors = const [],
  }) : borderColor = borderColor ?? const Color(0xFF000000);

  final String src;
  final List<Color> extractedColors;
  final double radiusTL, radiusTR, radiusBL, radiusBR;

  // Border
  final bool borderEnabled;
  final double borderWidth; // logical px at base scale
  final Color borderColor;
  final BorderStyle borderStyle;

  // Opacity
  final double opacity;

  @override
  CanvasItemKind get kind => CanvasItemKind.image;

  ImageProvider? resolveProvider() {
    if (src.isEmpty) return null;

    try {
      if (src.startsWith('asset://')) {
        final path = src.substring('asset://'.length);
        return AssetImage(path);
      } else if (src.startsWith('data:image/')) {
        final comma = src.indexOf(',');
        if (comma > 0) {
          final b64 = src.substring(comma + 1);
          final bytes = base64Decode(b64);
          return MemoryImage(bytes);
        }
      } else if (src.startsWith('http://') || src.startsWith('https://')) {
        return NetworkImage(src);
      }
    } catch (_) {
      return null;
    }
    return null;
  }

  @override
  Widget buildContent(CanvasScaleHandler scale) {
    final p = resolveProvider();
    final s = scale.s;
    final outerBorderRadius = BorderRadius.only(
      topLeft: Radius.circular(radiusTL * s),
      topRight: Radius.circular(radiusTR * s),
      bottomLeft: Radius.circular(radiusBL * s),
      bottomRight: Radius.circular(radiusBR * s),
    );

    final double bw =
        borderEnabled ? (borderWidth * s).clamp(0, 5000).toDouble() : 0;

    final innerBorderRadius =
        outerBorderRadius.subtract(BorderRadius.circular(bw));

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

    return Opacity(
      opacity: opacity,
      child: CustomPaint(
        painter: borderStyle != BorderStyle.solid
            ? DashedBorderPainter(
                borderRadius: outerBorderRadius,
                strokeWidth: bw,
                color: borderColor,
                borderStyle: borderStyle,
              )
            : null,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: outerBorderRadius,
            border: borderStyle == BorderStyle.solid && bw > 0
                ? Border.all(color: borderColor, width: bw)
                : null,
          ),
          child: ClipRRect(
            borderRadius: innerBorderRadius,
            clipBehavior: Clip.antiAlias,
            child: inner,
          ),
        ),
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
  CanvasItem copyWith({
    String? id,
    Offset? position,
    Size? size,
    bool? locked,
    double? rotationDeg,
    String? src,
    double? radiusTL,
    double? radiusTR,
    double? radiusBL,
    double? radiusBR,
    bool? borderEnabled,
    double? borderWidth,
    Color? borderColor,
    BorderStyle? borderStyle,
    double? opacity,
    List<Color>? extractedColors,
  }) =>
      ImageItem(
        id: id ?? this.id,
        position: position ?? this.position,
        size: size ?? this.size,
        locked: locked ?? this.locked,
        rotationDeg: rotationDeg ?? this.rotationDeg,
        src: src ?? this.src,
        radiusTL: radiusTL ?? this.radiusTL,
        radiusTR: radiusTR ?? this.radiusTR,
        radiusBL: radiusBL ?? this.radiusBL,
        radiusBR: radiusBR ?? this.radiusBR,
        borderEnabled: borderEnabled ?? this.borderEnabled,
        borderWidth: borderWidth ?? this.borderWidth,
        borderColor: borderColor ?? this.borderColor,
        borderStyle: borderStyle ?? this.borderStyle,
        opacity: opacity ?? this.opacity,
        extractedColors: extractedColors ?? this.extractedColors,
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
          'style': borderStyle.name,
        },
        'opacity': opacity,
        'extractedColors': extractedColors.map((c) => _colorToHex(c)).toList(),
      };

  static ImageItem fromJson(Map<String, dynamic> j) {
    final props = (j['props'] as Map?)?.cast<String, dynamic>() ?? const {};
    final r = (props['radii'] as Map?)?.cast<String, dynamic>() ?? const {};
    final b = (props['border'] as Map?)?.cast<String, dynamic>() ?? const {};
    final extractedColorsRaw =
        (props['extractedColors'] as List?)?.cast<String>() ?? const [];
    final extractedColors = extractedColorsRaw.map(_parseHexColor).toList();

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
      borderStyle: BorderStyle.values.firstWhere(
        (e) => e.name == (b['style'] as String?),
        orElse: () => BorderStyle.solid,
      ),
      opacity: (props['opacity'] as num?)?.toDouble() ?? 1.0,
      extractedColors: extractedColors,
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

class DashedBorderPainter extends CustomPainter {
  final BorderRadius borderRadius;
  final double strokeWidth;
  final Color color;
  final BorderStyle borderStyle;

  DashedBorderPainter({
    required this.borderRadius,
    required this.strokeWidth,
    required this.color,
    required this.borderStyle,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (strokeWidth <= 0) return;

    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    // Build the rounded rect and keep stroke fully inside the bounds.
    final outer = RRect.fromRectAndCorners(
      Rect.fromLTWH(0, 0, size.width, size.height),
      topLeft: borderRadius.topLeft,
      topRight: borderRadius.topRight,
      bottomLeft: borderRadius.bottomLeft,
      bottomRight: borderRadius.bottomRight,
    );
    final rrect = outer.deflate(strokeWidth / 2);

    final basePath = Path()..addRRect(rrect);

    Path toDraw;
    switch (borderStyle) {
      case BorderStyle.dashed:
        toDraw = _getDashedPath(basePath, 10, 5);
        break;
      case BorderStyle.moreDashed:
        toDraw = _getDashedPath(basePath, 5, 3);
        break;
      case BorderStyle.dotted:
        toDraw = _getDashedPath(basePath, 2, 2);
        break;
      default:
        toDraw = basePath;
    }

    canvas.drawPath(toDraw, paint);
  }

  Path _getDashedPath(Path source, double dashLength, double dashSpace) {
    final path = Path();
    for (final metric in source.computeMetrics()) {
      double distance = 0.0;
      while (distance < metric.length) {
        final next = distance + dashLength;
        path.addPath(metric.extractPath(distance, next), Offset.zero);
        distance = next + dashSpace;
      }
    }
    return path;
  }

  @override
  bool shouldRepaint(covariant DashedBorderPainter oldDelegate) {
    return oldDelegate.borderRadius != borderRadius ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.color != color ||
        oldDelegate.borderStyle != borderStyle;
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
  late TextEditingController _opacity;

  BorderStyle _borderStyle = BorderStyle.none;
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
    _opacity =
        TextEditingController(text: widget.item.opacity.toStringAsFixed(2));
    _borderStyle =
        widget.item.borderEnabled ? widget.item.borderStyle : BorderStyle.none;
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
      _opacity.text = widget.item.opacity.toStringAsFixed(2);
      _borderStyle = widget.item.borderEnabled
          ? widget.item.borderStyle
          : BorderStyle.none;
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
    _opacity.dispose();
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
    ImageItem u = widget.item;

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
    u = u.copyWith(
      radiusTL: vtl.clamp(0, maxR),
      radiusTR: vtr.clamp(0, maxR),
      radiusBL: vbl.clamp(0, maxR),
      radiusBR: vbr.clamp(0, maxR),
    ) as ImageItem;

    final bw = (double.tryParse(_bw.text.trim()) ?? u.borderWidth)
        .clamp(0, 5000)
        .toDouble();
    final bc = ImageItem._parseHexColor(_bc.text.trim());
    final opacity =
        (double.tryParse(_opacity.text.trim()) ?? u.opacity).clamp(0.0, 1.0);

    u = u.copyWith(
      borderEnabled: _borderStyle != BorderStyle.none,
      borderWidth: bw,
      borderColor: bc,
      borderStyle: _borderStyle,
      opacity: opacity,
    ) as ImageItem;

    _queueChange(u);
  }

  Widget _num(Widget prefix, TextEditingController c) {
    return SizedBox(
      width: 60,
      child: TextField(
        controller: c,
        textAlign: TextAlign.right,
        keyboardType: TextInputType.number,
        onChanged: (_) => _commit(),
        onSubmitted: (_) => _commit(),
      ),
    );
  }

  // No Expanded/Flexible/Spacer here; avoids ParentDataWidget misuse.
  Widget _borderColorField() {
    final color = ImageItem._parseHexColor(_bc.text);
    return Row(
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
        const SizedBox(width: 8),
        Expanded(
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

  Widget _buildBorderStyleSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: BorderStyle.values.map((style) {
        return GestureDetector(
          onTap: () {
            setState(() => _borderStyle = style);
            _commit();
          },
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: _borderStyle == style
                  ? MeragiTheme.of(context).token.primaryColor.withOpacity(0.1)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: _borderStyle == style
                    ? MeragiTheme.of(context).token.primaryColor
                    : Colors.grey.shade300,
                width: 1.5,
              ),
            ),
            child: Icon(
              _getIconForBorderStyle(style),
              color: _borderStyle == style
                  ? MeragiTheme.of(context).token.primaryColor
                  : Colors.grey.shade600,
            ),
          ),
        );
      }).toList(),
    );
  }

  IconData _getIconForBorderStyle(BorderStyle style) {
    switch (style) {
      case BorderStyle.none:
        return Icons.not_interested;
      case BorderStyle.solid:
        return Icons.remove;
      case BorderStyle.dashed:
        return Icons.horizontal_rule;
      case BorderStyle.moreDashed:
        return Icons.drag_handle;
      case BorderStyle.dotted:
        return Icons.more_horiz;
    }
  }

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
          SliderWithInput(
            label: 'Radius',
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
        const SizedBox(height: 8),
        _buildBorderStyleSelector(),
        if (_borderStyle != BorderStyle.none) ...[
          const SizedBox(height: 16),
          SliderWithInput(
            label: 'Stroke weight',
            value: (double.tryParse(_bw.text) ?? 0.0).clamp(0.0, 100.0),
            min: 0.0,
            max: 100.0,
            onChanged: (v) {
              setState(() => _bw.text = v.toStringAsFixed(0));
              _commit();
            },
          ),
          const SizedBox(height: 16),
          _borderColorField(),
        ],
        const SizedBox(height: 12),
        SliderWithInput(
          label: 'Transparency',
          value: (double.tryParse(_opacity.text) ?? 1.0).clamp(0.0, 1.0),
          min: 0.0,
          max: 1.0,
          onChanged: (v) {
            setState(() => _opacity.text = v.toStringAsFixed(2));
            _commit();
          },
        ),
      ],
    );
  }
}
