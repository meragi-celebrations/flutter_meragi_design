import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_meragi_design/flutter_meragi_design.dart' hide Path;
import 'package:flutter_meragi_design/src/components/canva/canvas_scope.dart';
import 'package:flutter_meragi_design/src/components/canva/scaling.dart';
import 'package:flutter_meragi_design/src/components/canva/ui/color_preview.dart';
import 'package:flutter_meragi_design/src/components/canva/ui/common_color_picker.dart';
import 'package:flutter_meragi_design/src/components/canva/ui/dialog_manager_scope.dart';
import 'package:flutter_meragi_design/src/components/canva/ui/draggable_dialog.dart';
import 'package:flutter_meragi_design/src/components/canva/utils.dart';

enum ShapeType { rectangle, circle, oval, line, arrow }

class ShapeItem extends CanvasItem {
  const ShapeItem({
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

  final ShapeType shapeType;
  final Color color;
  final Color strokeColor;
  final double strokeWidth;

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
  CanvasItem copyWith({
    String? id,
    Offset? position,
    Size? size,
    bool? locked,
    double? rotationDeg,
    ShapeType? shapeType,
    Color? color,
    Color? strokeColor,
    double? strokeWidth,
  }) =>
      ShapeItem(
        id: id ?? this.id,
        position: position ?? this.position,
        size: size ?? this.size,
        locked: locked ?? this.locked,
        rotationDeg: rotationDeg ?? this.rotationDeg,
        shapeType: shapeType ?? this.shapeType,
        color: color ?? this.color,
        strokeColor: strokeColor ?? this.strokeColor,
        strokeWidth: strokeWidth ?? this.strokeWidth,
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
      if (handleKey == 'start') {
        return copyWith(
          position: position + delta,
          size: Size(
            size.width - delta.dx,
            size.height - delta.dy,
          ),
        );
      } else {
        return copyWith(
          size: Size(
            size.width + delta.dx,
            size.height + delta.dy,
          ),
        );
      }
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
    final u = (widget.item.copyWith() as ShapeItem).copyWith(
      shapeType: _shapeType,
      color: _color,
      strokeColor: _strokeColor,
      strokeWidth: _strokeWidth,
    );
    widget.onChange(u);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle('Shape'),
        MDSelect<ShapeType>(
          initialValue: _shapeType,
          onChanged: (v) {
            if (v == null) return;
            setState(() => _shapeType = v);
            _emit();
          },
          options: ShapeType.values
              .map(
                (f) => MDOption(value: f, child: Text(f.name)),
              )
              .toList(),
          selectedOptionBuilder: (context, value) {
            return Text(value.name);
          },
        ),
        const SizedBox(height: 12),
        const SectionTitle('Fill Color'),
        ColorPreview(
          color: _color,
          onTap: () {
            final doc = CanvasScope.of(context, listen: false);
            final dialogManager = DialogManagerScope.of(context);
            late DraggableDialog dialog;
            dialog = DraggableDialog(
              onClose: () => dialogManager.close(dialog),
              child: CommonColorPicker(
                doc: doc,
                onColorSelected: (c) {
                  setState(() => _color = c);
                  _emit();
                },
                onOpenColorPicker: () {
                  dialogManager.close(dialog);
                  late DraggableDialog colorPickerDialog;
                  colorPickerDialog = DraggableDialog(
                    title: 'Select Color',
                    onClose: () => dialogManager.close(colorPickerDialog),
                    child: MDColorPicker(
                      initialColor: _color,
                      onColorChanged: (c) {
                        setState(() => _color = c);
                        _emit();
                      },
                      onDone: (c) {
                        doc.applyPatch([
                          {
                            'type': 'doc.colors.add',
                            'color': colorToHex(c),
                          }
                        ]);
                        setState(() => _color = c);
                        _emit();
                        dialogManager.close(colorPickerDialog);
                      },
                    ),
                  );
                  dialogManager.show(colorPickerDialog);
                },
              ),
            );
            dialogManager.show(dialog);
          },
        ),
        const SizedBox(height: 12),
        const SectionTitle('Stroke Color'),
        ColorPreview(
          color: _strokeColor,
          onTap: () {
            final doc = CanvasScope.of(context, listen: false);
            final dialogManager = DialogManagerScope.of(context);
            late DraggableDialog dialog;
            dialog = DraggableDialog(
              onClose: () => dialogManager.close(dialog),
              child: CommonColorPicker(
                doc: doc,
                onColorSelected: (c) {
                  setState(() => _strokeColor = c);
                  _emit();
                },
                onOpenColorPicker: () {
                  dialogManager.close(dialog);
                  late DraggableDialog colorPickerDialog;
                  colorPickerDialog = DraggableDialog(
                    title: 'Select Color',
                    onClose: () => dialogManager.close(colorPickerDialog),
                    child: MDColorPicker(
                      initialColor: _strokeColor,
                      onColorChanged: (c) {
                        setState(() => _strokeColor = c);
                        _emit();
                      },
                      onDone: (c) {
                        doc.applyPatch([
                          {
                            'type': 'doc.colors.add',
                            'color': colorToHex(c),
                          }
                        ]);
                        setState(() => _strokeColor = c);
                        _emit();
                        dialogManager.close(colorPickerDialog);
                      },
                    ),
                  );
                  dialogManager.show(colorPickerDialog);
                },
              ),
            );
            dialogManager.show(dialog);
          },
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
