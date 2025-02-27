import 'package:flutter/material.dart';
import 'package:flutter_meragi_design/src/theme/components/dimensions.dart';

class AppDimensionExtension extends ThemeExtension<AppDimensionExtension> {
  final AppDimension dimensions;

  const AppDimensionExtension({required this.dimensions});

  @override
  AppDimensionExtension copyWith({AppDimension? dimensions}) {
    return AppDimensionExtension(dimensions: dimensions ?? this.dimensions);
  }

  @override
  AppDimensionExtension lerp(AppDimensionExtension? other, double t) {
    if (other is! AppDimensionExtension) return this;
    return this;
  }
}

extension ThemeDataAppDimensionExtension on ThemeData {
  AppDimension get dimensions => extension<AppDimensionExtension>()!.dimensions;
}
