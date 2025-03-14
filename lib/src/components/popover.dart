import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_meragi_design/flutter_meragi_design.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:flutter_meragi_design/src/components/tap.dart';

/// Controls the visibility of a [MDPopover].
class MDPopoverController extends ChangeNotifier {
  /// Creates a new [MDPopoverController].
  MDPopoverController({bool isOpen = false}) : _controller = ShadPopoverController(isOpen: isOpen);

  final ShadPopoverController _controller;

  /// Indicates if the popover is visible.
  bool get isOpen => _controller.isOpen;

  /// Displays the popover.
  void show() => _controller.show();

  /// Hides the popover.
  void hide() => _controller.hide();

  /// Sets the visibility of the popover.
  void setOpen(bool open) => _controller.setOpen(open);

  /// Toggles the visibility of the popover.
  void toggle() => _controller.toggle();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

/// A wrapper around [ShadPopover] that provides the same functionality
/// with potential for customization.
class MDPopover extends StatelessWidget {
  const MDPopover({
    super.key,
    required this.child,
    required this.popover,
    this.controller,
    this.visible,
    this.closeOnTapOutside = true,
    this.focusNode,
    this.anchor,
    this.effects,
    this.shadows,
    this.padding,
    this.decoration,
    this.filter,
    this.groupId,
    this.areaGroupId,
    this.useSameGroupIdForChild = true,
  }) : assert(
          (controller != null) ^ (visible != null),
          'Either controller or visible must be provided',
        );

  /// The widget displayed as a popover.
  final WidgetBuilder popover;

  /// The child widget.
  final Widget child;

  /// The controller that controls the visibility of the [popover].
  final MDPopoverController? controller;

  /// Indicates if the popover should be visible.
  final bool? visible;

  /// Closes the popover when the user taps outside, defaults to true.
  final bool closeOnTapOutside;

  /// The focus node of the child, the [popover] will be shown when focused.
  final FocusNode? focusNode;

  /// The position of the [popover] in the global coordinate system.
  ///
  /// Defaults to `ShadAnchorAutoPosition(verticalOffset: 24, preferBelow: true)`.
  final ShadAnchorBase? anchor;

  /// The animation effects applied to the [popover].
  final List<Effect>? effects;

  /// The shadows applied to the [popover].
  final List<BoxShadow>? shadows;

  /// The padding of the [popover].
  final EdgeInsetsGeometry? padding;

  /// The decoration of the [popover].
  final ShadDecoration? decoration;

  /// The filter of the [popover].
  final ImageFilter? filter;

  /// The group id of the [popover].
  final Object? groupId;

  /// The area group id for mouse interactions.
  final Object? areaGroupId;

  /// Whether the [groupId] should be used for the child widget.
  final bool useSameGroupIdForChild;

  @override
  Widget build(BuildContext context) {
    return ShadPopover(
      popover: popover,
      controller: controller?._controller,
      visible: visible,
      closeOnTapOutside: closeOnTapOutside,
      focusNode: focusNode,
      anchor: anchor,
      effects: effects,
      shadows: shadows,
      padding: padding,
      decoration: decoration,
      filter: filter,
      groupId: groupId,
      areaGroupId: areaGroupId,
      useSameGroupIdForChild: useSameGroupIdForChild,
      child: child,
    );
  }
}

/// A menu item widget for use within [MDPopover].
class MDPopoverItem extends StatelessWidget {
  const MDPopoverItem({
    super.key,
    required this.child,
    this.onPressed,
    this.enabled = true,
    this.padding,
    this.width,
    this.height,
    this.isLoading = false,
    this.icon,
    this.iconData,
    this.mainAxisAlignment = MainAxisAlignment.start,
  });

  /// The child widget.
  final Widget child;

  /// Called when the item is tapped.
  final VoidCallback? onPressed;

  /// Whether the item is enabled.
  final bool enabled;

  /// The padding of the item.
  final EdgeInsetsGeometry? padding;

  /// The width of the item.
  final double? width;

  /// The height of the item.
  final double? height;

  /// Whether the item is in a loading state.
  final bool isLoading;

  /// The icon of the item.
  final Widget? icon;

  /// The icon data of the item.
  final IconData? iconData;

  /// The main axis alignment of the item.
  final MainAxisAlignment mainAxisAlignment;

  @override
  Widget build(BuildContext context) {
    return MDTap.ghost(
      onPressed: enabled ? onPressed : null,
      padding: padding,
      width: width ?? double.infinity,
      height: height,
      enabled: enabled,
      isLoading: isLoading,
      hoverBackgroundColor: context.theme.colors.background.secondary,
      icon: icon,
      iconData: iconData,
      mainAxisAlignment: mainAxisAlignment,
      child: child,
    );
  }
}

/// A menu widget for use within [MDPopover].
class MDPopoverMenu extends StatelessWidget {
  const MDPopoverMenu({
    super.key,
    required this.child,
    this.constraints,
  });

  /// The child widget.
  final Widget child;

  /// The box constraints of the menu.
  final BoxConstraints? constraints;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: constraints ?? const BoxConstraints(minWidth: 200, maxWidth: 200,),
      child: child,
    );
  }
}