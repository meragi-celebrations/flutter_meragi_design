import 'package:flutter/material.dart';

class MDSliderTheme {
  MDSliderTheme({
    this.errorTextStyle,
    this.labelTextStyle,
    this.helperTextStyle,
    this.bubbleTextStyle,
    this.bubbleRadius,
    this.bubbleColor,
    this.activeTrackColor,
    this.inactiveTrackColor,
    this.thumbColor,
    this.secondaryActiveColor,
    this.minMaxLabelTextStyle,
  });

  final Color? bubbleColor;
  final Color? activeTrackColor;
  final Color? inactiveTrackColor;
  final Color? thumbColor;
  final Color? secondaryActiveColor;
  final TextStyle? minMaxLabelTextStyle;
  final TextStyle? errorTextStyle;
  final TextStyle? labelTextStyle;
  final TextStyle? helperTextStyle;
  final TextStyle? bubbleTextStyle;
  final BorderRadiusGeometry? bubbleRadius;

  MDSliderTheme merge({final MDSliderTheme? other}) {
    if (other == null) {
      return this;
    }
    return MDSliderTheme(
      errorTextStyle: other.errorTextStyle ?? errorTextStyle,
      labelTextStyle: other.labelTextStyle ?? labelTextStyle,
      helperTextStyle: other.helperTextStyle ?? helperTextStyle,
      bubbleTextStyle: other.bubbleTextStyle ?? bubbleTextStyle,
      bubbleRadius: other.bubbleRadius ?? bubbleRadius,
      bubbleColor: other.bubbleColor ?? bubbleColor,
      activeTrackColor: other.activeTrackColor ?? activeTrackColor,
      inactiveTrackColor: other.inactiveTrackColor ?? inactiveTrackColor,
      thumbColor: other.thumbColor ?? thumbColor,
      secondaryActiveColor: other.secondaryActiveColor ?? secondaryActiveColor,
      minMaxLabelTextStyle: other.minMaxLabelTextStyle ?? minMaxLabelTextStyle,
    );
  }

  MDSliderTheme copyWith({
    final Color? bubbleColor,
    final Color? labelTextColor,
    final Color? helperTextColor,
    final Color? activeTrackColor,
    final Color? inactiveTrackColor,
    final Color? thumbColor,
    final Color? secondaryActiveColor,
    final TextStyle? minMaxLabelTextStyle,
    final TextStyle? errorTextStyle,
    final TextStyle? labelTextStyle,
    final TextStyle? helperTextStyle,
    final TextStyle? bubbleTextStyle,
    final BorderRadiusGeometry? bubbleRadius,
  }) {
    return MDSliderTheme(
      secondaryActiveColor: secondaryActiveColor ?? this.secondaryActiveColor,
      bubbleColor: bubbleColor ?? this.bubbleColor,
      activeTrackColor: activeTrackColor ?? this.activeTrackColor,
      inactiveTrackColor: inactiveTrackColor ?? this.inactiveTrackColor,
      thumbColor: thumbColor ?? this.thumbColor,
      minMaxLabelTextStyle: minMaxLabelTextStyle ?? this.minMaxLabelTextStyle,
      errorTextStyle: errorTextStyle ?? this.errorTextStyle,
      labelTextStyle: labelTextStyle ?? this.labelTextStyle,
      helperTextStyle: helperTextStyle ?? this.helperTextStyle,
      bubbleTextStyle: bubbleTextStyle ?? this.bubbleTextStyle,
      bubbleRadius: bubbleRadius ?? this.bubbleRadius,
    );
  }

  MDSliderTheme lerp({required MDSliderTheme? sliderTheme, required double t}) {
    if (sliderTheme == null) {
      return this;
    }
    return MDSliderTheme(
      secondaryActiveColor: Color.lerp(secondaryActiveColor, sliderTheme.secondaryActiveColor, t)!,
      bubbleColor: Color.lerp(bubbleColor, sliderTheme.bubbleColor, t)!,
      activeTrackColor: Color.lerp(activeTrackColor, sliderTheme.activeTrackColor, t)!,
      inactiveTrackColor: Color.lerp(inactiveTrackColor, sliderTheme.inactiveTrackColor, t)!,
      thumbColor: Color.lerp(thumbColor, sliderTheme.thumbColor, t)!,
      minMaxLabelTextStyle: TextStyle.lerp(minMaxLabelTextStyle, sliderTheme.minMaxLabelTextStyle, t)!,
      errorTextStyle: TextStyle.lerp(errorTextStyle, sliderTheme.errorTextStyle, t)!,
      labelTextStyle: TextStyle.lerp(labelTextStyle, sliderTheme.labelTextStyle, t)!,
      helperTextStyle: TextStyle.lerp(helperTextStyle, sliderTheme.helperTextStyle, t)!,
      bubbleTextStyle: TextStyle.lerp(bubbleTextStyle, sliderTheme.bubbleTextStyle, t)!,
      bubbleRadius: BorderRadiusGeometry.lerp(bubbleRadius, sliderTheme.bubbleRadius, t)!,
    );
  }
}
