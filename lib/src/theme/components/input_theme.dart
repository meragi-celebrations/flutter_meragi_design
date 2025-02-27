import 'dart:ui';

import 'package:flutter/material.dart';

@immutable
class MDInputTheme {
  final EdgeInsetsGeometry? padding;
  final Color? selectionColor;
  final Color? cursorColor;
  final Color? borderColor;
  final double? borderRadius;
  final double? height;
  final TextStyle? textStyle;

  const MDInputTheme({
    this.padding,
    this.selectionColor,
    this.cursorColor,
    this.borderColor,
    this.borderRadius,
    this.height,
    this.textStyle,
  });

  MDInputTheme copyWith({
    EdgeInsetsGeometry? padding,
    Color? selectionColor,
    Color? cursorColor,
    Color? borderColor,
    double? borderRadius,
    double? height,
    TextStyle? textStyle,
  }) {
    return MDInputTheme(
      padding: padding ?? this.padding,
      selectionColor: selectionColor ?? this.selectionColor,
      cursorColor: cursorColor ?? this.cursorColor,
      borderColor: borderColor ?? this.borderColor,
      borderRadius: borderRadius ?? this.borderRadius,
      height: height ?? this.height,
      textStyle: textStyle ?? this.textStyle,
    );
  }

  MDInputTheme lerp(MDInputTheme? other, double t) {
    if (other is! MDInputTheme) {
      return this;
    }
    return MDInputTheme(
      padding: EdgeInsetsGeometry.lerp(padding, other.padding, t),
      selectionColor: Color.lerp(selectionColor, other.selectionColor, t),
      cursorColor: Color.lerp(cursorColor, other.cursorColor, t),
      borderColor: Color.lerp(borderColor, other.borderColor, t),
      borderRadius: lerpDouble(borderRadius, other.borderRadius, t),
      height: lerpDouble(height, other.height, t),
      textStyle: TextStyle.lerp(textStyle, other.textStyle, t),
    );
  }

  MDInputTheme merge(MDInputTheme? other) {
    if (other == null) return this;

    return MDInputTheme(
      padding: other.padding ?? padding,
      selectionColor: other.selectionColor ?? selectionColor,
      cursorColor: other.cursorColor ?? cursorColor,
      borderColor: other.borderColor ?? borderColor,
      borderRadius: other.borderRadius ?? borderRadius,
      height: other.height ?? height,
      textStyle: other.textStyle ?? textStyle,
    );
  }
}

// MDInputTheme standardInputTheme = MDInputTheme(
//   height: ,
//   borderRadius: ,
//   padding: ,
//   borderColor: ,
//   cursorColor: ,
//   selectionColor: ,
//   textStyle: ,
// );
