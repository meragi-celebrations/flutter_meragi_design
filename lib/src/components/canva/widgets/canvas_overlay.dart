import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_meragi_design/src/components/canva/canvas_controller.dart';
import 'package:flutter_meragi_design/src/components/canva/geometry.dart';
import 'package:flutter_meragi_design/src/components/canva/items/base.dart';
import 'package:flutter_meragi_design/src/components/canva/scaling.dart';

class CanvasOverlay extends StatefulWidget {
  const CanvasOverlay({
    super.key,
    required this.controller,
    required this.scale,
  });

  final CanvasController controller;
  final CanvasScaleHandler scale;

  @override
  State<CanvasOverlay> createState() => _CanvasOverlayState();
}

class _CanvasOverlayState extends State<CanvasOverlay> {
  final _focusNode = FocusNode();
  bool _multiPressed = false;
  Offset? _lastLocal;

  void _onChanged() => setState(() {});

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onChanged);
    // ensure we can receive key events
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onChanged);
    _focusNode.dispose();
    super.dispose();
  }

  KeyEventResult _onKey(FocusNode node, KeyEvent e) {
    final isDown = e is KeyDownEvent;
    final k = e.logicalKey;
    final isCtrl = k == LogicalKeyboardKey.controlLeft ||
        k == LogicalKeyboardKey.controlRight;
    final isMeta =
        k == LogicalKeyboardKey.metaLeft || k == LogicalKeyboardKey.metaRight;
    if (isCtrl || isMeta) {
      print("multiselect");
      setState(() => _multiPressed = isDown);
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    final cursor = _cursorForHandle(widget.controller.hoveredHandle);

    return Focus(
      autofocus: true,
      canRequestFocus: true,
      onKeyEvent: _onKey,
      focusNode: _focusNode,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onPanDown: (d) {
          _lastLocal = d.localPosition;
          widget.controller.onDown(d.localPosition, multiSelect: _multiPressed);
        },
        onPanStart: (_) {
          // no-op; drag logic is in controller.onMove
        },
        onPanUpdate: (d) {
          _lastLocal = d.localPosition;
          widget.controller.onMove(d.localPosition, d.delta);
        },
        onPanEnd: (_) {
          widget.controller.onUp(_lastLocal ?? Offset.zero);
        },
        onPanCancel: () {
          widget.controller.onUp(_lastLocal ?? Offset.zero);
        },
        child: MouseRegion(
          cursor: cursor,
          onHover: widget.controller.onPointerHover,
          child: SizedBox.expand(
            child: CustomPaint(
              painter: _SelectionPainter(
                controller: widget.controller,
                scale: widget.scale,
              ),
            ),
          ),
        ),
      ),
    );
  }

  MouseCursor _cursorForHandle(String? h) {
    switch (h) {
      case 'rotate':
        return SystemMouseCursors.click;
      case 'topLeft':
      case 'bottomRight':
        return SystemMouseCursors.resizeUpLeftDownRight;
      case 'topRight':
      case 'bottomLeft':
        return SystemMouseCursors.resizeUpRightDownLeft;
      default:
        return SystemMouseCursors.basic;
    }
  }
}

class _SelectionPainter extends CustomPainter {
  _SelectionPainter({required this.controller, required this.scale});
  final CanvasController controller;
  final CanvasScaleHandler scale;

  static const double handleSize = 8.0;
  static const double rotHandleSize = 16.0;
  static const double rotHandleOffset = 30.0;

  @override
  void paint(Canvas canvas, Size size) {
    final sel = Paint()
      ..color = Colors.blueAccent
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;
    final fill = Paint()..color = Colors.white;
    final stroke = Paint()
      ..color = Colors.blueAccent
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    for (final id in controller.selection) {
      final item = controller.doc.itemById(id);
      _draw(canvas, item, sel, fill, stroke);
    }
  }

  void _draw(
      Canvas canvas, CanvasItem item, Paint sel, Paint fill, Paint stroke) {
    final pts = CanvasGeometry.corners(item, scale); // TL, TR, BR, BL
    canvas.drawPath(Path()..addPolygon(pts, true), sel);

    for (var i = 0; i < pts.length; i++) {
      final hovered = controller.hoveredHandle == item.getHandles()[i].key;
      final r = (hovered ? handleSize * 1.5 : handleSize) / 2;
      canvas.drawCircle(pts[i], r, fill);
      canvas.drawCircle(pts[i], r, stroke);
    }

    final rotPos =
        CanvasGeometry.rotateHandle(item, scale, offset: rotHandleOffset);
    final rr = (controller.hoveredHandle == 'rotate'
            ? rotHandleSize * 1.5
            : rotHandleSize) /
        2;
    final topMid = (pts[0] + pts[1]) / 2;
    canvas.drawCircle(rotPos, rr, fill);
    canvas.drawCircle(rotPos, rr, stroke);
    canvas.drawLine(topMid, rotPos, stroke);
  }

  @override
  bool shouldRepaint(covariant _SelectionPainter old) => true;
}
