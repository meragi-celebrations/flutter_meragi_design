import 'package:flutter/material.dart';
import 'package:flutter_meragi_design/flutter_meragi_design.dart';
import 'package:flutter_meragi_design/src/theme/theme_tokens.dart';
import 'package:flutter_meragi_design/src/utils/button_state_controller.dart';

enum ButtonVariant {
  filled,
  outline,
  ghost,
}

enum ButtonType { standard, primary, secondary, danger, info, warning, custom }

enum ButtonSize { sm, rg, lg }

class Button extends StatefulWidget {
  final VoidCallback? onTap;
  final Widget? child;
  final IconData? icon;
  final ButtonVariant variant;
  final ButtonType type;
  final Color? color;
  final Color? iconColor;
  final ButtonSize size;
  final double? spaceBetween;
  final double? height;
  final double? iconSize;
  final bool expand;
  final EdgeInsetsGeometry? padding;
  final bool isLoading;
  final Widget? loadingWidget;

  const Button({
    super.key,
    this.onTap,
    this.icon,
    this.child,
    this.variant = ButtonVariant.filled,
    this.type = ButtonType.standard,
    this.color,
    this.size = ButtonSize.rg,
    this.spaceBetween = 8,
    this.expand = false,
    this.iconColor,
    this.padding,
    this.height,
    this.iconSize,
    this.isLoading = false,
    this.loadingWidget,
  })  : menuChildren = const [],
        builder = null,
        _isDropdown = false,
        dividerColor = null;

  const Button.dropdown({
    super.key,
    this.onTap,
    this.icon,
    this.child,
    this.variant = ButtonVariant.filled,
    this.type = ButtonType.standard,
    this.color,
    this.size = ButtonSize.rg,
    this.spaceBetween = 8,
    this.expand = false,
    this.iconColor,
    this.padding,
    this.height,
    this.iconSize,
    this.dividerColor,
    required this.builder,
    required this.menuChildren,
    this.loadingWidget,
    this.isLoading = false,
  })  : assert(builder != null),
        _isDropdown = true;

  final MenuAnchorChildBuilder? builder;
  final List<Widget> menuChildren;
  final bool _isDropdown;
  bool get isDropdown => _isDropdown;
  final Color? dividerColor;

  @override
  State<Button> createState() => _ButtonState();
}

class _ButtonState extends State<Button> {
  late final ButtonStateController _stateController;

  @override
  void initState() {
    super.initState();
    _stateController = ButtonStateController();
  }

  Color? buttonColor(ThemeToken token) {
    if (widget.variant == ButtonVariant.ghost) {
      return null;
    }
    if (widget.variant == ButtonVariant.outline) {
      return token.outlineBackgroundColor;
    }
    switch (widget.type) {
      case ButtonType.standard:
        return token.filledStandardButtonColor;
      case ButtonType.primary:
        return token.filledPrimaryButtonColor;
      case ButtonType.secondary:
        return token.filledSecondaryButtonColor;
      case ButtonType.danger:
        return token.filledDangerButtonColor;
      case ButtonType.info:
        return token.filledInfoButtonColor;
      case ButtonType.warning:
        return token.filledWarningButtonColor;
      case ButtonType.custom:
        return widget.color;
    }
  }

  Color? buttonHoverColor(ThemeToken token) {
    switch (widget.type) {
      case ButtonType.standard:
        return widget.variant == ButtonVariant.filled
            ? token.filledStandardHoverButtonColor
            : widget.variant == ButtonVariant.outline
                ? token.outlineStandardHoverButtonColor
                : token.ghostStandardHoverButtonColor;
      case ButtonType.primary:
        return widget.variant == ButtonVariant.filled
            ? token.filledPrimaryHoverButtonColor
            : widget.variant == ButtonVariant.outline
                ? token.outlinePrimaryHoverButtonColor
                : token.ghostPrimaryHoverButtonColor;
      case ButtonType.secondary:
        return widget.variant == ButtonVariant.filled
            ? token.filledSecondaryHoverButtonColor
            : widget.variant == ButtonVariant.outline
                ? token.outlineSecondaryHoverButtonColor
                : token.ghostSecondaryHoverButtonColor;
      case ButtonType.danger:
        return widget.variant == ButtonVariant.filled
            ? token.filledDangerHoverButtonColor
            : widget.variant == ButtonVariant.outline
                ? token.outlineDangerHoverButtonColor
                : token.ghostDangerHoverButtonColor;
      case ButtonType.info:
        return widget.variant == ButtonVariant.filled
            ? token.filledInfoHoverButtonColor
            : widget.variant == ButtonVariant.outline
                ? token.outlineInfoHoverButtonColor
                : token.ghostInfoHoverButtonColor;
      case ButtonType.warning:
        return widget.variant == ButtonVariant.filled
            ? token.filledWarningHoverButtonColor
            : widget.variant == ButtonVariant.outline
                ? token.outlineWarningHoverButtonColor
                : token.ghostWarningHoverButtonColor;
      case ButtonType.custom:
        return widget.color?.withOpacity(0.2);
    }
  }

  Color? buttonDisabledColor(ThemeToken token) {
    switch (widget.variant) {
      case ButtonVariant.filled:
        return token.filledDisabledButtonColor;
      case ButtonVariant.outline:
        return token.outlinedDisabledButtonColor;
      case ButtonVariant.ghost:
        return token.ghostDisabledButtonColor;
    }
  }

  Color? buttonDisabledIconColor(ThemeToken token) {
    if (widget.variant == ButtonVariant.outline) {
      return token.outlinedDisabledBorderButtonColor;
    }
    return null;
  }

  Color borderColor(ThemeToken token, ButtonVariant variant) {
    switch (widget.type) {
      case ButtonType.standard:
        return token.outlineStandardBorderButtonColor;
      case ButtonType.primary:
        return token.filledPrimaryButtonColor;
      case ButtonType.secondary:
        return token.filledSecondaryButtonColor;
      case ButtonType.danger:
        return token.filledDangerButtonColor;
      case ButtonType.info:
        return token.filledInfoButtonColor;
      case ButtonType.warning:
        return token.filledWarningButtonColor;
      case ButtonType.custom:
        return widget.color ?? token.outlineStandardBorderButtonColor;
    }
  }

  BoxBorder? buttonBorder(ThemeToken token, bool isEnabled) {
    switch (widget.variant) {
      case ButtonVariant.filled:
      case ButtonVariant.ghost:
        return null;
      case ButtonVariant.outline:
        return Border.all(
          color: isEnabled
              ? borderColor(token, ButtonVariant.outline)
              : token.outlinedDisabledBorderButtonColor,
        );
    }
  }

  BorderRadius? buttonRadius(ThemeToken token) {
    switch (widget.size) {
      case ButtonSize.sm:
        return BorderRadius.circular(token.smBorderRadius);
      case ButtonSize.rg:
        return BorderRadius.circular(token.rgBorderRadius);
      case ButtonSize.lg:
        return BorderRadius.circular(token.lgBorderRadius);
    }
  }

  EdgeInsetsGeometry buttonPadding(ThemeToken token) {
    if (widget.padding != null) {
      return widget.padding!;
    }
    switch (widget.size) {
      case ButtonSize.sm:
        return token.smButtonPadding;
      case ButtonSize.rg:
        return token.rgButtonPadding;
      case ButtonSize.lg:
        return token.lgButtonPadding;
    }
  }

  double? buttonHeight(ThemeToken token) {
    if (widget.height != null) {
      return widget.height;
    }
    switch (widget.size) {
      case ButtonSize.sm:
        return token.smButtonHeight;
      case ButtonSize.rg:
        return token.rgButtonHeight;
      case ButtonSize.lg:
        return token.lgButtonHeight;
    }
  }

  double? buttonIconSize(ThemeToken token) {
    if (widget.iconSize != null) {
      return widget.iconSize;
    }
    switch (widget.size) {
      case ButtonSize.sm:
        return token.smButtonIconSize;
      case ButtonSize.rg:
        return token.rgButtonIconSize;
      case ButtonSize.lg:
        return token.lgButtonIconSize;
    }
  }

  Color? buttonIconColor(ThemeToken token) {
    ButtonVariant variant = widget.variant;
    switch (widget.type) {
      case ButtonType.standard:
        return variant == ButtonVariant.filled
            ? token.filledStandardButtonIconColor
            : variant == ButtonVariant.outline
                ? token.outlineStandardBorderButtonColor
                : token.ghostStandardButtonIconColor;
      case ButtonType.primary:
        return variant == ButtonVariant.filled
            ? token.filledPrimaryButtonIconColor
            : variant == ButtonVariant.outline
                ? token.outlinePrimaryBorderButtonColor
                : token.ghostPrimaryButtonIconColor;
      case ButtonType.secondary:
        return variant == ButtonVariant.filled
            ? token.filledSecondaryButtonIconColor
            : variant == ButtonVariant.outline
                ? token.outlineSecondaryBorderButtonColor
                : token.ghostSecondaryButtonIconColor;
      case ButtonType.danger:
        return variant == ButtonVariant.filled
            ? token.filledDangerButtonIconColor
            : variant == ButtonVariant.outline
                ? token.outlineDangerBorderButtonColor
                : token.ghostDangerButtonIconColor;
      case ButtonType.info:
        return variant == ButtonVariant.filled
            ? token.filledInfoButtonIconColor
            : variant == ButtonVariant.outline
                ? token.outlineInfoBorderButtonColor
                : token.ghostInfoButtonIconColor;
      case ButtonType.warning:
        return variant == ButtonVariant.filled
            ? token.filledWarningButtonIconColor
            : variant == ButtonVariant.outline
                ? token.outlineWarningBorderButtonColor
                : token.ghostWarningButtonIconColor;
      case ButtonType.custom:
        return widget.iconColor;
    }
  }

  TextStyle? buttonTextStyle(ThemeToken token) {
    switch (widget.size) {
      case ButtonSize.sm:
        return token.smButtonTextStyle.copyWith(
          color: buttonIconColor(token),
        );
      case ButtonSize.rg:
        return token.rgButtonTextStyle.copyWith(
          color: buttonIconColor(token),
        );
      case ButtonSize.lg:
        return token.lgButtonTextStyle.copyWith(
          color: buttonIconColor(token),
        );
    }
  }

  double? buttonDividerSize(ThemeToken token) {
    if (widget.height != null) {
      return widget.height;
    }
    switch (widget.size) {
      case ButtonSize.sm:
        return token.smButtonHeight;
      case ButtonSize.rg:
        return token.rgButtonHeight;
      case ButtonSize.lg:
        return token.lgButtonHeight;
    }
  }

  Color? buttonDividerColor(ThemeToken token) {
    if (widget.dividerColor != null) {
      return widget.dividerColor;
    }
    switch (widget.type) {
      case ButtonType.standard:
        return token.outlineStandardBorderButtonColor;
      case ButtonType.primary:
        return token.filledPrimaryButtonColor;
      case ButtonType.secondary:
        return token.filledSecondaryButtonColor;
      case ButtonType.danger:
        return token.filledDangerButtonColor;
      case ButtonType.info:
        return token.filledInfoButtonColor;
      case ButtonType.warning:
        return token.filledWarningButtonColor;
      case ButtonType.custom:
        return widget.color ?? token.outlineStandardBorderButtonColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeToken token = MeragiTheme.of(context).token;
    return ValueListenableBuilder(
      valueListenable: _stateController,
      builder: (context, states, _) {
        final isPressed = states.contains(ButtonState.pressed);
        final isHovered = states.contains(ButtonState.hovered);
        late bool isEnabled = true;
        if (widget.onTap == null) {
          isEnabled = false;
        }
        return Container(
          decoration: BoxDecoration(
            color: widget.isDropdown
                ? buttonColor(token)
                : isEnabled
                    ? isHovered
                        ? buttonHoverColor(token)
                        : buttonColor(token)
                    : buttonDisabledColor(token),
            border: widget.isDropdown ? buttonBorder(token, isEnabled) : null,
            borderRadius: buttonRadius(token),
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
                    padding: buttonPadding(token),
                    height: buttonHeight(token),
                    decoration: BoxDecoration(
                      color: widget.isDropdown
                          ? isEnabled
                              ? isHovered
                                  ? buttonHoverColor(token)
                                  : buttonColor(token)
                              : buttonDisabledColor(token)
                          : null,
                      border: widget.isDropdown
                          ? null
                          : buttonBorder(token, isEnabled),
                      borderRadius: buttonRadius(token),
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
                                  height: buttonIconSize(token),
                                  width: buttonIconSize(token),
                                  child: CircularProgressIndicator(
                                    color: buttonIconColor(token),
                                    strokeWidth: 2,
                                  ),
                                ),
                        ] else if (widget.icon != null)
                          Icon(
                            widget.icon!,
                            size: buttonIconSize(token),
                            color: isEnabled
                                ? buttonIconColor(token)
                                : token.disabledIconButtonColor,
                          ),
                        if ((widget.icon != null || widget.isLoading) &&
                            widget.child != null)
                          SizedBox(width: widget.spaceBetween),
                        if (widget.child != null)
                          DefaultTextStyle.merge(
                            style: buttonTextStyle(token),
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
                          height: buttonDividerSize(token),
                          child: VerticalDivider(
                            color: buttonDividerColor(token),
                            width: 0,
                          ),
                        ),
                        MenuAnchor(
                          menuChildren: widget.menuChildren,
                          builder: (context, controller, child) {
                            return SizedBox(
                              height: buttonHeight(token),
                              width: buttonHeight(token),
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
