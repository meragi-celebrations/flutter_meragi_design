import 'package:flutter/material.dart';
import 'package:theme_tailor_annotation/theme_tailor_annotation.dart';

part 'theme_tokens.tailor.dart';

@TailorMixin()
class ThemeToken extends ThemeExtension<ThemeToken>
    with _$ThemeTokenTailorMixin {
  //Card

  // //Background Color
  @override
  final Color defaultCardBackgroundColor;
  @override
  final Color primaryCardBackgroundColor;
  @override
  final Color secondaryCardBackgroundColor;
  @override
  final Color dangerCardBackgroundColor;
  @override
  final Color successCardBackgroundColor;
  @override
  final Color warningCardBackgroundColor;
  // // Border Color
  @override
  final Color defaultCardBorderColor;
  @override
  final Color primaryCardBorderColor;
  @override
  final Color secondaryCardBorderColor;
  @override
  final Color dangerCardBorderColor;
  @override
  final Color successCardBorderColor;
  @override
  final Color warningCardBorderColor;

  // // Padding
  @override
  final EdgeInsets smCardPadding;
  @override
  final EdgeInsets rgCardPadding;
  @override
  final EdgeInsets lgCardPadding;

  // // Border
  @override
  final double cardBorderWidth;
  @override
  final double smCardBorderRadius;
  @override
  final double rgCardBorderRadius;
  @override
  final double lgCardBorderRadius;

  // // Divider
  @override
  final double cardDividerThickness;
  @override
  final double cardDividerHeight;

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

  //Tag

  // //Background Color
  @override
  final Color defaultTagBackgroundColor;
  @override
  final Color primaryTagBackgroundColor;
  @override
  final Color secondaryTagBackgroundColor;
  @override
  final Color dangerTagBackgroundColor;
  @override
  final Color successTagBackgroundColor;
  @override
  final Color warningTagBackgroundColor;
  // // Border Color
  @override
  final Color defaultTagBorderColor;
  @override
  final Color primaryTagBorderColor;
  @override
  final Color secondaryTagBorderColor;
  @override
  final Color dangerTagBorderColor;
  @override
  final Color successTagBorderColor;
  @override
  final Color warningTagBorderColor;

  // // Padding
  @override
  final EdgeInsets smTagPadding;
  @override
  final EdgeInsets rgTagPadding;
  @override
  final EdgeInsets lgTagPadding;

  // // Border
  @override
  final double tagBorderWidth;
  @override
  final double smTagBorderRadius;
  @override
  final double rgTagBorderRadius;
  @override
  final double lgTagBorderRadius;

  // // Text
  @override
  final double smTagTextHeight;
  @override
  final double rgTagTextHeight;
  @override
  final double lgTagTextHeight;
  @override
  final double smTagTextSize;
  @override
  final double rgTagTextSize;
  @override
  final double lgTagTextSize;

  @override
  final FontWeight smTagTextWeight;
  @override
  final FontWeight rgTagTextWeight;
  @override
  final FontWeight lgTagTextWeight;

  @override
  final Color defaultTagTextColor;
  @override
  final Color primaryTagTextColor;
  @override
  final Color secondaryTagTextColor;
  @override
  final Color dangerTagTextColor;
  @override
  final Color successTagTextColor;
  @override
  final Color warningTagTextColor;

  // // Icon Size
  @override
  final double smTagIconSize;
  @override
  final double rgTagIconSize;
  @override
  final double lgTagIconSize;

  // // Icon Color
  @override
  final Color defaultTagIconColor;
  @override
  final Color primaryTagIconColor;
  @override
  final Color secondaryTagIconColor;
  @override
  final Color dangerTagIconColor;
  @override
  final Color successTagIconColor;
  @override
  final Color warningTagIconColor;

  // // Spacing
  @override
  final double smTagSpacing;
  @override
  final double rgTagSpacing;
  @override
  final double lgTagSpacing;

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
    required this.primaryCardBackgroundColor,
    required this.secondaryCardBackgroundColor,
    required this.dangerCardBackgroundColor,
    required this.successCardBackgroundColor,
    required this.warningCardBackgroundColor,
    required this.defaultCardBackgroundColor,
    required this.defaultCardBorderColor,
    required this.dangerCardBorderColor,
    required this.successCardBorderColor,
    required this.warningCardBorderColor,
    required this.primaryCardBorderColor,
    required this.secondaryCardBorderColor,
    required this.lgCardPadding,
    required this.rgCardPadding,
    required this.smCardPadding,
    required this.smCardBorderRadius,
    required this.rgCardBorderRadius,
    required this.lgCardBorderRadius,
    required this.cardBorderWidth,
    required this.cardDividerHeight,
    required this.cardDividerThickness,
    required this.defaultTagBackgroundColor,
    required this.primaryTagBackgroundColor,
    required this.secondaryTagBackgroundColor,
    required this.dangerTagBackgroundColor,
    required this.successTagBackgroundColor,
    required this.warningTagBackgroundColor,
    required this.defaultTagBorderColor,
    required this.primaryTagBorderColor,
    required this.secondaryTagBorderColor,
    required this.dangerTagBorderColor,
    required this.successTagBorderColor,
    required this.warningTagBorderColor,
    required this.tagBorderWidth,
    required this.smTagBorderRadius,
    required this.rgTagBorderRadius,
    required this.lgTagBorderRadius,
    required this.smTagPadding,
    required this.rgTagPadding,
    required this.lgTagPadding,
    required this.defaultTagIconColor,
    required this.primaryTagIconColor,
    required this.secondaryTagIconColor,
    required this.dangerTagIconColor,
    required this.successTagIconColor,
    required this.warningTagIconColor,
    required this.smTagIconSize,
    required this.rgTagIconSize,
    required this.lgTagIconSize,
    required this.defaultTagTextColor,
    required this.primaryTagTextColor,
    required this.secondaryTagTextColor,
    required this.dangerTagTextColor,
    required this.successTagTextColor,
    required this.warningTagTextColor,
    required this.smTagTextHeight,
    required this.rgTagTextHeight,
    required this.lgTagTextHeight,
    required this.smTagTextSize,
    required this.rgTagTextSize,
    required this.lgTagTextSize,
    required this.smTagTextWeight,
    required this.rgTagTextWeight,
    required this.lgTagTextWeight,
    required this.lgTagSpacing,
    required this.smTagSpacing,
    required this.rgTagSpacing,
  });
}
