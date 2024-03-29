import 'package:flutter/material.dart';
import 'package:theme_tailor_annotation/theme_tailor_annotation.dart';

part 'theme_tokens.tailor.dart';

@TailorMixin()
class ThemeToken extends ThemeExtension<ThemeToken> with _$ThemeTokenTailorMixin {
  //Button Colors
  @override
  final Color filledStandardButtonColor;
  @override
  final Color filledPrimaryButtonColor;
  @override
  final Color filledSecondaryButtonColor;
  @override
  final Color filledDangerButtonColor;
  @override
  final Color filledInfoButtonColor;
  @override
  final Color filledWarningButtonColor;

  @override
  final Color outlineBackgroundColor;

  @override
  final Color outlineStandardBorderButtonColor;
  @override
  final Color outlinePrimaryBorderButtonColor;
  @override
  final Color outlineSecondaryBorderButtonColor;
  @override
  final Color outlineDangerBorderButtonColor;
  @override
  final Color outlineInfoBorderButtonColor;
  @override
  final Color outlineWarningBorderButtonColor;

  //Button Sizes
  @override
  final double smButtonHeight;
  @override
  final EdgeInsets smButtonPadding;
  @override
  final double rgButtonHeight;
  @override
  final EdgeInsets rgButtonPadding;
  @override
  final double lgButtonHeight;
  @override
  final EdgeInsets lgButtonPadding;
  @override
  final double smBorderRadius;
  @override
  final double rgBorderRadius;
  @override
  final double lgBorderRadius;

  //icon
  @override
  final double smButtonIconSize;
  @override
  final double rgButtonIconSize;
  @override
  final double lgButtonIconSize;

  @override
  final Color filledStandardButtonIconColor;
  @override
  final Color filledPrimaryButtonIconColor;
  @override
  final Color filledSecondaryButtonIconColor;
  @override
  final Color filledDangerButtonIconColor;
  @override
  final Color filledInfoButtonIconColor;
  @override
  final Color filledWarningButtonIconColor;

  @override
  final Color ghostStandardButtonIconColor;
  @override
  final Color ghostPrimaryButtonIconColor;
  @override
  final Color ghostSecondaryButtonIconColor;
  @override
  final Color ghostDangerButtonIconColor;
  @override
  final Color ghostInfoButtonIconColor;
  @override
  final Color ghostWarningButtonIconColor;

  @override
  final Color filledDisabledButtonColor;
  @override
  final Color ghostDisabledButtonColor;
  @override
  final Color outlinedDisabledButtonColor;
  @override
  final Color outlinedDisabledBorderButtonColor;

  @override
  final Color disabledIconButtonColor;

  @override
  final TextStyle smButtonTextStyle;
  @override
  final TextStyle rgButtonTextStyle;
  @override
  final TextStyle lgButtonTextStyle;

  @override
  final Color filledStandardHoverButtonColor;
  @override
  final Color filledPrimaryHoverButtonColor;
  @override
  final Color filledSecondaryHoverButtonColor;
  @override
  final Color filledDangerHoverButtonColor;
  @override
  final Color filledInfoHoverButtonColor;
  @override
  final Color filledWarningHoverButtonColor;
  @override
  final Color outlineStandardHoverButtonColor;
  @override
  final Color outlinePrimaryHoverButtonColor;
  @override
  final Color outlineSecondaryHoverButtonColor;
  @override
  final Color outlineDangerHoverButtonColor;
  @override
  final Color outlineInfoHoverButtonColor;
  @override
  final Color outlineWarningHoverButtonColor;
  @override
  final Color ghostStandardHoverButtonColor;
  @override
  final Color ghostPrimaryHoverButtonColor;
  @override
  final Color ghostSecondaryHoverButtonColor;
  @override
  final Color ghostDangerHoverButtonColor;
  @override
  final Color ghostInfoHoverButtonColor;
  @override
  final Color ghostWarningHoverButtonColor;

  const ThemeToken({
    required this.filledStandardButtonColor,
    required this.filledPrimaryButtonColor,
    required this.filledSecondaryButtonColor,
    required this.filledDangerButtonColor,
    required this.filledInfoButtonColor,
    required this.filledWarningButtonColor,
    required this.outlineBackgroundColor,
    required this.outlineStandardBorderButtonColor,
    required this.outlinePrimaryBorderButtonColor,
    required this.outlineSecondaryBorderButtonColor,
    required this.outlineDangerBorderButtonColor,
    required this.outlineInfoBorderButtonColor,
    required this.outlineWarningBorderButtonColor,
    required this.smButtonHeight,
    required this.smButtonPadding,
    required this.rgButtonHeight,
    required this.rgButtonPadding,
    required this.lgButtonHeight,
    required this.lgButtonPadding,
    required this.smBorderRadius,
    required this.rgBorderRadius,
    required this.lgBorderRadius,
    required this.smButtonIconSize,
    required this.rgButtonIconSize,
    required this.lgButtonIconSize,
    required this.filledStandardButtonIconColor,
    required this.filledPrimaryButtonIconColor,
    required this.filledSecondaryButtonIconColor,
    required this.filledDangerButtonIconColor,
    required this.filledInfoButtonIconColor,
    required this.filledWarningButtonIconColor,
    required this.ghostStandardButtonIconColor,
    required this.ghostPrimaryButtonIconColor,
    required this.ghostSecondaryButtonIconColor,
    required this.ghostDangerButtonIconColor,
    required this.ghostInfoButtonIconColor,
    required this.ghostWarningButtonIconColor,
    required this.filledDisabledButtonColor,
    required this.ghostDisabledButtonColor,
    required this.outlinedDisabledButtonColor,
    required this.outlinedDisabledBorderButtonColor,
    required this.disabledIconButtonColor,
    required this.smButtonTextStyle,
    required this.rgButtonTextStyle,
    required this.lgButtonTextStyle,
    required this.filledStandardHoverButtonColor,
    required this.filledPrimaryHoverButtonColor,
    required this.filledSecondaryHoverButtonColor,
    required this.filledDangerHoverButtonColor,
    required this.filledInfoHoverButtonColor,
    required this.filledWarningHoverButtonColor,
    required this.outlineStandardHoverButtonColor,
    required this.outlinePrimaryHoverButtonColor,
    required this.outlineSecondaryHoverButtonColor,
    required this.outlineDangerHoverButtonColor,
    required this.outlineInfoHoverButtonColor,
    required this.outlineWarningHoverButtonColor,
    required this.ghostStandardHoverButtonColor,
    required this.ghostPrimaryHoverButtonColor,
    required this.ghostSecondaryHoverButtonColor,
    required this.ghostDangerHoverButtonColor,
    required this.ghostInfoHoverButtonColor,
    required this.ghostWarningHoverButtonColor,
  });
}
