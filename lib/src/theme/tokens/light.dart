import 'package:flutter/material.dart';
import 'package:flutter_meragi_design/src/theme/theme_tokens.dart';

ThemeToken light = ThemeToken(
  standardButtonColor: Colors.deepPurple[100]!,
  primaryButtonColor: Colors.deepPurple,
  secondaryButtonColor: Colors.deepPurpleAccent[100]!,
  dangerButtonColor: Colors.redAccent,
  infoButtonColor: Colors.blue,
  warningButtonColor: Colors.redAccent[100]!,
  infoFilledHoverButtonColor: Colors.blue[100]!,
  warningFilledHoverButtonColor: Colors.redAccent[100]!,
  dangerFilledHoverButtonColor: Colors.redAccent[100]!,
  primaryFilledHoverButtonColor: Colors.blue[100]!,
  secondaryFilledHoverButtonColor: Colors.deepPurpleAccent[100]!,
  standardFilledHoverButtonColor: Colors.deepPurple[100]!,

  smButtonHeight: 34,
  smButtonPadding: const EdgeInsets.symmetric(horizontal: 12),
  rgButtonHeight: 42,
  rgButtonPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
  lgButtonHeight: 50,
  lgButtonPadding: const EdgeInsets.symmetric(horizontal: 32, vertical: 0),
  smBorderRadius: 4,
  rgBorderRadius: 6,
  lgBorderRadius: 8,
  smButtonIconSize: 14,
  rgButtonIconSize: 16,
  lgButtonIconSize: 18,
  smButtonSpaceBetween: 2,
  rgButtonSpaceBetween: 4,
  lgButtonSpaceBetween: 6,
  filledSecondaryHoverButtonColor: Colors.deepPurpleAccent[100]!.withOpacity(0.7),
  filledWarningHoverButtonColor: Colors.redAccent[100]!.withOpacity(0.7),
  filledDangerHoverButtonColor: Colors.redAccent.withOpacity(0.7),
  filledInfoHoverButtonColor: Colors.blue.withOpacity(0.7),
  outlineStandardHoverButtonColor: Colors.deepPurple[100]!.withOpacity(0.3),
  outlinePrimaryHoverButtonColor: Colors.deepPurple.withOpacity(0.3),
  outlineSecondaryHoverButtonColor: Colors.deepPurpleAccent[100]!.withOpacity(0.3),
  outlineWarningHoverButtonColor: Colors.redAccent[100]!.withOpacity(0.3),
  outlineDangerHoverButtonColor: Colors.redAccent.withOpacity(0.3),
  outlineInfoHoverButtonColor: Colors.blue.withOpacity(0.3),
  ghostStandardHoverButtonColor: Colors.deepPurple[100]!.withOpacity(0.3),
  ghostPrimaryHoverButtonColor: Colors.deepPurple.withOpacity(0.3),
  ghostSecondaryHoverButtonColor: Colors.deepPurpleAccent[100]!.withOpacity(0.3),
  ghostWarningHoverButtonColor: Colors.redAccent[100]!.withOpacity(0.3),
  ghostDangerHoverButtonColor: Colors.redAccent.withOpacity(0.3),
  ghostInfoHoverButtonColor: Colors.blue.withOpacity(0.3),

  //Card
  defaultCardBackgroundColor: Colors.white,
  primaryCardBackgroundColor: Colors.deepPurple.shade100.withOpacity(.3),
  secondaryCardBackgroundColor: Colors.deepPurpleAccent.shade100.withOpacity(.3),
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

  // Text
  displayTextStyle: const TextStyle(fontSize: 24),
  h1TextStyle: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
  h2TextStyle: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
  h3TextStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
  h4TextStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
  h5TextStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
  bodyTextStyle: const TextStyle(fontSize: 14),
  h6TextStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
  captionTextStyle: const TextStyle(fontSize: 10, color: Colors.grey),
  codeTextStyle: const TextStyle(fontSize: 12, fontFamily: 'monospace', color: Colors.blue),
  quoteTextStyle: const TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
  linkTextStyle: const TextStyle(fontSize: 14, color: Colors.blue, decoration: TextDecoration.underline),
  standardHoverButtonColor: Colors.deepPurple[100]!.withOpacity(0.7),
  primaryHoverButtonColor: Colors.deepPurple.withOpacity(0.7),
  secondaryHoverButtonColor: Colors.deepPurpleAccent[100]!.withOpacity(0.7),
  warningHoverButtonColor: Colors.redAccent[100]!.withOpacity(0.7),
  dangerHoverButtonColor: Colors.redAccent.withOpacity(0.7),
  infoHoverButtonColor: Colors.blue.withOpacity(0.7),
  defaultCardBorderColor: Colors.grey[300]!,
  primaryTextColor: Colors.deepPurple,
  secondaryTextColor: Colors.deepPurpleAccent,
  successTextColor: Colors.green,
  warningTextColor: Colors.orange,
  infoTextColor: Colors.blue,
  errorTextColor: Colors.redAccent,
  disabledTextColor: Colors.grey,
  defaultTextColor: Colors.black,
  standardButtonTextColor: Colors.black,
  primaryButtonTextColor: Colors.white,
  secondaryButtonTextColor: Colors.black,
  dangerButtonTextColor: Colors.white,
  warningButtonTextColor: Colors.white,
  infoButtonTextColor: Colors.white,
  smButtonTextHeight: 12,
  rgButtonTextHeight: 14,
  lgButtonTextHeight: 16,
  disabledButtonColor: Colors.grey,
);
