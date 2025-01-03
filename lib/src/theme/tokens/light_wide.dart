import 'package:flutter/material.dart';
import 'package:flutter_meragi_design/flutter_meragi_design.dart';
import 'package:flutter_meragi_design/src/theme/theme_tokens.dart';

ThemeToken lightWide = light.copyWith(
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
  smButtonTextHeight: 12,
  rgButtonTextHeight: 14,
  lgButtonTextHeight: 16,
  disabledButtonColor: Colors.grey,
);

ThemeToken lightWide_v2 = lightWide
    .copyWithColors(
      primary: Color(0xFFFF5F68),
      secondary: Colors.black,
      tertiary: Colors.grey,
    )
    .copyWith(
      secondaryButtonTextColor: Colors.white,
    );
