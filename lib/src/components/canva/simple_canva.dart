// lib/src/components/canva/simple_canva.dart
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_meragi_design/src/components/canva/canvas_workspace.dart';
import 'package:flutter_meragi_design/src/components/canva/items/base.dart';
import 'package:flutter_meragi_design/src/components/canva/items/registered_items.dart';
import 'package:flutter_meragi_design/src/components/canva/palette_sidebar.dart';
import 'package:flutter_meragi_design/src/components/canva/simple_canva_controller.dart';
import 'package:flutter_meragi_design/src/components/canva/ui/dialog_manager.dart';
import 'package:flutter_meragi_design/src/components/canva/ui/dialog_manager_scope.dart';

import 'canvas_doc.dart';
import 'canvas_scope.dart';
import 'property_sidebar.dart';

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

class _SimpleCanvaState extends State<SimpleCanva> {
  final GlobalKey _repaintKey = GlobalKey();
  final GlobalKey _canvasBoxKey = GlobalKey();

  late final CanvasDoc _doc;
  late final DialogManager _dialogManager;

  @override
  void initState() {
    super.initState();
    registerBuiltInCanvasItems();
    _doc = CanvasDoc(
      baseSize: widget.baseCanvasSize,
      canvasColor: widget.initialCanvasColor,
    );
    _dialogManager = DialogManager();
    _dialogManager.addListener(() => setState(() {}));
    widget.controller?.doc = _doc;
    widget.controller?.exportAsPngFunc = _exportAsPng;
    if (widget.onChanged != null) {
      _doc.addListener(() => widget.onChanged?.call(_doc.items));
    }
  }

  @override
  void didUpdateWidget(covariant SimpleCanva oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      widget.controller?.doc = _doc;
      widget.controller?.exportAsPngFunc = _exportAsPng;
    }
  }

  @override
  void dispose() {
    _doc.dispose();
    _dialogManager.dispose();
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

  @override
  Widget build(BuildContext context) {
    // IMPORTANT: read doc via CanvasScope to make this subtree reactive
    return DialogManagerScope(
      manager: _dialogManager,
      child: CanvasScope(
        doc: _doc,
        child: Focus(
          autofocus: true,
          child: Shortcuts(
            shortcuts: <LogicalKeySet, Intent>{
              LogicalKeySet(LogicalKeyboardKey.meta, LogicalKeyboardKey.keyZ):
                  const UndoIntent(),
              LogicalKeySet(
                      LogicalKeyboardKey.control, LogicalKeyboardKey.keyZ):
                  const UndoIntent(),
              LogicalKeySet(LogicalKeyboardKey.meta, LogicalKeyboardKey.shift,
                  LogicalKeyboardKey.keyZ): const RedoIntent(),
              LogicalKeySet(
                  LogicalKeyboardKey.control,
                  LogicalKeyboardKey.shift,
                  LogicalKeyboardKey.keyZ): const RedoIntent(),
              LogicalKeySet(
                      LogicalKeyboardKey.control, LogicalKeyboardKey.keyY):
                  const RedoIntent(),
            },
            child: Actions(
              actions: <Type, Action<Intent>>{
                UndoIntent: CallbackAction<UndoIntent>(
                  onInvoke: (UndoIntent intent) => _doc.undo(),
                ),
                RedoIntent: CallbackAction<RedoIntent>(
                  onInvoke: (RedoIntent intent) => _doc.redo(),
                ),
              },
              child: Row(children: [
                // Sidebar
                PaletteSidebar(
                  palette: widget.palette,
                  sidebarWidth: widget.sidebarWidth,
                ),

                // Workspace and centered canvas
                CanvasWorkspace(
                  doc: _doc,
                  workspaceColor: widget.workspaceColor,
                  repaintKey: _repaintKey,
                  canvasBoxKey: _canvasBoxKey,
                  toLocal: _toLocal,
                ),

                // Right sidebar
                SizedBox(
                  width: widget.inspectorWidth,
                  child: const PropertiesSidebar(),
                ),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
