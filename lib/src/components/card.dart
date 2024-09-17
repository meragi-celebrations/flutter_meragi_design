import 'package:flutter/material.dart';
import 'package:flutter_meragi_design/src/theme/style.dart';

enum CardType { defaultType, primary, secondary, danger, success, warning }

enum CardSize { sm, rg, lg }

/// A card widget that can be used to display content in a card-like format.
///
/// This widget is designed to be used as a container for other widgets. It
/// provides a card-like background and border, and can be used to group related
/// widgets together.
///
/// The [header], [body], and [footer] properties can be used to specify the
/// content of the card. The [header] and [footer] properties can be used to
/// specify widgets that should be displayed in the header and footer of the
/// card, respectively. The [body] property can be used to specify the content
/// of the card.
///
/// The [decoration] property can be used to customize the appearance of the
/// card. The [decoration] property can be used to specify the background color,
/// border color, border width, and border radius of the card.
class MDCard extends StatelessWidget {
  /// The header of the card
  final Widget? header;

  /// The body of the card
  final Widget body;

  /// The footer of the card
  final Widget? footer;

  /// The alignment of the card
  final CrossAxisAlignment alignment;

  /// The decoration of the card
  final CardDecoration? decoration;

  /// Creates a card widget
  const MDCard({
    super.key,
    this.header,
    required this.body,
    this.footer,
    this.alignment = CrossAxisAlignment.center,
    this.decoration,
    this.elevation = 0,
  });

  /// The elevation of the card
  final double? elevation;
  @override
  Widget build(BuildContext context) {
    CardDecoration finalCardDecoration = CardDecoration(
      context: context,
    ).merge(decoration);

    Divider divider = Divider(
      height: finalCardDecoration.dividerHeight,
      thickness: finalCardDecoration.dividerThickness,
      color: finalCardDecoration.borderColor,
    );

    return Container(
      width: double.infinity,
      padding: finalCardDecoration.padding,
      decoration: finalCardDecoration.decoration.copyWith(boxShadow: kElevationToShadow[elevation]),
      child: Column(
        crossAxisAlignment: alignment,
        children: [
          header ?? const SizedBox.shrink(),
          if (header != null) divider,
          body,
          if (footer != null) divider,
          footer ?? const SizedBox.shrink(),
        ],
      ),
    );
  }
}

/// The decoration of the card
class CardDecoration extends Style {
  /// The type of the card
  final CardType type;

  /// The size of the card
  final CardSize size;

  /// The padding of the card
  final EdgeInsets? paddingOverride;

  /// The background color of the card
  final Color? backgroundColorOverride;

  /// The border color of the card
  final Color? borderColorOverride;

  /// The border radius of the card
  final double? borderRadiusOverride;

  /// The divider height of the card
  final double? dividerHeightOverride;

  /// The divider thickness of the card
  final double? dividerThicknessOverride;

  /// The border width of the card
  final double? borderWidthOverride;

  /// Creates a card decoration
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

  /// The styles of the card
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

  /// The padding of the card
  EdgeInsets get padding => paddingOverride ?? getStyle(size, 'padding');

  /// The border radius of the card
  double get borderRadius => borderRadiusOverride ?? getStyle(size, "BorderRadius");

  /// The background color of the card
  Color get backgroundColor => backgroundColorOverride ?? getStyle(type, "backgroundColor");

  /// The border color of the card
  Color get borderColor => borderColorOverride ?? getStyle(type, "borderColor");

  /// The border width of the card
  double get borderWidth => borderWidthOverride ?? token.cardBorderWidth;

  /// The divider height of the card
  double get dividerHeight => dividerHeightOverride ?? token.cardDividerHeight;

  /// The divider thickness of the card
  double get dividerThickness => dividerThicknessOverride ?? token.cardDividerThickness;

  /// The decoration of the card
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

  /// Creates a new card decoration with the given overrides
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
      backgroundColorOverride: backgroundColorOverride ?? this.backgroundColorOverride,
      borderColorOverride: borderColorOverride ?? this.borderColorOverride,
      dividerHeightOverride: dividerHeightOverride ?? this.dividerHeightOverride,
      dividerThicknessOverride: dividerThicknessOverride ?? this.dividerThicknessOverride,
      borderWidthOverride: borderWidthOverride ?? this.borderWidthOverride,
      paddingOverride: paddingOverride ?? this.paddingOverride,
      borderRadiusOverride: borderRadiusOverride ?? this.borderRadiusOverride,
    );
  }

  /// Merges the given card decoration with the current one
  CardDecoration merge(CardDecoration? other) {
    if (other == null) {
      return this;
    }
    return CardDecoration(
      context: other.context,
      type: other.type,
      size: other.size,
      backgroundColorOverride: other.backgroundColorOverride ?? backgroundColorOverride,
      borderColorOverride: other.borderColorOverride ?? borderColorOverride,
      dividerHeightOverride: other.dividerHeightOverride ?? dividerHeightOverride,
      dividerThicknessOverride: other.dividerThicknessOverride ?? dividerThicknessOverride,
      borderWidthOverride: other.borderWidthOverride ?? borderWidthOverride,
      paddingOverride: other.paddingOverride ?? paddingOverride,
      borderRadiusOverride: other.borderRadiusOverride ?? borderRadiusOverride,
    );
  }
}
