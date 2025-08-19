import 'dart:math' as math;

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
    required this.onMarqueeRect,
    required this.onComputeSnap,
    required this.onClearGuidelines,
  });

  final CanvasController controller;
  final CanvasScaleHandler scale;

  /// Render-space rect for the workspace to draw the selection box. Pass null to clear.
  final ValueChanged<Rect?> onMarqueeRect;

  final Offset Function(Set<String> movingIds, Offset cumulativeBaseDelta)
      onComputeSnap;
  final VoidCallback onClearGuidelines;

  @override
  State<CanvasOverlay> createState() => _CanvasOverlayState();
}

class _CanvasOverlayState extends State<CanvasOverlay> {
  final _focusNode = FocusNode();
  bool _multiPressed = false;

  // marquee state
  bool _marqueeActive = false;
  Offset? _marqueeStart; // render-space
  Offset? _lastLocal;

  bool _dragActive = false;
  Set<String> _dragIds = const {};
  Offset _cumBase = Offset.zero; // cumulative base delta since drag start
  Offset _snapBasePrev = Offset.zero; // previous snap we applied

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onChanged);
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

  void _onChanged() => setState(() {});

  Rect _normRect(Offset a, Offset b) {
    final left = math.min(a.dx, b.dx);
    final top = math.min(a.dy, b.dy);
    final right = math.max(a.dx, b.dx);
    final bottom = math.max(a.dy, b.dy);
    return Rect.fromLTRB(left, top, right, bottom);
  }

  KeyEventResult _onKey(FocusNode node, KeyEvent e) {
    final isDown = e is KeyDownEvent;
    final k = e.logicalKey;
    final isCtrl = k == LogicalKeyboardKey.controlLeft ||
        k == LogicalKeyboardKey.controlRight;
    final isMeta =
        k == LogicalKeyboardKey.metaLeft || k == LogicalKeyboardKey.metaRight;
    if (isCtrl || isMeta) {
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

          final overHandle =
              widget.controller.isOverAnySelectedHandle(d.localPosition);
          final overItem = widget.controller.topItemAt(d.localPosition) != null;

          // Marquee if empty
          if (!overHandle && !overItem) {
            _startMarquee(d.localPosition);
            return;
          }

          // Normal
          widget.controller.onDown(d.localPosition, multiSelect: _multiPressed);

          // Start a selection drag if not multi-toggle and not handle
          if (!overHandle && !_multiPressed && overItem) {
            _dragActive = true;
            _dragIds = widget.controller.selection; // move all selected
            _cumBase = Offset.zero;
            _snapBasePrev = Offset.zero;

            // initial guideline compute with zero delta
            widget.onComputeSnap(_dragIds, _cumBase);
          } else {
            _dragActive = false;
          }
        },
        onPanUpdate: (d) {
          _lastLocal = d.localPosition;

          if (_marqueeActive) {
            widget.onMarqueeRect(_normRect(_marqueeStart!, d.localPosition));
            return;
          }

          if (_dragActive) {
            // accumulate base delta since drag start
            final baseFrame = widget.scale.renderDeltaToBase(d.delta);
            _cumBase += baseFrame;

            // ask workspace for snap at this cumulative delta
            final snapBase = widget.onComputeSnap(_dragIds, _cumBase);

            // compute only the delta change in snap for THIS frame
            final snapDeltaBase = snapBase - _snapBasePrev;
            _snapBasePrev = snapBase;

            // convert snap delta to render-space to adjust this frame’s delta
            final snapDeltaRender = Offset(
              snapDeltaBase.dx * widget.scale.sx,
              snapDeltaBase.dy * widget.scale.sy,
            );

            final correctedDeltaRender = d.delta + snapDeltaRender;

            // feed corrected per-frame delta to controller
            widget.controller.onMove(d.localPosition, correctedDeltaRender);
            return;
          }

          // resize/rotate or simple move without snap
          widget.controller.onMove(d.localPosition, d.delta);
        },
        onPanEnd: (_) {
          if (_marqueeActive) {
            _finishMarquee();
            return;
          }
          if (_dragActive) {
            widget.controller.onUp(_lastLocal ?? Offset.zero);
            widget.onClearGuidelines();
            _dragActive = false;
            _dragIds = const {};
            _cumBase = Offset.zero;
            _snapBasePrev = Offset.zero;
            return;
          }
          widget.controller.onUp(_lastLocal ?? Offset.zero);
        },
        onPanCancel: () {
          if (_marqueeActive) {
            _cancelMarquee();
            return;
          }
          if (_dragActive) {
            widget.controller.onUp(_lastLocal ?? Offset.zero);
            widget.onClearGuidelines();
            _dragActive = false;
            _dragIds = const {};
            _cumBase = Offset.zero;
            _snapBasePrev = Offset.zero;
            return;
          }
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

  // helper to start marquee
  void _startMarquee(Offset p) {
    _marqueeActive = true;
    _marqueeStart = p;
    widget.onMarqueeRect(Rect.fromLTWH(p.dx, p.dy, 0, 0));
  }

  void _finishMarquee() {
    final end = _lastLocal ?? _marqueeStart!;
    final rectRender = _normRect(_marqueeStart!, end);

    final ids = <String>[];
    for (final it in widget.controller.doc.items) {
      if (CanvasGeometry.rectIntersectsItem(rectRender, it, widget.scale)) {
        ids.add(it.id); // select on ANY overlap
      }
    }

    widget.controller.doc.beginUndoGroup('Select');
    if (_multiPressed) {
      final merged = {...widget.controller.selection, ...ids}.toList();
      widget.controller.doc.applyPatch([
        {'type': 'selection.set', 'ids': merged},
      ]);
    } else {
      widget.controller.doc.applyPatch([
        {'type': 'selection.set', 'ids': ids},
      ]);
    }
    widget.controller.doc.commitUndoGroup();

    _marqueeActive = false;
    _marqueeStart = null;
    widget.onMarqueeRect(null);
  }

  void _cancelMarquee() {
    _marqueeActive = false;
    _marqueeStart = null;
    widget.onMarqueeRect(null);
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
      final handleKey = item.getHandles()[i].key;
      final hovered = controller.hoveredHandleItemId == item.id &&
          controller.hoveredHandle == handleKey;
      final r = (hovered ? handleSize * 1.5 : handleSize) / 2;
      canvas.drawCircle(pts[i], r, fill);
      canvas.drawCircle(pts[i], r, stroke);
    }

    final rotHovered = controller.hoveredHandleItemId == item.id &&
        controller.hoveredHandle == 'rotate';
    final rr = (rotHovered ? rotHandleSize * 1.5 : rotHandleSize) / 2;

    final rotPos =
        CanvasGeometry.rotateHandle(item, scale, offset: rotHandleOffset);

    final topMid = (pts[0] + pts[1]) / 2;
    canvas.drawCircle(rotPos, rr, fill);
    canvas.drawCircle(rotPos, rr, stroke);
    canvas.drawLine(topMid, rotPos, stroke);
  }

  @override
  bool shouldRepaint(covariant _SelectionPainter old) => true;
}
