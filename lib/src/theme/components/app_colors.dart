import 'package:flutter/material.dart';

abstract class AppColor {
  const AppColor({
    required this.background,
    required this.content,
    required this.border,
  });
  final MDBackgroundColor background;
  final MDContentColor content;
  final MDBorderColor border;

  abstract final Color primary;
  abstract final Color primaryB;
  abstract final Color accent;

  abstract final Color info;
  abstract final Color negative;
  abstract final Color warning;
  abstract final Color positive;
}

abstract class MDBackgroundColor {
  const MDBackgroundColor();

  abstract final Color primary;
  abstract final Color secondary;
  abstract final Color tertiary;

  abstract final Color stateDisabled;
  abstract final Color overlayDark;
  abstract final Color overlayLight;

  abstract final Color accent;
  abstract final Color negative;
  abstract final Color warning;
  abstract final Color positive;

  abstract final Color lightAccent;
  abstract final Color lightInfo;
  abstract final Color lightNegative;
  abstract final Color lightWarning;
  abstract final Color lightPositive;

  abstract final Color alwaysDark;
  abstract final Color alwaysLight;
}

abstract class MDContentColor {
  const MDContentColor();

  abstract final Color primary;
  abstract final Color secondary;
  abstract final Color tertiary;

  abstract final Color stateDisabled;
  abstract final Color onColor;
  abstract final Color onColorInverse;

  abstract final Color accent;
  abstract final Color negative;
  abstract final Color warning;
  abstract final Color positive;
}

abstract class MDBorderColor {
  const MDBorderColor();

  abstract final Color opaque;
  abstract final Color transparent;
  abstract final Color selected;

  abstract final Color stateDisabled;
  abstract final Color accent;
  abstract final Color negative;
  abstract final Color warning;
  abstract final Color positive;
}

// AppThemeColor Implementation
class CoralThemeColor implements AppColor {
  @override
  final Color primary = Colors.black;
  @override
  final Color primaryB = Colors.white;
  @override
  final Color accent = Color(0xFFE63946);

  @override
  final Color info = Color(0xFF457B9D);
  @override
  final Color negative = Color(0xFFE63946);
  @override
  final Color warning = Color(0xFFF4A261);
  @override
  final Color positive = Color(0xFF2A9D8F);

  @override
  final MDBackgroundColor background = _ThemeBackground();
  @override
  final MDContentColor content = _ThemeContent();
  @override
  final MDBorderColor border = _ThemeBorder();
}

class _ThemeBackground implements MDBackgroundColor {
  @override
  final Color primary = Colors.white;
  @override
  final Color secondary = Color(0xFFE0E0E0);
  @override
  final Color tertiary = Color(0xFFBDBDBD);

  @override
  final Color stateDisabled = Color(0xFFBDBDBD);
  @override
  final Color overlayDark = Colors.black;
  @override
  final Color overlayLight = Colors.white;

  @override
  final Color accent = Color(0xFFE63946);
  @override
  final Color negative = Color(0xFFE63946);
  @override
  final Color warning = Color(0xFFF4A261);
  @override
  final Color positive = Color(0xFF2A9D8F);

  @override
  final Color lightAccent = Color(0xFFFFE5E5);
  @override
  final Color lightInfo = Color(0xFFE0F2FE);
  @override
  final Color lightNegative = Color(0xFFFFCDD2);
  @override
  final Color lightWarning = Color(0xFFFFF3CD);
  @override
  final Color lightPositive = Color(0xFFDCFCE7);

  @override
  final Color alwaysDark = Colors.black;
  @override
  final Color alwaysLight = Colors.white;
}

class _ThemeContent implements MDContentColor {
  @override
  final Color primary = Colors.black;
  @override
  final Color secondary = Color(0xFF757575);
  @override
  final Color tertiary = Color(0xFF616161);

  @override
  final Color stateDisabled = Color(0xFFBDBDBD);
  @override
  final Color onColor = Colors.white;
  @override
  final Color onColorInverse = Colors.black;

  @override
  final Color accent = Color(0xFF457B9D);
  @override
  final Color negative = Color(0xFFE63946);
  @override
  final Color warning = Color(0xFFF4A261);
  @override
  final Color positive = Color(0xFF2A9D8F);
}

class _ThemeBorder implements MDBorderColor {
  @override
  final Color opaque = Color(0xFFBDBDBD);
  @override
  final Color transparent = Colors.transparent;
  @override
  final Color selected = Colors.black;

  @override
  final Color stateDisabled = Color(0xFFBDBDBD);
  @override
  final Color accent = Color(0xFFE63946);
  @override
  final Color negative = Color(0xFFE63946);
  @override
  final Color warning = Color(0xFFF4A261);
  @override
  final Color positive = Color(0xFF2A9D8F);
}
