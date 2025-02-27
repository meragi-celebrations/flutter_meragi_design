import 'package:flutter/material.dart';
import 'package:flutter_meragi_design/src/theme/components/typography.dart';

class AppTypographyExtension extends ThemeExtension<AppTypographyExtension> {
  final AppTypography fonts;

  const AppTypographyExtension({required this.fonts});

  @override
  AppTypographyExtension copyWith({AppTypography? fonts}) {
    return AppTypographyExtension(fonts: fonts ?? this.fonts);
  }

  @override
  AppTypographyExtension lerp(AppTypographyExtension? other, double t) {
    if (other is! AppTypographyExtension) return this;
    return this;
  }
}

extension ThemeDataAppTypographyExtension on ThemeData {
  AppTypography get fonts => extension<AppTypographyExtension>()!.fonts;
}
