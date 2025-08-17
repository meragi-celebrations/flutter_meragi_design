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
                                            onPanStart: () =>
                                                doc.beginUndoGroup('Drag'),
                                            onPanMove: (delta) {
                                              final moving =
                                                  doc.selectedIds.isEmpty
                                                      ? <String>{item.id}
                                                      : doc.selectedIds;
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
                                                            delta.dx,
                                                        'y': doc
                                                                .itemById(id)
                                                                .position
                                                                .dy +
                                                            delta.dy,
                                                      }
                                                    }
                                                  }
                                              ]);
                                            },
                                            onPanEnd: () =>
                                                doc.commitUndoGroup(),
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
}
