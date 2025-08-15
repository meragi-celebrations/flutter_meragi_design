import 'dart:convert';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_meragi_design/src/components/canva/canva_item.dart';
import 'package:flutter_meragi_design/src/components/canva/models.dart';
import 'package:flutter_meragi_design/src/components/canva/property_sidebar.dart';
import 'package:flutter_meragi_design/src/components/canva/scaling.dart';
import 'package:flutter_meragi_design/src/components/canva/ui/grid_painter.dart';
import 'package:flutter_meragi_design/src/components/canva/utils.dart';
import 'package:flutter_meragi_design/src/components/canva/workspace_action_bar.dart';

class CanvasPaletteImage {
  final String id;
  final ImageProvider provider;
  final Size? preferredSize;
  const CanvasPaletteImage({
    required this.id,
    required this.provider,
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

  List<CanvasItem> get items => List.unmodifiable(_state?._items ?? const []);

  void clear() => _state?._clear();

  void addFromProvider(ImageProvider provider, {Offset? position, Size? size}) {
    _state?._addItem(
      ImageItem(
        id: buildId(),
        imageId: null,
        provider: provider,
        position: position ?? const Offset(40, 40),
        size: size ?? const Size(140, 140),
      ),
    );
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
    _state?._addItem(
      TextItem(
        id: buildId(),
        text: text,
        fontSize: fontSize,
        fontColor: color,
        fontWeight: weight,
        fontFamily: fontFamily,
        position: position ?? const Offset(40, 40),
        size: size ?? const Size(220, 88),
      ),
    );
  }

  void addPalette({
    List<Color>? colors,
    Offset? position,
    Size? size,
  }) {
    _state?._addItem(
      PaletteItem(
        id: buildId(),
        paletteColors: colors ??
            const [Color(0xFF111827), Color(0xFF6B7280), Color(0xFFE5E7EB)],
        position: position ?? const Offset(40, 40),
        size: size ?? const Size(320, 64),
      ),
    );
  }

  void setCanvasColor(Color color) => _state?._setCanvasColor(color);

  Future<Uint8List?> exportAsPng({double pixelRatio = 3}) async =>
      _state?._exportAsPng(pixelRatio: pixelRatio);

  String exportAsJson({bool pretty = false}) {
    final doc = _state?._toJsonDocument() ??
        {
          'version': 1,
          'items': [],
          'canvas': {'color': colorToHex(Colors.white)}
        };
    return pretty
        ? const JsonEncoder.withIndent('  ').convert(doc)
        : jsonEncode(doc);
  }

  void loadFromJson(String jsonString) {
    try {
      final map = jsonDecode(jsonString) as Map<String, dynamic>;
      _state?._loadFromJsonDocument(map);
    } catch (e) {
      debugPrint('loadFromJson error: $e');
    }
  }

  void deleteSelected() => _state?._deleteSelected();

  void undo() => _state?._undoAction();
  void redo() => _state?._redoAction();
}

class _SimpleCanvaState extends State<SimpleCanva> {
  final GlobalKey _repaintKey = GlobalKey(); // wraps only the canvas
  final GlobalKey _canvasBoxKey = GlobalKey();

  final List<CanvasItem> _items = [];
  final Set<String> _selected = <String>{};
  Color _canvasColor = Colors.white;

  final List<String> _undoStack = [];
  final List<String> _redoStack = [];
  bool _suspendHistory = false;
  bool _gestureHistoryPushed = false;
  static const int _historyLimit = 100;

  bool _propsHistoryPushed = false;

  bool _gridVisible = false; // grid toggle
  double _gridSpacingBase = 24; // spacing in BASE canvas units (px)

  late Size _baseSize;
  CanvasScaleHandler? _scale;

  Map<String, CanvasPaletteImage> get _paletteById =>
      {for (final p in widget.palette) p.id: p};

  @override
  void initState() {
    super.initState();
    _baseSize = widget.baseCanvasSize;
    _canvasColor = widget.initialCanvasColor;
    widget.controller?._state = this;
  }

  @override
  void didUpdateWidget(covariant SimpleCanva oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      widget.controller?._state = this;
    }
  }

  // Selection helpers
  bool _isSelected(String id) => _selected.contains(id);

  CanvasItem? _singleSelected() {
    if (_selected.length != 1) return null;
    return _byId(_selected.first);
  }

  void _selectOnly(String id) {
    setState(() {
      _selected
        ..clear()
        ..add(id);
    });
    _propsHistoryPushed = false;
    _notify();
  }

  void _toggleSelect(String id) {
    setState(() {
      _selected.contains(id) ? _selected.remove(id) : _selected.add(id);
    });
    _propsHistoryPushed = false;
    _notify();
  }

  void _clearSelection() {
    if (_selected.isEmpty) return;
    setState(() => _selected.clear());
    _propsHistoryPushed = false;
    _notify();
  }

  void _deleteSelected() {
    _pushHistory();
    setState(() {
      _items.removeWhere((e) => _selected.contains(e.id));
      _selected.clear();
    });
    _propsHistoryPushed = false;
    _notify();
  }

  // Undo Redo
  void _pushHistory() {
    if (_suspendHistory) return;
    final snap = jsonEncode(_toJsonDocument());
    _undoStack.add(snap);
    if (_undoStack.length > _historyLimit) _undoStack.removeAt(0);
    _redoStack.clear();
  }

  void _undoAction() {
    if (_undoStack.isEmpty) return;
    _suspendHistory = true;
    try {
      final current = jsonEncode(_toJsonDocument());
      _redoStack.add(current);
      final prev = _undoStack.removeLast();
      _loadFromJsonDocument(jsonDecode(prev) as Map<String, dynamic>);
    } finally {
      _suspendHistory = false;
    }
  }

  void _redoAction() {
    if (_redoStack.isEmpty) return;
    _suspendHistory = true;
    try {
      final current = jsonEncode(_toJsonDocument());
      _undoStack.add(current);
      final next = _redoStack.removeLast();
      _loadFromJsonDocument(jsonDecode(next) as Map<String, dynamic>);
    } finally {
      _suspendHistory = false;
    }
  }

  // one-shot push at gesture begin, so drag or resize is a single undo step
  void _gestureBegin() {
    if (!_gestureHistoryPushed) {
      _pushHistory();
      _gestureHistoryPushed = true;
    }
  }

  void _gestureEnd() {
    _gestureHistoryPushed = false;
  }

  void _bringToFront() {
    _pushHistory();
    setState(() {
      final keep = _items.where((e) => !_selected.contains(e.id)).toList();
      final sel = _items.where((e) => _selected.contains(e.id)).toList();
      _items
        ..clear()
        ..addAll(keep)
        ..addAll(sel);
    });
    _notify();
  }

  void _sendToBack() {
    _pushHistory();
    setState(() {
      final keep = _items.where((e) => !_selected.contains(e.id)).toList();
      final sel = _items.where((e) => _selected.contains(e.id)).toList();
      _items
        ..clear()
        ..addAll(sel)
        ..addAll(keep);
    });
    _notify();
  }

  void _duplicateSelected() {
    _pushHistory();
    final clones = <CanvasItem>[];
    for (final it in _items) {
      if (_selected.contains(it.id)) {
        final dup = it.cloneWith(id: buildId())
          ..position = it.position + const Offset(12, 12)
          ..locked = false;
        clones.add(dup);
      }
    }
    setState(() {
      _items.addAll(clones);
      _selected
        ..clear()
        ..addAll(clones.map((e) => e.id));
    });
    _propsHistoryPushed = false;
    _notify();
  }

  // Align helpers
  void _alignLeft() {
    _pushHistory();
    if (_selected.length < 2) return;
    final left = _selected
        .map((id) => _byId(id).position.dx)
        .reduce((a, b) => a < b ? a : b);
    setState(() {
      for (final id in _selected) {
        final it = _byId(id);
        if (!it.locked) it.position = Offset(left, it.position.dy);
      }
    });
    _notify();
  }

  void _alignTop() {
    _pushHistory();
    if (_selected.length < 2) return;
    final top = _selected
        .map((id) => _byId(id).position.dy)
        .reduce((a, b) => a < b ? a : b);
    setState(() {
      for (final id in _selected) {
        final it = _byId(id);
        if (!it.locked) it.position = Offset(it.position.dx, top);
      }
    });
    _notify();
  }

  void _alignHCenter() {
    _pushHistory();
    if (_selected.length < 2) return;
    final cx = _selected.map((id) {
          final it = _byId(id);
          return it.position.dx + it.size.width / 2;
        }).reduce((a, b) => a + b) /
        _selected.length;
    setState(() {
      for (final id in _selected) {
        final it = _byId(id);
        if (!it.locked) {
          it.position = Offset(cx - it.size.width / 2, it.position.dy);
        }
      }
    });
    _notify();
  }

  void _alignVCenter() {
    _pushHistory();
    if (_selected.length < 2) return;
    final cy = _selected.map((id) {
          final it = _byId(id);
          return it.position.dy + it.size.height / 2;
        }).reduce((a, b) => a + b) /
        _selected.length;
    setState(() {
      for (final id in _selected) {
        final it = _byId(id);
        if (!it.locked) {
          it.position = Offset(it.position.dx, cy - it.size.height / 2);
        }
      }
    });
    _notify();
  }

  void _alignRight() {
    _pushHistory();
    if (_selected.length < 2) return;
    final right = _selected.map((id) {
      final it = _byId(id);
      return it.position.dx + it.size.width;
    }).reduce((a, b) => a > b ? a : b);
    setState(() {
      for (final id in _selected) {
        final it = _byId(id);
        if (!it.locked) {
          it.position = Offset(right - it.size.width, it.position.dy);
        }
      }
    });
    _notify();
  }

  void _alignBottom() {
    _pushHistory();
    if (_selected.length < 2) return;
    final bottom = _selected.map((id) {
      final it = _byId(id);
      return it.position.dy + it.size.height;
    }).reduce((a, b) => a > b ? a : b);
    setState(() {
      for (final id in _selected) {
        final it = _byId(id);
        if (!it.locked) {
          it.position = Offset(it.position.dx, bottom - it.size.height);
        }
      }
    });
    _notify();
  }

  void _alignCanvasHCenter() {
    if (_selected.isEmpty) return;
    _pushHistory();
    final cx = _baseSize.width / 2;
    setState(() {
      for (final id in _selected) {
        final it = _byId(id);
        if (!it.locked) {
          it.position = Offset(cx - it.size.width / 2, it.position.dy);
        }
      }
    });
    _notify();
  }

  void _alignCanvasVCenter() {
    if (_selected.isEmpty) return;
    _pushHistory();
    final cy = _baseSize.height / 2;
    setState(() {
      for (final id in _selected) {
        final it = _byId(id);
        if (!it.locked) {
          it.position = Offset(it.position.dx, cy - it.size.height / 2);
        }
      }
    });
    _notify();
  }

  void _toggleLockSelected() {
    _pushHistory();
    setState(() {
      final anyUnlocked = _selected.any((id) => !_byId(id).locked);
      for (final id in _selected) {
        _byId(id).locked = anyUnlocked;
      }
    });
    _notify();
  }

  void _panSelected(Offset delta) {
    if (_selected.isEmpty) return;
    final movable =
        _items.where((it) => _selected.contains(it.id) && !it.locked);
    if (movable.isEmpty) return;

    _pushHistory();
    setState(() {
      for (final it in movable) {
        it.position = it.position + delta;
      }
    });
    _notify();
  }

  void _propChangeStart() {
    if (!_propsHistoryPushed) {
      _pushHistory();
      _propsHistoryPushed = true;
    }
  }

  void _propChangeEnd() {
    _propsHistoryPushed = false;
  }

  void _propApply(CanvasItem updated) {
    final idx = _items.indexWhere((e) => e.id == updated.id);
    if (idx == -1) return;
    setState(() {
      _items[idx] = updated;
    });
    _notify();
  }

  void _setCanvasColor(Color c) => setState(() => _canvasColor = c);

  CanvasItem _byId(String id) => _items.firstWhere((e) => e.id == id);

  void _notify() => widget.onChanged?.call(List.unmodifiable(_items));

  void _addItem(CanvasItem item) {
    setState(() {
      _items.add(item);
      _selected
        ..clear()
        ..add(item.id);
    });
    _notify();
  }

  void _addTextBox() {
    _pushHistory();
    _addItem(
      TextItem(
        id: buildId(),
        text: 'Double-click to edit',
        position: const Offset(60, 60),
        size: const Size(240, 96),
      ),
    );
  }

  void _addPaletteBox() {
    _pushHistory();
    _addItem(
      PaletteItem(
        id: buildId(),
        paletteColors: const [
          Color(0xFF111827),
          Color(0xFF6B7280),
          Color(0xFFE5E7EB),
        ],
        position: const Offset(60, 60),
        size: const Size(320, 64),
      ),
    );
  }

  void _clear() {
    setState(() {
      _items.clear();
      _selected.clear();
    });
    _notify();
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

  Map<String, dynamic> _toJsonDocument() => {
        'version': 2,
        'canvas': {
          'base': {'w': _baseSize.width, 'h': _baseSize.height},
          'aspect': _baseSize.width / _baseSize.height,
          'color': colorToHex(_canvasColor),
        },
        'items': [for (int i = 0; i < _items.length; i++) _items[i].toJson(i)],
      };

  void _loadFromJsonDocument(Map<String, dynamic> doc) {
    final canvas = (doc['canvas'] as Map?) ?? {};
    final colorHex = canvas['color'] as String?;
    if (colorHex != null) {
      final c = hexToColor(colorHex);
      if (c != null) _canvasColor = c;
    }

    // base size
    final base = (canvas['base'] as Map?)?.cast<String, dynamic>();
    if (base != null) {
      final bw = (base['w'] as num?)?.toDouble();
      final bh = (base['h'] as num?)?.toDouble();
      if (bw != null && bw > 0 && bh != null && bh > 0) {
        _baseSize = Size(bw, bh);
      }
    }

    final rawItems =
        (doc['items'] as List?)?.cast<Map<String, dynamic>>() ?? const [];
    final rebuilt = <CanvasItem>[];
    for (final j in rawItems) {
      // Resolve provider from palette id if present
      ImageProvider? provider;
      final props = (j['props'] as Map?)?.cast<String, dynamic>() ?? const {};
      final imageId =
          (props['imageId'] as String?) ?? (j['imageId'] as String?);
      if (imageId != null && _paletteById.containsKey(imageId)) {
        provider = _paletteById[imageId]!.provider;
      }
      provider ??= deserializeProvider(props['src'] ?? j['src']);

      rebuilt.add(CanvasItem.fromJson(j, provider));
    }
    setState(() {
      _items
        ..clear()
        ..addAll(rebuilt);
      _selected.clear();
    });
    _propsHistoryPushed = false;
    _notify();
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
    final thumb = _thumb(p.provider);
    final feedback = _dragFeedback(p.provider);
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

  void _handleTapDownOnCanvas(TapDownDetails details) {
    final localRender = _toLocal(details.globalPosition);
    final scale = _scale;
    if (scale == null) return;

    final localBase = scale.renderToBase(localRender);

    String? hitId;
    for (final item in _items.reversed) {
      final rect = Rect.fromLTWH(item.position.dx, item.position.dy,
          item.size.width, item.size.height);
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
      _clearSelection();
      return;
    }

    final alreadySelected = _selected.contains(hitId);
    if (additive) {
      _toggleSelect(hitId);
    } else {
      if (!alreadySelected) _selectOnly(hitId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(children: [
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
            Positioned.fill(
              child: Container(
                color: widget.workspaceColor,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final maxW = constraints.maxWidth;
                        final maxH = constraints.maxHeight;
                        final targetAspect = _baseSize.width / _baseSize.height;
                        double w = maxW;
                        double h = w / targetAspect;
                        if (h > maxH) {
                          h = maxH;
                          w = h * targetAspect;
                        }

                        _scale = CanvasScaleHandler(
                          baseSize: _baseSize,
                          renderSize: Size(w, h),
                        );

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
                            child: Stack(children: [
                              Positioned.fill(
                                child: GestureDetector(
                                  behavior: HitTestBehavior.deferToChild,
                                  onTapDown: _handleTapDownOnCanvas,
                                  child: RepaintBoundary(
                                    key: _repaintKey,
                                    child: Container(
                                      key: _canvasBoxKey,
                                      decoration: BoxDecoration(
                                        color: _canvasColor,
                                        borderRadius: BorderRadius.circular(12),
                                        border:
                                            Border.all(color: Colors.black12),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
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
                                            final baseSize =
                                                pal.preferredSize ??
                                                    const Size(160, 160);

                                            _addItem(ImageItem(
                                              id: buildId(),
                                              imageId: pal.id,
                                              provider: pal.provider,
                                              position: baseDrop -
                                                  Offset(baseSize.width / 2,
                                                      baseSize.height / 2),
                                              size: baseSize,
                                            ));
                                          },
                                          builder: (context, _, __) {
                                            final canvasSize = Size(w, h);
                                            return Stack(children: [
                                              if (_gridVisible &&
                                                  _scale != null)
                                                Positioned.fill(
                                                  child: CustomPaint(
                                                    painter: GridPainter(
                                                      spacingBase:
                                                          _gridSpacingBase,
                                                      scale: _scale!,
                                                      color: Colors.black
                                                          .withOpacity(0.06),
                                                      boldEvery:
                                                          5, // thicker line every 5 cells
                                                    ),
                                                  ),
                                                ),
                                              for (final item in _items)
                                                CanvasItemWidget(
                                                  key: ValueKey(item.id),
                                                  item: item,
                                                  canvasSize: canvasSize,
                                                  isSelected:
                                                      _isSelected(item.id),
                                                  onPanStart: _gestureBegin,
                                                  onPanMove: _panSelected,
                                                  onPanEnd: _gestureEnd,
                                                  onResizeStart: _gestureBegin,
                                                  onResizeCommit: (updated) {
                                                    setState(() {
                                                      final idx = _items
                                                          .indexWhere((e) =>
                                                              e.id == item.id);
                                                      if (idx != -1)
                                                        _items[idx] = updated;
                                                    });
                                                    _notify();
                                                  },
                                                  onResizeEnd: _gestureEnd,
                                                  scale: _scale!,
                                                ),
                                            ]);
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ]),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 20,
              left: 0,
              right: 0,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: WorkspaceActionBar(
                  canvasColor: _canvasColor,
                  onUndo: _undoAction,
                  onRedo: _redoAction,
                  onColorPick: (c) => _setCanvasColor(c),
                  onAddText: _addTextBox,
                  onAddPalette: _addPaletteBox,
                  gridVisible: _gridVisible,
                  gridSpacing: _gridSpacingBase,
                  onGridToggle: () =>
                      setState(() => _gridVisible = !_gridVisible),
                  onGridSpacingChanged: (v) => setState(() {
                    // sane bounds in base units
                    _gridSpacingBase = v.clamp(2.0, 400.0);
                  }),
                ),
              ),
            ),
          ],
        ),
      ),

      // Right sidebar
      SizedBox(
        width: widget.inspectorWidth,
        child: PropertiesSidebar(
          item: _singleSelected(),
          selectedCount: _selected.length,
          // actions
          onDelete: _deleteSelected,
          onDuplicate: _duplicateSelected,
          onFront: _bringToFront,
          onBack: _sendToBack,
          onAlignLeft: _alignLeft,
          onAlignHCenter: _alignHCenter,
          onAlignRight: _alignRight,
          onAlignTop: _alignTop,
          onAlignVCenter: _alignVCenter,
          onAlignBottom: _alignBottom,
          onAlignCanvasHCenter: _alignCanvasHCenter,
          onAlignCanvasVCenter: _alignCanvasVCenter,
          onLockToggle: _toggleLockSelected,
          // property change hooks
          onChangeStart: _propChangeStart,
          onChanged: _propApply,
          onChangeEnd: _propChangeEnd,
        ),
      ),
    ]);
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
