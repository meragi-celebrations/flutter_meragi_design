import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_meragi_design/src/components/canva/canva_item.dart';
import 'package:flutter_meragi_design/src/components/canva/canvas_doc.dart';
import 'package:flutter_meragi_design/src/components/canva/canvas_scope.dart';
import 'package:flutter_meragi_design/src/components/canva/color_extractor.dart';
import 'package:flutter_meragi_design/src/components/canva/items/image.dart';
import 'package:flutter_meragi_design/src/components/canva/palette_sidebar.dart';
import 'package:flutter_meragi_design/src/components/canva/scaling.dart';
import 'package:flutter_meragi_design/src/components/canva/ui/grid_painter.dart';
import 'package:flutter_meragi_design/src/components/canva/utils.dart';
import 'package:flutter_meragi_design/src/components/canva/workspace_action_bar.dart';

class _Guideline {
  const _Guideline({
    required this.axis,
    required this.start,
    required this.end,
  });
  final Axis axis;
  final Offset start;
  final Offset end;
}

class CanvasWorkspace extends StatefulWidget {
  const CanvasWorkspace({
    super.key,
    required this.doc,
    required this.workspaceColor,
    required this.repaintKey,
    required this.canvasBoxKey,
    required this.toLocal,
  });

  final CanvasDoc doc;
  final Color workspaceColor;
  final GlobalKey repaintKey;
  final GlobalKey canvasBoxKey;
  final Offset Function(Offset) toLocal;

  @override
  State<CanvasWorkspace> createState() => _CanvasWorkspaceState();
}

class _CanvasWorkspaceState extends State<CanvasWorkspace> {
  CanvasScaleHandler? _scale;
  Rect? _selectionRect;
  Offset? _dragSelectionStart;

  final List<_Guideline> _guidelines = [];
  Offset _snapOffset = Offset.zero;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Stack(
        children: [
          // The canvas area
          Positioned.fill(
            child: Container(
              color: widget.workspaceColor,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      // reactive doc read
                      final doc = CanvasScope.of(context);

                      final maxW = constraints.maxWidth;
                      final maxH = constraints.maxHeight;
                      final targetAspect =
                          doc.baseSize.width / doc.baseSize.height;
                      double w = maxW;
                      double h = w / targetAspect;
                      if (h > maxH) {
                        h = maxH;
                        w = h * targetAspect;
                      }

                      _scale = CanvasScaleHandler(
                        baseSize: doc.baseSize,
                        renderSize: Size(w, h),
                      );

                      final canvasSize = Size(w, h);

                      return SizedBox(
                        width: w,
                        height: h,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: const [
                              BoxShadow(
                                blurRadius: 5,
                                color: Color(0x33000000),
                                offset: Offset(0, 5),
                              )
                            ],
                          ),
                          child: Stack(
                            children: [
                              // Visual canvas
                              Positioned.fill(
                                child: RepaintBoundary(
                                  key: widget.repaintKey,
                                  child: Container(
                                    key: widget.canvasBoxKey,
                                    decoration: BoxDecoration(
                                      color: doc.canvasColor,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(color: Colors.black12),
                                    ),
                                    clipBehavior: Clip.antiAlias,
                                    child: Stack(
                                      children: [
                                        if (doc.gridVisible && _scale != null)
                                          Positioned.fill(
                                            child: CustomPaint(
                                              painter: GridPainter(
                                                spacingBase: doc.gridSpacing,
                                                scale: _scale!,
                                                color: Colors.black
                                                    .withOpacity(0.06),
                                                boldEvery: 5,
                                              ),
                                            ),
                                          ),
                                        // Items
                                        for (final item in doc.items)
                                          CanvasItemWidget(
                                            key: ValueKey(item.id),
                                            item: item,
                                            canvasSize: canvasSize,
                                            isSelected: doc.selectedIds
                                                .contains(item.id),
                                            onPanStart: () {
                                              doc.beginUndoGroup('Drag');
                                              setState(() {
                                                _guidelines.clear();
                                              });
                                            },
                                            onPanMove: (delta) {
                                              final moving =
                                                  doc.selectedIds.isEmpty
                                                      ? <String>{item.id}
                                                      : doc.selectedIds;
                                              _calculateGuidelines(
                                                  doc, moving, delta);
                                              doc.applyPatch([
                                                for (final id in moving)
                                                  {
                                                    'type': 'update',
                                                    'id': id,
                                                    'changes': {
                                                      'position': {
                                                        'x': doc
                                                                .itemById(id)
                                                                .position
                                                                .dx +
                                                            delta.dx +
                                                            _snapOffset.dx,
                                                        'y': doc
                                                                .itemById(id)
                                                                .position
                                                                .dy +
                                                            delta.dy +
                                                            _snapOffset.dy,
                                                      }
                                                    }
                                                  }
                                              ]);
                                            },
                                            onPanEnd: () {
                                              doc.commitUndoGroup();
                                              setState(() {
                                                _guidelines.clear();
                                              });
                                            },
                                            onResizeStart: () =>
                                                doc.beginUndoGroup('Resize'),
                                            onResizeCommit: (updated) {
                                              doc.applyPatch([
                                                {
                                                  'type': 'update',
                                                  'id': updated.id,
                                                  'changes': {
                                                    'position': {
                                                      'x': updated.position.dx,
                                                      'y': updated.position.dy,
                                                    },
                                                    'size': {
                                                      'w': updated.size.width,
                                                      'h': updated.size.height,
                                                    },
                                                    'rotationDeg':
                                                        updated.rotationDeg,
                                                  }
                                                }
                                              ]);
                                            },
                                            onResizeEnd: () =>
                                                doc.commitUndoGroup(),
                                            scale: _scale!,
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),

                              // Guidelines
                              if (_guidelines.isNotEmpty)
                                Positioned.fill(
                                  child: CustomPaint(
                                    painter: _GuidelinePainter(
                                      guidelines: _guidelines,
                                      scale: _scale!,
                                    ),
                                  ),
                                ),

                              // Selection capture
                              Positioned.fill(
                                child: Listener(
                                  behavior: HitTestBehavior.translucent,
                                  onPointerDown: (event) {
                                    final scale = _scale;
                                    if (scale == null) return;

                                    final localRender =
                                        widget.toLocal(event.position);
                                    final localBase =
                                        scale.renderToBase(localRender);

                                    String? hitId;
                                    for (final item in doc.items.reversed) {
                                      final rect = Rect.fromLTWH(
                                        item.position.dx,
                                        item.position.dy,
                                        item.size.width,
                                        item.size.height,
                                      );
                                      if (rect.contains(localBase)) {
                                        hitId = item.id;
                                        break;
                                      }
                                    }

                                    if (hitId == null) {
                                      setState(() {
                                        _dragSelectionStart = localRender;
                                        _selectionRect = Rect.fromLTWH(
                                            localRender.dx,
                                            localRender.dy,
                                            0,
                                            0);
                                      });
                                    }
                                  },
                                  onPointerMove: (event) {
                                    final start = _dragSelectionStart;
                                    if (start == null) return;
                                    final pos = widget.toLocal(event.position);
                                    setState(() {
                                      _selectionRect =
                                          Rect.fromPoints(start, pos);
                                    });
                                  },
                                  onPointerUp: (event) {
                                    final scale = _scale;
                                    final rect = _selectionRect;
                                    final start = _dragSelectionStart;

                                    if (scale != null &&
                                        rect != null &&
                                        start != null) {
                                      final baseRect = Rect.fromPoints(
                                        scale.renderToBase(rect.topLeft),
                                        scale.renderToBase(rect.bottomRight),
                                      );

                                      final selected = <String>{};
                                      for (final item in doc.items) {
                                        final itemRect = Rect.fromLTWH(
                                          item.position.dx,
                                          item.position.dy,
                                          item.size.width,
                                          item.size.height,
                                        );
                                        if (baseRect.overlaps(itemRect)) {
                                          selected.add(item.id);
                                        }
                                      }
                                      doc.applyPatch([
                                        {
                                          'type': 'selection.set',
                                          'ids': selected.toList()
                                        }
                                      ]);
                                    } else {
                                      // no drag, handle tap
                                      final localRender =
                                          widget.toLocal(event.position);
                                      final localBase =
                                          scale!.renderToBase(localRender);

                                      String? hitId;
                                      for (final item in doc.items.reversed) {
                                        final rect = Rect.fromLTWH(
                                          item.position.dx,
                                          item.position.dy,
                                          item.size.width,
                                          item.size.height,
                                        );
                                        if (rect.contains(localBase)) {
                                          hitId = item.id;
                                          break;
                                        }
                                      }

                                      final keys = HardwareKeyboard
                                          .instance.logicalKeysPressed;
                                      final additive = keys.contains(
                                              LogicalKeyboardKey.shiftLeft) ||
                                          keys.contains(
                                              LogicalKeyboardKey.shiftRight) ||
                                          keys.contains(
                                              LogicalKeyboardKey.controlLeft) ||
                                          keys.contains(LogicalKeyboardKey
                                              .controlRight) ||
                                          keys.contains(
                                              LogicalKeyboardKey.metaLeft) ||
                                          keys.contains(
                                              LogicalKeyboardKey.metaRight);

                                      if (hitId == null) {
                                        doc.applyPatch([
                                          {
                                            'type': 'selection.set',
                                            'ids': <String>[]
                                          }
                                        ]);
                                      } else if (additive) {
                                        final ids =
                                            doc.selectedIds.contains(hitId)
                                                ? doc.selectedIds
                                                    .where((e) => e != hitId)
                                                    .toList()
                                                : [...doc.selectedIds, hitId];
                                        doc.applyPatch([
                                          {'type': 'selection.set', 'ids': ids}
                                        ]);
                                      } else {
                                        doc.applyPatch([
                                          {
                                            'type': 'selection.set',
                                            'ids': [hitId]
                                          }
                                        ]);
                                      }
                                    }

                                    setState(() {
                                      _dragSelectionStart = null;
                                      _selectionRect = null;
                                    });
                                  },
                                  child: const SizedBox.expand(),
                                ),
                              ),

                              // DragTarget overlay so drops work even over items
                              Positioned.fill(
                                child: DragTarget<CanvasPaletteImage>(
                                  onWillAccept: (_) => true,
                                  onAcceptWithDetails: (details) async {
                                    final scale = _scale;
                                    if (scale == null) return;

                                    final localRender =
                                        widget.toLocal(details.offset);
                                    final baseDrop =
                                        scale.renderToBase(localRender);

                                    final pal = details.data;
                                    final baseSize = pal.preferredSize ??
                                        const Size(160, 160);

                                    final id = widget.doc.newId();
                                    final itemJson = {
                                      'id': id,
                                      'kind': 'image',
                                      'x': baseDrop.dx - baseSize.width / 2,
                                      'y': baseDrop.dy - baseSize.height / 2,
                                      'w': baseSize.width,
                                      'h': baseSize.height,
                                      'z': 0,
                                      'locked': false,
                                      'rot': 0,
                                      'props': {
                                        'src': pal.srcUri,
                                        'radii': {
                                          'tl': 0,
                                          'tr': 0,
                                          'bl': 0,
                                          'br': 0
                                        },
                                      },
                                    };

                                    final tempItem =
                                        ImageItem.fromJson(itemJson);
                                    final provider = tempItem.resolveProvider();
                                    if (provider == null) {
                                      // Handle case where image provider can't be resolved
                                      widget.doc.beginUndoGroup('Add Image');
                                      widget.doc.applyPatch([
                                        {
                                          'type': 'insert',
                                          'item': itemJson,
                                          'index': null
                                        },
                                        {
                                          'type': 'selection.set',
                                          'ids': [id]
                                        },
                                      ]);
                                      widget.doc.commitUndoGroup();
                                      return;
                                    }
                                    final colors =
                                        await getColorsFromImage(provider);
                                    final colorHexes = colors
                                        .map((c) => colorToHex(c))
                                        .toList();
                                    (itemJson['props'] as Map<String, dynamic>)[
                                        'extractedColors'] = colorHexes;

                                    widget.doc.beginUndoGroup('Add Image');
                                    widget.doc.applyPatch([
                                      {
                                        'type': 'insert',
                                        'item': itemJson,
                                        'index': null
                                      },
                                      {
                                        'type': 'selection.set',
                                        'ids': [id]
                                      },
                                    ]);
                                    widget.doc.commitUndoGroup();
                                  },
                                  builder: (context, _, __) =>
                                      const SizedBox.expand(),
                                ),
                              ),

                              // Selection box
                              if (_selectionRect != null)
                                Positioned.fromRect(
                                  rect: _selectionRect!,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.blueAccent.withOpacity(0.1),
                                      border: Border.all(
                                        color: Colors.blueAccent,
                                        width: 1,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),

          // Workspace action bar overlay
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: SafeArea(
              top: false,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: const WorkspaceActionBar(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _calculateGuidelines(
      CanvasDoc doc, Set<String> movingIds, Offset delta) {
    final newGuidelines = <_Guideline>[];
    _snapOffset = Offset.zero;

    if (_scale == null) return;

    final movingItems = movingIds.map((id) => doc.itemById(id)).toList();
    final staticItems =
        doc.items.where((item) => !movingIds.contains(item.id)).toList();

    if (staticItems.isEmpty) {
      setState(() => _guidelines.clear());
      return;
    }

    Rect movingBounds = movingItems.first.rect;
    for (int i = 1; i < movingItems.length; i++) {
      movingBounds = movingBounds.expandToInclude(movingItems[i].rect);
    }
    movingBounds = movingBounds.translate(delta.dx, delta.dy);

    const snapThreshold = 2.0;

    for (final staticItem in staticItems) {
      final staticBounds = staticItem.rect;

      // Horizontal checks
      final dyLeft = (staticBounds.left - movingBounds.left).abs();
      final dyRight = (staticBounds.right - movingBounds.right).abs();
      final dyCenter = (staticBounds.center.dx - movingBounds.center.dx).abs();

      if (dyLeft < snapThreshold) {
        _snapOffset = Offset(staticBounds.left - movingBounds.left, 0);
        newGuidelines.add(_Guideline(
          axis: Axis.vertical,
          start: Offset(
              staticBounds.left,
              staticBounds.top < movingBounds.top
                  ? staticBounds.top
                  : movingBounds.top),
          end: Offset(
              staticBounds.left,
              staticBounds.bottom > movingBounds.bottom
                  ? staticBounds.bottom
                  : movingBounds.bottom),
        ));
      }
      if (dyRight < snapThreshold) {
        _snapOffset = Offset(staticBounds.right - movingBounds.right, 0);
        newGuidelines.add(_Guideline(
          axis: Axis.vertical,
          start: Offset(
              staticBounds.right,
              staticBounds.top < movingBounds.top
                  ? staticBounds.top
                  : movingBounds.top),
          end: Offset(
              staticBounds.right,
              staticBounds.bottom > movingBounds.bottom
                  ? staticBounds.bottom
                  : movingBounds.bottom),
        ));
      }
      if (dyCenter < snapThreshold) {
        _snapOffset =
            Offset(staticBounds.center.dx - movingBounds.center.dx, 0);
        newGuidelines.add(_Guideline(
          axis: Axis.vertical,
          start: Offset(
              staticBounds.center.dx,
              staticBounds.top < movingBounds.top
                  ? staticBounds.top
                  : movingBounds.top),
          end: Offset(
              staticBounds.center.dx,
              staticBounds.bottom > movingBounds.bottom
                  ? staticBounds.bottom
                  : movingBounds.bottom),
        ));
      }

      // Vertical checks
      final dxTop = (staticBounds.top - movingBounds.top).abs();
      final dxBottom = (staticBounds.bottom - movingBounds.bottom).abs();
      final dxCenter = (staticBounds.center.dy - movingBounds.center.dy).abs();

      if (dxTop < snapThreshold) {
        _snapOffset = Offset(0, staticBounds.top - movingBounds.top);
        newGuidelines.add(_Guideline(
          axis: Axis.horizontal,
          start: Offset(
              staticBounds.left < movingBounds.left
                  ? staticBounds.left
                  : movingBounds.left,
              staticBounds.top),
          end: Offset(
              staticBounds.right > movingBounds.right
                  ? staticBounds.right
                  : movingBounds.right,
              staticBounds.top),
        ));
      }
      if (dxBottom < snapThreshold) {
        _snapOffset = Offset(0, staticBounds.bottom - movingBounds.bottom);
        newGuidelines.add(_Guideline(
          axis: Axis.horizontal,
          start: Offset(
              staticBounds.left < movingBounds.left
                  ? staticBounds.left
                  : movingBounds.left,
              staticBounds.bottom),
          end: Offset(
              staticBounds.right > movingBounds.right
                  ? staticBounds.right
                  : movingBounds.right,
              staticBounds.bottom),
        ));
      }
      if (dxCenter < snapThreshold) {
        _snapOffset =
            Offset(0, staticBounds.center.dy - movingBounds.center.dy);
        newGuidelines.add(_Guideline(
          axis: Axis.horizontal,
          start: Offset(
              staticBounds.left < movingBounds.left
                  ? staticBounds.left
                  : movingBounds.left,
              staticBounds.center.dy),
          end: Offset(
              staticBounds.right > movingBounds.right
                  ? staticBounds.right
                  : movingBounds.right,
              staticBounds.center.dy),
        ));
      }
    }

    setState(() {
      _guidelines
        ..clear()
        ..addAll(newGuidelines);
    });
  }
}

class _GuidelinePainter extends CustomPainter {
  _GuidelinePainter({required this.guidelines, required this.scale});

  final List<_Guideline> guidelines;
  final CanvasScaleHandler scale;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.red
      ..strokeWidth = 1;

    for (final g in guidelines) {
      final p1 = scale.baseToRender(g.start);
      final p2 = scale.baseToRender(g.end);
      canvas.drawLine(p1, p2, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _GuidelinePainter oldDelegate) => true;
}
