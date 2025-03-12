import 'package:flutter/material.dart';
import 'package:flutter_meragi_design/src/theme/components/decorator.dart';

class MDDecorationExtension extends ThemeExtension<MDDecorationExtension> {
  final MDDecoration decoration;

  const MDDecorationExtension({required this.decoration});

  @override
  MDDecorationExtension copyWith({MDDecoration? decoration}) {
    return MDDecorationExtension(decoration: decoration ?? this.decoration);
  }

  @override
  MDDecorationExtension lerp(MDDecorationExtension? other, double t) {
    if (other is! MDDecorationExtension) return this;
    return this;
  }
}

extension ThemeDataMDDecorationExtension on ThemeData {
  MDDecoration get decoration => extension<MDDecorationExtension>()!.decoration;
}
