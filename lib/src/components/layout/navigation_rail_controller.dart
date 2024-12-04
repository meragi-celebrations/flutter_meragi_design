import 'package:flutter/foundation.dart';

class MDNavigationRailController extends ChangeNotifier implements ValueListenable<bool> {
  bool _isExpanded;
  bool _isHoverable;
  bool _expandedButton;

  MDNavigationRailController({
    final bool isExpanded = false,
    final bool isHoverable = false,
    final bool expandedButton = true,
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

  void setExpandedButton(bool newValue, {bool notifyListener = true}) {
    if (_expandedButton == newValue) return;

    _expandedButton = newValue;
    if (notifyListener) notifyListeners();
  }

  @override
  bool get value => _isExpanded;
}
