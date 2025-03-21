import 'package:flutter/material.dart';
import 'package:flutter_meragi_design/src/theme/components/editor_theme.dart';

class MDEditorThemeExtension extends ThemeExtension<MDEditorThemeExtension> {
  final MDEditorTheme theme;

  const MDEditorThemeExtension({required this.theme});

  @override
  MDEditorThemeExtension copyWith({MDEditorTheme? theme}) {
    return MDEditorThemeExtension(theme: theme ?? this.theme);
  }

  @override
  MDEditorThemeExtension lerp(MDEditorThemeExtension? other, double t) {
    if (other is! MDEditorThemeExtension) return this;
    return this;
  }
}

extension ThemeDataMDEditorThemeExtension on ThemeData {
  MDEditorTheme get editorTheme => extension<MDEditorThemeExtension>()!.theme;
}
