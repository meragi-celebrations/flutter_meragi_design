import 'dart:ui';

import 'package:flutter/material.dart';

@immutable
class MDMarkdownEditorTheme {
  final Color? backgroundColor;
  final Color? borderColor;
  final double? borderRadius;
  final EdgeInsets? padding;
  final TextStyle? textStyle;
  final Color? selectionColor;
  final Color? cursorColor;
  final Color? hoverBackgroundColor;

  const MDMarkdownEditorTheme({
    this.backgroundColor,
    this.borderColor,
    this.borderRadius,
    this.padding,
    this.textStyle,
    this.selectionColor,
    this.cursorColor,
    this.hoverBackgroundColor,
  });

  MDMarkdownEditorTheme copyWith({
    Color? backgroundColor,
    Color? borderColor,
    double? borderRadius,
    EdgeInsets? padding,
    TextStyle? textStyle,
    Color? selectionColor,
    Color? cursorColor,
    Color? hoverBackgroundColor,
  }) {
    return MDMarkdownEditorTheme(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      borderColor: borderColor ?? this.borderColor,
      borderRadius: borderRadius ?? this.borderRadius,
      padding: padding ?? this.padding,
      textStyle: textStyle ?? this.textStyle,
      selectionColor: selectionColor ?? this.selectionColor,
      cursorColor: cursorColor ?? this.cursorColor,
      hoverBackgroundColor: hoverBackgroundColor ?? this.hoverBackgroundColor,
    );
  }

  MDMarkdownEditorTheme lerp(MDMarkdownEditorTheme? other, double t) {
    if (other is! MDMarkdownEditorTheme) {
      return this;
    }
    return MDMarkdownEditorTheme(
      backgroundColor: Color.lerp(backgroundColor, other.backgroundColor, t),
      borderColor: Color.lerp(borderColor, other.borderColor, t),
      borderRadius: lerpDouble(borderRadius, other.borderRadius, t),
      padding: EdgeInsets.lerp(padding, other.padding, t),
      textStyle: TextStyle.lerp(textStyle, other.textStyle, t),
      selectionColor: Color.lerp(selectionColor, other.selectionColor, t),
      cursorColor: Color.lerp(cursorColor, other.cursorColor, t),
    );
  }

  MDMarkdownEditorTheme merge(MDMarkdownEditorTheme? other) {
    if (other == null) return this;

    return MDMarkdownEditorTheme(
      backgroundColor: other.backgroundColor ?? backgroundColor,
      borderColor: other.borderColor ?? borderColor,
      borderRadius: other.borderRadius ?? borderRadius,
      padding: other.padding ?? padding,
      textStyle: other.textStyle ?? textStyle,
      selectionColor: other.selectionColor ?? selectionColor,
      cursorColor: other.cursorColor ?? cursorColor,
    );
  }
} 