import 'package:flutter/material.dart';

abstract class AppColor {
  const AppColor({
    required this.background,
    required this.content,
    required this.border,
    required this.primary,
    required this.primaryB,
    required this.accent,
    required this.info,
    required this.negative,
    required this.warning,
    required this.positive,
  });

  final MDBackgroundColor background;
  final MDContentColor content;
  final MDBorderColor border;

  final Color primary;
  final Color primaryB;
  final Color accent;

  final Color info;
  final Color negative;
  final Color warning;
  final Color positive;
}

abstract class MDBackgroundColor {
  const MDBackgroundColor({
    required this.primary,
    required this.secondary,
    required this.tertiary,
    required this.stateDisabled,
    required this.overlayDark,
    required this.overlayLight,
    required this.accent,
    required this.negative,
    required this.warning,
    required this.positive,
    required this.lightAccent,
    required this.lightInfo,
    required this.lightNegative,
    required this.lightWarning,
    required this.lightPositive,
    required this.alwaysDark,
    required this.alwaysLight,
  });

  final Color primary;
  final Color secondary;
  final Color tertiary;

  final Color stateDisabled;
  final Color overlayDark;
  final Color overlayLight;

  final Color accent;
  final Color negative;
  final Color warning;
  final Color positive;

  final Color lightAccent;
  final Color lightInfo;
  final Color lightNegative;
  final Color lightWarning;
  final Color lightPositive;

  final Color alwaysDark;
  final Color alwaysLight;
}

abstract class MDContentColor {
  const MDContentColor({
    required this.primary,
    required this.secondary,
    required this.tertiary,
    required this.stateDisabled,
    required this.onColor,
    required this.onColorInverse,
    required this.accent,
    required this.negative,
    required this.warning,
    required this.positive,
  });

  final Color primary;
  final Color secondary;
  final Color tertiary;

  final Color stateDisabled;
  final Color onColor;
  final Color onColorInverse;

  final Color accent;
  final Color negative;
  final Color warning;
  final Color positive;
}

abstract class MDBorderColor {
  const MDBorderColor({
    required this.opaque,
    required this.transparent,
    required this.selected,
    required this.stateDisabled,
    required this.accent,
    required this.negative,
    required this.warning,
    required this.positive,
  });

  final Color opaque;
  final Color transparent;
  final Color selected;

  final Color stateDisabled;
  final Color accent;
  final Color negative;
  final Color warning;
  final Color positive;
}

// AppThemeColor Implementation
class CoralThemeColor implements AppColor {
  CoralThemeColor({
    this.primary = Colors.black,
    this.primaryB = Colors.white,
    this.accent = const Color(0xFFE63946),
    this.info = const Color(0xFF457B9D),
    this.negative = const Color(0xFFE63946),
    this.warning = const Color(0xFFF4A261),
    this.positive = const Color(0xFF2A9D8F),
    MDBackgroundColor? background,
    MDContentColor? content,
    MDBorderColor? border,
  })  : background = background ?? MDCoralBackgroundColor(),
        content = content ?? MDCoralContentColor(),
        border = border ?? MDCoralBorderColor();

  @override
  final Color primary;
  @override
  final Color primaryB;
  @override
  final Color accent;

  @override
  final Color info;
  @override
  final Color negative;
  @override
  final Color warning;
  @override
  final Color positive;

  @override
  final MDBackgroundColor background;
  @override
  final MDContentColor content;
  @override
  final MDBorderColor border;

  CoralThemeColor copyWith({
    Color? primary,
    Color? primaryB,
    Color? accent,
    Color? info,
    Color? negative,
    Color? warning,
    Color? positive,
    MDBackgroundColor? background,
    MDContentColor? content,
    MDBorderColor? border,
  }) {
    return CoralThemeColor(
      primary: primary ?? this.primary,
      primaryB: primaryB ?? this.primaryB,
      accent: accent ?? this.accent,
      info: info ?? this.info,
      negative: negative ?? this.negative,
      warning: warning ?? this.warning,
      positive: positive ?? this.positive,
      background: background ?? this.background,
      content: content ?? this.content,
      border: border ?? this.border,
    );
  }

  CoralThemeColor merge(CoralThemeColor? other) {
    if (other == null) return this;
    return copyWith(
      primary: other.primary,
      primaryB: other.primaryB,
      accent: other.accent,
      info: other.info,
      negative: other.negative,
      warning: other.warning,
      positive: other.positive,
      background: other.background,
      content: other.content,
      border: other.border,
    );
  }
}

class MDCoralBackgroundColor implements MDBackgroundColor {
  MDCoralBackgroundColor({
    this.primary = Colors.white,
    this.secondary = const Color(0xFFF3F3F3),
    this.tertiary = const Color(0xFFE8E8E8),
    this.stateDisabled = const Color(0xFFBDBDBD),
    this.overlayDark = Colors.black,
    this.overlayLight = Colors.white,
    this.accent = const Color(0xFFE63946),
    this.negative = const Color(0xFFE63946),
    this.warning = const Color(0xFFF4A261),
    this.positive = const Color(0xFF2A9D8F),
    this.lightAccent = const Color(0xFFFFE5E5),
    this.lightInfo = const Color(0xFFE0F2FE),
    this.lightNegative = const Color(0xFFFFCDD2),
    this.lightWarning = const Color(0xFFFFF3CD),
    this.lightPositive = const Color(0xFFDCFCE7),
    this.alwaysDark = Colors.black,
    this.alwaysLight = Colors.white,
  });

  @override
  final Color primary;
  @override
  final Color secondary;
  @override
  final Color tertiary;

  @override
  final Color stateDisabled;
  @override
  final Color overlayDark;
  @override
  final Color overlayLight;

  @override
  final Color accent;
  @override
  final Color negative;
  @override
  final Color warning;
  @override
  final Color positive;

  @override
  final Color lightAccent;
  @override
  final Color lightInfo;
  @override
  final Color lightNegative;
  @override
  final Color lightWarning;
  @override
  final Color lightPositive;

  @override
  final Color alwaysDark;
  @override
  final Color alwaysLight;

  MDCoralBackgroundColor copyWith({
    Color? primary,
    Color? secondary,
    Color? tertiary,
    Color? stateDisabled,
    Color? overlayDark,
    Color? overlayLight,
    Color? accent,
    Color? negative,
    Color? warning,
    Color? positive,
    Color? lightAccent,
    Color? lightInfo,
    Color? lightNegative,
    Color? lightWarning,
    Color? lightPositive,
    Color? alwaysDark,
    Color? alwaysLight,
  }) {
    return MDCoralBackgroundColor(
      primary: primary ?? this.primary,
      secondary: secondary ?? this.secondary,
      tertiary: tertiary ?? this.tertiary,
      stateDisabled: stateDisabled ?? this.stateDisabled,
      overlayDark: overlayDark ?? this.overlayDark,
      overlayLight: overlayLight ?? this.overlayLight,
      accent: accent ?? this.accent,
      negative: negative ?? this.negative,
      warning: warning ?? this.warning,
      positive: positive ?? this.positive,
      lightAccent: lightAccent ?? this.lightAccent,
      lightInfo: lightInfo ?? this.lightInfo,
      lightNegative: lightNegative ?? this.lightNegative,
      lightWarning: lightWarning ?? this.lightWarning,
      lightPositive: lightPositive ?? this.lightPositive,
      alwaysDark: alwaysDark ?? this.alwaysDark,
      alwaysLight: alwaysLight ?? this.alwaysLight,
    );
  }

  MDCoralBackgroundColor merge(MDCoralBackgroundColor? other) {
    if (other == null) return this;
    return copyWith(
      primary: other.primary,
      secondary: other.secondary,
      tertiary: other.tertiary,
      stateDisabled: other.stateDisabled,
      overlayDark: other.overlayDark,
      overlayLight: other.overlayLight,
      accent: other.accent,
      negative: other.negative,
      warning: other.warning,
      positive: other.positive,
      lightAccent: other.lightAccent,
      lightInfo: other.lightInfo,
      lightNegative: other.lightNegative,
      lightWarning: other.lightWarning,
      lightPositive: other.lightPositive,
      alwaysDark: other.alwaysDark,
      alwaysLight: other.alwaysLight,
    );
  }
}

class MDCoralContentColor implements MDContentColor {
  MDCoralContentColor({
    this.primary = Colors.black,
    this.secondary = const Color(0xFF757575),
    this.tertiary = const Color(0xFF616161),
    this.stateDisabled = const Color(0xFFBDBDBD),
    this.onColor = Colors.white,
    this.onColorInverse = Colors.black,
    this.accent = const Color(0xFF457B9D),
    this.negative = const Color(0xFFE63946),
    this.warning = const Color(0xFFF4A261),
    this.positive = const Color(0xFF2A9D8F),
  });

  @override
  final Color primary;
  @override
  final Color secondary;
  @override
  final Color tertiary;

  @override
  final Color stateDisabled;
  @override
  final Color onColor;
  @override
  final Color onColorInverse;

  @override
  final Color accent;
  @override
  final Color negative;
  @override
  final Color warning;
  @override
  final Color positive;

  MDCoralContentColor copyWith({
    Color? primary,
    Color? secondary,
    Color? tertiary,
    Color? stateDisabled,
    Color? onColor,
    Color? onColorInverse,
    Color? accent,
    Color? negative,
    Color? warning,
    Color? positive,
  }) {
    return MDCoralContentColor(
      primary: primary ?? this.primary,
      secondary: secondary ?? this.secondary,
      tertiary: tertiary ?? this.tertiary,
      stateDisabled: stateDisabled ?? this.stateDisabled,
      onColor: onColor ?? this.onColor,
      onColorInverse: onColorInverse ?? this.onColorInverse,
      accent: accent ?? this.accent,
      negative: negative ?? this.negative,
      warning: warning ?? this.warning,
      positive: positive ?? this.positive,
    );
  }

  MDCoralContentColor merge(MDCoralContentColor? other) {
    if (other == null) return this;
    return copyWith(
      primary: other.primary,
      secondary: other.secondary,
      tertiary: other.tertiary,
      stateDisabled: other.stateDisabled,
      onColor: other.onColor,
      onColorInverse: other.onColorInverse,
      accent: other.accent,
      negative: other.negative,
      warning: other.warning,
      positive: other.positive,
    );
  }
}

class MDCoralBorderColor implements MDBorderColor {
  MDCoralBorderColor({
    this.opaque = const Color(0xFFE8E8E8),
    this.transparent = Colors.transparent,
    this.selected = Colors.black,
    this.stateDisabled = const Color(0xFFF3F3F3),
    this.accent = const Color(0xFFFF5F68),
    this.negative = const Color(0xFFDE1135),
    this.warning = const Color(0xFF9F6402),
    this.positive = const Color(0xFF0E8345),
  });

  @override
  final Color opaque;
  @override
  final Color transparent;
  @override
  final Color selected;

  @override
  final Color stateDisabled;
  @override
  final Color accent;
  @override
  final Color negative;
  @override
  final Color warning;
  @override
  final Color positive;

  MDCoralBorderColor copyWith({
    Color? opaque,
    Color? transparent,
    Color? selected,
    Color? stateDisabled,
    Color? accent,
    Color? negative,
    Color? warning,
    Color? positive,
  }) {
    return MDCoralBorderColor(
      opaque: opaque ?? this.opaque,
      transparent: transparent ?? this.transparent,
      selected: selected ?? this.selected,
      stateDisabled: stateDisabled ?? this.stateDisabled,
      accent: accent ?? this.accent,
      negative: negative ?? this.negative,
      warning: warning ?? this.warning,
      positive: positive ?? this.positive,
    );
  }

  MDCoralBorderColor merge(MDCoralBorderColor? other) {
    if (other == null) return this;
    return copyWith(
      opaque: other.opaque,
      transparent: other.transparent,
      selected: other.selected,
      stateDisabled: other.stateDisabled,
      accent: other.accent,
      negative: other.negative,
      warning: other.warning,
      positive: other.positive,
    );
  }
}
