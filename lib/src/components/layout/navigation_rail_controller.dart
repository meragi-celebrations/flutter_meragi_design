import 'package:flutter/foundation.dart';

class MDNavigationRailController extends ChangeNotifier implements ValueListenable<bool> {
  bool _isExpanded;
  bool _isHoverable;
  bool _expandedButton;

  MDNavigationRailController({
    final bool isExpanded = false,
    final bool isHoverable = false,
    final bool expandedButton = false,
  })  : _isHoverable = isHoverable,
        _isExpanded = isExpanded,
        _expandedButton = expandedButton;

  bool get isHoverable => _isHoverable;
  bool get isExpanded => _isExpanded;
  bool get expandedButton => _expandedButton;

  void open({bool notifyListener = true}) {
    _isExpanded = true;
    if (notifyListener) notifyListeners();
  }

  void close({bool notifyListener = true}) {
    _isExpanded = false;
    if (notifyListener) notifyListeners();
  }

  void setHoverable(bool newValue, {bool notifyListener = true}) {
    if (_isHoverable == newValue) return;

    _isHoverable = newValue;
    if (notifyListener) notifyListeners();
  }

  void setExpandedButton(bool newValue,
      {bool notifyListener = true,

      /// Useful for case if you are using [MDNavigationRail.builder]
      /// This will wrap your builder with [Expanded], [Flexible], or nothing.
      /// This is because it wraps [setExpandedButton] and [MDNavigationRail.builder] into
      /// a column which may or may not break the layout if you are using some scroll widgets like
      /// [SingleChildScrollView] or [CustomScrollView]
      BuilderFlexType type = BuilderFlexType.expanded}) {
    if (_expandedButton == newValue) return;

    _expandedButton = newValue;
    if (notifyListener) notifyListeners();
  }

  @override
  bool get value => _isExpanded;
}

enum BuilderFlexType { expanded, flexible, none }
