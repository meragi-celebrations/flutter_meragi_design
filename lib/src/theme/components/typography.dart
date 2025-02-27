import 'package:flutter/material.dart';

abstract class AppTypography {
  const AppTypography({
    required this.paragraph,
    required this.heading,
    required this.fontFamily,
  });

  final MDParagraphTypography paragraph;
  final MDHeadingTypography heading;
  final String fontFamily;
}

abstract class MDParagraphTypography {
  const MDParagraphTypography({
    required this.fontFamily,
  });

  final String fontFamily;

  abstract final TextStyle xSmall;
  abstract final TextStyle small;
  abstract final TextStyle medium;
  abstract final TextStyle large;
}

abstract class MDHeadingTypography {
  const MDHeadingTypography({
    required this.fontFamily,
  });

  final String fontFamily;

  abstract final TextStyle xSmall;
  abstract final TextStyle small;
  abstract final TextStyle medium;
  abstract final TextStyle large;
  abstract final TextStyle xLarge;
  abstract final TextStyle xxLarge;
}

// Concrete implementation of AppTypography
class MDDefaultTypography implements AppTypography {
  MDDefaultTypography({
    this.fontFamily = 'Poppins',
  });

  @override
  final String fontFamily;

  @override
  late final MDParagraphTypography paragraph = _DefaultParagraphTypography(
    fontFamily: fontFamily,
  );

  @override
  late final MDHeadingTypography heading = _DefaultHeadingTypography(
    fontFamily: fontFamily,
  );
}

class _DefaultParagraphTypography implements MDParagraphTypography {
  const _DefaultParagraphTypography({
    required this.fontFamily,
  });

  @override
  final String fontFamily;

  @override
  TextStyle get xSmall => TextStyle(
        fontFamily: fontFamily,
        fontSize: 12,
        height: 20 / 12,
        fontWeight: FontWeight.normal,
      );

  @override
  TextStyle get small => TextStyle(
        fontFamily: fontFamily,
        fontSize: 14,
        height: 20 / 14,
        fontWeight: FontWeight.normal,
      );

  @override
  TextStyle get medium => TextStyle(
        fontFamily: fontFamily,
        fontSize: 16,
        height: 24 / 16,
        fontWeight: FontWeight.normal,
      );

  @override
  TextStyle get large => TextStyle(
        fontFamily: fontFamily,
        fontSize: 18,
        height: 28 / 18,
        fontWeight: FontWeight.normal,
      );
}

class _DefaultHeadingTypography implements MDHeadingTypography {
  const _DefaultHeadingTypography({
    required this.fontFamily,
  });

  @override
  final String fontFamily;

  @override
  TextStyle get xSmall => TextStyle(
        fontFamily: fontFamily,
        fontSize: 20,
        height: 28 / 20,
        fontWeight: FontWeight.bold,
      );

  @override
  TextStyle get small => TextStyle(
        fontFamily: fontFamily,
        fontSize: 24,
        height: 32 / 24,
        fontWeight: FontWeight.bold,
      );

  @override
  TextStyle get medium => TextStyle(
        fontFamily: fontFamily,
        fontSize: 28,
        height: 36 / 28,
        fontWeight: FontWeight.bold,
      );

  @override
  TextStyle get large => TextStyle(
        fontFamily: fontFamily,
        fontSize: 32,
        height: 40 / 32,
        fontWeight: FontWeight.bold,
      );

  @override
  TextStyle get xLarge => TextStyle(
        fontFamily: fontFamily,
        fontSize: 36,
        height: 44 / 36,
        fontWeight: FontWeight.bold,
      );

  @override
  TextStyle get xxLarge => TextStyle(
        fontFamily: fontFamily,
        fontSize: 40,
        height: 52 / 40,
        fontWeight: FontWeight.bold,
      );
}
