import 'package:flutter/material.dart';
import 'package:flutter_meragi_design/flutter_meragi_design.dart';
import 'package:flutter_meragi_design/src/theme/theme_tokens.dart';

/// Enum for different text types
enum TextType {
  primary,
  secondary,
  success,
  warning,
  info,
  error,
  disabled,
  standard,
}

/// Abstract base class for all text widgets
abstract class BaseText extends StatelessWidget {
  /// The text to be displayed
  final String text;

  /// The type of text (e.g. primary, secondary, etc.)
  final TextType type;

  final TextStyle? style;

  /// Constructor for BaseText
  const BaseText(
      {Key? key, required this.text, this.type = TextType.standard, this.style})
      : super(key: key);

  /// Get the text style for this text widget
  TextStyle textStyle(BuildContext context);

  /// Get the text color for this text widget based on the type
  Color _getTextColor(TextType type, ThemeToken token) {
    switch (type) {
      case TextType.primary:
        return token.primaryTextColor;
      case TextType.secondary:
        return token.secondaryTextColor;
      case TextType.success:
        return token.successTextColor;
      case TextType.warning:
        return token.warningTextColor;
      case TextType.info:
        return token.infoTextColor;
      case TextType.error:
        return token.errorTextColor;
      case TextType.disabled:
        return token.disabledTextColor;
      default:
        return token.defaultTextColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeToken token = MeragiTheme.of(context).token;
    return Text(
      text,
      style: textStyle(context)
          .copyWith(
            color: _getTextColor(type, token),
          )
          .merge(style),
    );
  }
}

/// Display text widget
class DisplayText extends BaseText {
  /// Constructor for DisplayText
  const DisplayText(
      {Key? key,
      required String text,
      TextType type = TextType.standard,
      TextStyle? style})
      : super(key: key, text: text, type: type, style: style);

  @override
  TextStyle textStyle(BuildContext context) =>
      MeragiTheme.of(context).token.displayTextStyle;
}

/// H1 text widget
class H1 extends BaseText {
  /// Constructor for H1
  const H1(
      {Key? key,
      required String text,
      TextType type = TextType.standard,
      TextStyle? style})
      : super(key: key, text: text, type: type, style: style);

  @override
  TextStyle textStyle(BuildContext context) =>
      MeragiTheme.of(context).token.h1TextStyle;
}

/// H2 text widget
class H2 extends BaseText {
  /// Constructor for H2
  const H2({
    Key? key,
    required String text,
    TextType type = TextType.standard,
    TextStyle? style,
  }) : super(
          key: key,
          text: text,
          type: type,
          style: style,
        );

  @override
  TextStyle textStyle(BuildContext context) =>
      MeragiTheme.of(context).token.h2TextStyle;
}

/// H3 text widget
class H3 extends BaseText {
  /// Constructor for H3
  const H3({
    Key? key,
    required String text,
    TextType type = TextType.standard,
    TextStyle? style,
  }) : super(
          key: key,
          text: text,
          type: type,
          style: style,
        );

  @override
  TextStyle textStyle(BuildContext context) =>
      MeragiTheme.of(context).token.h3TextStyle;
}

/// H4 text widget
class H4 extends BaseText {
  /// Constructor for H4
  const H4({
    Key? key,
    required String text,
    TextType type = TextType.standard,
    TextStyle? style,
  }) : super(
          key: key,
          text: text,
          type: type,
          style: style,
        );

  @override
  TextStyle textStyle(BuildContext context) =>
      MeragiTheme.of(context).token.h4TextStyle;
}

/// H5 text widget
class H5 extends BaseText {
  /// Constructor for H5
  const H5({
    Key? key,
    required String text,
    TextType type = TextType.standard,
    TextStyle? style,
  }) : super(
          key: key,
          text: text,
          type: type,
          style: style,
        );

  @override
  TextStyle textStyle(BuildContext context) =>
      MeragiTheme.of(context).token.h5TextStyle;
}

/// H5 text widget
class H6 extends BaseText {
  /// Constructor for H5
  const H6({
    Key? key,
    required String text,
    TextType type = TextType.standard,
    TextStyle? style,
  }) : super(
          key: key,
          text: text,
          type: type,
          style: style,
        );

  @override
  TextStyle textStyle(BuildContext context) =>
      MeragiTheme.of(context).token.h6TextStyle;
}

/// Body text widget
class BodyText extends BaseText {
  /// Constructor for BodyText
  const BodyText({
    Key? key,
    required String text,
    TextType type = TextType.standard,
    TextStyle? style,
  }) : super(
          key: key,
          text: text,
          type: type,
          style: style,
        );

  @override
  TextStyle textStyle(BuildContext context) =>
      MeragiTheme.of(context).token.bodyTextStyle;
}

/// Caption text widget
class CaptionText extends BaseText {
  /// Constructor for CaptionText
  const CaptionText({
    Key? key,
    required String text,
    TextType type = TextType.standard,
    TextStyle? style,
  }) : super(
          key: key,
          text: text,
          type: type,
          style: style,
        );

  @override
  TextStyle textStyle(BuildContext context) =>
      MeragiTheme.of(context).token.captionTextStyle;
}

/// Link text widget
class LinkText extends BaseText {
  /// Constructor for LinkText
  const LinkText({
    Key? key,
    required String text,
    TextType type = TextType.standard,
    TextStyle? style,
  }) : super(
          key: key,
          text: text,
          type: type,
          style: style,
        );

  @override
  TextStyle textStyle(BuildContext context) =>
      MeragiTheme.of(context).token.linkTextStyle;
}

/// Quote text widget
class QuoteText extends BaseText {
  /// Constructor for QuoteText
  const QuoteText({
    Key? key,
    required String text,
    TextType type = TextType.standard,
    TextStyle? style,
  }) : super(
          key: key,
          text: text,
          type: type,
          style: style,
        );

  @override
  TextStyle textStyle(BuildContext context) =>
      MeragiTheme.of(context).token.quoteTextStyle;
}

/// Code text widget
class CodeText extends BaseText {
  /// Constructor for CodeText
  const CodeText({
    Key? key,
    required String text,
    TextType type = TextType.standard,
    TextStyle? style,
  }) : super(
          key: key,
          text: text,
          type: type,
          style: style,
        );

  @override
  TextStyle textStyle(BuildContext context) =>
      MeragiTheme.of(context).token.codeTextStyle;
}
