import 'package:flutter/material.dart';
import 'package:flutter_meragi_design/src/theme/style.dart';

class MDNavigationRailDecoration extends Style {
  MDNavigationRailDecoration({
    required super.context,
    final EdgeInsets? contentPaddingOverride,
    final Color? backgroundColorOverride,
    final BorderRadius? borderRadiusOverride,
    final double? collapseWidthOverride,
    final double? expandedWidthOverride,
    final Duration? animationDurationOverride,
    final List<BoxShadow>? boxShadowOverride,
  })  : _contentPaddingOverride = contentPaddingOverride,
        _backgroundColorOverride = backgroundColorOverride,
        _borderRadiusOverride = borderRadiusOverride,
        _collapseWidthOverride = collapseWidthOverride,
        _expandedWidthOverride = expandedWidthOverride,
        _boxShadowOverride = boxShadowOverride,
        _animationDurationOverride = animationDurationOverride;

  final EdgeInsets? _contentPaddingOverride;
  final Color? _backgroundColorOverride;
  final BorderRadius? _borderRadiusOverride;
  final double? _collapseWidthOverride;
  final double? _expandedWidthOverride;
  final Duration? _animationDurationOverride;
  final List<BoxShadow>? _boxShadowOverride;

  EdgeInsets get contentPadding => _contentPaddingOverride ?? token.navigationRailcontentPadding;

  Color get backgroundColor => _backgroundColorOverride ?? token.navigationRailBackgroundColor;

  double get collapsedWidth => _collapseWidthOverride ?? token.navigationRailCollapsedWidth;

  double get expandedWidth => _expandedWidthOverride ?? token.navigationRailExpandedWidth;

  BorderRadius get borderRadius => _borderRadiusOverride ?? token.navigationRailBorderRadius;

  Duration get animationDuration => _animationDurationOverride ?? token.navigationRailAnimationDuration;

  List<BoxShadow> get boxShadow => _boxShadowOverride ?? token.navigationRailBoxShadow;

  MDNavigationRailDecoration copyWith({
    final EdgeInsets? contentPaddingOverride,
    final Color? backgroundColorOverride,
    final BorderRadius? borderRadiusOverride,
    final double? collapseWidthOverride,
    final double? expandedWidthOverride,
    final Duration? animationDurationOverride,
    final List<BoxShadow>? boxShadowOverride,
  }) {
    return MDNavigationRailDecoration(
      context: context,
      contentPaddingOverride: contentPaddingOverride ?? contentPadding,
      backgroundColorOverride: backgroundColorOverride ?? backgroundColor,
      borderRadiusOverride: borderRadiusOverride ?? borderRadius,
      collapseWidthOverride: collapseWidthOverride ?? collapsedWidth,
      expandedWidthOverride: expandedWidthOverride ?? expandedWidth,
      animationDurationOverride: animationDurationOverride ?? animationDuration,
      boxShadowOverride: boxShadowOverride ?? boxShadow,
    );
  }

  MDNavigationRailDecoration merge(MDNavigationRailDecoration? other) {
    if (other == null) {
      return this;
    }
    return copyWith(
      contentPaddingOverride: other.contentPadding,
      backgroundColorOverride: other.backgroundColor,
      borderRadiusOverride: other.borderRadius,
      collapseWidthOverride: other.collapsedWidth,
      expandedWidthOverride: other.expandedWidth,
      animationDurationOverride: other.animationDuration,
      boxShadowOverride: other.boxShadow,
    );
  }
}
