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

  const MDCard(
      {super.key,
      this.header,
      required this.body,
      this.footer,
      this.type = CardType.defaultType,
      this.size = CardSize.rg,
      this.alignment = CrossAxisAlignment.center});

  @override
  Widget build(BuildContext context) {
    ThemeToken token = MeragiTheme.of(context).token;

    Color backgroundColor(ThemeToken token) {
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

    Color borderColor(ThemeToken token) {
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

    double borderRadius(ThemeToken token) {
      switch (size) {
        case CardSize.sm:
          return token.smCardBorderRadius;
        case CardSize.rg:
          return token.rgCardBorderRadius;
        case CardSize.lg:
          return token.lgCardBorderRadius;
      }
    }

    EdgeInsets padding(ThemeToken token) {
      switch (size) {
        case CardSize.sm:
          return token.smCardPadding;
        case CardSize.rg:
          return token.rgCardPadding;
        case CardSize.lg:
          return token.lgCardPadding;
      }
    }

    return Container(
      width: double.infinity,
      padding: padding(token),
      decoration: BoxDecoration(
        color: backgroundColor(token),
        border: Border.all(
          width: 1,
          color: borderColor(token),
        ),
        borderRadius: BorderRadius.circular(borderRadius(token)),
      ),
      child: Column(
        crossAxisAlignment: alignment,
        children: [
          header ?? const SizedBox.shrink(),
          if (header != null)
            Divider(
              height: token.cardDividerHeight,
              thickness: token.cardDividerThickness,
            ),
          body,
          if (footer != null)
            Divider(
              height: token.cardDividerHeight,
              thickness: token.cardDividerThickness,
            ),
          footer ?? const SizedBox.shrink(),
        ],
      ),
    );
  }
}
