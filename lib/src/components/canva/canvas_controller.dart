import 'dart:math' as math;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_meragi_design/src/components/canva/canvas_doc.dart';
import 'package:flutter_meragi_design/src/components/canva/geometry.dart';
import 'package:flutter_meragi_design/src/components/canva/items/base.dart';
import 'package:flutter_meragi_design/src/components/canva/scaling.dart';

enum _DragMode { idle, drag, resize, rotate }

class CanvasController extends ChangeNotifier {
  CanvasController({required this.doc, required CanvasScaleHandler scale})
      : scale = scale;

  final CanvasDoc doc;
  CanvasScaleHandler scale;

  void setScale(CanvasScaleHandler next) {
    scale = next;
  }

  bool get isTransforming => _dragMode != _DragMode.idle;

  // This will manage the set of selected item IDs.
  Set<String> get selection => doc.selectedIds;

  // Interaction state
  _DragMode _dragMode = _DragMode.idle;
  String? _draggedItemId;
  String? _draggedHandle;
  String? hoveredHandle;
  String? hoveredHandleItemId;

  void onPointerHover(PointerHoverEvent event) {
    final local = event.localPosition;

    String? key;
    String? itemId;

    // Only check currently selected items
    for (final id in selection) {
      final item = doc.itemById(id);
      final k = _hitTestHandles(item, local);
      if (k != null) {
        key = k;
        itemId = id;
        break;
      }
    }

    if (key != hoveredHandle || itemId != hoveredHandleItemId) {
      hoveredHandle = key;
      hoveredHandleItemId = itemId;
      notifyListeners();
    }
  }

  void clearHover() {
    if (hoveredHandle != null || hoveredHandleItemId != null) {
      hoveredHandle = null;
      hoveredHandleItemId = null;
      notifyListeners();
    }
  }

  void onDown(Offset localPosition, {bool multiSelect = false}) {
    // 1) handles on already-selected items
    for (final id in selection) {
      final item = doc.itemById(id);
      final handleHit = _hitTestHandles(item, localPosition);
      if (handleHit != null) {
        _dragMode = handleHit == 'rotate' ? _DragMode.rotate : _DragMode.resize;
        _draggedItemId = id;
        _draggedHandle = handleHit;
        doc.beginUndoGroup('Transform');
        notifyListeners();
        return;
      }
    }

    // 2) hit test items (top-most first)
    String? hitId;
    for (final item in doc.items.reversed) {
      if (_hitTestItem(item, localPosition)) {
        hitId = item.id;
        break;
      }
    }

    // click on empty space
    if (hitId == null) {
      if (!multiSelect) {
        doc.applyPatch([
          {'type': 'selection.set', 'ids': []}
        ]);
      }
      _dragMode = _DragMode.idle;
      _draggedItemId = null;
      notifyListeners();
      return;
    }

    // multi-select toggle
    if (multiSelect) {
      if (selection.contains(hitId)) {
        doc.applyPatch([
          {
            'type': 'selection.remove',
            'ids': [hitId]
          }
        ]);
      } else {
        doc.applyPatch([
          {
            'type': 'selection.add',
            'ids': [hitId]
          }
        ]);
      }
      _dragMode = _DragMode.idle; // no drag on toggle
      _draggedItemId = null;
      notifyListeners();
      return;
    }

    // single-click on an item
    doc.beginUndoGroup('Drag');
    if (!selection.contains(hitId)) {
      // select only the clicked item
      doc.applyPatch([
        {
          'type': 'selection.set',
          'ids': [hitId]
        }
      ]);
    }
    // if it was already selected (possibly many selected), keep selection as-is
    _draggedItemId = hitId;
    _dragMode = _DragMode.drag; // drag the whole selection
    notifyListeners();
  }

  void onMove(Offset localPosition, Offset deltaRenderSpace) {
    if (_dragMode == _DragMode.idle) return;

    final delta = scale.renderDeltaToBase(deltaRenderSpace);

    switch (_dragMode) {
      case _DragMode.drag:
        if (selection.isEmpty) return;
        final ops = <Map<String, dynamic>>[];
        for (final id in selection) {
          final it = doc.itemById(id);
          ops.add({
            'type': 'update',
            'id': id,
            'changes': {
              'position': {
                'x': it.position.dx + delta.dx,
                'y': it.position.dy + delta.dy,
              }
            }
          });
        }
        doc.applyPatch(ops);
        break;

      case _DragMode.resize:
        {
          final item = doc.itemById(_draggedItemId!);
          final updated = item.resizeWithHandle(_draggedHandle!, delta, scale);
          doc.applyPatch([
            {'type': 'replace', 'item': updated.toJson(0)}
          ]);
          break;
        }

      case _DragMode.rotate:
        {
          final item = doc.itemById(_draggedItemId!);
          final center = scale.baseToRender(item.rect.center);
          final angle = math.atan2(
              localPosition.dy - center.dy, localPosition.dx - center.dx);
          final deg = angle * 180 / math.pi + 90;
          doc.applyPatch([
            {
              'type': 'update',
              'id': _draggedItemId,
              'changes': {'rotationDeg': deg}
            }
          ]);
          break;
        }

      case _DragMode.idle:
        break;
    }
  }

  void onUp(Offset _) {
    if (_dragMode != _DragMode.idle) {
      doc.commitUndoGroup();
    }
    _draggedItemId = null;
    _draggedHandle = null;
    _dragMode = _DragMode.idle;
  }

  String? topItemAt(Offset localPosition) {
    for (final item in doc.items.reversed) {
      if (_hitTestItem(item, localPosition)) return item.id;
    }
    return null;
  }

  bool isOverAnySelectedHandle(Offset localPosition) {
    for (final id in selection) {
      final item = doc.itemById(id);
      if (_hitTestHandles(item, localPosition) != null) return true;
    }
    return false;
  }

  bool _hitTestItem(CanvasItem item, Offset localPosition) {
    return CanvasGeometry.hitItem(item, scale, localPosition);
  }

  String? _hitTestHandles(CanvasItem item, Offset localPosition) {
    // Match painter sizes
    const cornerW = 12.0, cornerH = 12.0;
    const edgeW = 18.0, edgeH = 8.0;

    bool hitRotatedRect(
        Offset center, double angle, double w, double h, Offset p) {
      // rotate point into rect-local space
      final d = p - center;
      final ca = math.cos(-angle), sa = math.sin(-angle);
      final lx = d.dx * ca - d.dy * sa;
      final ly = d.dx * sa + d.dy * ca;
      return lx.abs() <= w / 2 && ly.abs() <= h / 2;
    }

    for (final h in item.getHandles()) {
      final p = CanvasGeometry.handlePosition(item, scale, h.alignment);
      final isEdge = h.key == 'top' ||
          h.key == 'right' ||
          h.key == 'bottom' ||
          h.key == 'left';

      if (isEdge) {
        final ang = CanvasGeometry.edgeAngleForKey(item, scale, h.key);
        if (hitRotatedRect(p, ang, edgeW, edgeH, localPosition)) return h.key;
      } else {
        final r = Rect.fromCenter(center: p, width: cornerW, height: cornerH);
        if (r.contains(localPosition)) return h.key;
      }
    }

    // rotation handle
    const rotHandleRadius = 16.0 / 2;
    final rotPos = CanvasGeometry.rotateHandle(item, scale);
    if ((localPosition - rotPos).distanceSquared <
        rotHandleRadius * rotHandleRadius) {
      return 'rotate';
    }
    return null;
  }
}
