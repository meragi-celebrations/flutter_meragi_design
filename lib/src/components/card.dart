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
    CardDecoration cardDecoration = CardDecoration(
      context: context,
      type: type,
      size: size,
    );
    return Container(
      width: double.infinity,
      padding: cardDecoration.padding,
      decoration: CardDecoration(
        context: context,
        type: type,
        size: size,
      ).decoration,
      child: Column(
        crossAxisAlignment: alignment,
        children: [
          header ?? const SizedBox.shrink(),
          if (header != null)
            Divider(
              height: cardDecoration.dividerHeight,
              thickness: cardDecoration.dividerThickness,
            ),
          body,
          if (footer != null)
            Divider(
              height: cardDecoration.dividerHeight,
              thickness: cardDecoration.dividerThickness,
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

  CardDecoration(
      {required this.context, required this.type, required this.size})
      : assert(context != null, 'context cannot be null'),
        assert(type != null, 'type cannot be null'),
        assert(size != null, 'size cannot be null');

  ThemeToken get token => MeragiTheme.of(context).token;

  EdgeInsets get padding {
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
        width: 1,
        color: borderColor,
      ),
      borderRadius: BorderRadius.circular(borderRadius),
    );
  }

  double get borderRadius {
    switch (size) {
      case CardSize.sm:
        return token.smCardBorderRadius;
      case CardSize.rg:
        return token.rgCardBorderRadius;
      case CardSize.lg:
        return token.lgCardBorderRadius;
    }
  }

  double get dividerHeight => token.cardDividerHeight;

  double get dividerThickness => token.cardDividerThickness;

  Color get borderColor {
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

  Color get backgroundColor {
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
}
