import 'package:flutter/material.dart';
import 'package:flutter_meragi_design/src/theme/components/typography.dart';
import 'package:flutter_meragi_design/src/theme/extensions/typography.dart';
import 'package:flutter_meragi_design/src/theme/theme_tokens.dart';
import 'package:flutter_meragi_design/src/theme/tokens/light.dart';

import 'components/app_colors.dart';
import 'components/input_theme.dart';
import 'extensions/colors.dart';
import 'extensions/input_theme.dart';

class MeragiTheme extends InheritedWidget {
  late final ThemeToken token;

  MeragiTheme({super.key, required super.child, ThemeToken? token}) : token = token ?? light;

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
  final AppColor appColor;
  final AppTypography typography;
  // final MDDimensions dimensions;
  final MDInputTheme? inputTheme;

  const MDTheme({
    required this.appColor,
    required this.typography,
    // required this.dimensions,
    this.inputTheme,
  });

  ThemeData get themeData => ThemeData(
        primaryColor: appColor.primary,
        secondaryHeaderColor: appColor.primaryB,
        brightness: Brightness.light,
        fontFamily: typography.fontFamily,
        // backgroundColor: appColor.background.primary,
        scaffoldBackgroundColor: appColor.background.primary,
        extensions: [
          AppColorExtension(colors: appColor),
          AppTypographyExtension(fonts: typography),
          MDInputThemeExtension(
            theme: MDInputTheme(
              cursorColor: appColor.primary,
              borderColor: appColor.border.opaque,
              selectionColor: appColor.background.tertiary,
            ).merge(inputTheme),
          ),
        ],
      );
}

extension MeragiToken on BuildContext {
  ThemeToken get token => MeragiTheme.of(this).token;
}
