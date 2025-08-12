import 'dart:convert';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class SimpleCanva extends StatefulWidget {
  const SimpleCanva({
    super.key,
    required this.palette,
    this.controller,
    this.sidebarWidth = 120,
    this.canvasBackground = const Color(0xFFF7F7F7),
    this.onChanged,
    this.showDeleteOnSelect = true,
  });

  final List<CanvasPaletteImage> palette;
  final SimpleCanvaController? controller;
  final double sidebarWidth;
  final Color canvasBackground;
  final ValueChanged<List<CanvasItem>>? onChanged;
  final bool showDeleteOnSelect;

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

  Future<Uint8List?> exportAsPng({double pixelRatio = 3}) async {
    return _state?._exportAsPng(pixelRatio: pixelRatio);
  }

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
}

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

class CanvasItem {
  final String id;
  final String? imageId; // id from palette when applicable
  final ImageProvider provider;
  Offset position;
  Size size;
  bool selected;

  CanvasItem({
    required this.id,
    required this.imageId,
    required this.provider,
    required this.position,
    required this.size,
    this.selected = false,
  });

  CanvasItem copy() => CanvasItem(
        id: id,
        imageId: imageId,
        provider: provider,
        position: position,
        size: size,
        selected: selected,
      );

  Map<String, dynamic> toJson(int zIndex) => {
        'id': id,
        if (imageId != null) 'imageId': imageId,
        'x': position.dx,
        'y': position.dy,
        'w': size.width,
        'h': size.height,
        'z': zIndex,
        'src': _serializeProvider(provider),
      };

  static CanvasItem fromJson(
    Map<String, dynamic> json,
    ImageProvider resolvedProvider,
  ) {
    return CanvasItem(
      id: (json['id'] as String?) ?? _id(),
      imageId: json['imageId'] as String?,
      provider: resolvedProvider,
      position: Offset(
        (json['x'] as num?)?.toDouble() ?? 0,
        (json['y'] as num?)?.toDouble() ?? 0,
      ),
      size: Size(
        (json['w'] as num?)?.toDouble() ?? 100,
        (json['h'] as num?)?.toDouble() ?? 100,
      ),
      selected: false,
    );
  }
}

class _SimpleCanvaState extends State<SimpleCanva> {
  final GlobalKey _repaintKey = GlobalKey();
  final GlobalKey _canvasBoxKey = GlobalKey();

  final List<CanvasItem> _items = [];
  String? _selectedId;

  Map<String, CanvasPaletteImage> get _paletteById => {
        for (final p in widget.palette) p.id: p,
      };

  @override
  void initState() {
    super.initState();
    widget.controller?._state = this;
  }

  @override
  void didUpdateWidget(covariant SimpleCanva oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      widget.controller?._state = this;
    }
  }

  void _notify() => widget.onChanged?.call(List.unmodifiable(_items));

  void _clearSelection() {
    setState(() {
      for (final it in _items) {
        it.selected = false;
      }
      _selectedId = null;
    });
  }

  void _select(String id) {
    setState(() {
      for (final it in _items) {
        it.selected = it.id == id;
      }
      _selectedId = id;
      final idx = _items.indexWhere((e) => e.id == id);
      if (idx != -1) {
        final it = _items.removeAt(idx);
        _items.add(it); // bring to top
      }
    });
  }

  void _removeSelected() {
    if (_selectedId == null) return;
    setState(() {
      _items.removeWhere((e) => e.id == _selectedId);
      _selectedId = null;
    });
    _notify();
  }

  void _addItem(CanvasItem item) {
    setState(() {
      _items.add(item);
      _selectedId = item.id;
      for (final it in _items) {
        it.selected = it.id == _selectedId;
      }
    });
    _notify();
  }

  void _clear() {
    setState(() {
      _items.clear();
      _selectedId = null;
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

  void _handleCanvasTapDown(TapDownDetails details) {
    final local = _toLocal(details.globalPosition);
    // hit-test from topmost to bottom
    for (final item in _items.reversed) {
      final rect = Rect.fromLTWH(
        item.position.dx,
        item.position.dy,
        item.size.width,
        item.size.height,
      );
      if (rect.contains(local)) {
        _select(item.id);
        return;
      }
    }
    _clearSelection();
  }

  Map<String, dynamic> _toJsonDocument() {
    return {
      'version': 1,
      'items': [
        for (int i = 0; i < _items.length; i++) _items[i].toJson(i),
      ],
    };
  }

  void _loadFromJsonDocument(Map<String, dynamic> doc) {
    final rawItems = (doc['items'] as List?)?.cast<Map<String, dynamic>>() ??
        <Map<String, dynamic>>[];
    final rebuilt = <CanvasItem>[];

    for (final j in rawItems) {
      final imageId = j['imageId'] as String?;
      ImageProvider? provider;

      if (imageId != null && _paletteById.containsKey(imageId)) {
        provider = _paletteById[imageId]!.provider;
      }
      provider ??= _deserializeProvider(j['src']);
      if (provider == null) {
        debugPrint('Skipping item because provider could not be resolved: $j');
        continue;
      }
      rebuilt.add(CanvasItem.fromJson(j, provider));
    }

    setState(() {
      _items
        ..clear()
        ..addAll(rebuilt);
      _selectedId = null;
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

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Sidebar palette
        SizedBox(
          width: widget.sidebarWidth,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              border: Border(
                right: BorderSide(color: Colors.grey.shade300),
              ),
            ),
            child: ListView.separated(
              padding: const EdgeInsets.all(8),
              itemCount: widget.palette.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) =>
                  _paletteDraggable(widget.palette[index]),
            ),
          ),
        ),
        // Canvas
        Expanded(
          child: GestureDetector(
            behavior: HitTestBehavior.deferToChild,
            onTapDown: _handleCanvasTapDown,
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
                    final size = pal.preferredSize ?? const Size(160, 160);
                    final id = _id();
                    _addItem(CanvasItem(
                      id: id,
                      imageId: pal.id,
                      provider: pal.provider,
                      position: local - Offset(size.width / 2, size.height / 2),
                      size: size,
                    ));
                  },
                  builder: (context, candidateData, rejectedData) {
                    return LayoutBuilder(
                      builder: (context, constraints) {
                        final canvasSize =
                            Size(constraints.maxWidth, constraints.maxHeight);
                        return Stack(
                          children: [
                            for (final item in _items)
                              _CanvasItemWidget(
                                key: ValueKey(item.id),
                                item: item,
                                canvasSize: canvasSize,
                                onChanged: (updated) {
                                  setState(() {
                                    final idx = _items
                                        .indexWhere((e) => e.id == item.id);
                                    if (idx != -1) {
                                      _items[idx] = updated;
                                    }
                                  });
                                  _notify();
                                },
                              ),
                            if (widget.showDeleteOnSelect &&
                                _selectedId != null)
                              Positioned(
                                right: 12,
                                top: 12,
                                child: ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.redAccent,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 8),
                                  ),
                                  onPressed: _removeSelected,
                                  icon: const Icon(Icons.delete),
                                  label: const Text('Delete'),
                                ),
                              ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _thumb(ImageProvider provider) {
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
          child: Image(image: provider, fit: BoxFit.cover),
        ),
      ),
    );
  }

  Widget _dragFeedback(ImageProvider provider) {
    return Material(
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
                opacity: 0.9, child: Image(image: provider, fit: BoxFit.cover)),
          ),
        ),
      ),
    );
  }
}

class _CanvasItemWidget extends StatefulWidget {
  const _CanvasItemWidget({
    super.key,
    required this.item,
    required this.canvasSize,
    required this.onChanged,
  });

  final CanvasItem item;
  final Size canvasSize;
  final ValueChanged<CanvasItem> onChanged;

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

  void _commit() => widget.onChanged(_item);

  void _move(Offset delta) {
    final maxX = widget.canvasSize.width - _item.size.width;
    final maxY = widget.canvasSize.height - _item.size.height;
    final next = _item.position + delta;
    _item.position = Offset(
      next.dx.clamp(0, maxX),
      next.dy.clamp(0, maxY),
    );
  }

  void _resizeFromCorner(Offset delta, _Corner corner) {
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

    _item
      ..position = Offset(left, top)
      ..size = Size(width, height);
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
        onPanStart: (_) {
          // ensure it's selected when a drag starts
          _item.selected = true;
          _commit();
        },
        onPanUpdate: (d) {
          if (!_item.selected) return;
          setState(() => _move(d.delta));
          _commit();
        },
        child: Stack(
          clipBehavior: Clip.hardEdge,
          children: [
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  border: _item.selected
                      ? Border.all(color: Colors.blueAccent, width: 1)
                      : null,
                  color: Colors.white,
                ),
                child: Image(image: _item.provider, fit: BoxFit.contain),
              ),
            ),
            if (_item.selected) ...[
              _handle(Alignment.topLeft, _Corner.topLeft),
              _handle(Alignment.topRight, _Corner.topRight),
              _handle(Alignment.bottomLeft, _Corner.bottomLeft),
              _handle(Alignment.bottomRight, _Corner.bottomRight),
            ],
          ],
        ),
      ),
    );
  }

  Widget _handle(Alignment align, _Corner corner) {
    return Align(
      alignment: align,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onPanStart: (_) {
          _item.selected = true;
          _commit();
        },
        onPanUpdate: (d) {
          setState(() => _resizeFromCorner(d.delta, corner));
          _commit();
        },
        child: Container(
          width: _handleSize,
          height: _handleSize,
          margin: const EdgeInsets.all(1.5),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.blueAccent, width: 1),
            boxShadow: const [BoxShadow(blurRadius: 2, color: Colors.black26)],
          ),
        ),
      ),
    );
  }
}

enum _Corner { topLeft, topRight, bottomLeft, bottomRight }

String _id() => DateTime.now().microsecondsSinceEpoch.toString();

Map<String, dynamic>? _serializeProvider(ImageProvider provider) {
  if (provider is NetworkImage) {
    return {
      'type': 'network',
      'url': provider.url,
    };
  }
  if (provider is AssetImage) {
    return {
      'type': 'asset',
      'name': provider.assetName,
      if (provider.package != null) 'package': provider.package,
    };
  }
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
