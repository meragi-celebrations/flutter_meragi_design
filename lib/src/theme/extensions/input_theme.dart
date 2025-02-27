import 'package:flutter/material.dart';
import 'package:flutter_meragi_design/src/theme/components/input_theme.dart';

class MDInputThemeExtension extends ThemeExtension<MDInputThemeExtension> {
  final MDInputTheme theme;

  const MDInputThemeExtension({required this.theme});

  @override
  MDInputThemeExtension copyWith({MDInputTheme? theme}) {
    return MDInputThemeExtension(theme: theme ?? this.theme);
  }

  @override
  MDInputThemeExtension lerp(MDInputThemeExtension? other, double t) {
    if (other is! MDInputThemeExtension) return this;
    return this;
  }
}

extension ThemeDataMDInputThemeExtension on ThemeData {
  MDInputTheme get inputTheme => extension<MDInputThemeExtension>()!.theme;
}
