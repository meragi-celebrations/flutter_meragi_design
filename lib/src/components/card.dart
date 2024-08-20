import 'package:flutter/material.dart';
import 'package:flutter_meragi_design/flutter_meragi_design.dart';
import 'package:flutter_meragi_design/src/theme/theme_tokens.dart';

enum CardType { defaultType, primary, secondary, danger, success, warning }

enum CardSize { sm, rg, lg }

class MDCard extends StatelessWidget {
  final Widget? header;
  final Widget body;
  final Widget? footer;
  final CardType type;
  final CardSize size;
  final CrossAxisAlignment alignment;
  final CardDecoration? cardDecoration;

  const MDCard({
    super.key,
    this.header,
    required this.body,
    this.footer,
    this.type = CardType.defaultType,
    this.size = CardSize.rg,
    this.alignment = CrossAxisAlignment.center,
    this.cardDecoration,
  });

  @override
  Widget build(BuildContext context) {
    CardDecoration finalCardDecoration = CardDecoration(
      context: context,
      type: type,
      size: size,
    ).merge(cardDecoration);

    return Container(
      width: double.infinity,
      padding: finalCardDecoration.padding,
      decoration: finalCardDecoration.decoration,
      child: Column(
        crossAxisAlignment: alignment,
        children: [
          header ?? const SizedBox.shrink(),
          if (header != null)
            Divider(
              height: finalCardDecoration.dividerHeight,
              thickness: finalCardDecoration.dividerThickness,
            ),
          body,
          if (footer != null)
            Divider(
              height: finalCardDecoration.dividerHeight,
              thickness: finalCardDecoration.dividerThickness,
            ),
          footer ?? const SizedBox.shrink(),
        ],
      ),
    );
  }
}

class CardDecoration {
  final BuildContext context;
  final CardType type;
  final CardSize size;

  final EdgeInsets? paddingOverride;
  final Color? backgroundColorOverride;
  final Color? borderColorOverride;
  final double? borderRadiusOverride;
  final double? dividerHeightOverride;
  final double? dividerThicknessOverride;
  final double? borderWidthOverride;

  CardDecoration({
    required this.context,
    required this.type,
    required this.size,
    this.paddingOverride,
    this.backgroundColorOverride,
    this.borderColorOverride,
    this.borderRadiusOverride,
    this.dividerHeightOverride,
    this.dividerThicknessOverride,
    this.borderWidthOverride,
  });

  ThemeToken get token => MeragiTheme.of(context).token;

  EdgeInsets get padding {
    if (paddingOverride != null) {
      return paddingOverride!;
    }

    switch (size) {
      case CardSize.sm:
        return token.smCardPadding;
      case CardSize.rg:
        return token.rgCardPadding;
      case CardSize.lg:
        return token.lgCardPadding;
    }
  }

  BoxDecoration get decoration {
    return BoxDecoration(
      color: backgroundColor,
      border: Border.all(
        width: borderWidth,
        color: borderColor,
      ),
      borderRadius: BorderRadius.circular(borderRadius),
    );
  }

  double get borderRadius {
    if (borderRadiusOverride != null) {
      return borderRadiusOverride!;
    }

    switch (size) {
      case CardSize.sm:
        return token.smCardBorderRadius;
      case CardSize.rg:
        return token.rgCardBorderRadius;
      case CardSize.lg:
        return token.lgCardBorderRadius;
    }
  }

  Color get backgroundColor {
    if (backgroundColorOverride != null) {
      return backgroundColorOverride!;
    }

    switch (type) {
      case CardType.primary:
        return token.primaryCardBackgroundColor;
      case CardType.secondary:
        return token.secondaryCardBackgroundColor;
      case CardType.danger:
        return token.dangerCardBackgroundColor;
      case CardType.success:
        return token.successCardBackgroundColor;
      case CardType.warning:
        return token.warningCardBackgroundColor;
      default:
        return token.defaultCardBackgroundColor;
    }
  }

  Color get borderColor {
    if (borderColorOverride != null) {
      return borderColorOverride!;
    }

    switch (type) {
      case CardType.primary:
        return token.primaryCardBorderColor;
      case CardType.secondary:
        return token.secondaryCardBorderColor;
      case CardType.danger:
        return token.dangerCardBorderColor;
      case CardType.success:
        return token.successCardBorderColor;
      case CardType.warning:
        return token.warningCardBorderColor;
      default:
        return token.defaultCardBorderColor;
    }
  }

  double get borderWidth {
    if (borderWidthOverride != null) {
      return borderWidthOverride!;
    }

    return token.cardBorderWidth;
  }

  double get dividerHeight {
    if (dividerHeightOverride != null) {
      return dividerHeightOverride!;
    }

    return token.cardDividerHeight;
  }

  double get dividerThickness {
    if (dividerThicknessOverride != null) {
      return dividerThicknessOverride!;
    }

    return token.cardDividerThickness;
  }

  CardDecoration copyWith({
    BuildContext? context,
    CardType? type,
    CardSize? size,
    Color? backgroundColorOverride,
    Color? borderColorOverride,
    double? dividerHeightOverride,
    double? dividerThicknessOverride,
    double? borderWidthOverride,
    EdgeInsets? paddingOverride,
    double? borderRadiusOverride,
  }) {
    return CardDecoration(
      context: context ?? this.context,
      type: type ?? this.type,
      size: size ?? this.size,
      backgroundColorOverride:
          backgroundColorOverride ?? this.backgroundColorOverride,
      borderColorOverride: borderColorOverride ?? this.borderColorOverride,
      dividerHeightOverride:
          dividerHeightOverride ?? this.dividerHeightOverride,
      dividerThicknessOverride:
          dividerThicknessOverride ?? this.dividerThicknessOverride,
      borderWidthOverride: borderWidthOverride ?? this.borderWidthOverride,
      paddingOverride: paddingOverride ?? this.paddingOverride,
      borderRadiusOverride: borderRadiusOverride ?? this.borderRadiusOverride,
    );
  }

  CardDecoration merge(CardDecoration? other) {
    if (other == null) {
      return this;
    }
    return CardDecoration(
      context: other.context,
      type: other.type,
      size: other.size,
      backgroundColorOverride:
          other.backgroundColorOverride ?? backgroundColorOverride,
      borderColorOverride: other.borderColorOverride ?? borderColorOverride,
      dividerHeightOverride:
          other.dividerHeightOverride ?? dividerHeightOverride,
      dividerThicknessOverride:
          other.dividerThicknessOverride ?? dividerThicknessOverride,
      borderWidthOverride: other.borderWidthOverride ?? borderWidthOverride,
      paddingOverride: other.paddingOverride ?? paddingOverride,
      borderRadiusOverride: other.borderRadiusOverride ?? borderRadiusOverride,
    );
  }
}
