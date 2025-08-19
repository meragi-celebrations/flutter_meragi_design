import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_meragi_design/flutter_meragi_design.dart';
import 'package:flutter_meragi_design/src/components/canva/canva_item.dart';
import 'package:flutter_meragi_design/src/components/canva/canvas_controller.dart';
import 'package:flutter_meragi_design/src/components/canva/canvas_doc.dart';
import 'package:flutter_meragi_design/src/components/canva/canvas_scope.dart';
import 'package:flutter_meragi_design/src/components/canva/color_extractor.dart';
import 'package:flutter_meragi_design/src/components/canva/geometry.dart';
import 'package:flutter_meragi_design/src/components/canva/items/image.dart';
import 'package:flutter_meragi_design/src/components/canva/scaling.dart';
import 'package:flutter_meragi_design/src/components/canva/ui/grid_painter.dart';
import 'package:flutter_meragi_design/src/components/canva/utils.dart';
import 'package:flutter_meragi_design/src/components/canva/widgets/canvas_overlay.dart';
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
  late final CanvasController _controller;
  CanvasScaleHandler? _scale;
  Rect? _selectionRect;
  Offset? _dragSelectionStart;

  final List<_Guideline> _guidelines = [];
  Offset _snapOffset = Offset.zero;

  @override
  void initState() {
    super.initState();
    _controller =
        CanvasController(doc: widget.doc, scale: CanvasScaleHandler.initial());
  }

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

                      // compute canvas size
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

                      // update controller scale and reuse the SAME instance everywhere
                      _controller.setScale(_controller.scale.copyWith(
                        baseSize: doc.baseSize,
                        renderSize: Size(w, h),
                      ));
                      final scale = _controller.scale; // single source of truth
                      _scale = scale; // keep your local ref if you need it

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
                                            scale: _scale!,
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              if (_scale != null)
                                Positioned.fill(
                                  child: CanvasOverlay(
                                    controller: _controller,
                                    scale: _scale!,
                                    onMarqueeRect: (r) {
                                      setState(() => _selectionRect = r);
                                    },
                                    onComputeSnap:
                                        (movingIds, cumulativeBaseDelta) {
                                      return _calculateGuidelines(widget.doc,
                                          movingIds, cumulativeBaseDelta);
                                    },
                                    onClearGuidelines: () {
                                      setState(() => _guidelines.clear());
                                    },
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

  Rect _rotatedAabb(CanvasItem item) {
    final sc = _scale!;
    final ptsR =
        CanvasGeometry.corners(item, sc); // render-space corners TL,TR,BR,BL
    double minX = double.infinity, minY = double.infinity;
    double maxX = -double.infinity, maxY = -double.infinity;

    for (final pR in ptsR) {
      final pB = sc.renderToBase(pR); // back to base space
      if (pB.dx < minX) minX = pB.dx;
      if (pB.dy < minY) minY = pB.dy;
      if (pB.dx > maxX) maxX = pB.dx;
      if (pB.dy > maxY) maxY = pB.dy;
    }
    return Rect.fromLTRB(minX, minY, maxX, maxY);
  }

  Offset _calculateGuidelines(
      CanvasDoc doc, Set<String> movingIds, Offset delta) {
    final sc = _scale;
    if (sc == null) {
      setState(() => _guidelines.clear());
      return Offset.zero;
    }

    // Tune threshold in BASE units. Slightly larger is friendlier.
    const snapThreshold = 4.0;

    // Split moving vs static
    final movingItems = movingIds.map(doc.itemById).toList();
    final staticItems =
        doc.items.where((it) => !movingIds.contains(it.id)).toList();

    if (movingItems.isEmpty || staticItems.isEmpty) {
      setState(() => _guidelines.clear());
      return Offset.zero;
    }

    // Union of rotated AABBs for the moving selection, then apply cumulative base delta
    Rect movingBounds = _rotatedAabb(movingItems.first);
    for (int i = 1; i < movingItems.length; i++) {
      movingBounds = movingBounds.expandToInclude(_rotatedAabb(movingItems[i]));
    }
    movingBounds = movingBounds.translate(delta.dx, delta.dy);

    // Prepare candidates: canvas centers also act like a "static item"
    final List<Rect> staticBoundsList = [
      for (final it in staticItems) _rotatedAabb(it),
    ];

    final canvasCenter = doc.baseSize.center(Offset.zero);
    // Represent the canvas centers as degenerate rects to reuse the same code path
    staticBoundsList.add(Rect.fromLTWH(
        canvasCenter.dx, 0, 0, doc.baseSize.height)); // vertical center line
    staticBoundsList.add(Rect.fromLTWH(
        0, canvasCenter.dy, doc.baseSize.width, 0)); // horizontal center line

    // Track best X and Y snaps
    double? bestDx; // how much to move in X
    _Guideline? bestXGuide;

    double? bestDy; // how much to move in Y
    _Guideline? bestYGuide;

    // Helpers
    void considerX(double targetX, double movingX, Rect a, Rect b) {
      final diff = targetX - movingX;
      if (diff.abs() <= snapThreshold &&
          (bestDx == null || diff.abs() < bestDx!.abs())) {
        bestDx = diff;
        final top = math.min(a.top, b.top);
        final bottom = math.max(a.bottom, b.bottom);
        bestXGuide = _Guideline(
          axis: Axis.vertical,
          start: Offset(targetX, top),
          end: Offset(targetX, bottom),
        );
      }
    }

    void considerY(double targetY, double movingY, Rect a, Rect b) {
      final diff = targetY - movingY;
      if (diff.abs() <= snapThreshold &&
          (bestDy == null || diff.abs() < bestDy!.abs())) {
        bestDy = diff;
        final left = math.min(a.left, b.left);
        final right = math.max(a.right, b.right);
        bestYGuide = _Guideline(
          axis: Axis.horizontal,
          start: Offset(left, targetY),
          end: Offset(right, targetY),
        );
      }
    }

    // Moving features (edges and centers)
    final mxL = movingBounds.left;
    final mxC = movingBounds.center.dx;
    final mxR = movingBounds.right;

    final myT = movingBounds.top;
    final myC = movingBounds.center.dy;
    final myB = movingBounds.bottom;

    for (final sb in staticBoundsList) {
      // If this is one of the synthetic "canvas center" rects, its other axis span is already correct.

      // Vertical lines (x-alignment): left / center / right
      considerX(sb.left, mxL, sb, movingBounds);
      considerX(sb.center.dx, mxC, sb, movingBounds);
      considerX(sb.right, mxR, sb, movingBounds);

      // Horizontal lines (y-alignment): top / center / bottom
      considerY(sb.top, myT, sb, movingBounds);
      considerY(sb.center.dy, myC, sb, movingBounds);
      considerY(sb.bottom, myB, sb, movingBounds);
    }

    // Apply results
    final newGuides = <_Guideline>[];
    if (bestXGuide != null) newGuides.add(bestXGuide!);
    if (bestYGuide != null) newGuides.add(bestYGuide!);

    setState(() {
      _guidelines
        ..clear()
        ..addAll(newGuides);
    });

    return Offset(bestDx ?? 0, bestDy ?? 0);
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
