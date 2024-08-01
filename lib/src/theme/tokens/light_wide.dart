import 'package:flutter/material.dart';
import 'package:flutter_meragi_design/src/theme/theme_tokens.dart';

ThemeToken lightWide = ThemeToken(
  filledStandardButtonColor: Colors.deepPurple[100]!,
  filledPrimaryButtonColor: Colors.deepPurple,
  filledSecondaryButtonColor: Colors.deepPurpleAccent[100]!,
  filledDangerButtonColor: Colors.redAccent,
  filledInfoButtonColor: Colors.blue,
  filledWarningButtonColor: Colors.redAccent[100]!,
  outlineBackgroundColor: Colors.white,
  outlineStandardBorderButtonColor: Colors.grey[500]!,
  outlinePrimaryBorderButtonColor: Colors.deepPurple,
  outlineSecondaryBorderButtonColor: Colors.deepPurpleAccent[100]!,
  outlineDangerBorderButtonColor: Colors.redAccent,
  outlineInfoBorderButtonColor: Colors.blue,
  outlineWarningBorderButtonColor: Colors.redAccent[100]!,
  smButtonHeight: 25,
  smButtonPadding: const EdgeInsets.symmetric(horizontal: 5),
  rgButtonHeight: 32,
  rgButtonPadding: const EdgeInsets.symmetric(horizontal: 7, vertical: 0),
  lgButtonHeight: 38,
  lgButtonPadding: const EdgeInsets.symmetric(horizontal: 13, vertical: 0),
  smBorderRadius: 4,
  rgBorderRadius: 6,
  lgBorderRadius: 8,
  smButtonIconSize: 14,
  rgButtonIconSize: 16,
  lgButtonIconSize: 18,
  smButtonSpaceBetween: 5,
  rgButtonSpaceBetween: 8,
  lgButtonSpaceBetween: 12,
  filledStandardButtonIconColor: Colors.white,
  filledPrimaryButtonIconColor: Colors.white,
  filledSecondaryButtonIconColor: Colors.white,
  filledInfoButtonIconColor: Colors.white,
  filledWarningButtonIconColor: Colors.white,
  filledDangerButtonIconColor: Colors.white,
  ghostStandardButtonIconColor: Colors.deepPurple[100]!,
  ghostPrimaryButtonIconColor: Colors.deepPurple,
  ghostSecondaryButtonIconColor: Colors.deepPurpleAccent[100]!,
  ghostInfoButtonIconColor: Colors.blue,
  ghostWarningButtonIconColor: Colors.redAccent,
  ghostDangerButtonIconColor: Colors.redAccent[100]!,
  filledDisabledButtonColor: Colors.grey[200]!,
  ghostDisabledButtonColor: Colors.grey[200]!,
  outlinedDisabledButtonColor: Colors.grey[200]!,
  outlinedDisabledBorderButtonColor: Colors.grey[300]!,
  disabledIconButtonColor: Colors.grey[400]!,
  smButtonTextStyle: const TextStyle(
    fontSize: 12,
    height: 1.5,
    fontWeight: FontWeight.w400,
  ),
  rgButtonTextStyle: const TextStyle(
    fontSize: 14,
    height: 1.4,
    fontWeight: FontWeight.w500,
  ),
  lgButtonTextStyle: const TextStyle(
    fontSize: 16,
    height: 1.5,
    fontWeight: FontWeight.w500,
  ),
  filledStandardHoverButtonColor: Colors.deepPurple[100]!.withOpacity(0.7),
  filledPrimaryHoverButtonColor: Colors.deepPurple.withOpacity(0.7),
  filledSecondaryHoverButtonColor:
      Colors.deepPurpleAccent[100]!.withOpacity(0.7),
  filledWarningHoverButtonColor: Colors.redAccent[100]!.withOpacity(0.7),
  filledDangerHoverButtonColor: Colors.redAccent.withOpacity(0.7),
  filledInfoHoverButtonColor: Colors.blue.withOpacity(0.7),
  outlineStandardHoverButtonColor: Colors.deepPurple[100]!.withOpacity(0.3),
  outlinePrimaryHoverButtonColor: Colors.deepPurple.withOpacity(0.3),
  outlineSecondaryHoverButtonColor:
      Colors.deepPurpleAccent[100]!.withOpacity(0.3),
  outlineWarningHoverButtonColor: Colors.redAccent[100]!.withOpacity(0.3),
  outlineDangerHoverButtonColor: Colors.redAccent.withOpacity(0.3),
  outlineInfoHoverButtonColor: Colors.blue.withOpacity(0.3),
  ghostStandardHoverButtonColor: Colors.deepPurple[100]!.withOpacity(0.3),
  ghostPrimaryHoverButtonColor: Colors.deepPurple.withOpacity(0.3),
  ghostSecondaryHoverButtonColor:
      Colors.deepPurpleAccent[100]!.withOpacity(0.3),
  ghostWarningHoverButtonColor: Colors.redAccent[100]!.withOpacity(0.3),
  ghostDangerHoverButtonColor: Colors.redAccent.withOpacity(0.3),
  ghostInfoHoverButtonColor: Colors.blue.withOpacity(0.3),

  //Card
  defaultCardBackgroundColor: Colors.white,
  primaryCardBackgroundColor: Colors.deepPurple.shade100.withOpacity(.3),
  secondaryCardBackgroundColor:
      Colors.deepPurpleAccent.shade100.withOpacity(.3),
  dangerCardBackgroundColor: Colors.redAccent.shade100.withOpacity(.3),
  successCardBackgroundColor: Colors.green.shade100.withOpacity(.3),
  warningCardBackgroundColor: Colors.orange.shade100.withOpacity(.3),
  defaultCardBorderColor: Colors.black,
  primaryCardBorderColor: Colors.deepPurple,
  secondaryCardBorderColor: Colors.deepPurpleAccent,
  dangerCardBorderColor: Colors.redAccent,
  successCardBorderColor: Colors.green,
  warningCardBorderColor: Colors.orange,
  smCardPadding: const EdgeInsets.all(6),
  rgCardPadding: const EdgeInsets.all(8),
  lgCardPadding: const EdgeInsets.all(10),
  smCardBorderRadius: 6,
  rgCardBorderRadius: 6,
  lgCardBorderRadius: 8,
  cardBorderWidth: 1,
  cardDividerHeight: 10,
  cardDividerThickness: .5,

  //Tag
  defaultTagBackgroundColor: Colors.white,
  primaryTagBackgroundColor: Colors.deepPurple.shade100.withOpacity(.3),
  secondaryTagBackgroundColor: Colors.deepPurpleAccent.shade100.withOpacity(.3),
  dangerTagBackgroundColor: Colors.redAccent.shade100.withOpacity(.3),
  successTagBackgroundColor: Colors.green.shade100.withOpacity(.3),
  warningTagBackgroundColor: Colors.orange.shade100.withOpacity(.3),
  defaultTagBorderColor: Colors.black,
  primaryTagBorderColor: Colors.deepPurple.shade100.withOpacity(.3),
  secondaryTagBorderColor: Colors.deepPurpleAccent.shade100.withOpacity(.3),
  dangerTagBorderColor: Colors.redAccent.shade100.withOpacity(.3),
  successTagBorderColor: Colors.green.shade100.withOpacity(.3),
  warningTagBorderColor: Colors.orange.shade100.withOpacity(.3),
  smTagPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
  rgTagPadding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
  lgTagPadding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
  smTagBorderRadius: 6,
  rgTagBorderRadius: 6,
  lgTagBorderRadius: 8,
  tagBorderWidth: 1,
  smTagIconSize: 12.5,
  rgTagIconSize: 15,
  lgTagIconSize: 17,
  defaultTagIconColor: Colors.black,
  primaryTagIconColor: Colors.deepPurple,
  secondaryTagIconColor: Colors.deepPurpleAccent,
  dangerTagIconColor: Colors.redAccent,
  successTagIconColor: Colors.green,
  warningTagIconColor: Colors.orange,
  defaultTagTextColor: Colors.black,
  primaryTagTextColor: Colors.deepPurple,
  secondaryTagTextColor: Colors.deepPurpleAccent,
  dangerTagTextColor: Colors.redAccent,
  successTagTextColor: Colors.green,
  warningTagTextColor: Colors.orange,
  smTagTextHeight: 1.5,
  rgTagTextHeight: 1.5,
  lgTagTextHeight: 1.5,
  smTagTextSize: 12,
  rgTagTextSize: 14,
  lgTagTextSize: 16,
  smTagTextWeight: FontWeight.w400,
  rgTagTextWeight: FontWeight.w500,
  lgTagTextWeight: FontWeight.w500,
  smTagSpacing: 3,
  rgTagSpacing: 4,
  lgTagSpacing: 5,
);
