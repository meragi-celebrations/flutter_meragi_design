import 'package:flutter/material.dart';
import 'package:flutter_meragi_design/src/components/canva/canva_item.dart';
import 'package:flutter_meragi_design/src/components/canva/canvas_controller.dart';
import 'package:flutter_meragi_design/src/components/canva/canvas_doc.dart';
import 'package:flutter_meragi_design/src/components/canva/canvas_scope.dart';
import 'package:flutter_meragi_design/src/components/canva/color_extractor.dart';
import 'package:flutter_meragi_design/src/components/canva/items/image.dart';
import 'package:flutter_meragi_design/src/components/canva/palette_sidebar.dart';
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

  // was: void _calculateGuidelines(CanvasDoc doc, Set<String> movingIds, Offset delta)
  Offset _calculateGuidelines(
      CanvasDoc doc, Set<String> movingIds, Offset delta) {
    final newGuidelines = <_Guideline>[];
    _snapOffset = Offset.zero;

    if (_scale == null) {
      setState(() => _guidelines.clear());
      return Offset.zero;
    }

    final movingItems = movingIds.map((id) => doc.itemById(id)).toList();
    final staticItems =
        doc.items.where((item) => !movingIds.contains(item.id)).toList();

    if (staticItems.isEmpty || movingItems.isEmpty) {
      setState(() => _guidelines.clear());
      return Offset.zero;
    }

    Rect movingBounds = movingItems.first.rect;
    for (int i = 1; i < movingItems.length; i++) {
      movingBounds = movingBounds.expandToInclude(movingItems[i].rect);
    }
    movingBounds = movingBounds.translate(delta.dx, delta.dy);

    const snapThreshold = 2.0;

    // Canvas centers
    final canvasCenter = doc.baseSize.center(Offset.zero);

    // Horizontal canvas center check
    if ((movingBounds.center.dx - canvasCenter.dx).abs() < snapThreshold) {
      _snapOffset =
          Offset(canvasCenter.dx - movingBounds.center.dx, _snapOffset.dy);
      newGuidelines.add(_Guideline(
        axis: Axis.vertical,
        start: Offset(canvasCenter.dx, 0),
        end: Offset(canvasCenter.dx, doc.baseSize.height),
      ));
    }

    // Vertical canvas center check
    if ((movingBounds.center.dy - canvasCenter.dy).abs() < snapThreshold) {
      _snapOffset =
          Offset(_snapOffset.dx, canvasCenter.dy - movingBounds.center.dy);
      newGuidelines.add(_Guideline(
        axis: Axis.horizontal,
        start: Offset(0, canvasCenter.dy),
        end: Offset(doc.baseSize.width, canvasCenter.dy),
      ));
    }

    for (final staticItem in staticItems) {
      final staticBounds = staticItem.rect;

      // Horizontal checks
      final dyLeft = (staticBounds.left - movingBounds.left).abs();
      final dyRight = (staticBounds.right - movingBounds.right).abs();
      final dyCenter = (staticBounds.center.dx - movingBounds.center.dx).abs();

      if (dyLeft < snapThreshold) {
        _snapOffset =
            Offset(staticBounds.left - movingBounds.left, _snapOffset.dy);
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
        _snapOffset =
            Offset(staticBounds.right - movingBounds.right, _snapOffset.dy);
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
        _snapOffset = Offset(
            staticBounds.center.dx - movingBounds.center.dx, _snapOffset.dy);
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
        _snapOffset =
            Offset(_snapOffset.dx, staticBounds.top - movingBounds.top);
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
        _snapOffset =
            Offset(_snapOffset.dx, staticBounds.bottom - movingBounds.bottom);
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
        _snapOffset = Offset(
            _snapOffset.dx, staticBounds.center.dy - movingBounds.center.dy);
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

    return _snapOffset; // return base-space snap
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
