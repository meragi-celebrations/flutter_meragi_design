import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_meragi_design/flutter_meragi_design.dart' hide Path;
import 'package:flutter_meragi_design/src/components/canva/scaling.dart';
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
  List<Handle> getHandles() {
    switch (shapeType) {
      case ShapeType.line:
      case ShapeType.arrow:
        return [
          const Handle(key: 'start', alignment: Alignment.topLeft),
          const Handle(key: 'end', alignment: Alignment.bottomRight),
        ];
      default:
        return super.getHandles();
    }
  }

  @override
  CanvasItem resizeWithHandle(
    String handleKey,
    Offset delta,
    CanvasScaleHandler scale,
  ) {
    if (shapeType == ShapeType.line || shapeType == ShapeType.arrow) {
      final newItem = cloneWith();
      if (handleKey == 'start') {
        newItem.position += delta;
        newItem.size = Size(
          newItem.size.width - delta.dx,
          newItem.size.height - delta.dy,
        );
      } else {
        newItem.size = Size(
          newItem.size.width + delta.dx,
          newItem.size.height + delta.dy,
        );
      }
      return newItem;
    }
    return super.resizeWithHandle(handleKey, delta, scale);
  }

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
        if (color.alpha > 0) canvas.drawRect(rect, paint);
        if (strokeWidth > 0 && strokeColor.alpha > 0) {
          canvas.drawRect(rect, strokePaint);
        }
        break;
      case ShapeType.circle:
        final radius = size.width / 2;
        if (color.alpha > 0) canvas.drawCircle(rect.center, radius, paint);
        if (strokeWidth > 0 && strokeColor.alpha > 0) {
          canvas.drawCircle(rect.center, radius, strokePaint);
        }
        break;
      case ShapeType.oval:
        if (color.alpha > 0) canvas.drawOval(rect, paint);
        if (strokeWidth > 0 && strokeColor.alpha > 0) {
          canvas.drawOval(rect, strokePaint);
        }
        break;
      case ShapeType.line:
        if (strokeWidth > 0 && strokeColor.alpha > 0) {
          canvas.drawLine(rect.topLeft, rect.bottomRight, strokePaint);
        }
        break;
      case ShapeType.arrow:
        if (strokeWidth > 0 && strokeColor.alpha > 0) {
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
        }
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
        MDTap(
          onPressed: () async {
            final color = await showDialog<Color>(
              context: context,
              builder: (context) => AlertDialog(
                content: MDColorPicker(
                  initialColor: _color,
                  onColorChanged: (c) {
                    setState(() => _color = c);
                    _emit();
                  },
                  onDone: (c) => Navigator.pop(context, c),
                ),
              ),
            );
            if (color != null) {
              setState(() => _color = color);
              _emit();
            }
          },
          child: Container(
            height: 48,
            decoration: BoxDecoration(
              color: _color,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300),
            ),
          ),
        ),
        const SizedBox(height: 12),
        const SectionTitle('Stroke Color'),
        MDTap(
          onPressed: () async {
            final color = await showDialog<Color>(
              context: context,
              builder: (context) => AlertDialog(
                content: MDColorPicker(
                  initialColor: _strokeColor,
                  onColorChanged: (c) {
                    setState(() => _strokeColor = c);
                    _emit();
                  },
                  onDone: (c) => Navigator.pop(context, c),
                ),
              ),
            );
            if (color != null) {
              setState(() => _strokeColor = color);
              _emit();
            }
          },
          child: Container(
            height: 48,
            decoration: BoxDecoration(
              color: _strokeColor,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300),
            ),
          ),
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
