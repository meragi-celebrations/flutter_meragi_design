// lib/src/components/canva/simple_canva.dart
import 'dart:convert';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_meragi_design/src/components/canva/workspace_action_bar.dart';

import 'canva_item.dart';
import 'canvas_doc.dart';
import 'canvas_scope.dart';
import 'models.dart';
import 'property_sidebar.dart';
import 'scaling.dart';
import 'ui/grid_painter.dart';
import 'utils.dart';

class CanvasPaletteImage {
  final String id;
  final String
      srcUri; // e.g. asset://images/a.png, https://..., data:image/png;base64,...
  final ImageProvider? preview; // optional – for sidebar thumbnail
  final Size? preferredSize;
  const CanvasPaletteImage({
    required this.id,
    required this.srcUri,
    this.preview,
    this.preferredSize,
  });
}

class SimpleCanva extends StatefulWidget {
  const SimpleCanva({
    super.key,
    required this.palette,
    this.controller,
    this.sidebarWidth = 120,
    this.inspectorWidth = 280,
    this.workspaceColor = const Color(0xFFF3F4F6),
    this.initialCanvasColor = Colors.white,
    this.onChanged,
    this.baseCanvasSize = const Size(960, 540),
  });

  final List<CanvasPaletteImage> palette;
  final SimpleCanvaController? controller;
  final double sidebarWidth;
  final double inspectorWidth;
  final Color workspaceColor;
  final Color initialCanvasColor;
  final ValueChanged<List<CanvasItem>>? onChanged;
  final Size baseCanvasSize;

  @override
  State<SimpleCanva> createState() => _SimpleCanvaState();
}

class SimpleCanvaController {
  _SimpleCanvaState? _state;
  CanvasDoc? get _doc => _state?._doc;

  List<CanvasItem> get items => List.unmodifiable(_doc?.items ?? const []);

  void clear() {
    final d = _doc;
    if (d == null) return;
    d.beginUndoGroup('Clear');
    d.applyPatch([
      for (final it in d.items) {'type': 'remove', 'id': it.id},
      {'type': 'selection.set', 'ids': <String>[]},
    ]);
    d.commitUndoGroup();
  }

  void addImageFromSrc(String srcUri, {Offset? position, Size? size}) {
    final d = _doc;
    if (d == null) return;
    final id = d.newId();
    final pos = position ?? const Offset(40, 40);
    final sz = size ?? const Size(140, 140);
    final itemJson = {
      'id': id,
      'kind': 'image',
      'x': pos.dx,
      'y': pos.dy,
      'w': sz.width,
      'h': sz.height,
      'z': 0,
      'locked': false,
      'rot': 0,
      'props': {
        'src': srcUri,
        'radii': {'tl': 0, 'tr': 0, 'bl': 0, 'br': 0},
      },
    };
    d.beginUndoGroup('Add Image');
    d.applyPatch([
      {'type': 'insert', 'item': itemJson, 'index': null},
      {
        'type': 'selection.set',
        'ids': [id]
      },
    ]);
    d.commitUndoGroup();
  }

  void addText({
    String text = 'Double-click to edit',
    Offset? position,
    Size? size,
    double fontSize = 24,
    Color color = Colors.black,
    FontWeight weight = FontWeight.w600,
    String? fontFamily,
  }) {
    final d = _doc;
    if (d == null) return;
    final id = d.newId();
    final item = TextItem(
      id: id,
      text: text,
      fontSize: fontSize,
      fontColor: color,
      fontWeight: weight,
      fontFamily: fontFamily,
      position: position ?? const Offset(40, 40),
      size: size ?? const Size(220, 88),
    );
    d.beginUndoGroup('Add Text');
    d.applyPatch([
      {'type': 'insert', 'item': item.toJson(0)},
      {
        'type': 'selection.set',
        'ids': [id]
      },
    ]);
    d.commitUndoGroup();
  }

  void addPalette({List<Color>? colors, Offset? position, Size? size}) {
    final d = _doc;
    if (d == null) return;
    final id = d.newId();
    final item = PaletteItem(
      id: id,
      paletteColors: colors ??
          const [Color(0xFF111827), Color(0xFF6B7280), Color(0xFFE5E7EB)],
      position: position ?? const Offset(40, 40),
      size: size ?? const Size(320, 64),
    );
    d.beginUndoGroup('Add Palette');
    d.applyPatch([
      {'type': 'insert', 'item': item.toJson(0)},
      {
        'type': 'selection.set',
        'ids': [id]
      },
    ]);
    d.commitUndoGroup();
  }

  void setCanvasColor(Color color) {
    _doc?.applyPatch([
      {
        'type': 'canvas.update',
        'changes': {'color': colorToHex(color)}
      }
    ]);
  }

  Future<Uint8List?> exportAsPng({double pixelRatio = 3}) async =>
      _state?._exportAsPng(pixelRatio: pixelRatio);

  String exportAsJson({bool pretty = false}) {
    final d = _doc;
    final map = d?.toJson() ??
        {
          'version': 1,
          'items': [],
          'canvas': {'color': colorToHex(Colors.white)}
        };
    return pretty
        ? const JsonEncoder.withIndent('  ').convert(map)
        : jsonEncode(map);
  }

  void loadFromJson(String jsonString) {
    final d = _doc;
    if (d == null) return;
    try {
      final map = jsonDecode(jsonString) as Map<String, dynamic>;
      d.loadFromJson(map);
    } catch (e) {
      debugPrint('loadFromJson error: $e');
    }
  }

  void deleteSelected() {
    final d = _doc;
    if (d == null) return;
    final ids = d.selectedIds.toList();
    if (ids.isEmpty) return;
    d.beginUndoGroup('Delete');
    d.applyPatch([
      for (final id in ids) {'type': 'remove', 'id': id},
      {'type': 'selection.set', 'ids': <String>[]},
    ]);
    d.commitUndoGroup();
  }

  void undo() => _doc?.undo();
  void redo() => _doc?.redo();
}

class _SimpleCanvaState extends State<SimpleCanva> {
  final GlobalKey _repaintKey = GlobalKey();
  final GlobalKey _canvasBoxKey = GlobalKey();

  late final CanvasDoc _doc;
  CanvasScaleHandler? _scale;

  Map<String, CanvasPaletteImage> get _paletteById =>
      {for (final p in widget.palette) p.id: p};

  @override
  void initState() {
    super.initState();
    registerBuiltInCanvasItems();
    _doc = CanvasDoc(
      baseSize: widget.baseCanvasSize,
      canvasColor: widget.initialCanvasColor,
    );
    widget.controller?._state = this;
    if (widget.onChanged != null) {
      _doc.addListener(() => widget.onChanged?.call(_doc.items));
    }
  }

  @override
  void didUpdateWidget(covariant SimpleCanva oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      widget.controller?._state = this;
    }
  }

  @override
  void dispose() {
    _doc.dispose();
    super.dispose();
  }

  Future<Uint8List?> _exportAsPng({double pixelRatio = 3}) async {
    try {
      final boundary = _repaintKey.currentContext?.findRenderObject()
          as RenderRepaintBoundary?;
      if (boundary == null) return null;
      final image = await boundary.toImage(pixelRatio: pixelRatio);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      return byteData?.buffer.asUint8List();
    } catch (e) {
      debugPrint('exportAsPng error: $e');
      return null;
    }
  }

  Offset _toLocal(Offset global) {
    final rb = _canvasBoxKey.currentContext?.findRenderObject() as RenderBox?;
    if (rb == null) return global;
    return rb.globalToLocal(global);
  }

  // pass CanvasDoc explicitly so we don't rely on the State's context
  void _handlePointerDown(PointerDownEvent event, CanvasDoc doc) {
    final scale = _scale;
    if (scale == null) return;

    final localRender = _toLocal(event.position);
    final localBase = scale.renderToBase(localRender);

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

    final keys = HardwareKeyboard.instance.logicalKeysPressed;
    final additive = keys.contains(LogicalKeyboardKey.shiftLeft) ||
        keys.contains(LogicalKeyboardKey.shiftRight) ||
        keys.contains(LogicalKeyboardKey.controlLeft) ||
        keys.contains(LogicalKeyboardKey.controlRight) ||
        keys.contains(LogicalKeyboardKey.metaLeft) ||
        keys.contains(LogicalKeyboardKey.metaRight);

    if (hitId == null) {
      // clear selection on empty canvas
      doc.applyPatch([
        {'type': 'selection.set', 'ids': <String>[]}
      ]);
      return;
    }

    if (additive) {
      final ids = doc.selectedIds.contains(hitId)
          ? doc.selectedIds.where((e) => e != hitId).toList()
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

  bool _immediateDragPlatform() {
    if (kIsWeb) return true;
    switch (defaultTargetPlatform) {
      case TargetPlatform.macOS:
      case TargetPlatform.windows:
      case TargetPlatform.linux:
        return true;
      default:
        return false;
    }
  }

  Widget _paletteDraggable(CanvasPaletteImage p) {
    final thumb = _thumbForPalette(p);
    final feedback = Material(
      elevation: 4,
      color: Colors.transparent,
      child: ConstrainedBox(
        constraints: const BoxConstraints.tightFor(width: 96, height: 96),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.black12),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Opacity(opacity: 0.9, child: thumb),
          ),
        ),
      ),
    );
    if (_immediateDragPlatform()) {
      return Draggable<CanvasPaletteImage>(
        data: p,
        dragAnchorStrategy: pointerDragAnchorStrategy,
        feedback: feedback,
        childWhenDragging: Opacity(opacity: 0.35, child: thumb),
        child: thumb,
      );
    } else {
      return LongPressDraggable<CanvasPaletteImage>(
        data: p,
        dragAnchorStrategy: pointerDragAnchorStrategy,
        feedback: feedback,
        childWhenDragging: Opacity(opacity: 0.35, child: thumb),
        child: thumb,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // IMPORTANT: read doc via CanvasScope to make this subtree reactive
    return CanvasScope(
      doc: _doc,
      child: Row(children: [
        // Sidebar
        SizedBox(
          width: widget.sidebarWidth,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(right: BorderSide(color: Colors.grey.shade300)),
            ),
            child: ListView.separated(
              padding: const EdgeInsets.all(8),
              itemCount: widget.palette.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, i) => _paletteDraggable(widget.palette[i]),
            ),
          ),
        ),

        // Workspace and centered canvas
        Expanded(
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
                                      key: _repaintKey,
                                      child: Container(
                                        key: _canvasBoxKey,
                                        decoration: BoxDecoration(
                                          color: doc.canvasColor,
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          border:
                                              Border.all(color: Colors.black12),
                                        ),
                                        clipBehavior: Clip.antiAlias,
                                        child: Stack(
                                          children: [
                                            if (doc.gridVisible &&
                                                _scale != null)
                                              Positioned.fill(
                                                child: CustomPaint(
                                                  painter: GridPainter(
                                                    spacingBase:
                                                        doc.gridSpacing,
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
                                                                    .itemById(
                                                                        id)
                                                                    .position
                                                                    .dx +
                                                                delta.dx,
                                                            'y': doc
                                                                    .itemById(
                                                                        id)
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
                                                onResizeStart: () => doc
                                                    .beginUndoGroup('Resize'),
                                                onResizeCommit: (updated) {
                                                  doc.applyPatch([
                                                    {
                                                      'type': 'update',
                                                      'id': updated.id,
                                                      'changes': {
                                                        'position': {
                                                          'x': updated
                                                              .position.dx,
                                                          'y': updated
                                                              .position.dy,
                                                        },
                                                        'size': {
                                                          'w': updated
                                                              .size.width,
                                                          'h': updated
                                                              .size.height,
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
                                      onPointerDown: (e) {
                                        // pass doc captured from builder
                                        _handlePointerDown(e, doc);
                                      },
                                      child: const SizedBox.expand(),
                                    ),
                                  ),

                                  // DragTarget overlay so drops work even over items
                                  Positioned.fill(
                                    child: DragTarget<CanvasPaletteImage>(
                                      onWillAccept: (_) => true,
                                      onAcceptWithDetails: (details) {
                                        final scale = _scale;
                                        if (scale == null) return;

                                        final localRender =
                                            _toLocal(details.offset);
                                        final baseDrop =
                                            scale.renderToBase(localRender);

                                        final pal = details.data;
                                        final baseSize = pal.preferredSize ??
                                            const Size(160, 160);

                                        final id = _doc.newId();
                                        final itemJson = {
                                          'id': id,
                                          'kind': 'image',
                                          'x': baseDrop.dx - baseSize.width / 2,
                                          'y':
                                              baseDrop.dy - baseSize.height / 2,
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

                                        _doc.beginUndoGroup('Add Image');
                                        _doc.applyPatch([
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
                                        _doc.commitUndoGroup();
                                      },
                                      builder: (context, _, __) =>
                                          const SizedBox.expand(),
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
        ),

        // Right sidebar
        SizedBox(
          width: widget.inspectorWidth,
          child: const PropertiesSidebar(),
        ),
      ]),
    );
  }

  Widget _thumb(ImageProvider provider) => AspectRatio(
        aspectRatio: 1,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.black12),
            boxShadow: const [BoxShadow(blurRadius: 2, color: Colors.black12)],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image(image: provider, fit: BoxFit.cover),
          ),
        ),
      );

  Widget _thumbForPalette(CanvasPaletteImage p) {
    final prov = p.preview ?? _derivePreview(p.srcUri);
    return AspectRatio(
      aspectRatio: 1,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.black12),
          boxShadow: const [BoxShadow(blurRadius: 2, color: Colors.black12)],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: prov != null
              ? Image(image: prov, fit: BoxFit.cover)
              : const Center(child: Icon(Icons.image_outlined)),
        ),
      ),
    );
  }

  ImageProvider? _derivePreview(String src) {
    try {
      if (src.startsWith('asset://')) {
        return AssetImage(src.substring('asset://'.length));
      } else if (src.startsWith('http://') || src.startsWith('https://')) {
        return NetworkImage(src);
      } else if (src.startsWith('data:image/')) {
        final comma = src.indexOf(',');
        if (comma > 0) {
          final b64 = src.substring(comma + 1);
          return MemoryImage(base64Decode(b64));
        }
      }
    } catch (_) {}
    return null;
  }

  Widget _dragFeedback(ImageProvider provider) => Material(
        elevation: 4,
        color: Colors.transparent,
        child: ConstrainedBox(
          constraints: const BoxConstraints.tightFor(width: 96, height: 96),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.black12),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Opacity(
                opacity: 0.9,
                child: Image(image: provider, fit: BoxFit.cover),
              ),
            ),
          ),
        ),
      );
}
