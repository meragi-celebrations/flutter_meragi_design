import 'dart:convert';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

class SimpleCanva extends StatefulWidget {
  const SimpleCanva({
    super.key,
    required this.palette,
    this.controller,
    this.sidebarWidth = 120,
    this.canvasBackground = const Color(0xFFF7F7F7),
    this.onChanged,
  });

  final List<CanvasPaletteImage> palette;
  final SimpleCanvaController? controller;
  final double sidebarWidth;
  final Color canvasBackground;
  final ValueChanged<List<CanvasItem>>? onChanged;

  @override
  State<SimpleCanva> createState() => _SimpleCanvaState();
}

class SimpleCanvaController {
  _SimpleCanvaState? _state;

  List<CanvasItem> get items => List.unmodifiable(_state?._items ?? const []);

  void clear() => _state?._clear();

  void addFromProvider(ImageProvider provider, {Offset? position, Size? size}) {
    _state?._addItem(
      CanvasItem(
        id: _id(),
        imageId: null,
        provider: provider,
        position: position ?? const Offset(40, 40),
        size: size ?? const Size(140, 140),
      ),
    );
  }

  Future<Uint8List?> exportAsPng({double pixelRatio = 3}) async =>
      _state?._exportAsPng(pixelRatio: pixelRatio);

  String exportAsJson({bool pretty = false}) {
    final doc = _state?._toJsonDocument() ?? {'version': 1, 'items': []};
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
}

class CanvasPaletteImage {
  final String id;
  final ImageProvider provider;
  final Size? preferredSize;
  const CanvasPaletteImage(
      {required this.id, required this.provider, this.preferredSize});
}

class CanvasItem {
  final String id;
  final String? imageId; // links to palette id when applicable
  final ImageProvider provider;
  Offset position;
  Size size;
  bool locked;

  CanvasItem({
    required this.id,
    required this.imageId,
    required this.provider,
    required this.position,
    required this.size,
    this.locked = false,
  });

  CanvasItem copy() => CanvasItem(
        id: id,
        imageId: imageId,
        provider: provider,
        position: position,
        size: size,
        locked: locked,
      );

  Map<String, dynamic> toJson(int zIndex) => {
        'id': id,
        if (imageId != null) 'imageId': imageId,
        'x': position.dx,
        'y': position.dy,
        'w': size.width,
        'h': size.height,
        'z': zIndex,
        'locked': locked,
        'src': _serializeProvider(provider),
      };

  static CanvasItem fromJson(
      Map<String, dynamic> json, ImageProvider provider) {
    return CanvasItem(
      id: (json['id'] as String?) ?? _id(),
      imageId: json['imageId'] as String?,
      provider: provider,
      position: Offset((json['x'] as num?)?.toDouble() ?? 0,
          (json['y'] as num?)?.toDouble() ?? 0),
      size: Size((json['w'] as num?)?.toDouble() ?? 100,
          (json['h'] as num?)?.toDouble() ?? 100),
      locked: (json['locked'] as bool?) ?? false,
    );
  }
}

// ————— Intents for Shortcuts/Actions —————
class DeleteIntent extends Intent {
  const DeleteIntent();
}

class DuplicateIntent extends Intent {
  const DuplicateIntent();
}

class SelectAllIntent extends Intent {
  const SelectAllIntent();
}

class NudgeLeftIntent extends Intent {
  const NudgeLeftIntent();
}

class NudgeRightIntent extends Intent {
  const NudgeRightIntent();
}

class NudgeUpIntent extends Intent {
  const NudgeUpIntent();
}

class NudgeDownIntent extends Intent {
  const NudgeDownIntent();
}

class NudgeLeftBigIntent extends Intent {
  const NudgeLeftBigIntent();
}

class NudgeRightBigIntent extends Intent {
  const NudgeRightBigIntent();
}

class NudgeUpBigIntent extends Intent {
  const NudgeUpBigIntent();
}

class NudgeDownBigIntent extends Intent {
  const NudgeDownBigIntent();
}

// ————— IMPLEMENTATION —————
class _SimpleCanvaState extends State<SimpleCanva> {
  final GlobalKey _repaintKey = GlobalKey();
  final GlobalKey _canvasBoxKey = GlobalKey();

  final List<CanvasItem> _items = [];
  final Set<String> _selected = <String>{};

  Map<String, CanvasPaletteImage> get _paletteById =>
      {for (final p in widget.palette) p.id: p};

  @override
  void initState() {
    super.initState();
    widget.controller?._state = this;
  }

  @override
  void didUpdateWidget(covariant SimpleCanva oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller)
      widget.controller?._state = this;
  }

  // Selection helpers
  bool _isSelected(String id) => _selected.contains(id);

  void _selectOnly(String id) {
    setState(() {
      _selected
        ..clear()
        ..add(id);
    });
    _notify();
  }

  void _toggleSelect(String id) {
    setState(() {
      _selected.contains(id) ? _selected.remove(id) : _selected.add(id);
    });
    _notify();
  }

  void _clearSelection() {
    if (_selected.isEmpty) return;
    setState(() => _selected.clear());
    _notify();
  }

  void _deleteSelected() {
    setState(() {
      _items.removeWhere((e) => _selected.contains(e.id));
      _selected.clear();
    });
    _notify();
  }

  void _bringToFront() {
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
    final clones = <CanvasItem>[];
    for (final it in _items) {
      if (_selected.contains(it.id)) {
        final dup = it.copy()
          ..position = it.position + const Offset(12, 12)
          ..locked = false;
        clones.add(CanvasItem(
          id: _id(),
          imageId: dup.imageId,
          provider: dup.provider,
          position: dup.position,
          size: dup.size,
          locked: dup.locked,
        ));
      }
    }
    setState(() {
      _items.addAll(clones);
      _selected
        ..clear()
        ..addAll(clones.map((e) => e.id));
    });
    _notify();
  }

  // Align helpers
  void _alignLeft() {
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
    if (_selected.length < 2) return;
    final cx = _selected.map((id) {
          final it = _byId(id);
          return it.position.dx + it.size.width / 2;
        }).reduce((a, b) => a + b) /
        _selected.length;
    setState(() {
      for (final id in _selected) {
        final it = _byId(id);
        if (!it.locked)
          it.position = Offset(cx - it.size.width / 2, it.position.dy);
      }
    });
    _notify();
  }

  void _alignVCenter() {
    if (_selected.length < 2) return;
    final cy = _selected.map((id) {
          final it = _byId(id);
          return it.position.dy + it.size.height / 2;
        }).reduce((a, b) => a + b) /
        _selected.length;
    setState(() {
      for (final id in _selected) {
        final it = _byId(id);
        if (!it.locked)
          it.position = Offset(it.position.dx, cy - it.size.height / 2);
      }
    });
    _notify();
  }

  void _alignRight() {
    if (_selected.length < 2) return;
    final right = _selected.map((id) {
      final it = _byId(id);
      return it.position.dx + it.size.width;
    }).reduce((a, b) => a > b ? a : b);
    setState(() {
      for (final id in _selected) {
        final it = _byId(id);
        if (!it.locked)
          it.position = Offset(right - it.size.width, it.position.dy);
      }
    });
    _notify();
  }

  void _alignBottom() {
    if (_selected.length < 2) return;
    final bottom = _selected.map((id) {
      final it = _byId(id);
      return it.position.dy + it.size.height;
    }).reduce((a, b) => a > b ? a : b);
    setState(() {
      for (final id in _selected) {
        final it = _byId(id);
        if (!it.locked)
          it.position = Offset(it.position.dx, bottom - it.size.height);
      }
    });
    _notify();
  }

  void _toggleLockSelected() {
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
    final size = _canvasSize();
    setState(() {
      for (final id in _selected) {
        final it = _byId(id);
        if (it.locked) continue;
        final maxX = size.width - it.size.width;
        final maxY = size.height - it.size.height;
        final next = it.position + delta;
        it.position = Offset(next.dx.clamp(0, maxX), next.dy.clamp(0, maxY));
      }
    });
    _notify();
  }

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
        'version': 1,
        'items': [for (int i = 0; i < _items.length; i++) _items[i].toJson(i)],
      };

  void _loadFromJsonDocument(Map<String, dynamic> doc) {
    final rawItems = (doc['items'] as List?)?.cast<Map<String, dynamic>>() ??
        const <Map<String, dynamic>>[];
    final rebuilt = <CanvasItem>[];
    for (final j in rawItems) {
      final imageId = j['imageId'] as String?;
      ImageProvider? provider;
      if (imageId != null && _paletteById.containsKey(imageId))
        provider = _paletteById[imageId]!.provider;
      provider ??= _deserializeProvider(j['src']);
      if (provider == null) continue;
      rebuilt.add(CanvasItem.fromJson(j, provider));
    }
    setState(() {
      _items
        ..clear()
        ..addAll(rebuilt);
      _selected.clear();
    });
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
    final local = _toLocal(details.globalPosition);
    String? hitId;
    for (final item in _items.reversed) {
      final rect = Rect.fromLTWH(item.position.dx, item.position.dy,
          item.size.width, item.size.height);
      if (rect.contains(local)) {
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

    if (hitId != null) {
      additive ? _toggleSelect(hitId) : _selectOnly(hitId);
    } else {
      _clearSelection();
    }
  }

  Size _canvasSize() {
    final rb = _canvasBoxKey.currentContext?.findRenderObject() as RenderBox?;
    return rb?.size ?? const Size(1, 1);
  }

  @override
  Widget build(BuildContext context) {
    // Keyboard shortcuts using new KeyEvent system
    final shortcuts = <ShortcutActivator, Intent>{
      const SingleActivator(LogicalKeyboardKey.delete): const DeleteIntent(),
      const SingleActivator(LogicalKeyboardKey.backspace): const DeleteIntent(),
      const SingleActivator(LogicalKeyboardKey.keyD, control: true):
          const DuplicateIntent(),
      const SingleActivator(LogicalKeyboardKey.keyD, meta: true):
          const DuplicateIntent(),
      const SingleActivator(LogicalKeyboardKey.keyA, control: true):
          const SelectAllIntent(),
      const SingleActivator(LogicalKeyboardKey.keyA, meta: true):
          const SelectAllIntent(),
      const SingleActivator(LogicalKeyboardKey.arrowLeft):
          const NudgeLeftIntent(),
      const SingleActivator(LogicalKeyboardKey.arrowRight):
          const NudgeRightIntent(),
      const SingleActivator(LogicalKeyboardKey.arrowUp): const NudgeUpIntent(),
      const SingleActivator(LogicalKeyboardKey.arrowDown):
          const NudgeDownIntent(),
      const SingleActivator(LogicalKeyboardKey.arrowLeft, shift: true):
          const NudgeLeftBigIntent(),
      const SingleActivator(LogicalKeyboardKey.arrowRight, shift: true):
          const NudgeRightBigIntent(),
      const SingleActivator(LogicalKeyboardKey.arrowUp, shift: true):
          const NudgeUpBigIntent(),
      const SingleActivator(LogicalKeyboardKey.arrowDown, shift: true):
          const NudgeDownBigIntent(),
    };

    return Row(children: [
      // Sidebar
      SizedBox(
        width: widget.sidebarWidth,
        child: DecoratedBox(
          decoration: BoxDecoration(
              color: Colors.grey.shade100,
              border: Border(right: BorderSide(color: Colors.grey.shade300))),
          child: ListView.separated(
            padding: const EdgeInsets.all(8),
            itemCount: widget.palette.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, i) => _paletteDraggable(widget.palette[i]),
          ),
        ),
      ),

      // Canvas + overlay
      Expanded(
        child: Focus(
          autofocus: true,
          child: Shortcuts(
            shortcuts: shortcuts,
            child: Actions(
              actions: <Type, Action<Intent>>{
                DeleteIntent: CallbackAction<DeleteIntent>(onInvoke: (_) {
                  _deleteSelected();
                  return null;
                }),
                DuplicateIntent: CallbackAction<DuplicateIntent>(onInvoke: (_) {
                  _duplicateSelected();
                  return null;
                }),
                SelectAllIntent: CallbackAction<SelectAllIntent>(onInvoke: (_) {
                  setState(() => _selected
                    ..clear()
                    ..addAll(_items.map((e) => e.id)));
                  _notify();
                  return null;
                }),
                NudgeLeftIntent: CallbackAction<NudgeLeftIntent>(onInvoke: (_) {
                  _panSelected(const Offset(-1, 0));
                  return null;
                }),
                NudgeRightIntent:
                    CallbackAction<NudgeRightIntent>(onInvoke: (_) {
                  _panSelected(const Offset(1, 0));
                  return null;
                }),
                NudgeUpIntent: CallbackAction<NudgeUpIntent>(onInvoke: (_) {
                  _panSelected(const Offset(0, -1));
                  return null;
                }),
                NudgeDownIntent: CallbackAction<NudgeDownIntent>(onInvoke: (_) {
                  _panSelected(const Offset(0, 1));
                  return null;
                }),
                NudgeLeftBigIntent:
                    CallbackAction<NudgeLeftBigIntent>(onInvoke: (_) {
                  _panSelected(const Offset(-10, 0));
                  return null;
                }),
                NudgeRightBigIntent:
                    CallbackAction<NudgeRightBigIntent>(onInvoke: (_) {
                  _panSelected(const Offset(10, 0));
                  return null;
                }),
                NudgeUpBigIntent:
                    CallbackAction<NudgeUpBigIntent>(onInvoke: (_) {
                  _panSelected(const Offset(0, -10));
                  return null;
                }),
                NudgeDownBigIntent:
                    CallbackAction<NudgeDownBigIntent>(onInvoke: (_) {
                  _panSelected(const Offset(0, 10));
                  return null;
                }),
              },
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final canvas = GestureDetector(
                    behavior: HitTestBehavior.deferToChild,
                    onTapDown: _handleTapDownOnCanvas,
                    child: RepaintBoundary(
                      key: _repaintKey,
                      child: Container(
                        key: _canvasBoxKey,
                        color: widget.canvasBackground,
                        child: DragTarget<CanvasPaletteImage>(
                          onWillAccept: (_) => true,
                          onAcceptWithDetails: (details) {
                            final local = _toLocal(details.offset);
                            final pal = details.data;
                            final size =
                                pal.preferredSize ?? const Size(160, 160);
                            _addItem(CanvasItem(
                              id: _id(),
                              imageId: pal.id,
                              provider: pal.provider,
                              position: local -
                                  Offset(size.width / 2, size.height / 2),
                              size: size,
                            ));
                          },
                          builder: (context, _, __) {
                            final canvasSize = Size(
                                constraints.maxWidth, constraints.maxHeight);
                            return Stack(children: [
                              for (final item in _items)
                                _CanvasItemWidget(
                                  key: ValueKey(item.id),
                                  item: item,
                                  canvasSize: canvasSize,
                                  isSelected: _isSelected(item.id),
                                  onPanMove: _panSelected,
                                  onResizeCommit: (updated) {
                                    setState(() {
                                      final idx = _items
                                          .indexWhere((e) => e.id == item.id);
                                      if (idx != -1) _items[idx] = updated;
                                    });
                                    _notify();
                                  },
                                ),
                            ]);
                          },
                        ),
                      ),
                    ),
                  );

                  return Stack(children: [
                    // Canvas area
                    Positioned.fill(child: canvas),

                    // Actions bar overlay. Outside the canvas GestureDetector, so clicks do not clear selection.
                    if (_selected.isNotEmpty)
                      Positioned(
                        left: 16,
                        top: 16,
                        child: _ActionsBar(
                          count: _selected.length,
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
                          onLockToggle: _toggleLockSelected,
                        ),
                      ),
                  ]);
                },
              ),
            ),
          ),
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
              child: Image(image: provider, fit: BoxFit.cover)),
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
                    child: Image(image: provider, fit: BoxFit.cover))),
          ),
        ),
      );
}

// ————— Item widget —————
class _CanvasItemWidget extends StatefulWidget {
  const _CanvasItemWidget({
    super.key,
    required this.item,
    required this.canvasSize,
    required this.isSelected,
    required this.onPanMove,
    required this.onResizeCommit,
  });

  final CanvasItem item;
  final Size canvasSize;
  final bool isSelected;
  final void Function(Offset delta) onPanMove; // move ALL selected
  final void Function(CanvasItem updated)
      onResizeCommit; // resize only this item

  @override
  State<_CanvasItemWidget> createState() => _CanvasItemWidgetState();
}

class _CanvasItemWidgetState extends State<_CanvasItemWidget> {
  static const double _handleSize = 14;
  static const double _minSize = 40;

  late CanvasItem _item;

  @override
  void initState() {
    super.initState();
    _item = widget.item.copy();
  }

  @override
  void didUpdateWidget(covariant _CanvasItemWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    _item = widget.item.copy();
  }

  void _resizeFromCorner(Offset delta, _Corner corner) {
    if (_item.locked) return;
    double left = _item.position.dx;
    double top = _item.position.dy;
    double width = _item.size.width;
    double height = _item.size.height;

    switch (corner) {
      case _Corner.topLeft:
        left += delta.dx;
        top += delta.dy;
        width -= delta.dx;
        height -= delta.dy;
        break;
      case _Corner.topRight:
        top += delta.dy;
        width += delta.dx;
        height -= delta.dy;
        break;
      case _Corner.bottomLeft:
        left += delta.dx;
        width -= delta.dx;
        height += delta.dy;
        break;
      case _Corner.bottomRight:
        width += delta.dx;
        height += delta.dy;
        break;
    }

    width = width.clamp(_minSize, widget.canvasSize.width);
    height = height.clamp(_minSize, widget.canvasSize.height);

    left = left.clamp(0, widget.canvasSize.width - width);
    top = top.clamp(0, widget.canvasSize.height - height);

    setState(() {
      _item
        ..position = Offset(left, top)
        ..size = Size(width, height);
    });
    widget.onResizeCommit(_item);
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: _item.position.dx,
      top: _item.position.dy,
      width: _item.size.width,
      height: _item.size.height,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onPanUpdate: (d) {
          if (!widget.isSelected || _item.locked) return;
          widget.onPanMove(d.delta);
        },
        child: Stack(
          clipBehavior: Clip.hardEdge,
          children: [
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  border: widget.isSelected
                      ? Border.all(color: Colors.blueAccent, width: 1)
                      : null,
                  color: Colors.white,
                ),
                child: Image(image: _item.provider, fit: BoxFit.contain),
              ),
            ),
            if (widget.isSelected && !_item.locked) ...[
              _handle(Alignment.topLeft, _Corner.topLeft),
              _handle(Alignment.topRight, _Corner.topRight),
              _handle(Alignment.bottomLeft, _Corner.bottomLeft),
              _handle(Alignment.bottomRight, _Corner.bottomRight),
            ],
            if (_item.locked)
              Align(
                alignment: Alignment.topLeft,
                child: Container(
                  margin: const EdgeInsets.all(2),
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(4)),
                  child: const Icon(Icons.lock, size: 12, color: Colors.white),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _handle(Alignment align, _Corner corner) => Align(
        alignment: align,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onPanUpdate: (d) => _resizeFromCorner(d.delta, corner),
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
      );
}

enum _Corner { topLeft, topRight, bottomLeft, bottomRight }

// ————— Actions bar —————
class _ActionsBar extends StatelessWidget {
  const _ActionsBar({
    required this.count,
    required this.onDelete,
    required this.onDuplicate,
    required this.onFront,
    required this.onBack,
    required this.onAlignLeft,
    required this.onAlignHCenter,
    required this.onAlignRight,
    required this.onAlignTop,
    required this.onAlignVCenter,
    required this.onAlignBottom,
    required this.onLockToggle,
  });

  final int count;
  final VoidCallback onDelete;
  final VoidCallback onDuplicate;
  final VoidCallback onFront;
  final VoidCallback onBack;
  final VoidCallback onAlignLeft;
  final VoidCallback onAlignHCenter;
  final VoidCallback onAlignRight;
  final VoidCallback onAlignTop;
  final VoidCallback onAlignVCenter;
  final VoidCallback onAlignBottom;
  final VoidCallback onLockToggle;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(blurRadius: 8, color: Colors.black26)],
        border: Border.all(color: Colors.black12),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Text('$count selected',
                  style: const TextStyle(fontWeight: FontWeight.w600)),
            ),
            IconButton(
                tooltip: 'Delete',
                icon: const Icon(Icons.delete_outline),
                onPressed: onDelete),
            IconButton(
                tooltip: 'Duplicate',
                icon: const Icon(Icons.control_point_duplicate_outlined),
                onPressed: onDuplicate),
            const VerticalDivider(width: 12),
            IconButton(
                tooltip: 'Bring to front',
                icon: const Icon(Icons.flip_to_front_outlined),
                onPressed: onFront),
            IconButton(
                tooltip: 'Send to back',
                icon: const Icon(Icons.flip_to_back_outlined),
                onPressed: onBack),
            const VerticalDivider(width: 12),
            IconButton(
                tooltip: 'Align left',
                icon: const Icon(Icons.align_horizontal_left),
                onPressed: onAlignLeft),
            IconButton(
                tooltip: 'Align H center',
                icon: const Icon(Icons.align_horizontal_center),
                onPressed: onAlignHCenter),
            IconButton(
                tooltip: 'Align right',
                icon: const Icon(Icons.align_horizontal_right),
                onPressed: onAlignRight),
            IconButton(
                tooltip: 'Align top',
                icon: const Icon(Icons.align_vertical_top),
                onPressed: onAlignTop),
            IconButton(
                tooltip: 'Align V center',
                icon: const Icon(Icons.align_vertical_center),
                onPressed: onAlignVCenter),
            IconButton(
                tooltip: 'Align bottom',
                icon: const Icon(Icons.align_vertical_bottom),
                onPressed: onAlignBottom),
            const VerticalDivider(width: 12),
            IconButton(
                tooltip: 'Lock or unlock',
                icon: const Icon(Icons.lock_open),
                onPressed: onLockToggle),
          ],
        ),
      ),
    );
  }
}

// ————— Helpers —————
String _id() => DateTime.now().microsecondsSinceEpoch.toString();

Map<String, dynamic>? _serializeProvider(ImageProvider provider) {
  if (provider is NetworkImage) return {'type': 'network', 'url': provider.url};
  if (provider is AssetImage)
    return {
      'type': 'asset',
      'name': provider.assetName,
      if (provider.package != null) 'package': provider.package
    };
  return null;
}

ImageProvider? _deserializeProvider(dynamic src) {
  if (src is! Map) return null;
  final type = src['type'];
  switch (type) {
    case 'network':
      final url = src['url'] as String?;
      if (url == null || url.isEmpty) return null;
      return NetworkImage(url);
    case 'asset':
      final name = src['name'] as String?;
      if (name == null || name.isEmpty) return null;
      final pkg = src['package'] as String?;
      return AssetImage(name, package: pkg);
    default:
      return null;
  }
}
