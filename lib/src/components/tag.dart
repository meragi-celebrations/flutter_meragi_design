import 'package:flutter/material.dart';
import 'package:flutter_meragi_design/flutter_meragi_design.dart';
import 'package:flutter_meragi_design/src/theme/theme_tokens.dart';

enum TagType { defaultType, primary, secondary, danger, success, warning }

enum TagSize { sm, rg, lg }

class MDTag extends StatelessWidget {
  final Widget? body;
  final String? text;
  final IconData? icon;
  final TagType type;
  final TagSize size;

  const MDTag({
    super.key,
    this.body,
    this.text,
    this.icon,
    this.type = TagType.defaultType,
    this.size = TagSize.rg,
  });

  Color backgroundColor(ThemeToken token) {
    switch (type) {
      case TagType.primary:
        return token.primaryTagBackgroundColor;
      case TagType.secondary:
        return token.secondaryTagBackgroundColor;
      case TagType.danger:
        return token.dangerTagBackgroundColor;
      case TagType.success:
        return token.successTagBackgroundColor;
      case TagType.warning:
        return token.warningTagBackgroundColor;
      default:
        return token.defaultTagBackgroundColor;
    }
  }

  Color borderColor(ThemeToken token) {
    switch (type) {
      case TagType.primary:
        return token.primaryTagBorderColor;
      case TagType.secondary:
        return token.secondaryTagBorderColor;
      case TagType.danger:
        return token.dangerTagBorderColor;
      case TagType.success:
        return token.successTagBorderColor;
      case TagType.warning:
        return token.warningTagBorderColor;
      default:
        return token.defaultTagBorderColor;
    }
  }

  EdgeInsets padding(ThemeToken token) {
    switch (size) {
      case TagSize.sm:
        return token.smTagPadding;
      case TagSize.rg:
        return token.rgTagPadding;
      case TagSize.lg:
        return token.lgTagPadding;
    }
  }

  double borderRadius(ThemeToken token) {
    switch (size) {
      case TagSize.sm:
        return token.smTagBorderRadius;
      case TagSize.rg:
        return token.rgTagBorderRadius;
      case TagSize.lg:
        return token.lgTagBorderRadius;
    }
  }

  double iconSize(ThemeToken token) {
    switch (size) {
      case TagSize.sm:
        return token.smTagIconSize;
      case TagSize.rg:
        return token.rgTagIconSize;
      case TagSize.lg:
        return token.lgTagIconSize;
    }
  }

  Color iconColor(ThemeToken token) {
    switch (type) {
      case TagType.primary:
        return token.primaryTagIconColor;
      case TagType.secondary:
        return token.secondaryTagIconColor;
      case TagType.danger:
        return token.dangerTagIconColor;
      case TagType.success:
        return token.successTagIconColor;
      case TagType.warning:
        return token.warningTagIconColor;
      default:
        return token.defaultTagIconColor;
    }
  }

  double textHeight(ThemeToken token) {
    switch (size) {
      case TagSize.sm:
        return token.smTagTextHeight;
      case TagSize.rg:
        return token.rgTagTextHeight;
      case TagSize.lg:
        return token.lgTagTextHeight;
    }
  }

  double textSize(ThemeToken token) {
    switch (size) {
      case TagSize.sm:
        return token.smTagTextSize;
      case TagSize.rg:
        return token.rgTagTextSize;
      case TagSize.lg:
        return token.lgTagTextSize;
    }
  }

  FontWeight textWeight(ThemeToken token) {
    switch (size) {
      case TagSize.sm:
        return token.smTagTextWeight;
      case TagSize.rg:
        return token.rgTagTextWeight;
      case TagSize.lg:
        return token.lgTagTextWeight;
    }
  }

  Color textColor(ThemeToken token) {
    switch (type) {
      case TagType.primary:
        return token.primaryTagTextColor;
      case TagType.secondary:
        return token.secondaryTagTextColor;
      case TagType.danger:
        return token.dangerTagTextColor;
      case TagType.success:
        return token.successTagTextColor;
      case TagType.warning:
        return token.warningTagTextColor;
      default:
        return token.defaultTagTextColor;
    }
  }

  double spacing(ThemeToken token) {
    switch (size) {
      case TagSize.sm:
        return token.smTagSpacing;
      case TagSize.rg:
        return token.rgTagSpacing;
      case TagSize.lg:
        return token.lgTagSpacing;
    }
  }

  Widget finalBody(ThemeToken token) {
    return body ??
        Wrap(
          direction: Axis.horizontal,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: spacing(token),
          children: [
            if (icon != null)
              Icon(
                icon,
                size: iconSize(token),
                color: iconColor(token),
              ),
            Text(
              text!,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: textSize(token),
                fontWeight: textWeight(token),
                color: textColor(token),
                height: textHeight(token),
              ),
            )
          ],
        );
  }

  @override
  Widget build(BuildContext context) {
    ThemeToken token = MeragiTheme.of(context).token;
    return Container(
      padding: padding(token),
      decoration: BoxDecoration(
        color: backgroundColor(token),
        border: Border.all(
          width: token.tagBorderWidth,
          color: borderColor(token),
        ),
        borderRadius: BorderRadius.circular(borderRadius(token)),
      ),
      child: finalBody(token),
    );
  }
}
