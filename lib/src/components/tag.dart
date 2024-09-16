import 'package:flutter/material.dart';
import 'package:flutter_meragi_design/src/theme/style.dart';

enum TagType { defaultType, primary, secondary, danger, success, warning, info }

enum TagSize { sm, rg, lg }

/// A tag widget that can be used to display a tag-like widget.
///
/// The [TagDecoration] class is used to customize the appearance of the tag.
/// The [TagType] enum is used to specify the type of the tag.
/// The [TagSize] enum is used to specify the size of the tag.
///
/// The [body] property can be used to specify the content of the tag.
/// The [text] property can be used to specify the text of the tag.
/// The [icon] property can be used to specify the icon of the tag.
///
/// The [isDetailed] method can be used to check if the tag is detailed.
/// The [buildBody] method can be used to build the body of the tag.
class MDTag extends StatelessWidget {
  final Widget? body;
  final String? text;
  final IconData? icon;
  final TagDecoration? decoration;

  const MDTag({
    super.key,
    this.body,
    this.text,
    this.icon,
    this.decoration,
  })  : _title = null,
        _value = null;

  const MDTag.detailed({
    super.key,
    required String title,
    required String value,
    this.decoration,
  })  : body = null,
        text = null,
        icon = null,
        _title = title,
        _value = value;

  final String? _title;
  final String? _value;

  bool isDetailed() => _title != null && _value != null;

  Widget buildBody(TagDecoration finalTagDecoration) {
    var textStyle = TextStyle(
      color: finalTagDecoration.textColor,
      height: finalTagDecoration.textHeight,
      fontSize: finalTagDecoration.textSize,
      fontWeight: finalTagDecoration.textWeight,
    );

    if (isDetailed()) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _title!,
            style: textStyle.copyWith(
              fontSize: finalTagDecoration.textSize * .7,
              height: 0,
            ),
          ),
          Text(
            _value!,
            style: textStyle.copyWith(height: 0),
          ),
        ],
      );
    }

    return (body != null)
        ? body!
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null)
                Row(
                  children: [
                    Icon(
                      icon,
                      color: finalTagDecoration.textColor,
                      size: finalTagDecoration.iconSize,
                    ),
                    SizedBox(
                      width: finalTagDecoration.spacing,
                    ),
                  ],
                ),
              if (text != null)
                Text(
                  text!,
                  style: textStyle,
                ),
            ],
          );
  }

  @override
  Widget build(BuildContext context) {
    TagDecoration finalTagDecoration = TagDecoration(
      context: context,
    ).merge(decoration);

    return Container(
      padding: finalTagDecoration.padding,
      decoration: BoxDecoration(
          color: finalTagDecoration.backgroundColor,
          borderRadius: BorderRadius.circular(
            finalTagDecoration.borderRadius,
          ),
          border: Border.all(
            color: finalTagDecoration.borderColor,
          )),
      child: buildBody(finalTagDecoration),
    );
  }
}

/// A class for customizing the appearance of a tag.
class TagDecoration extends Style {
  final TagType type;
  final TagSize size;
  final Color? backgroundColorOverride;
  final Color? textColorOverride;
  final double? borderRadiusOverride;
  final EdgeInsets? paddingOverride;
  final double? iconSizeOverride;
  final double? textSizeOverride;
  final double? textHeightOverride;
  final FontWeight? textWeightOverride;
  final double? spacingOverride;

  const TagDecoration({
    required super.context,
    this.type = TagType.defaultType,
    this.size = TagSize.rg,
    this.backgroundColorOverride,
    this.textColorOverride,
    this.borderRadiusOverride,
    this.paddingOverride,
    this.iconSizeOverride,
    this.textSizeOverride,
    this.textHeightOverride,
    this.textWeightOverride,
    this.spacingOverride,
  });

  @override
  Map get styles => {
        TagType.defaultType: {
          'backgroundColor': token.defaultTagBackgroundColor,
          'textColor': token.defaultTagTextColor,
          'borderColor': token.defaultTagBorderColor,
        },
        TagType.primary: {
          'backgroundColor': token.primaryTagBackgroundColor,
          'textColor': token.primaryTagTextColor,
          'borderColor': token.primaryTagBorderColor,
        },
        TagType.secondary: {
          'backgroundColor': token.secondaryTagBackgroundColor,
          'textColor': token.secondaryTagTextColor,
          'borderColor': token.secondaryTagBorderColor,
        },
        TagType.danger: {
          'backgroundColor': token.dangerTagBackgroundColor,
          'textColor': token.dangerTagTextColor,
          'borderColor': token.dangerTagBorderColor,
        },
        TagType.success: {
          'backgroundColor': token.successTagBackgroundColor,
          'textColor': token.successTagTextColor,
          'borderColor': token.successTagBorderColor,
        },
        TagType.warning: {
          'backgroundColor': token.warningTagBackgroundColor,
          'textColor': token.warningTagTextColor,
          'borderColor': token.warningTagBorderColor,
        },
        TagType.info: {
          'backgroundColor': token.infoTagBackgroundColor,
          'textColor': token.infoTagTextColor,
          'borderColor': token.infoTagBorderColor,
        },
        TagSize.sm: {
          'padding': token.smTagPadding,
          'borderRadius': token.smTagBorderRadius,
          'iconSize': token.smTagIconSize,
          'textSize': token.smTagTextSize,
          'textHeight': token.smTagTextHeight,
          'textWeight': token.smTagTextWeight,
          'spacing': token.smTagSpacing,
        },
        TagSize.rg: {
          'padding': token.rgTagPadding,
          'borderRadius': token.rgTagBorderRadius,
          'iconSize': token.rgTagIconSize,
          'textSize': token.rgTagTextSize,
          'textHeight': token.rgTagTextHeight,
          'textWeight': token.rgTagTextWeight,
          'spacing': token.rgTagSpacing,
        },
        TagSize.lg: {
          'padding': token.lgTagPadding,
          'borderRadius': token.lgTagBorderRadius,
          'iconSize': token.lgTagIconSize,
          'textSize': token.lgTagTextSize,
          'textHeight': token.lgTagTextHeight,
          'textWeight': token.lgTagTextWeight,
          'spacing': token.lgTagSpacing,
        },
      };

  Color get backgroundColor =>
      backgroundColorOverride ?? getStyle(type, "backgroundColor");

  Color get textColor => textColorOverride ?? getStyle(type, "textColor");

  Color get borderColor => getStyle(type, "borderColor");

  double get borderRadius =>
      borderRadiusOverride ?? getStyle(size, "borderRadius");

  double get iconSize => iconSizeOverride ?? getStyle(size, "iconSize");

  double get textSize => textSizeOverride ?? getStyle(size, "textSize");

  double get textHeight => textHeightOverride ?? getStyle(size, "textHeight");

  FontWeight get textWeight =>
      textWeightOverride ?? getStyle(size, "textWeight");

  double get spacing => spacingOverride ?? getStyle(size, "spacing");

  EdgeInsets get padding => paddingOverride ?? getStyle(size, "padding");

  TagDecoration copyWith({
    BuildContext? context,
    TagType? type,
    TagSize? size,
    Color? backgroundColorOverride,
    Color? textColorOverride,
    double? borderRadiusOverride,
    EdgeInsets? paddingOverride,
    double? iconSizeOverride,
    double? textSizeOverride,
    double? textHeightOverride,
    FontWeight? textWeightOverride,
    double? spacingOverride,
  }) {
    return TagDecoration(
      context: context ?? this.context,
      type: type ?? this.type,
      size: size ?? this.size,
      backgroundColorOverride:
          backgroundColorOverride ?? this.backgroundColorOverride,
      textColorOverride: textColorOverride ?? this.textColorOverride,
      borderRadiusOverride: borderRadiusOverride ?? this.borderRadiusOverride,
      paddingOverride: paddingOverride ?? this.paddingOverride,
      iconSizeOverride: iconSizeOverride ?? this.iconSizeOverride,
      textSizeOverride: textSizeOverride ?? this.textSizeOverride,
      textHeightOverride: textHeightOverride ?? this.textHeightOverride,
      textWeightOverride: textWeightOverride ?? this.textWeightOverride,
      spacingOverride: spacingOverride ?? this.spacingOverride,
    );
  }

  TagDecoration merge(TagDecoration? other) {
    if (other == null) {
      return this;
    }
    return TagDecoration(
      context: other.context,
      type: other.type,
      size: other.size,
      backgroundColorOverride:
          other.backgroundColorOverride ?? backgroundColorOverride,
      textColorOverride: other.textColorOverride ?? textColorOverride,
      borderRadiusOverride: other.borderRadiusOverride ?? borderRadiusOverride,
      paddingOverride: other.paddingOverride ?? paddingOverride,
      iconSizeOverride: other.iconSizeOverride ?? iconSizeOverride,
      textSizeOverride: other.textSizeOverride ?? textSizeOverride,
      textHeightOverride: other.textHeightOverride ?? textHeightOverride,
      textWeightOverride: other.textWeightOverride ?? textWeightOverride,
      spacingOverride: other.spacingOverride ?? spacingOverride,
    );
  }
}
