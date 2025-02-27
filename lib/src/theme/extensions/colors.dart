import 'package:flutter/material.dart';
import 'package:flutter_meragi_design/src/theme/components/app_colors.dart';

class AppColorExtension extends ThemeExtension<AppColorExtension> {
  final AppColor colors;

  const AppColorExtension({required this.colors});

  @override
  AppColorExtension copyWith({AppColor? colors}) {
    return AppColorExtension(colors: colors ?? this.colors);
  }

  @override
  AppColorExtension lerp(AppColorExtension? other, double t) {
    if (other is! AppColorExtension) return this;
    return this;
  }
}

extension ThemeDataAppColorExtension on ThemeData {
  AppColor get colors => extension<AppColorExtension>()!.colors;
}
