import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_meragi_design/src/components/canva/items/base.dart';
import 'package:flutter_meragi_design/src/components/canva/items/palette.dart';
import 'package:flutter_meragi_design/src/components/canva/items/text.dart';

import 'canvas_doc.dart';
import 'utils.dart';

class SimpleCanvaController {
  CanvasDoc? doc;
  Future<Uint8List?> Function({double pixelRatio})? exportAsPngFunc;

  List<CanvasItem> get items => List.unmodifiable(doc?.items ?? const []);

  void clear() {
    final d = doc;
    if (d == null) return;
    d.beginUndoGroup('Clear');
    d.applyPatch([
      for (final it in d.items) {'type': 'remove', 'id': it.id},
      {'type': 'selection.set', 'ids': <String>[]},
    ]);
    d.commitUndoGroup();
  }

  void addImageFromSrc(String srcUri, {Offset? position, Size? size}) {
    final d = doc;
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
    String text = 'Add a Text',
    Offset? position,
    Size? size,
    double fontSize = 24,
    Color color = Colors.black,
    FontWeight weight = FontWeight.w600,
    String? fontFamily,
  }) {
    final d = doc;
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
    final d = doc;
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
    doc?.applyPatch([
      {
        'type': 'canvas.update',
        'changes': {'color': colorToHex(color)}
      }
    ]);
  }

  Future<Uint8List?> exportAsPng({double pixelRatio = 3}) async =>
      exportAsPngFunc?.call(pixelRatio: pixelRatio);

  Map<String, dynamic> exportAsMap() {
    final d = doc;
    if (d == null) {
      return {
        'version': 1,
        'items': [],
        'canvas': {'color': colorToHex(Colors.white)}
      };
    }
    return d.toJson();
  }

  String exportAsJson({bool pretty = false}) {
    final d = doc;
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
    final d = doc;
    if (d == null) return;
    try {
      final map = jsonDecode(jsonString) as Map<String, dynamic>;
      d.loadFromJson(map);
    } catch (e) {
      debugPrint('loadFromJson error: $e');
    }
  }

  void deleteSelected() {
    final d = doc;
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

  void undo() => doc?.undo();
  void redo() => doc?.redo();
}

class UndoIntent extends Intent {
  const UndoIntent();
}

class RedoIntent extends Intent {
  const RedoIntent();
}
