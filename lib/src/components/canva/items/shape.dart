import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_meragi_design/src/components/canva/items/base.dart';
import 'package:flutter_meragi_design/src/components/canva/scaling.dart';
import 'package:flutter_meragi_design/src/components/canva/ui/color_dot.dart';
import 'package:flutter_meragi_design/src/components/canva/utils.dart';

enum ShapeType { rectangle, circle, oval, line, arrow }

class ShapeItem extends CanvasItem {
  ShapeItem({
    required super.id,
    required super.position,
    required super.size,
    this.shapeType = ShapeType.rectangle,
    this.color = Colors.blue,
    this.strokeColor = Colors.black,
    this.strokeWidth = 1.0,
    super.locked = false,
    super.rotationDeg = 0,
  });

  ShapeType shapeType;
  Color color;
  Color strokeColor;
  double strokeWidth;

  @override
  CanvasItemKind get kind => CanvasItemKind.shape;

  @override
  Widget buildContent(CanvasScaleHandler scale) {
    return CustomPaint(
      painter: _ShapePainter(
        shapeType: shapeType,
        color: color,
        strokeColor: strokeColor,
        strokeWidth: strokeWidth * scale.s,
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
    return _ShapePropsEditor(
      item: this,
      onBegin: onChangeStart,
      onChange: onChanged,
      onEnd: onChangeEnd,
    );
  }

  @override
  CanvasItem cloneWith({String? id}) => ShapeItem(
        id: id ?? this.id,
        position: position,
        size: size,
        shapeType: shapeType,
        color: color,
        strokeColor: strokeColor,
        strokeWidth: strokeWidth,
        locked: locked,
        rotationDeg: rotationDeg,
      );

  @override
  Map<String, dynamic> propsToJson() => {
        'shapeType': shapeType.index,
        'color': colorToHex(color),
        'strokeColor': colorToHex(strokeColor),
        'strokeWidth': strokeWidth,
      };

  static ShapeItem fromJson(Map<String, dynamic> j) {
    final p = (j['props'] as Map?)?.cast<String, dynamic>() ?? const {};
    return ShapeItem(
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
      shapeType: ShapeType.values[(p['shapeType'] as int?) ?? 0],
      color: hexToColor((p['color'] as String?) ?? '#FF0000FF') ?? Colors.blue,
      strokeColor: hexToColor((p['strokeColor'] as String?) ?? '#FF000000') ??
          Colors.black,
      strokeWidth: (p['strokeWidth'] as num?)?.toDouble() ?? 1.0,
    );
  }
}

class _ShapePainter extends CustomPainter {
  _ShapePainter({
    required this.shapeType,
    required this.color,
    required this.strokeColor,
    required this.strokeWidth,
  });

  final ShapeType shapeType;
  final Color color;
  final Color strokeColor;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final strokePaint = Paint()
      ..color = strokeColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    final rect = Rect.fromLTWH(0, 0, size.width, size.height);

    switch (shapeType) {
      case ShapeType.rectangle:
        canvas.drawRect(rect, paint);
        if (strokeWidth > 0) canvas.drawRect(rect, strokePaint);
        break;
      case ShapeType.circle:
        final radius = size.width / 2;
        canvas.drawCircle(rect.center, radius, paint);
        if (strokeWidth > 0) {
          canvas.drawCircle(rect.center, radius, strokePaint);
        }
        break;
      case ShapeType.oval:
        canvas.drawOval(rect, paint);
        if (strokeWidth > 0) canvas.drawOval(rect, strokePaint);
        break;
      case ShapeType.line:
        canvas.drawLine(rect.topLeft, rect.bottomRight, strokePaint);
        break;
      case ShapeType.arrow:
        final p1 = rect.topLeft;
        final p2 = rect.bottomRight;
        canvas.drawLine(p1, p2, strokePaint);
        final angle = (p2 - p1).direction;
        final arrowSize = 10 + strokeWidth;
        final path = Path()
          ..moveTo(p2.dx, p2.dy)
          ..lineTo(
            p2.dx - arrowSize * 1.5 * math.cos(angle - 0.5),
            p2.dy - arrowSize * 1.5 * math.sin(angle - 0.5),
          )
          ..lineTo(
            p2.dx - arrowSize * 1.5 * math.cos(angle + 0.5),
            p2.dy - arrowSize * 1.5 * math.sin(angle + 0.5),
          )
          ..close();
        canvas.drawPath(path, strokePaint..style = PaintingStyle.fill);
        break;
    }
  }

  @override
  bool shouldRepaint(covariant _ShapePainter oldDelegate) =>
      shapeType != oldDelegate.shapeType ||
      color != oldDelegate.color ||
      strokeColor != oldDelegate.strokeColor ||
      strokeWidth != oldDelegate.strokeWidth;
}

class _ShapePropsEditor extends StatefulWidget {
  const _ShapePropsEditor({
    required this.item,
    required this.onBegin,
    required this.onChange,
    required this.onEnd,
  });

  final ShapeItem item;
  final VoidCallback onBegin;
  final ValueChanged<CanvasItem> onChange;
  final VoidCallback onEnd;

  @override
  State<_ShapePropsEditor> createState() => _ShapePropsEditorState();
}

class _ShapePropsEditorState extends State<_ShapePropsEditor> {
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

  late ShapeType _shapeType;
  late Color _color;
  late Color _strokeColor;
  late double _strokeWidth;

  bool _begun = false;

  void _begin() {
    if (_begun) return;
    _begun = true;
    widget.onBegin();
  }

  @override
  void initState() {
    super.initState();
    _shapeType = widget.item.shapeType;
    _color = widget.item.color;
    _strokeColor = widget.item.strokeColor;
    _strokeWidth = widget.item.strokeWidth;
  }

  @override
  void didUpdateWidget(covariant _ShapePropsEditor oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.item.id != widget.item.id) {
      if (_begun) {
        widget.onEnd();
        _begun = false;
      }
      _shapeType = widget.item.shapeType;
      _color = widget.item.color;
      _strokeColor = widget.item.strokeColor;
      _strokeWidth = widget.item.strokeWidth;
      setState(() {});
    }
  }

  void _emit() {
    _begin();
    final u = widget.item.cloneWith() as ShapeItem
      ..shapeType = _shapeType
      ..color = _color
      ..strokeColor = _strokeColor
      ..strokeWidth = _strokeWidth;
    widget.onChange(u);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle('Shape'),
        DropdownButtonFormField<ShapeType>(
          value: _shapeType,
          decoration: const InputDecoration(
            isDense: true,
            border: OutlineInputBorder(),
          ),
          items: ShapeType.values
              .map(
                (f) => DropdownMenuItem(value: f, child: Text(f.name)),
              )
              .toList(),
          onChanged: (v) {
            if (v == null) return;
            setState(() => _shapeType = v);
            _emit();
          },
        ),
        const SizedBox(height: 12),
        const SectionTitle('Fill Color'),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: [
            for (final c in _swatches)
              ColorDot(
                color: c,
                selected: c.value == _color.value,
                onTap: () {
                  setState(() => _color = c);
                  _emit();
                },
              ),
          ],
        ),
        const SizedBox(height: 12),
        const SectionTitle('Stroke Color'),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: [
            for (final c in _swatches)
              ColorDot(
                color: c,
                selected: c.value == _strokeColor.value,
                onTap: () {
                  setState(() => _strokeColor = c);
                  _emit();
                },
              ),
          ],
        ),
        const SizedBox(height: 12),
        const SectionTitle('Stroke Width'),
        Row(
          children: [
            Expanded(
              child: Slider(
                value: _strokeWidth.clamp(0, 20),
                min: 0,
                max: 20,
                label: _strokeWidth.toStringAsFixed(1),
                onChanged: (v) {
                  setState(() => _strokeWidth = v);
                  _emit();
                },
              ),
            ),
            SizedBox(
              width: 48,
              child: Text(
                _strokeWidth.toStringAsFixed(1),
                textAlign: TextAlign.right,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
