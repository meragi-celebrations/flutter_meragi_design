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
          backgroundColor: colors.background.secondary,
          foregroundColor: colors.content.primary,
          hoverBackgroundColor: colors.background.tertiary.darken(),
        ),
        outlineButtonTheme: ShadButtonTheme(
          merge: true,
          backgroundColor: Colors.transparent,
          foregroundColor: colors.primary,
          hoverBackgroundColor: colors.background.tertiary,
          hoverForegroundColor: colors.primary,
        ),
        ghostButtonTheme: ShadButtonTheme(
          merge: true,
          backgroundColor: Colors.transparent,
          foregroundColor: colors.primary,
          hoverBackgroundColor: colors.background.tertiary,
          hoverForegroundColor: colors.primary,
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
            height: 26,
          ),
          regular: ShadButtonSizeTheme(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
            height: 34,
          ),
          icon: ShadButtonSizeTheme(
              padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
              height: 28,
              width: 28),
        ),
        optionTheme: ShadOptionTheme(
          hoveredBackgroundColor: colors.background.tertiary,
        ),
        inputTheme: ShadInputTheme(
          placeholderStyle: typography.paragraph.small
              .copyWith(color: colors.content.stateDisabled),

          decoration: ShadDecoration(
            border: ShadBorder(
              top: BorderSide(color: colors.border.opaque),
              bottom: BorderSide(color: colors.border.opaque),
              left: BorderSide(color: colors.border.opaque),
              right: BorderSide(color: colors.border.opaque),
            ),
          ),
          // padding: EdgeInsets.symmetric(horizontal: dimensions.padding, vertical: dimensions.padding / 2),
        ),
        checkboxTheme: ShadCheckboxTheme(
          decoration: ShadDecoration(
            border: ShadBorder(
              top: BorderSide(color: colors.border.opaque.darken(15)),
              bottom: BorderSide(color: colors.border.opaque.darken(15)),
              left: BorderSide(color: colors.border.opaque.darken(15)),
              right: BorderSide(color: colors.border.opaque.darken(15)),
            ),
          ),
        ),
        radioTheme: ShadRadioTheme(
            circleSize: 14,
            decoration: ShadDecoration(
                border: ShadBorder.all(
              color: colors.border.opaque,
            ))),
        contextMenuTheme: ShadContextMenuTheme(
          textStyle: typography.paragraph.small,
          trailingTextStyle: typography.paragraph.small
              .copyWith(color: colors.content.stateDisabled),
          constraints: const BoxConstraints(minWidth: 250),
          selectedBackgroundColor: colors.background.secondary,
          itemDecoration: ShadDecoration(
            color: colors.background.primary,
          ),
        ),
        cardTheme: ShadCardTheme(padding: EdgeInsets.all(dimensions.padding)),
        popoverTheme: ShadPopoverTheme(
          decoration: ShadDecoration(
            color: colors.background.primary,
            border: ShadBorder.all(color: colors.border.transparent),
          ),
        ),
      );

  ThemeData get themeData => ThemeData(
        primaryColor: colors.primary,
        secondaryHeaderColor: colors.primaryB,
        brightness: Brightness.light,
        fontFamily: typography.fontFamily,
        scaffoldBackgroundColor: colors.background.tertiary,
        iconTheme: IconThemeData(color: colors.primary),
        checkboxTheme: CheckboxThemeData(
          fillColor: MDWidgetStateResolver<Color>({
            WidgetState.selected: colors.primary,
            WidgetState.hovered: colors.background.secondary.darken(20),
            "default": colors.background.secondary,
          }).resolveWith(),
          side: BorderSide(
            color: colors.background.secondary,
            width: 1,
          ),
        ),
        sliderTheme: SliderThemeData(
          activeTrackColor: colors.primary,
          inactiveTrackColor: colors.background.secondary,
          thumbColor: colors.primary,
          overlayColor: colors.primary.withOpacity(0.3),
          rangeThumbShape: RoundRangeSliderThumbShape(
            enabledThumbRadius: dimensions.radius / 2,
          ),
          trackHeight: dimensions.stroke * 2,
        ),
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
