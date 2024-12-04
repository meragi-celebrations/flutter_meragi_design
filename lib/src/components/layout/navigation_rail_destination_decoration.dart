import 'package:flutter/material.dart';
import 'package:flutter_meragi_design/src/theme/style.dart';

class MDNavigationRailDestinationDecoration extends Style {
  MDNavigationRailDestinationDecoration({
    required super.context,
    final Color? selectedColorOverride,
    final Color? selectedHoverColorOverride,
    final Color? nonSelectedColorOverride,
    final Color? nonSelectedHoverColorOverride,
  })  : _selectedColorOverride = selectedColorOverride,
        _selectedHoverColorOverride = selectedHoverColorOverride,
        _nonSelectedColorOverride = nonSelectedColorOverride,
        _nonSelectedHoverColorOverride = nonSelectedHoverColorOverride;

  final Color? _selectedColorOverride;
  final Color? _selectedHoverColorOverride;
  final Color? _nonSelectedColorOverride;
  final Color? _nonSelectedHoverColorOverride;

  Color get selectedColor => _selectedColorOverride ?? token.navigationRailDestinationSelectedColor;
  Color get selectedHoverColor => _selectedHoverColorOverride ?? token.navigationRailDestinationSelectedHoverColor;
  Color get nonSelectedColor => _nonSelectedColorOverride ?? token.navigationRailDestinationNonSelectedColor;
  Color get nonSelectedHoverColor =>
      _nonSelectedHoverColorOverride ?? token.navigationRailDestinationNonSelectedHoverColor;

  MDNavigationRailDestinationDecoration copyWith({
    final Color? selectedColorOverride,
    final Color? selectedHoverColorOverride,
    final Color? nonSelectedColorOverride,
    final Color? nonSelectedHoverColorOverride,
  }) {
    return MDNavigationRailDestinationDecoration(
      context: context,
      selectedColorOverride: selectedColorOverride ?? selectedColor,
      selectedHoverColorOverride: selectedHoverColorOverride ?? selectedHoverColor,
      nonSelectedColorOverride: nonSelectedColorOverride ?? nonSelectedColor,
      nonSelectedHoverColorOverride: nonSelectedHoverColorOverride ?? nonSelectedHoverColor,
    );
  }

  MDNavigationRailDestinationDecoration merge(MDNavigationRailDestinationDecoration? other) {
    if (other == null) {
      return this;
    }
    return copyWith(
      selectedColorOverride: other.selectedColor,
      selectedHoverColorOverride: other.selectedHoverColor,
      nonSelectedColorOverride: other.nonSelectedColor,
      nonSelectedHoverColorOverride: other.nonSelectedHoverColor,
    );
  }
}
