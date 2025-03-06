import 'package:flutter/material.dart';
import 'package:flutter_meragi_design/flutter_meragi_design.dart';
import 'package:flutter_meragi_design/src/theme/theme_tokens.dart';
import 'package:flutter_meragi_design/src/utils/map.dart';

class Style {
  final BuildContext context;

  const Style({required this.context});

  ThemeToken get token => MeragiTheme.of(context).token;

  Map get styles => {};

  dynamic getStyle(dynamic cat, String key) {
    return valueFromMap(cat, styles)[key];
  }
}

/// The type of card to display.
enum CardType {
  /// The default card type.
  defaultType,
  /// A primary card type.
  primary,
  /// A secondary card type.
  secondary,
  /// A danger card type.
  danger,
  /// A success card type.
  success,
  /// A warning card type.
  warning,
}

/// The size of the card.
enum CardSize {
  /// Small size.
  sm,
  /// Regular size.
  rg,
  /// Large size.
  lg,
}

/// A class that provides decoration for cards.
class CardDecoration {
  final BuildContext context;
  final CardType type;

  CardDecoration({
    required this.context,
    required this.type,
  });

  Color get backgroundColor {
    final theme = Theme.of(context);
    switch (type) {
      case CardType.defaultType:
        return theme.colorScheme.surface;
      case CardType.primary:
        return theme.colorScheme.primary.withOpacity(0.1);
      case CardType.secondary:
        return theme.colorScheme.secondary.withOpacity(0.1);
      case CardType.danger:
        return theme.colorScheme.error.withOpacity(0.1);
      case CardType.success:
        return theme.colorScheme.tertiary.withOpacity(0.1);
      case CardType.warning:
        return theme.colorScheme.tertiary.withOpacity(0.1);
    }
  }

  BorderRadius get borderRadius => const BorderRadius.all(Radius.circular(8));

  Border get border {
    final theme = Theme.of(context);
    switch (type) {
      case CardType.defaultType:
        return Border.all(color: theme.colorScheme.outline.withOpacity(0.1));
      case CardType.primary:
        return Border.all(color: theme.colorScheme.primary.withOpacity(0.2));
      case CardType.secondary:
        return Border.all(color: theme.colorScheme.secondary.withOpacity(0.2));
      case CardType.danger:
        return Border.all(color: theme.colorScheme.error.withOpacity(0.2));
      case CardType.success:
        return Border.all(color: theme.colorScheme.tertiary.withOpacity(0.2));
      case CardType.warning:
        return Border.all(color: theme.colorScheme.tertiary.withOpacity(0.2));
    }
  }

  List<BoxShadow> get shadows => [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 10,
          offset: const Offset(0, 2),
        ),
      ];
}
