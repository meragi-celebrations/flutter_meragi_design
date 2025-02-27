import 'package:flutter/material.dart';
import 'package:flutter_meragi_design/src/theme/style.dart';

enum MDInputType { primary, secondary, tertiary, error, success, warning, info, disabled }

class MDInputDecoration extends Style {
  final MDInputType type;

  MDInputDecoration({
    required super.context,
    this.type = MDInputType.secondary,
    Color? selectionColorOverride,
    Color? cursorColorOverride,
    EdgeInsets? paddingOverride,
    Color? borderColorOverride,
    double? borderRadiusOverride,
  })  : _selectionColorOverride = selectionColorOverride,
        _cursorColorOverride = cursorColorOverride,
        _paddingOverride = paddingOverride,
        _borderColorOverride = borderColorOverride,
        _borderRadiusOverride = borderRadiusOverride;

  final Color? _selectionColorOverride;
  final Color? _cursorColorOverride;
  final EdgeInsets? _paddingOverride;
  final Color? _borderColorOverride;
  final double? _borderRadiusOverride;

  @override
  Map get styles => {};

  Color get selectionColor => _selectionColorOverride ?? token.secondaryColor.withOpacity(.3);

  Color get cursorColor => _cursorColorOverride ?? token.secondaryColor;

  EdgeInsets get padding => _paddingOverride ?? EdgeInsets.symmetric(horizontal: token.padding);

  Color get borderColor => _borderColorOverride ?? token.borderColor;

  double get borderRadius => _borderRadiusOverride ?? token.radius;
}
