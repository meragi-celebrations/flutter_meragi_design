import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_meragi_design/src/components/canva/items/base.dart';
import 'package:flutter_meragi_design/src/components/canva/scaling.dart';

class CanvasItemWidget extends StatefulWidget {
  const CanvasItemWidget({
    super.key,
    required this.item,
    required this.canvasSize,
    required this.isSelected,
    required this.onPanMove,
    required this.onResizeCommit,
    required this.onPanStart,
    required this.onPanEnd,
    required this.onResizeStart,
    required this.onResizeEnd,
    required this.scale,
  });

  final CanvasItem item;
  final Size canvasSize;
  final bool isSelected;
  final void Function(Offset delta) onPanMove; // move ALL selected
  final void Function(CanvasItem updated) onResizeCommit; // resize / edits
  final VoidCallback onPanStart;
  final VoidCallback onPanEnd;
  final VoidCallback onResizeStart;
  final VoidCallback onResizeEnd;
  final CanvasScaleHandler scale;

  @override
  State<CanvasItemWidget> createState() => _CanvasItemWidgetState();
}

class _CanvasItemWidgetState extends State<CanvasItemWidget> {
  static const double _handleSize = 8;
  static const double _minSize = 40;

  // Rotate handle inside the top edge
  static const double _rotHandleSize = 16.0;
  static const double _rotHandlePad = 2.0;

  late CanvasItem _item;

  // rotation gesture state
  late double _rotStartDeg; // model degrees at gesture start
  late double _rotStartAngleRad; // pointer angle at gesture start (radians)

  // local box key to convert global -> local for angle math
  final GlobalKey _boxKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _item = widget.item.cloneWith(); // defensive local copy
  }

  @override
  void didUpdateWidget(covariant CanvasItemWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    _item = widget.item.cloneWith();
  }

  double get _radians => _item.rotationDeg * math.pi / 180.0;

  // ---------- Resize ----------
  void _resizeFromHandle(Offset renderDelta, Handle handle) {
    if (_item.locked) return;

    // As the widget is rotated, the drag delta is in the coordinate system of the
    // screen, not the rotated widget. We need to convert the delta to the local
    // coordinate system of the widget.
    final angle = -_radians;
    final cosA = math.cos(angle);
    final sinA = math.sin(angle);
    final dx = renderDelta.dx * cosA - renderDelta.dy * sinA;
    final dy = renderDelta.dx * sinA + renderDelta.dy * cosA;

    final delta = widget.scale.renderDeltaToBase(Offset(dx, dy));
    final updated = _item.resizeWithHandle(handle.key, delta, widget.scale);

    setState(() {
      _item = updated;
    });
    widget.onResizeCommit(_item);
  }

  // ---------- Rotation math ----------
  Offset _globalToLocal(Offset global) {
    final rb = _boxKey.currentContext?.findRenderObject() as RenderBox?;
    if (rb == null) return global;
    return rb.globalToLocal(global);
  }

  double _angleAtLocal(Offset local) {
    final sizeRender = widget.scale.baseToRenderSize(_item.size);
    final cx = sizeRender.width / 2;
    final cy = sizeRender.height / 2;
    final dx = local.dx - cx;
    final dy = local.dy - cy;
    return math.atan2(dy, dx);
  }

  void _onRotateStart(DragStartDetails d) {
    if (_item.locked) return;
    widget.onResizeStart();
    _rotStartDeg = _item.rotationDeg;
    final local = _globalToLocal(d.globalPosition);
    _rotStartAngleRad = _angleAtLocal(local);
  }

  void _onRotateUpdate(DragUpdateDetails d) {
    if (_item.locked) return;
    final local = _globalToLocal(d.globalPosition);
    final angle = _angleAtLocal(local);
    final deltaRad = angle - _rotStartAngleRad;
    final deltaDeg = deltaRad * 180.0 / math.pi;

    setState(() {
      _item.rotationDeg = (_rotStartDeg + deltaDeg) % 360.0;
      if (_item.rotationDeg < 0) _item.rotationDeg += 360.0;
    });
    widget.onResizeCommit(_item);
  }

  void _onRotateEnd(DragEndDetails _) {
    widget.onResizeEnd();
  }

  Widget _rotationHandle() {
    // small circular handle at top center, inside bounds
    return Positioned(
      top: _rotHandlePad,
      left: (widget.scale.baseToRenderSize(_item.size).width - _rotHandleSize) /
          2,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onPanStart: _onRotateStart,
        onPanUpdate: _onRotateUpdate,
        onPanEnd: _onRotateEnd,
        child: Container(
          width: _rotHandleSize,
          height: _rotHandleSize,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.blueAccent, width: 1),
            boxShadow: const [BoxShadow(blurRadius: 2, color: Colors.black26)],
          ),
          child: const Icon(Icons.rotate_right,
              size: 12, color: Colors.blueAccent),
        ),
      ),
    );
  }

  // ---------- Double tap -> item-specific edit ----------
  Future<void> _handleDoubleTap() async {
    final updated = await _item.handleDoubleTap(context);
    if (updated != null) {
      setState(() => _item = updated.cloneWith());
      widget.onResizeCommit(updated);
    }
  }

  @override
  Widget build(BuildContext context) {
    final posRender = widget.scale.baseToRender(_item.position);
    final sizeRender = widget.scale.baseToRenderSize(_item.size);

    return Positioned(
      left: posRender.dx,
      top: posRender.dy,
      width: sizeRender.width,
      height: sizeRender.height,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onPanStart: (_) => widget.onPanStart(),
        onPanUpdate: (d) {
          if (!widget.isSelected || _item.locked) return;
          widget.onPanMove(widget.scale.renderDeltaToBase(d.delta));
        },
        onPanEnd: (_) => widget.onPanEnd(),
        onDoubleTap: _handleDoubleTap,
        child: Transform.rotate(
          angle: _radians,
          alignment: Alignment.center,
          child: Stack(
            key: _boxKey,
            clipBehavior: Clip.none, // allow rotated content to overflow
            children: [
              // selection border & content
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    border: widget.isSelected
                        ? Border.all(color: Colors.blueAccent, width: 1)
                        : null,
                    color: Colors.transparent,
                  ),
                  child: Center(
                    child: SizedBox.expand(
                      child: _item.buildContent(widget.scale),
                    ),
                  ),
                ),
              ),

              // resize handles
              if (widget.isSelected && !_item.locked) ...[
                for (final handle in _item.getHandles()) _handle(handle),
                _rotationHandle(),
              ],

              if (_item.locked)
                Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    margin: const EdgeInsets.all(2),
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child:
                        const Icon(Icons.lock, size: 12, color: Colors.white),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _handle(Handle handle) => Align(
        alignment: handle.alignment,
        child: MouseRegion(
          cursor: handle.cursor,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onPanStart: (_) => widget.onResizeStart(),
            onPanUpdate: (d) => _resizeFromHandle(d.delta, handle),
            onPanEnd: (_) => widget.onResizeEnd(),
            child: Container(
              width: _handleSize,
              height: _handleSize,
              margin: const EdgeInsets.all(1.5),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.blueAccent, width: 1),
                boxShadow: const [
                  BoxShadow(blurRadius: 2, color: Colors.black26)
                ],
              ),
            ),
          ),
        ),
      );
}
