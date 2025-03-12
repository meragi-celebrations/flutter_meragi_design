import 'package:flutter/material.dart';
import 'package:flutter_meragi_design/flutter_meragi_design.dart';

class MDPopoverThemeExtension extends ThemeExtension<MDPopoverThemeExtension> {
  final MDPopoverTheme popoverTheme;

  const MDPopoverThemeExtension({required this.popoverTheme});

  @override
  MDPopoverThemeExtension copyWith({MDPopoverTheme? popoverTheme}) {
    return MDPopoverThemeExtension(
        popoverTheme: popoverTheme ?? this.popoverTheme);
  }

  @override
  MDPopoverThemeExtension lerp(MDPopoverThemeExtension? other, double t) {
    if (other is! MDPopoverThemeExtension) return this;
    return this;
  }
}

extension ThemeDataMDPopoverThemeExtension on ThemeData {
  MDPopoverTheme get popoverTheme =>
      extension<MDPopoverThemeExtension>()!.popoverTheme;
}
