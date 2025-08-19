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
                                        'paletteId': pal.id,
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
    final ptsR = CanvasGeometry.corners(item, sc);
    double minX = double.infinity, minY = double.infinity;
    double maxX = -double.infinity, maxY = -double.infinity;
    for (final pR in ptsR) {
      final pB = sc.renderToBase(pR);
      if (pB.dx < minX) minX = pB.dx;
      if (pB.dy < minY) minY = pB.dy;
      if (pB.dx > maxX) maxX = pB.dx;
      if (pB.dy > maxY) maxY = pB.dy;
    }
    return Rect.fromLTRB(minX, minY, maxX, maxY);
  }

  double _nearestGrid(double v, double spacing) {
    if (spacing <= 0) return v;
    final k = (v / spacing).roundToDouble();
    return k * spacing;
  }

  Offset _calculateGuidelines(
      CanvasDoc doc, Set<String> movingIds, Offset delta) {
    final sc = _scale;
    if (sc == null) {
      setState(() => _guidelines.clear());
      return Offset.zero;
    }

    // Thresholds in BASE units
    final gridSnap = doc.gridVisible ? doc.gridSpacing : 0.0;
    final baseThreshold = gridSnap > 0
        ? (gridSnap * 0.35).clamp(3.0, 10.0)
        : 4.0; // friendly band

    final movingItems = movingIds.map(doc.itemById).toList();
    final staticItems =
        doc.items.where((it) => !movingIds.contains(it.id)).toList();

    if (movingItems.isEmpty) {
      setState(() => _guidelines.clear());
      return Offset.zero;
    }

    // Union of rotated AABBs for the whole selection, moved by current base delta
    Rect moving = _rotatedAabb(movingItems.first);
    for (int i = 1; i < movingItems.length; i++) {
      moving = moving.expandToInclude(_rotatedAabb(movingItems[i]));
    }
    moving = moving.translate(delta.dx, delta.dy);

    // Candidate lines in base space
    final List<double> xs = [];
    final List<double> ys = [];

    // 1) other items’ edges and centers
    for (final it in staticItems) {
      final r = _rotatedAabb(it);
      xs.addAll([r.left, r.center.dx, r.right]);
      ys.addAll([r.top, r.center.dy, r.bottom]);
    }

    // 2) canvas edges and centers
    final W = doc.baseSize.width;
    final H = doc.baseSize.height;
    xs.addAll([0.0, W / 2, W]);
    ys.addAll([0.0, H / 2, H]);

    // 3) grid lines: only the nearest grid to each moving feature
    if (gridSnap > 0) {
      final gxL = _nearestGrid(moving.left, gridSnap);
      final gxC = _nearestGrid(moving.center.dx, gridSnap);
      final gxR = _nearestGrid(moving.right, gridSnap);
      xs.addAll([gxL, gxC, gxR]);

      final gyT = _nearestGrid(moving.top, gridSnap);
      final gyC = _nearestGrid(moving.center.dy, gridSnap);
      final gyB = _nearestGrid(moving.bottom, gridSnap);
      ys.addAll([gyT, gyC, gyB]);
    }

    // Moving features
    final mx = [moving.left, moving.center.dx, moving.right];
    final my = [moving.top, moving.center.dy, moving.bottom];

    double? bestDx;
    _Guideline? bestXGuide;

    double? bestDy;
    _Guideline? bestYGuide;

    // choose the closest X among candidates to any moving x-feature
    for (final cx in xs) {
      for (final mxf in mx) {
        final d = cx - mxf;
        if (d.abs() <= baseThreshold &&
            (bestDx == null || d.abs() < bestDx!.abs())) {
          bestDx = d;
          bestXGuide = _Guideline(
            axis: Axis.vertical,
            start: Offset(cx, 0),
            end: Offset(cx, H),
          );
        }
      }
    }

    // choose the closest Y among candidates to any moving y-feature
    for (final cy in ys) {
      for (final myf in my) {
        final d = cy - myf;
        if (d.abs() <= baseThreshold &&
            (bestDy == null || d.abs() < bestDy!.abs())) {
          bestDy = d;
          bestYGuide = _Guideline(
            axis: Axis.horizontal,
            start: Offset(0, cy),
            end: Offset(W, cy),
          );
        }
      }
    }

    // Show at most one guide per axis to avoid jitter
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
