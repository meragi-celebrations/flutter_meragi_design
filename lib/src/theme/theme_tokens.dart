import 'package:flutter/material.dart';
import 'package:theme_tailor_annotation/theme_tailor_annotation.dart';

import '../extensions/colors.dart';

part 'theme_tokens.tailor.dart';

@TailorMixin()
class ThemeToken extends ThemeExtension<ThemeToken> with _$ThemeTokenTailorMixin {
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
  late final Color defaultCardBorderColor;
  @override
  late final Color primaryCardBorderColor;
  @override
  late final Color secondaryCardBorderColor;
  @override
  late final Color dangerCardBorderColor;
  @override
  late final Color successCardBorderColor;
  @override
  late final Color warningCardBorderColor;

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

  // Button
  // // Button Colors
  @override
  final Color standardButtonColor;
  @override
  final Color primaryButtonColor;
  @override
  final Color secondaryButtonColor;
  @override
  final Color dangerButtonColor;
  @override
  final Color infoButtonColor;
  @override
  final Color warningButtonColor;

  // // Hover Color
  @override
  final Color standardHoverButtonColor;
  @override
  final Color primaryHoverButtonColor;
  @override
  final Color secondaryHoverButtonColor;
  @override
  final Color warningHoverButtonColor;
  @override
  final Color dangerHoverButtonColor;
  @override
  final Color infoHoverButtonColor;

  @override
  final Color standardFilledHoverButtonColor;
  @override
  final Color primaryFilledHoverButtonColor;
  @override
  final Color secondaryFilledHoverButtonColor;
  @override
  final Color dangerFilledHoverButtonColor;
  @override
  final Color infoFilledHoverButtonColor;
  @override
  final Color warningFilledHoverButtonColor;

  // //Button Sizes
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

  // // Space between icon and text
  @override
  final double smButtonSpaceBetween;
  @override
  final double rgButtonSpaceBetween;
  @override
  final double lgButtonSpaceBetween;

  //icon
  @override
  final double smButtonIconSize;
  @override
  final double rgButtonIconSize;
  @override
  final double lgButtonIconSize;

  @override
  final Color disabledButtonColor;
  @override
  final Color disabledTextColor;

  @override
  final Color standardButtonTextColor;
  @override
  final Color primaryButtonTextColor;
  @override
  final Color secondaryButtonTextColor;
  @override
  final Color dangerButtonTextColor;
  @override
  final Color infoButtonTextColor;
  @override
  final Color warningButtonTextColor;

  @override
  final double smButtonTextHeight;
  @override
  final double rgButtonTextHeight;
  @override
  final double lgButtonTextHeight;

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
  @override
  final Color infoTagBackgroundColor;
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
  @override
  final Color infoTagBorderColor;

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
  @override
  final Color infoTagTextColor;

  // // Icon Size
  @override
  final double smTagIconSize;
  @override
  final double rgTagIconSize;
  @override
  final double lgTagIconSize;

  // // Spacing
  @override
  final double smTagSpacing;
  @override
  final double rgTagSpacing;
  @override
  final double lgTagSpacing;

  // Typography

  // // Text Style
  @override
  final TextStyle displayTextStyle;
  @override
  final TextStyle h1TextStyle;
  @override
  final TextStyle h2TextStyle;
  @override
  final TextStyle h3TextStyle;
  @override
  final TextStyle h4TextStyle;
  @override
  final TextStyle h5TextStyle;
  @override
  final TextStyle h6TextStyle;
  @override
  final TextStyle linkTextStyle;
  @override
  final TextStyle codeTextStyle;
  @override
  final TextStyle quoteTextStyle;
  @override
  final TextStyle bodyTextStyle;
  @override
  final TextStyle captionTextStyle;

  // // Text color
  @override
  final Color primaryTextColor;
  @override
  final Color secondaryTextColor;
  @override
  final Color successTextColor;
  @override
  final Color warningTextColor;
  @override
  final Color infoTextColor;
  @override
  final Color errorTextColor;
  @override
  final Color defaultTextColor;
  @override
  final Color navigationRailBackgroundColor;
  @override
  final EdgeInsets navigationRailcontentPadding;
  @override
  final double navigationRailCollapsedWidth;
  @override
  final double navigationRailExpandedWidth;
  @override
  final Color navigationRailDestinationSelectedColor;
  @override
  final Color navigationRailDestinationSelectedHoverColor;
  @override
  final Color navigationRailDestinationNonSelectedHoverColor;
  @override
  final Color navigationRailDestinationNonSelectedColor;
  @override
  final BorderRadius navigationRailBorderRadius;
  @override
  final Duration navigationRailAnimationDuration;
  @override
  final List<BoxShadow> navigationRailBoxShadow;

  // ExpansionTile
  @override
  final Color expansionTileSplashColor;
  @override
  final Color expansionTileHoverColor;
  @override
  final InteractiveInkFeatureFactory expansionTileSplashFactory;
  @override
  final Color expansionTileBackgroundColor;
  @override
  final EdgeInsets expansiontitlePadding;
  @override
  final AnimationStyle expansionAnimationStyle;
  @override
  final VisualDensity visualDensity;
  @override
  final ShapeBorder expansionTileCollapsedShape;
  @override
  final ShapeBorder expansionTileExpandedShape;

  // Standard properties
  @override
  final Color primaryColor;
  @override
  final Color secondaryColor;
  @override
  final Color tertiaryColor;
  @override
  final double padding;
  @override
  final double radius;

  @override
  final Color successColor;
  @override
  final Color warningColor;
  @override
  final Color infoColor;
  @override
  final Color errorColor;

  @override
  final Color borderColor;

  ThemeToken({
    // Button
    required this.standardButtonColor,
    required this.primaryButtonColor,
    required this.secondaryButtonColor,
    required this.dangerButtonColor,
    required this.infoButtonColor,
    required this.warningButtonColor,
    required this.standardFilledHoverButtonColor,
    required this.primaryFilledHoverButtonColor,
    required this.secondaryFilledHoverButtonColor,
    required this.dangerFilledHoverButtonColor,
    required this.infoFilledHoverButtonColor,
    required this.warningFilledHoverButtonColor,
    required this.standardButtonTextColor,
    required this.primaryButtonTextColor,
    required this.secondaryButtonTextColor,
    required this.dangerButtonTextColor,
    required this.infoButtonTextColor,
    required this.warningButtonTextColor,
    required this.smButtonTextHeight,
    required this.rgButtonTextHeight,
    required this.lgButtonTextHeight,
    required this.smButtonHeight,
    required this.smButtonPadding,
    required this.rgButtonHeight,
    required this.rgButtonPadding,
    required this.lgButtonHeight,
    required this.lgButtonPadding,
    required this.smButtonSpaceBetween,
    required this.rgButtonSpaceBetween,
    required this.lgButtonSpaceBetween,
    required this.smBorderRadius,
    required this.rgBorderRadius,
    required this.lgBorderRadius,
    required this.smButtonIconSize,
    required this.rgButtonIconSize,
    required this.lgButtonIconSize,
    required this.disabledButtonColor,
    required this.standardHoverButtonColor,
    required this.primaryHoverButtonColor,
    required this.secondaryHoverButtonColor,
    required this.warningHoverButtonColor,
    required this.dangerHoverButtonColor,
    required this.infoHoverButtonColor,
    required this.primaryCardBackgroundColor,
    required this.secondaryCardBackgroundColor,
    required this.dangerCardBackgroundColor,
    required this.successCardBackgroundColor,
    required this.warningCardBackgroundColor,
    required this.defaultCardBackgroundColor,
    defaultCardBorderColor,
    dangerCardBorderColor,
    successCardBorderColor,
    warningCardBorderColor,
    primaryCardBorderColor,
    secondaryCardBorderColor,
    required this.lgCardPadding,
    required this.rgCardPadding,
    required this.smCardPadding,
    required this.smCardBorderRadius,
    required this.rgCardBorderRadius,
    required this.lgCardBorderRadius,
    required this.cardBorderWidth,
    required this.cardDividerHeight,
    required this.cardDividerThickness,

    // tag
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
    required this.infoTagBackgroundColor,
    required this.infoTagBorderColor,
    required this.infoTagTextColor,
    required this.primaryTextColor,
    required this.secondaryTextColor,
    required this.successTextColor,
    required this.warningTextColor,
    required this.infoTextColor,
    required this.errorTextColor,
    required this.disabledTextColor,
    required this.defaultTextColor,
    required this.displayTextStyle,
    required this.bodyTextStyle,
    required this.h1TextStyle,
    required this.h2TextStyle,
    required this.h3TextStyle,
    required this.h4TextStyle,
    required this.h5TextStyle,
    required this.h6TextStyle,
    required this.quoteTextStyle,
    required this.codeTextStyle,
    required this.linkTextStyle,
    required this.captionTextStyle,

    //navigationRail
    required this.navigationRailBackgroundColor,
    required this.navigationRailCollapsedWidth,
    required this.navigationRailExpandedWidth,
    required this.navigationRailcontentPadding,
    required this.navigationRailDestinationSelectedColor,
    required this.navigationRailDestinationSelectedHoverColor,
    required this.navigationRailDestinationNonSelectedColor,
    required this.navigationRailDestinationNonSelectedHoverColor,
    required this.navigationRailBorderRadius,
    required this.navigationRailAnimationDuration,
    required this.navigationRailBoxShadow,

    // ExpansionTile
    required this.expansionTileSplashColor,
    required this.expansionTileHoverColor,
    required this.expansionTileSplashFactory,
    required this.expansionTileBackgroundColor,
    required this.expansiontitlePadding,
    required this.expansionAnimationStyle,
    required this.visualDensity,
    required this.expansionTileCollapsedShape,
    required this.expansionTileExpandedShape,

    // Standard Properties
    required this.primaryColor,
    required this.secondaryColor,
    required this.tertiaryColor,
    required this.padding,
    required this.radius,

    // Additional colors
    required this.successColor,
    required this.warningColor,
    required this.infoColor,
    required this.errorColor,
    required this.borderColor,
  }) {
    this.defaultCardBorderColor = defaultCardBorderColor ?? borderColor;
    this.primaryCardBorderColor = primaryCardBorderColor ?? primaryColor;
    this.secondaryCardBorderColor = secondaryCardBorderColor ?? secondaryColor;
    this.dangerCardBorderColor = dangerCardBorderColor ?? errorColor;
    this.successCardBorderColor = successCardBorderColor ?? successColor;
    this.warningCardBorderColor = warningCardBorderColor ?? warningColor;
  }

  ThemeToken copyWithColors({
    Color? primary,
    Color? secondary,
    Color? tertiary,
    Color? success,
    Color? warning,
    Color? info,
    Color? error,
  }) {
    return copyWith(
      // Standard Properties
      primaryColor: primary ?? primaryColor,
      secondaryColor: secondary ?? secondaryColor,
      tertiaryColor: tertiary ?? tertiaryColor,
      successColor: success ?? successColor,
      warningColor: warning ?? warningColor,
      infoColor: info ?? infoColor,
      errorColor: error ?? errorColor,

      // Card
      // Background color
      primaryCardBackgroundColor: primary?.lighten(80),
      secondaryCardBackgroundColor: secondary?.lighten(80),
      successCardBackgroundColor: success?.lighten(80),
      warningCardBackgroundColor: warning?.lighten(80),
      dangerCardBackgroundColor: error?.lighten(80),

      // // Border Color
      primaryCardBorderColor: primary?.lighten(40),
      secondaryCardBorderColor: secondary?.lighten(40),
      successCardBorderColor: success?.lighten(40),
      warningCardBorderColor: warning?.lighten(40),
      dangerCardBorderColor: error?.lighten(40),

      // Button
      // // Background color
      primaryButtonColor: primary,
      secondaryButtonColor: secondary,
      warningButtonColor: warning,
      infoButtonColor: info,
      dangerButtonColor: error,

      // // Hover colors(outline, ghost)
      primaryHoverButtonColor: primary?.lighten(90),
      secondaryHoverButtonColor: secondary?.lighten(90),
      warningHoverButtonColor: warning?.lighten(90),
      infoHoverButtonColor: info?.lighten(90),
      dangerHoverButtonColor: error?.lighten(90),

      // // Hover colors(filled)
      primaryFilledHoverButtonColor: primary?.darken(20),
      secondaryFilledHoverButtonColor: secondary?.darken(20),
      warningFilledHoverButtonColor: warning?.darken(20),
      infoFilledHoverButtonColor: info?.darken(20),
      dangerFilledHoverButtonColor: error?.darken(20),

      // typography
      primaryTextColor: primary,
      secondaryTextColor: secondary,
      successTextColor: success,
      warningTextColor: warning,
      infoTextColor: info,
      errorTextColor: error,

      //navigationRail
      navigationRailDestinationSelectedColor: primary,
      navigationRailDestinationSelectedHoverColor: primary,
      navigationRailDestinationNonSelectedHoverColor: primary?.lighten(50),
      navigationRailDestinationNonSelectedColor: primary?.lighten(95),
      // navigationRailBorderRadius,
      // navigationRailAnimationDuration,
      // navigationRailBoxShadow,
    );
  }
}
