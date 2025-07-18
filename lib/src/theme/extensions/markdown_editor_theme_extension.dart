import 'package:flutter/material.dart';
import 'package:flutter_meragi_design/src/theme/components/markdown_editor_theme.dart';

class MDMarkdownEditorThemeExtension extends ThemeExtension<MDMarkdownEditorThemeExtension> {
  final MDMarkdownEditorTheme theme;

  const MDMarkdownEditorThemeExtension({required this.theme});

  @override
  MDMarkdownEditorThemeExtension copyWith({MDMarkdownEditorTheme? theme}) {
    return MDMarkdownEditorThemeExtension(theme: theme ?? this.theme);
  }

  @override
  MDMarkdownEditorThemeExtension lerp(MDMarkdownEditorThemeExtension? other, double t) {
    if (other is! MDMarkdownEditorThemeExtension) return this;
    return this;
  }
}

extension ThemeDataMDMarkdownEditorThemeExtension on ThemeData {
  MDMarkdownEditorTheme get markdownEditorTheme => 
    extension<MDMarkdownEditorThemeExtension>()?.theme ?? const MDMarkdownEditorTheme();
} 