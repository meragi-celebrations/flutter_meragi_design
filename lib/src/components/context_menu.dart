import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_meragi_design/flutter_meragi_design.dart';

class MDContextMenu extends StatelessWidget {
  const MDContextMenu({
    super.key,
    required this.child,
    required this.items,
    this.anchor,
    this.visible,
    this.constraints,
    this.onHoverArea,
    this.padding,
    this.groupId,
    this.effects,
    this.shadows,
    this.decoration,
    this.filter,
    this.controller,
  });

  final Widget child;
  final List<Widget> items;
  final ShadAnchorBase? anchor;
  final bool? visible;
  final BoxConstraints? constraints;
  final ValueChanged<bool>? onHoverArea;
  final EdgeInsetsGeometry? padding;
  final Object? groupId;
  final List<Effect<dynamic>>? effects;
  final List<BoxShadow>? shadows;
  final ShadDecoration? decoration;
  final ImageFilter? filter;
  final ShadContextMenuController? controller;

  @override
  Widget build(BuildContext context) {
    return ShadContextMenu(
      child: child,
      items: items,
      anchor: anchor,
      visible: visible,
      constraints: constraints,
      onHoverArea: onHoverArea,
      padding: padding,
      groupId: groupId,
      effects: effects,
      shadows: shadows,
      decoration: decoration,
      filter: filter,
      controller: controller,
    );
  }
}

class MDContextMenuRegion extends StatelessWidget {
  const MDContextMenuRegion({
    super.key,
    required this.child,
    required this.items,
    this.visible,
    this.constraints,
    this.onHoverArea,
    this.padding,
    this.groupId,
    this.effects,
    this.shadows,
    this.decoration,
    this.filter,
    this.controller,
    this.longPressEnabled,
  });

  final Widget child;
  final List<Widget> items;
  final bool? visible;
  final BoxConstraints? constraints;
  final ValueChanged<bool>? onHoverArea;
  final EdgeInsetsGeometry? padding;
  final Object? groupId;
  final List<Effect<dynamic>>? effects;
  final List<BoxShadow>? shadows;
  final ShadDecoration? decoration;
  final ImageFilter? filter;
  final ShadContextMenuController? controller;
  final bool? longPressEnabled;

  @override
  Widget build(BuildContext context) {
    return ShadContextMenuRegion(
      child: child,
      items: items,
      visible: visible,
      constraints: constraints,
      onHoverArea: onHoverArea,
      padding: padding,
      groupId: groupId,
      effects: effects,
      shadows: shadows,
      decoration: decoration,
      filter: filter,
      controller: controller,
      longPressEnabled: longPressEnabled,
    );
  }
}

class MDContextMenuItem extends StatelessWidget {
  const MDContextMenuItem({
    super.key,
    required this.child,
    this.items = const [],
    this.enabled = true,
    this.leading,
    this.trailing,
    this.leadingPadding,
    this.trailingPadding,
    this.padding,
    this.onPressed,
    this.anchor,
    this.showDelay,
    this.height,
    this.buttonVariant,
    this.decoration,
    this.textStyle,
    this.trailingTextStyle,
    this.constraints,
    this.subMenuPadding,
    this.backgroundColor,
    this.selectedBackgroundColor,
    this.closeOnTap,
    required this.variant,
    this.insetPadding,
  });

  const MDContextMenuItem.raw({
    super.key,
    required this.variant,
    required this.child,
    this.items = const [],
    this.enabled = true,
    this.leading,
    this.trailing,
    this.leadingPadding,
    this.trailingPadding,
    this.padding,
    this.insetPadding,
    this.onPressed,
    this.anchor,
    this.showDelay,
    this.height,
    this.buttonVariant,
    this.decoration,
    this.textStyle,
    this.trailingTextStyle,
    this.constraints,
    this.subMenuPadding,
    this.backgroundColor,
    this.selectedBackgroundColor,
    this.closeOnTap,
  });

  const MDContextMenuItem.inset({
    super.key,
    required this.child,
    this.items = const [],
    this.enabled = true,
    this.leading,
    this.trailing,
    this.leadingPadding,
    this.trailingPadding,
    this.padding,
    this.insetPadding,
    this.onPressed,
    this.anchor,
    this.showDelay,
    this.height,
    this.buttonVariant,
    this.decoration,
    this.textStyle,
    this.trailingTextStyle,
    this.constraints,
    this.subMenuPadding,
    this.backgroundColor,
    this.selectedBackgroundColor,
    this.closeOnTap,
  }) : variant = ShadContextMenuItemVariant.inset;

  final ShadContextMenuItemVariant variant;
  final Widget child;
  final bool enabled;
  final Widget? leading;
  final Widget? trailing;
  final EdgeInsetsGeometry? leadingPadding;
  final EdgeInsetsGeometry? trailingPadding;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? insetPadding;
  final VoidCallback? onPressed;
  final ShadAnchorBase? anchor;
  final Duration? showDelay;
  final double? height;
  final ShadButtonVariant? buttonVariant;
  final ShadDecoration? decoration;
  final TextStyle? textStyle;
  final TextStyle? trailingTextStyle;
  final BoxConstraints? constraints;
  final EdgeInsetsGeometry? subMenuPadding;
  final Color? backgroundColor;
  final Color? selectedBackgroundColor;
  final bool? closeOnTap;
  final List<Widget> items;

  @override
  Widget build(BuildContext context) {
    return ShadContextMenuItem.raw(
      variant: variant,
      items: items,
      enabled: enabled,
      leading: leading,
      trailing: trailing,
      leadingPadding: leadingPadding,
      trailingPadding: trailingPadding,
      padding: padding,
      insetPadding: insetPadding,
      onPressed: onPressed,
      anchor: anchor,
      showDelay: showDelay,
      height: height,
      buttonVariant: buttonVariant,
      decoration: decoration,
      textStyle: textStyle,
      trailingTextStyle: trailingTextStyle,
      constraints: constraints,
      subMenuPadding: subMenuPadding,
      backgroundColor: backgroundColor,
      selectedBackgroundColor: selectedBackgroundColor,
      closeOnTap: closeOnTap,
      child: child,
    );
  }
}
