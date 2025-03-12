import 'package:flutter/material.dart';
import 'package:flutter_meragi_design/flutter_meragi_design.dart';

class MDContextMenuThemeExtension
    extends ThemeExtension<MDContextMenuThemeExtension> {
  final MDContextMenuTheme contextMenuTheme;

  const MDContextMenuThemeExtension({required this.contextMenuTheme});

  @override
  MDContextMenuThemeExtension copyWith({MDContextMenuTheme? contextMenuTheme}) {
    return MDContextMenuThemeExtension(
        contextMenuTheme: contextMenuTheme ?? this.contextMenuTheme);
  }

  @override
  MDContextMenuThemeExtension lerp(
      MDContextMenuThemeExtension? other, double t) {
    if (other is! MDContextMenuThemeExtension) return this;
    return this;
  }
}

extension ThemeDataMDContextMenuThemeExtension on ThemeData {
  MDContextMenuTheme get contextMenuTheme =>
      extension<MDContextMenuThemeExtension>()!.contextMenuTheme;
}
