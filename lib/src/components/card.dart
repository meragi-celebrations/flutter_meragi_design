import 'package:flutter/material.dart';
import 'package:flutter_meragi_design/src/theme/style.dart';

enum CardType { defaultType, primary, secondary, danger, success, warning }

enum CardSize { sm, rg, lg }

class MDCard extends StatelessWidget {
  final Widget? header;
  final Widget body;
  final Widget? footer;
  final CrossAxisAlignment alignment;
  final CardDecoration? decoration;

  const MDCard({
    super.key,
    this.header,
    required this.body,
    this.footer,
    this.alignment = CrossAxisAlignment.center,
    this.decoration,
  });

  @override
  Widget build(BuildContext context) {
    CardDecoration finalCardDecoration = CardDecoration(
      context: context,
    ).merge(decoration);

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

class CardDecoration extends Style {
  final CardType type;
  final CardSize size;

  final EdgeInsets? paddingOverride;
  final Color? backgroundColorOverride;
  final Color? borderColorOverride;
  final double? borderRadiusOverride;
  final double? dividerHeightOverride;
  final double? dividerThicknessOverride;
  final double? borderWidthOverride;

  const CardDecoration({
    required super.context,
    this.type = CardType.defaultType,
    this.size = CardSize.rg,
    this.paddingOverride,
    this.backgroundColorOverride,
    this.borderColorOverride,
    this.borderRadiusOverride,
    this.dividerHeightOverride,
    this.dividerThicknessOverride,
    this.borderWidthOverride,
  });

  @override
  Map get styles => {
        CardSize.sm: {
          "padding": token.smCardPadding,
          "BorderRadius": token.smCardBorderRadius,
        },
        CardSize.rg: {
          "padding": token.rgCardPadding,
          "BorderRadius": token.rgCardBorderRadius,
        },
        CardSize.lg: {
          "padding": token.lgCardPadding,
          "BorderRadius": token.lgCardBorderRadius,
        },
        CardType.primary: {
          "backgroundColor": token.primaryCardBackgroundColor,
          "borderColor": token.primaryCardBorderColor,
        },
        CardType.secondary: {
          "backgroundColor": token.secondaryCardBackgroundColor,
          "borderColor": token.secondaryCardBorderColor,
        },
        CardType.danger: {
          "backgroundColor": token.dangerCardBackgroundColor,
          "borderColor": token.dangerCardBorderColor,
        },
        CardType.success: {
          "backgroundColor": token.successCardBackgroundColor,
          "borderColor": token.successCardBorderColor,
        },
        CardType.warning: {
          "backgroundColor": token.warningCardBackgroundColor,
          "borderColor": token.warningCardBorderColor,
        },
        CardType.defaultType: {
          "backgroundColor": token.defaultCardBackgroundColor,
          "borderColor": token.defaultCardBorderColor,
        }
      };

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

  EdgeInsets get padding => paddingOverride ?? getStyle(size, 'padding');

  double get borderRadius =>
      borderRadiusOverride ?? getStyle(size, "BorderRadius");

  Color get backgroundColor =>
      backgroundColorOverride ?? getStyle(type, "backgroundColor");

  Color get borderColor => borderColorOverride ?? getStyle(type, "borderColor");

  double get borderWidth => borderWidthOverride ?? token.cardBorderWidth;

  double get dividerHeight => dividerHeightOverride ?? token.cardDividerHeight;

  double get dividerThickness =>
      dividerThicknessOverride ?? token.cardDividerThickness;

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
