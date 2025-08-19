// lib/src/components/canva/canvas_doc.dart
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_meragi_design/src/components/canva/items/base.dart';

import 'utils.dart';

/// Minimal, generic kernel. Widgets compose their own actions using patches.
/// No high-level helpers here.
class CanvasDoc extends ChangeNotifier {
  CanvasDoc({
    required Size baseSize,
    Color canvasColor = Colors.white,
    bool gridVisible = false,
    double gridSpacing = 24,
  })  : _baseSize = baseSize,
        _canvasColor = canvasColor,
        _gridVisible = gridVisible,
        _gridSpacing = gridSpacing;

  // State
  final List<CanvasItem> _items = [];
  final Set<String> _selected = <String>{};
  final List<Color> _documentColors = [];

  Size _baseSize;
  Color _canvasColor;
  bool _gridVisible;
  double _gridSpacing;

  // Read API
  List<CanvasItem> get items => List.unmodifiable(_items);
  Set<String> get selectedIds => Set.unmodifiable(_selected);
  int get selectedCount => _selected.length;
  CanvasItem itemById(String id) => _items.firstWhere((e) => e.id == id);
  Size get baseSize => _baseSize;
  Color get canvasColor => _canvasColor;
  bool get gridVisible => _gridVisible;
  double get gridSpacing => _gridSpacing;
  List<Color> get documentColors => List.unmodifiable(_documentColors);

  // Ids
  String newId() => buildId();

  // History
  final List<String> _undo = [];
  final List<String> _redo = [];
  String? _preGroupSnapshot;
  bool _groupOpen = false;

  void beginUndoGroup(String label) {
    if (_groupOpen) return;
    _preGroupSnapshot = jsonEncode(toJson());
    _groupOpen = true;
  }

  void commitUndoGroup() {
    if (!_groupOpen) return;
    if (_preGroupSnapshot != null) {
      _undo.add(_preGroupSnapshot!);
      if (_undo.length > 100) _undo.removeAt(0);
      _redo.clear();
    }
    _preGroupSnapshot = null;
    _groupOpen = false;
  }

  void rollbackUndoGroup() {
    if (!_groupOpen) return;
    if (_preGroupSnapshot != null) {
      _loadFromJsonInternal(
          jsonDecode(_preGroupSnapshot!) as Map<String, dynamic>);
    }
    _preGroupSnapshot = null;
    _groupOpen = false;
    notifyListeners();
  }

  void undo() {
    if (_undo.isEmpty) return;
    final cur = jsonEncode(toJson());
    final prev = _undo.removeLast();
    _redo.add(cur);
    _loadFromJsonInternal(jsonDecode(prev) as Map<String, dynamic>);
    notifyListeners();
  }

  void redo() {
    if (_redo.isEmpty) return;
    final cur = jsonEncode(toJson());
    final next = _redo.removeLast();
    _undo.add(cur);
    _loadFromJsonInternal(jsonDecode(next) as Map<String, dynamic>);
    notifyListeners();
  }

  /// Apply a batch of generic ops. If no group is open, an implicit one is used.
  ///
  /// Supported ops:
  ///  - {'type':'insert', 'item': <json>, 'index': int?}
  ///  - {'type':'replace', 'item': <json>}  // full replacement by id
  ///  - {'type':'update', 'id':String, 'changes': {'position': {'x':..,'y':..}, 'size': {'w':..,'h':..}, 'rotationDeg': .., 'locked': bool}}
  ///  - {'type':'remove', 'id': String}
  ///  - {'type':'move', 'ids': [..], 'toIndex': int} // group move
  ///  - {'type':'selection.set', 'ids': [..]}
  ///  - {'type':'selection.add', 'ids': [..]}
  ///  - {'type':'selection.remove', 'ids': [..]}
  ///  - {'type':'canvas.update', 'changes': {'base': {'w':..,'h':..}, 'color':'#RRGGBB', 'gridVisible': bool, 'gridSpacing': double}}
  ///  - {'type':'doc.colors.add', 'color': '#RRGGBB'}
  void applyPatch(List<Map<String, dynamic>> ops) {
    final implicit = !_groupOpen;
    if (implicit) beginUndoGroup('Change');

    for (final op in ops) {
      switch (op['type']) {
        case 'insert':
          _opInsert(op);
          break;
        case 'replace':
          _opReplace(op);
          break;
        case 'update':
          _opUpdate(op);
          break;
        case 'remove':
          _opRemove(op);
          break;
        case 'move':
          _opMove(op);
          break;
        case 'selection.set':
          _selected
            ..clear()
            ..addAll(((op['ids'] as List?) ?? const []).cast<String>());
          break;
        case 'selection.add':
          _selected.addAll(((op['ids'] as List?) ?? const []).cast<String>());
          break;
        case 'selection.remove':
          _selected
              .removeAll(((op['ids'] as List?) ?? const []).cast<String>());
          break;
        case 'canvas.update':
          _opCanvasUpdate(op);
          break;
        case 'doc.colors.add':
          _opAddColor(op);
          break;
        default:
          debugPrint('Unknown op: ${op['type']}');
      }
    }

    if (implicit) commitUndoGroup();
    notifyListeners();
  }

  void _opInsert(Map<String, dynamic> op) {
    final itemJson = (op['item'] as Map).cast<String, dynamic>();
    final item = CanvasItem.fromJson(itemJson); // <-- only json
    final index = op['index'] as int?;
    if (index == null || index < 0 || index > _items.length) {
      _items.add(item);
    } else {
      _items.insert(index, item);
    }
  }

  void _opReplace(Map<String, dynamic> op) {
    final itemJson = (op['item'] as Map).cast<String, dynamic>();
    final id = itemJson['id'] as String?;
    if (id == null) return;
    final idx = _items.indexWhere((e) => e.id == id);
    if (idx == -1) return;
    final item = CanvasItem.fromJson(itemJson); // <-- only json
    _items[idx] = item;
  }

  void _opUpdate(Map<String, dynamic> op) {
    final id = op['id'] as String?;
    if (id == null) return;
    final idx = _items.indexWhere((e) => e.id == id);
    if (idx == -1) return;
    final changes =
        (op['changes'] as Map?)?.cast<String, dynamic>() ?? const {};

    var it = _items[idx];

    final pos = (changes['position'] as Map?)?.cast<String, dynamic>();
    if (pos != null) {
      final x = (pos['x'] as num?)?.toDouble();
      final y = (pos['y'] as num?)?.toDouble();
      if (x != null && y != null) {
        it = it.copyWith(position: Offset(x, y));
      }
    }
    final size = (changes['size'] as Map?)?.cast<String, dynamic>();
    if (size != null) {
      final w = (size['w'] as num?)?.toDouble();
      final h = (size['h'] as num?)?.toDouble();
      if (w != null && h != null) {
        it = it.copyWith(size: Size(w < 1 ? 1 : w, h < 1 ? 1 : h));
      }
    }
    final rot = (changes['rotationDeg'] as num?)?.toDouble();
    if (rot != null) {
      it = it.copyWith(rotationDeg: rot % 360);
    }

    final locked = changes['locked'];
    if (locked is bool) {
      it = it.copyWith(locked: locked);
    }

    _items[idx] = it;
  }

  void _opRemove(Map<String, dynamic> op) {
    final id = op['id'] as String?;
    if (id == null) return;
    _items.removeWhere((e) => e.id == id);
    _selected.remove(id);
  }

  void _opMove(Map<String, dynamic> op) {
    final ids = ((op['ids'] as List?) ?? const []).cast<String>();
    final toIndexRaw = (op['toIndex'] as int?) ?? _items.length;
    var toIndex = toIndexRaw.clamp(0, _items.length);
    if (ids.isEmpty) return;

    final moving = <CanvasItem>[];
    _items.removeWhere((e) {
      if (ids.contains(e.id)) {
        moving.add(e);
        return true;
      }
      return false;
    });

    // clamp again after removal
    toIndex = toIndex.clamp(0, _items.length);

    _items.insertAll(toIndex, moving);
  }

  void _opCanvasUpdate(Map<String, dynamic> op) {
    final changes =
        (op['changes'] as Map?)?.cast<String, dynamic>() ?? const {};
    final base = (changes['base'] as Map?)?.cast<String, dynamic>();
    if (base != null) {
      final w = (base['w'] as num?)?.toDouble();
      final h = (base['h'] as num?)?.toDouble();
      if (w != null && w > 0 && h != null && h > 0) {
        _baseSize = Size(w, h);
      }
    }
    final colorHex = changes['color'] as String?;
    if (colorHex != null) {
      final c = hexToColor(colorHex);
      if (c != null) _canvasColor = c;
    }
    final gv = changes['gridVisible'];
    if (gv is bool) _gridVisible = gv;
    final gs = (changes['gridSpacing'] as num?)?.toDouble();
    if (gs != null) _gridSpacing = gs.clamp(2.0, 400.0);
  }

  void _opAddColor(Map<String, dynamic> op) {
    final colorHex = op['color'] as String?;
    if (colorHex == null) return;
    final color = hexToColor(colorHex);
    if (color != null && !_documentColors.contains(color)) {
      _documentColors.add(color);
    }
  }

  // Serialization
  Map<String, dynamic> toJson() => {
        'version': 2,
        'canvas': {
          'base': {'w': _baseSize.width, 'h': _baseSize.height},
          'aspect': _baseSize.width / _baseSize.height,
          'color': colorToHex(_canvasColor),
          'grid': {'visible': _gridVisible, 'spacing': _gridSpacing},
          'docColors': _documentColors.map(colorToHex).toList(),
        },
        'items': [for (int i = 0; i < _items.length; i++) _items[i].toJson(i)],
      };

  void loadFromJson(Map<String, dynamic> doc) {
    _loadFromJsonInternal(doc);
    _selected.clear();
    notifyListeners();
  }

  void _loadFromJsonInternal(Map<String, dynamic> doc) {
    final canvas = (doc['canvas'] as Map?) ?? {};
    final base = (canvas['base'] as Map?)?.cast<String, dynamic>();
    if (base != null) {
      final w = (base['w'] as num?)?.toDouble();
      final h = (base['h'] as num?)?.toDouble();
      if (w != null && h != null && w > 0 && h > 0) _baseSize = Size(w, h);
    }
    final colorHex = canvas['color'] as String?;
    if (colorHex != null) {
      final c = hexToColor(colorHex);
      if (c != null) _canvasColor = c;
    }
    final grid = (canvas['grid'] as Map?)?.cast<String, dynamic>();
    if (grid != null) {
      _gridVisible = (grid['visible'] as bool?) ?? _gridVisible;
      final spacing = (grid['spacing'] as num?)?.toDouble();
      if (spacing != null) _gridSpacing = spacing.clamp(2.0, 400.0);
    }

    final docColors =
        (canvas['docColors'] as List?)?.cast<String>() ?? const [];
    _documentColors
      ..clear()
      ..addAll(docColors.map((e) => hexToColor(e)).whereType<Color>());

    final rawItems =
        (doc['items'] as List?)?.cast<Map<String, dynamic>>() ?? const [];
    _items
      ..clear()
      ..addAll(rawItems.map((j) => CanvasItem.fromJson(j)));
  }
}
