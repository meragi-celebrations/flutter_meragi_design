import 'package:flutter/material.dart';
import 'package:flutter_meragi_design/src/theme/style.dart';
import 'package:flutter_meragi_design/src/theme/theme_tokens.dart';
import 'package:flutter_meragi_design/src/utils/button_state_controller.dart';

enum ButtonVariant {
  filled,
  outline,
  ghost,
}

enum ButtonType { standard, primary, secondary, danger, info, warning }

enum ButtonSize { sm, rg, lg }

/// A button widget that can be used to create a button with a given style.
///
/// The [MDButton] widget is a wrapper around a [GestureDetector] widget, which
/// is used to detect tap events. The [MDButton] widget can be used to create
/// both filled and outlined buttons.
///
/// The [MDButton] widget takes a [ButtonDecoration] object as its decoration
/// parameter. The [ButtonDecoration] object is used to define the style of the
/// button.
///
/// The [MDButton] widget also takes a [VoidCallback] as its onTap parameter. This
/// callback is called when the button is tapped.
///
/// The [MDButton] widget can also be used to create a dropdown button.
/// To create a dropdown button, the [Button.dropdown] constructor should be
/// used. The [Button.dropdown] constructor takes a [MenuAnchorChildBuilder]
/// as its builder parameter. The [MenuAnchorChildBuilder] is used to define
/// the child of the dropdown button.
///
/// The [Button.dropdown] constructor also takes a list of [Widget]s as its
/// menuChildren parameter. The [menuChildren] parameter is used to define the
/// children of the dropdown menu.
class MDButton extends StatefulWidget {
  /// The callback that is called when the button is tapped.
  final VoidCallback? onTap;

  /// The child of the button.
  final Widget? child;

  /// The icon of the button.
  final IconData? icon;

  /// Whether the button should expand to fill the available space.
  final bool expand;

  /// Whether the button is currently loading.
  final bool isLoading;

  /// The widget that is displayed when the button is loading.
  final Widget? loadingWidget;

  /// The decoration of the button.
  final ButtonDecoration? decoration;

  const MDButton({
    super.key,
    this.onTap,
    this.icon,
    this.child,
    this.expand = false,
    this.isLoading = false,
    this.loadingWidget,
    this.decoration,
  })  : menuChildren = const [],
        builder = null,
        _isDropdown = false,
        dividerColor = null;

  /// Creates a dropdown button with the given decoration, onTap callback, child,
  /// icon, and expand property.
  const MDButton.dropdown({
    super.key,
    this.onTap,
    this.icon,
    this.child,
    this.expand = false,
    this.dividerColor,
    required this.builder,
    required this.menuChildren,
    this.loadingWidget,
    this.isLoading = false,
    this.decoration,
  })  : assert(builder != null),
        _isDropdown = true;

  /// The builder of the dropdown menu.
  final MenuAnchorChildBuilder? builder;

  /// The children of the dropdown menu.
  final List<Widget> menuChildren;

  /// Whether the button is a dropdown button.
  final bool _isDropdown;
  bool get isDropdown => _isDropdown;
  final Color? dividerColor;
  @override
  State<MDButton> createState() => _MDButtonState();
}

class _MDButtonState extends State<MDButton> {
  late final ButtonStateController _stateController;

  @override
  void initState() {
    super.initState();
    _stateController = ButtonStateController();
  }

  @override
  Widget build(BuildContext context) {
    ButtonDecoration finalDecoration = ButtonDecoration(
      context: context,
    ).merge(widget.decoration);

    return ValueListenableBuilder(
      valueListenable: _stateController,
      builder: (context, states, _) {
        final isHovered = states.contains(ButtonState.hovered);
        late bool isEnabled = true;
        if (widget.onTap == null) {
          isEnabled = false;
        }
        return Container(
          decoration: BoxDecoration(
            color: widget.isDropdown
                ? finalDecoration.buttonBackgroundColor
                : isEnabled
                    ? isHovered
                        ? finalDecoration.buttonHoverColor
                        : finalDecoration.buttonBackgroundColor
                    : finalDecoration.buttonDisabledColor,
            border: widget.isDropdown ? finalDecoration.buttonBorder : null,
            borderRadius: finalDecoration.borderRadius,
          ),
          child: Builder(builder: (context) {
            Widget baseButton = MouseRegion(
              cursor: SystemMouseCursors.click,
              onEnter: (_) {
                _stateController.updateState(ButtonState.hovered);
              },
              onExit: (_) {
                _stateController.updateState(ButtonState.hovered);
              },
              child: GestureDetector(
                onTap: widget.onTap,
                child: AnimatedSize(
                  duration: const Duration(milliseconds: 150),
                  child: Container(
                    padding: finalDecoration.buttonPadding,
                    height: finalDecoration.buttonHeight,
                    decoration: BoxDecoration(
                      color: widget.isDropdown
                          ? isEnabled
                              ? isHovered
                                  ? finalDecoration.buttonHoverColor
                                  : finalDecoration.buttonBackgroundColor
                              : finalDecoration.buttonDisabledColor
                          : null,
                      border: widget.isDropdown
                          ? null
                          : isEnabled
                              ? finalDecoration.buttonBorder
                              : null,
                      borderRadius: finalDecoration.borderRadius,
                    ),
                    child: Row(
                      mainAxisSize:
                          widget.expand ? MainAxisSize.max : MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (widget.isLoading) ...[
                          widget.loadingWidget != null
                              ? widget.loadingWidget!
                              : SizedBox(
                                  height: finalDecoration.buttonIconSize,
                                  width: finalDecoration.buttonIconSize,
                                  child: CircularProgressIndicator(
                                    color: finalDecoration.buttonTextColor,
                                    strokeWidth: 2,
                                  ),
                                ),
                        ] else if (widget.icon != null)
                          Icon(
                            widget.icon!,
                            size: finalDecoration.buttonIconSize,
                            color: isEnabled
                                ? finalDecoration.buttonTextColor
                                : Colors.grey,
                          ),
                        if ((widget.icon != null || widget.isLoading) &&
                            widget.child != null)
                          SizedBox(width: finalDecoration.buttonSpaceBetween),
                        if (widget.child != null)
                          DefaultTextStyle.merge(
                            style: finalDecoration.buttonTextStyle.copyWith(
                                color: isEnabled ? null : Colors.grey),
                            child: widget.child!,
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            );
            if (widget.isDropdown) {
              return Row(
                mainAxisSize:
                    widget.expand ? MainAxisSize.max : MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  baseButton,
                  if (widget.isDropdown)
                    Row(
                      children: [
                        SizedBox(
                          height: finalDecoration.buttonHeight,
                          child: VerticalDivider(
                            color: finalDecoration.dividerColor,
                            width: 0,
                          ),
                        ),
                        MenuAnchor(
                          menuChildren: widget.menuChildren,
                          builder: (context, controller, child) {
                            return SizedBox(
                              height: finalDecoration.buttonHeight,
                              width: finalDecoration.buttonHeight,
                              child: widget.builder != null
                                  ? widget.builder!(context, controller, child)
                                  : null,
                            );
                          },
                        ),
                      ],
                    )
                ],
              );
            }
            return baseButton;
          }),
        );
      },
    );
  }
}

class ButtonDecoration extends Style {
  final ButtonVariant variant;
  final ButtonType type;
  final ButtonSize size;
  final Color? colorOverride;
  final Color? iconColorOverride;
  final Color? hoverColorOverride;
  final double? spaceBetweenOverride;
  final double? heightOverride;
  final double? iconSizeOverride;
  final Color? disabledColorOverride;
  final double? borderRadiusOverride;
  final Color? textColorOverride;
  final double? textHeightOverride;
  final EdgeInsetsGeometry? paddingOverride;
  final Color? Function(ThemeToken token)? disabledIconColorOverride;

  ButtonDecoration({
    required super.context,
    this.variant = ButtonVariant.filled,
    this.type = ButtonType.standard,
    this.size = ButtonSize.rg,
    this.colorOverride,
    this.iconColorOverride,
    this.hoverColorOverride,
    this.spaceBetweenOverride,
    this.heightOverride,
    this.iconSizeOverride,
    this.disabledColorOverride,
    this.borderRadiusOverride,
    this.textColorOverride,
    this.textHeightOverride,
    this.paddingOverride,
    this.disabledIconColorOverride,
  });

  @override
  Map get styles => {
        ButtonType.standard: {
          "buttonColor": token.standardButtonColor,
          "buttonHoverColor": token.standardHoverButtonColor,
          "buttonTextColor": token.standardButtonTextColor,
          "filledButtonHoverColor": token.standardFilledHoverButtonColor,
        },
        ButtonType.primary: {
          "buttonColor": token.primaryButtonColor,
          "buttonHoverColor": token.primaryHoverButtonColor,
          "buttonTextColor": token.primaryButtonTextColor,
          "filledButtonHoverColor": token.primaryFilledHoverButtonColor,
        },
        ButtonType.secondary: {
          "buttonColor": token.secondaryButtonColor,
          "buttonHoverColor": token.secondaryHoverButtonColor,
          "buttonTextColor": token.secondaryButtonTextColor,
          "filledButtonHoverColor": token.secondaryFilledHoverButtonColor,
        },
        ButtonType.danger: {
          "buttonColor": token.dangerButtonColor,
          "buttonHoverColor": token.dangerHoverButtonColor,
          "buttonTextColor": token.dangerButtonTextColor,
          "filledButtonHoverColor": token.dangerFilledHoverButtonColor,
        },
        ButtonType.info: {
          "buttonColor": token.infoButtonColor,
          "buttonHoverColor": token.infoHoverButtonColor,
          "buttonTextColor": token.infoButtonTextColor,
          "filledButtonHoverColor": token.infoFilledHoverButtonColor,
        },
        ButtonType.warning: {
          "buttonColor": token.warningButtonColor,
          "buttonHoverColor": token.warningHoverButtonColor,
          "buttonTextColor": token.warningButtonTextColor,
          "filledButtonHoverColor": token.warningFilledHoverButtonColor,
        },
        ButtonSize.sm: {
          "buttonHeight": token.smButtonHeight,
          "buttonIconSize": token.smButtonIconSize,
          "buttonSpaceBetween": token.smButtonSpaceBetween,
          "buttonTextHeight": token.smButtonTextHeight,
          "borderRadius": token.smBorderRadius,
          "padding": token.smButtonPadding,
        },
        ButtonSize.rg: {
          "buttonHeight": token.rgButtonHeight,
          "buttonIconSize": token.rgButtonIconSize,
          "buttonSpaceBetween": token.rgButtonSpaceBetween,
          "buttonTextHeight": token.rgButtonTextHeight,
          "borderRadius": token.rgBorderRadius,
          "padding": token.rgButtonPadding,
        },
        ButtonSize.lg: {
          "buttonHeight": token.lgButtonHeight,
          "buttonIconSize": token.lgButtonIconSize,
          "buttonSpaceBetween": token.lgButtonSpaceBetween,
          "buttonTextHeight": token.lgButtonTextHeight,
          "borderRadius": token.lgBorderRadius,
          "padding": token.lgButtonPadding,
        },
      };

  Color get buttonColor {
    return colorOverride ?? getStyle(type, 'buttonColor');
  }

  Color get buttonBackgroundColor {
    if ([ButtonVariant.ghost, ButtonVariant.outline].contains(variant)) {
      return Colors.transparent;
    }
    return buttonColor;
  }

  Color? get buttonHoverColor {
    if (hoverColorOverride != null) {
      return hoverColorOverride;
    }

    if (variant == ButtonVariant.filled) {
      return getStyle(type, 'filledButtonHoverColor');
    }

    return getStyle(type, 'buttonHoverColor');
  }

  Color? get buttonDisabledColor {
    return disabledColorOverride ?? token.disabledButtonColor;
  }

  BorderRadius? get borderRadius {
    return BorderRadius.circular(
        borderRadiusOverride ?? getStyle(size, 'borderRadius'));
  }

  EdgeInsetsGeometry get buttonPadding {
    return paddingOverride ?? getStyle(size, 'padding');
  }

  double? get buttonHeight {
    return heightOverride ?? getStyle(size, 'buttonHeight');
  }

  double? get buttonIconSize {
    return iconSizeOverride ?? getStyle(size, 'buttonIconSize');
  }

  double? get buttonSpaceBetween {
    return spaceBetweenOverride ?? getStyle(size, 'buttonSpaceBetween');
  }

  double? get buttonTextHeight {
    return textHeightOverride ?? getStyle(size, 'buttonTextHeight');
  }

  Color get buttonTextColor {
    if (textColorOverride != null) {
      return textColorOverride!;
    }

    if ([ButtonVariant.ghost, ButtonVariant.outline].contains(variant)) {
      return buttonColor;
    }

    return getStyle(type, 'buttonTextColor');
  }

  Color get dividerColor {
    if ([ButtonVariant.ghost, ButtonVariant.outline].contains(variant)) {
      return buttonColor;
    }

    return buttonTextColor;
  }

  BoxBorder? get buttonBorder {
    if ([ButtonVariant.ghost, ButtonVariant.filled].contains(variant)) {
      return null;
    }
    return Border.all(color: buttonColor);
  }

  TextStyle get buttonTextStyle {
    return TextStyle(
      color: buttonTextColor,
      fontSize: buttonTextHeight,
      height: 1.2,
    );
  }

  ButtonDecoration copyWith({
    ButtonVariant? variant,
    ButtonType? type,
    ButtonSize? size,
    Color? colorOverride,
    Color? iconColorOverride,
    Color? hoverColorOverride,
    double? spaceBetweenOverride,
    double? heightOverride,
    double? iconSizeOverride,
    Color? disabledColorOverride,
    double? borderRadiusOverride,
    Color? textColorOverride,
    double? textHeightOverride,
    EdgeInsetsGeometry? paddingOverride,
    Color? Function(ThemeToken token)? disabledIconColorOverride,
  }) {
    return ButtonDecoration(
      context: context,
      variant: variant ?? this.variant,
      type: type ?? this.type,
      size: size ?? this.size,
      colorOverride: colorOverride ?? this.colorOverride,
      iconColorOverride: iconColorOverride ?? this.iconColorOverride,
      hoverColorOverride: hoverColorOverride ?? this.hoverColorOverride,
      spaceBetweenOverride: spaceBetweenOverride ?? this.spaceBetweenOverride,
      heightOverride: heightOverride ?? this.heightOverride,
      iconSizeOverride: iconSizeOverride ?? this.iconSizeOverride,
      disabledColorOverride:
          disabledColorOverride ?? this.disabledColorOverride,
      borderRadiusOverride: borderRadiusOverride ?? this.borderRadiusOverride,
      textColorOverride: textColorOverride ?? this.textColorOverride,
      textHeightOverride: textHeightOverride ?? this.textHeightOverride,
      paddingOverride: paddingOverride ?? this.paddingOverride,
      disabledIconColorOverride:
          disabledIconColorOverride ?? this.disabledIconColorOverride,
    );
  }

  ButtonDecoration merge(ButtonDecoration? other) {
    if (other == null) {
      return this;
    }
    return copyWith(
      variant: other.variant,
      type: other.type,
      size: other.size,
      colorOverride: other.colorOverride,
      iconColorOverride: other.iconColorOverride,
      hoverColorOverride: other.hoverColorOverride,
      spaceBetweenOverride: other.spaceBetweenOverride,
      heightOverride: other.heightOverride,
      iconSizeOverride: other.iconSizeOverride,
      disabledColorOverride: other.disabledColorOverride,
      borderRadiusOverride: other.borderRadiusOverride,
      textColorOverride: other.textColorOverride,
      textHeightOverride: other.textHeightOverride,
      paddingOverride: other.paddingOverride,
      disabledIconColorOverride: other.disabledIconColorOverride,
    );
  }
}
