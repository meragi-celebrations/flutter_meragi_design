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

  void onPointerHover(PointerHoverEvent event) {
    final localPosition = event.localPosition;
    String? handleHit;
    for (final id in selection) {
      final item = doc.itemById(id);
      handleHit = _hitTestHandles(item, localPosition);
      if (handleHit != null) {
        break;
      }
    }
    if (handleHit != hoveredHandle) {
      hoveredHandle = handleHit;
      notifyListeners();
    }
  }

  void onDown(Offset localPosition, {bool multiSelect = false}) {
    for (final id in selection) {
      final item = doc.itemById(id);
      final handleHit = _hitTestHandles(item, localPosition);
      if (handleHit != null) {
        // make sure the item whose handle you grabbed is selected
        if (!selection.contains(id)) {
          doc.applyPatch([
            {
              'type': 'selection.add',
              'ids': [id]
            }
          ]);
        }
        _dragMode = handleHit == 'rotate' ? _DragMode.rotate : _DragMode.resize;
        _draggedItemId = id;
        _draggedHandle = handleHit;
        doc.beginUndoGroup('Transform');
        notifyListeners();
        return;
      }
    }

    String? hitId;
    for (final item in doc.items.reversed) {
      if (_hitTestItem(item, localPosition)) {
        hitId = item.id;
        break;
      }
    }

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

    if (multiSelect) {
      if (selection.contains(hitId)) {
        // toggle off
        doc.applyPatch([
          {
            'type': 'selection.remove',
            'ids': [hitId]
          }
        ]);
        // do not start drag on a toggle off
        _dragMode = _DragMode.idle;
        _draggedItemId = null;
        notifyListeners();
        return;
      } else {
        // add to selection; no drag in same gesture
        doc.applyPatch([
          {
            'type': 'selection.add',
            'ids': [hitId]
          }
        ]);
        _dragMode = _DragMode.idle;
        _draggedItemId = null;
        notifyListeners();
        return;
      }
    } else {
      // single select and start drag
      doc.beginUndoGroup('Drag');
      doc.applyPatch([
        {
          'type': 'selection.set',
          'ids': [hitId]
        }
      ]);
      _draggedItemId = hitId;
      _dragMode = _DragMode.drag;
      notifyListeners();
    }
  }

  void onMove(Offset localPosition, Offset deltaRenderSpace) {
    if (_dragMode == _DragMode.idle) return;
    if (_draggedItemId == null && _dragMode != _DragMode.rotate) return;

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
          // rotation only for the active item
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

  bool _hitTestItem(CanvasItem item, Offset localPosition) {
    return CanvasGeometry.hitItem(item, scale, localPosition);
  }

  String? _hitTestHandles(CanvasItem item, Offset localPosition) {
    final pts = CanvasGeometry.corners(item, scale);
    const handleRadius = 12.0;

    for (int i = 0; i < pts.length; i++) {
      if ((localPosition - pts[i]).distanceSquared <
          handleRadius * handleRadius) {
        // make sure handle order matches: [TL, TR, BR, BL]
        return item.getHandles()[i].key;
      }
    }

    final rotPos = CanvasGeometry.rotateHandle(item, scale);
    if ((localPosition - rotPos).distanceSquared <
        handleRadius * handleRadius) {
      return 'rotate';
    }
    return null;
  }
}
