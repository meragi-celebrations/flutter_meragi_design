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

  ShadColorScheme get shadColorScheme => ShadColorScheme(
        background: colors.background.primary,
        foreground: colors.content.primary,
        card: colors.background.primary,
        cardForeground: colors.content.primary,
        popover: colors.background.secondary,
        popoverForeground: colors.content.primary,
        primary: colors.primary,
        primaryForeground: colors.content.onColor,
        secondary: colors.background.tertiary,
        secondaryForeground: colors.content.primary,
        muted: colors.background.stateDisabled,
        mutedForeground: colors.content.stateDisabled,
        accent: colors.accent,
        accentForeground: colors.content.primary,
        destructive: colors.negative,
        destructiveForeground: colors.content.onColor,
        border: colors.border.opaque,
        input: colors.border.opaque,
        selection: colors.background.tertiary,
        ring: colors.primary,
      );

  ShadThemeData get shadTheme => ShadThemeData(
        colorScheme: shadColorScheme,
        brightness: Brightness.light,
        textTheme: ShadTextTheme(
          family: typography.fontFamily,
          h1Large: typography.heading.xLarge,
          h1: typography.heading.large,
          h2: typography.heading.medium,
          h3: typography.heading.small,
          h4: typography.heading.xSmall,
          p: typography.paragraph.medium,
          small: typography.paragraph.small,
          large: typography.paragraph.large,
        ),
        primaryButtonTheme: ShadButtonTheme(
          backgroundColor: colors.primary,
          foregroundColor: colors.content.onColor,
          hoverBackgroundColor: colors.primary.lighten(20),
        ),
        secondaryButtonTheme: ShadButtonTheme(
          merge: true,
          backgroundColor: colors.background.tertiary,
          foregroundColor: colors.content.primary,
          hoverBackgroundColor: colors.background.tertiary.darken(),
        ),
        outlineButtonTheme: ShadButtonTheme(
          merge: true,
          backgroundColor: colors.background.primary,
          foregroundColor: colors.content.primary,
          hoverBackgroundColor: colors.background.primary.darken(),
        ),
        ghostButtonTheme: ShadButtonTheme(
          merge: true,
          backgroundColor: colors.background.primary,
          foregroundColor: colors.content.primary,
          hoverBackgroundColor: colors.background.primary.darken(),
        ),
        destructiveButtonTheme: ShadButtonTheme(
          merge: true,
          backgroundColor: colors.negative,
          foregroundColor: colors.content.onColor,
          hoverBackgroundColor: colors.negative.darken(),
        ),
        buttonSizesTheme: const ShadButtonSizesTheme(
          sm: ShadButtonSizeTheme(
            padding: EdgeInsets.symmetric(horizontal: 5, vertical: 0),
            height: 34,
          ),
          regular: ShadButtonSizeTheme(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
            height: 38,
          ),
          icon: ShadButtonSizeTheme(
            padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
            height: 28,
            width: 28
          ),
        ),
        optionTheme: ShadOptionTheme(
          hoveredBackgroundColor: colors.background.tertiary,
        ),
        inputTheme: ShadInputTheme(
          placeholderStyle: typography.paragraph.small.copyWith(color: colors.content.stateDisabled),
          decoration: ShadDecoration(
            border: ShadBorder(
              top: BorderSide(color: colors.border.opaque),
              bottom: BorderSide(color: colors.border.opaque),
              left: BorderSide(color: colors.border.opaque),
              right: BorderSide(color: colors.border.opaque),
            ),
          ),
        ),
        checkboxTheme: ShadCheckboxTheme(
          decoration: ShadDecoration(
            border: ShadBorder(
              top: BorderSide(color: colors.border.opaque.darken(15)),
              bottom: BorderSide(color: colors.border.opaque.darken(15)),
              left: BorderSide(color: colors.border.opaque.darken(15)),
              right: BorderSide(color: colors.border.opaque.darken(15)),
            ),),
        ),
        contextMenuTheme: ShadContextMenuTheme(
          backgroundColor: colors.background.primary,
          selectedBackgroundColor: colors.background.tertiary,
          textStyle: typography.paragraph.small,
          trailingTextStyle: typography.paragraph.small.copyWith(color: colors.content.stateDisabled),
        ),
      );

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
          AppDimensionExtension(dimensions: dimensions),
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
