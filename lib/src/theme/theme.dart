import 'package:flutter/material.dart';
import 'package:flutter_meragi_design/flutter_meragi_design.dart';
import 'package:flutter_meragi_design/src/theme/theme_tokens.dart';

class MeragiTheme extends InheritedWidget {
  late final ThemeToken token;

  MeragiTheme({super.key, required super.child, ThemeToken? token})
      : token = token ?? light;

  @override
  bool updateShouldNotify(covariant MeragiTheme oldWidget) {
    return oldWidget.token != token;
  }

  static MeragiTheme of(BuildContext context) {
    final MeragiTheme? result = maybeOf(context);
    assert(result != null, 'No Meragi Theme found in context');
    return result!;
  }

  static MeragiTheme? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<MeragiTheme>();
  }
}

class MDTheme {
  final AppColor colors;
  final AppTypography typography;
  final AppDimension dimensions;

  final MDInputTheme? inputTheme;

  const MDTheme({
    required this.colors,
    required this.typography,
    required this.dimensions,
    this.inputTheme,
  });

  ThemeData get themeData => ThemeData(
        primaryColor: colors.primary,
        secondaryHeaderColor: colors.primaryB,
        brightness: Brightness.light,
        fontFamily: typography.fontFamily,
        // backgroundColor: appColor.background.primary,
        scaffoldBackgroundColor: colors.background.primary,
        extensions: [
          AppColorExtension(colors: colors),
          AppTypographyExtension(fonts: typography),
          MDInputThemeExtension(
            theme: MDInputTheme(
              cursorColor: colors.primary,
              borderColor: colors.border.opaque,
              selectionColor: colors.background.tertiary,
              borderRadius: dimensions.radius,
              height: dimensions.inputHeight,
              textStyle: typography.paragraph.medium,
              padding: EdgeInsets.symmetric(
                vertical: 0.0,
                horizontal: dimensions.padding,
              ),
            ).merge(inputTheme),
          ),
        ],
      );
}

extension MeragiToken on BuildContext {
  ThemeToken get token => MeragiTheme.of(this).token;
}
