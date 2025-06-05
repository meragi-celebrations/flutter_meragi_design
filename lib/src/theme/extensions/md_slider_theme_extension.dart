import 'package:flutter/material.dart';
import 'package:flutter_meragi_design/src/theme/components/slider_theme.dart';

class SliderThemeExtension extends ThemeExtension<SliderThemeExtension> {
  final MDSliderTheme theme;

  SliderThemeExtension({required this.theme});

  @override
  SliderThemeExtension copyWith({final SliderThemeExtension? extension}) {
    return SliderThemeExtension(theme: theme.merge(other: extension?.theme));
  }

  @override
  SliderThemeExtension lerp(SliderThemeExtension? other, double t) {
    return SliderThemeExtension(theme: theme.lerp(sliderTheme: other?.theme, t: t));
  }
}

extension ThemeDataSliderThemeExtension on ThemeData {
  MDSliderTheme get mdSliderTheme => extension<SliderThemeExtension>()!.theme;
}
