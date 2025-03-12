import 'dart:async';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_meragi_design/flutter_meragi_design.dart';

const kContextMenuGroupId = ValueKey('context-menu');

/// {@template MDContextMenuRegion}
/// A widget that shows the context menu when the user right clicks the [child]
/// or long presses it (only on android and ios), unless a value to
/// [longPressEnabled] is provided.
/// {@endtemplate}
class MDContextMenuRegion extends StatefulWidget {
  /// {@macro MDContextMenuRegion}
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

  /// {@template MDContextMenuRegion.child}
  /// The child that triggers the visibility of the context menu.
  /// {@endtemplate}
  final Widget child;

  /// {@macro MDContextMenu.items}
  final List<Widget> items;

  /// {@macro MDContextMenu.visible}
  final bool? visible;

  /// {@macro MDContextMenu.constraints}
  final BoxConstraints? constraints;

  /// {@macro MDContextMenu.onHoverArea}
  final ValueChanged<bool>? onHoverArea;

  /// {@macro MDContextMenu.padding}
  final EdgeInsetsGeometry? padding;

  /// {@macro MDMouseArea.groupId}
  final Object? groupId;

  /// {@macro MDPopover.effects}
  final List<Effect<dynamic>>? effects;

  /// {@macro MDPopover.shadows}
  final List<BoxShadow>? shadows;

  /// {@macro MDPopover.decoration}
  final MDDecoration? decoration;

  /// {@macro MDPopover.filter}
  final ImageFilter? filter;

  /// {@macro MDContextMenu.controller}
  final MDContextMenuController? controller;

  /// {@template MDContextMenuRegion.longPressEnabled}
  /// Whether the context menu should be shown when the user long presses the
  /// child, defaults to true only on Android and iOS.
  /// {@endtemplate}
  final bool? longPressEnabled;

  @override
  State<MDContextMenuRegion> createState() => _MDContextMenuRegionState();
}

class _MDContextMenuRegionState extends State<MDContextMenuRegion> {
  MDContextMenuController? _controller;
  MDContextMenuController get controller =>
      widget.controller ??
      (_controller ??=
          MDContextMenuController(isOpen: widget.visible ?? false));
  Offset? offset;

  final isContextMenuAlreadyDisabled = kIsWeb && !BrowserContextMenu.enabled;

  @override
  void didUpdateWidget(covariant MDContextMenuRegion oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.visible != null) {
      controller.setOpen(widget.visible!);
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  void showAtOffset(Offset offset) {
    if (!mounted) return;
    setState(() => this.offset = offset);
    controller.show();
  }

  void hide() {
    controller.hide();
  }

  void show(Offset offset) {
    showAtOffset(offset);
  }

  void onLongPress() {
    assert(offset != null, 'offset must not be null');
    showAtOffset(offset!);
  }

  @override
  Widget build(BuildContext context) {
    final platform = Theme.of(context).platform;
    final effectiveLongPressEnabled = widget.longPressEnabled ??
        (platform == TargetPlatform.android || platform == TargetPlatform.iOS);

    final isWindows = platform == TargetPlatform.windows;

    return MDContextMenu(
      anchor: offset == null ? null : MDGlobalAnchor(offset!),
      controller: controller,
      items: widget.items,
      constraints: widget.constraints ?? const BoxConstraints(minWidth: 250),
      onHoverArea: widget.onHoverArea,
      padding: widget.padding,
      groupId: widget.groupId,
      effects: widget.effects,
      shadows: widget.shadows,
      decoration: widget.decoration,
      filter: widget.filter,
      child: MDGestureDetector(
        cursor: MouseCursor.defer,
        onTapDown: (_) => hide(),
        onSecondaryTapDown: (d) async {
          if (kIsWeb && !isContextMenuAlreadyDisabled) {
            await BrowserContextMenu.disableContextMenu();
          }
          if (!isWindows) show(d.globalPosition);
        },
        onSecondaryTapUp: (d) async {
          if (isWindows) {
            show(d.globalPosition);
            await Future<void>.delayed(Duration.zero);
          }
          if (kIsWeb && !isContextMenuAlreadyDisabled) {
            await BrowserContextMenu.enableContextMenu();
          }
        },
        onLongPressStart: effectiveLongPressEnabled
            ? (d) {
                offset = d.globalPosition;
              }
            : null,
        onLongPress: effectiveLongPressEnabled ? onLongPress : null,
        child: widget.child,
      ),
    );
  }
}

typedef MDContextMenuController = MDPopoverController;

class MDContextMenu extends StatefulWidget {
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

  /// {@template MDContextMenu.child}
  /// The child of the context menu.
  /// {@endtemplate}
  final Widget child;

  /// {@template MDContextMenu.items}
  /// The items of the context menu.
  /// {@endtemplate}
  final List<Widget> items;

  /// {@template MDContextMenu.anchor}
  /// The anchor of the context menu.
  /// {@endtemplate}
  final MDAnchorBase? anchor;

  /// {@template MDContextMenu.visible}
  /// Whether the context menu is visible, defaults to null.
  /// {@endtemplate}
  final bool? visible;

  /// {@template MDContextMenu.constraints}
  /// The constraints of the context menu, defaults to
  /// `BoxConstraints(minWidth: 128)`.
  /// {@endtemplate}
  final BoxConstraints? constraints;

  /// {@template MDContextMenu.onHoverArea}
  /// The callback called when the hover area changes.
  /// {@endtemplate}
  final ValueChanged<bool>? onHoverArea;

  /// {@template MDContextMenu.padding}
  /// The padding of the context menu, defaults to
  /// `EdgeInsets.symmetric(vertical: 4)`.
  /// {@endtemplate}
  final EdgeInsetsGeometry? padding;

  /// {@macro MDMouseArea.groupId}
  final Object? groupId;

  /// {@macro MDPopover.effects}
  final List<Effect<dynamic>>? effects;

  /// {@macro MDPopover.shadows}
  final List<BoxShadow>? shadows;

  /// {@macro MDPopover.decoration}
  final MDDecoration? decoration;

  /// {@macro MDPopover.filter}
  final ImageFilter? filter;

  /// {@template MDContextMenu.controller}
  /// The controller of the context menu, starts from isOpen set to false.
  /// {@endtemplate}
  final MDContextMenuController? controller;

  @override
  State<MDContextMenu> createState() => MDContextMenuState();
}

class MDContextMenuState extends State<MDContextMenu> {
  MDContextMenuController? _controller;
  MDContextMenuController get controller =>
      widget.controller ??
      (_controller ??=
          MDContextMenuController(isOpen: widget.visible ?? false));

  @override
  void didUpdateWidget(covariant MDContextMenu oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.visible != null) {
      controller.setOpen(widget.visible!);
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  // ignore: use_setters_to_change_properties
  void setVisible(bool visible) {
    controller.setOpen(visible);
  }

  @override
  Widget build(BuildContext context) {
    // if the context menu has no items, just return the child
    if (widget.items.isEmpty) return widget.child;

    final theme = context.theme;

    final effectiveConstraints = widget.constraints ??
        theme.contextMenuTheme.constraints ??
        const BoxConstraints(minWidth: 128);

    final effectivePadding = widget.padding ??
        theme.contextMenuTheme.padding ??
        const EdgeInsets.symmetric(vertical: 4);

    final effectiveDecoration =
        (theme.contextMenuTheme.decoration ?? const MDDecoration())
            .mergeWith(widget.decoration);

    final effectiveFilter = widget.filter ?? theme.contextMenuTheme.filter;

    final effectiveEffects = widget.effects ?? theme.contextMenuTheme.effects;

    final effectiveShadows = widget.shadows ?? theme.contextMenuTheme.shadows;

    Widget child = MDPopover(
      controller: controller,
      padding: effectivePadding,
      areaGroupId: widget.groupId,
      groupId: kContextMenuGroupId,
      anchor: widget.anchor,
      decoration: effectiveDecoration,
      effects: effectiveEffects,
      shadows: effectiveShadows,
      filter: effectiveFilter,
      useSameGroupIdForChild: false,
      popover: (context) {
        return MDMouseArea(
          groupId: widget.groupId,
          key: ValueKey(widget.groupId),
          child: ConstrainedBox(
            constraints: effectiveConstraints,
            child: IntrinsicWidth(
              child: TapRegion(
                groupId: kContextMenuGroupId,
                child: FocusTraversalGroup(
                  policy: OrderedTraversalPolicy(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: widget.items,
                  ),
                ),
              ),
            ),
          ),
        );
      },
      child: MDMouseArea(
        groupId: widget.groupId,
        onEnter: (_) => widget.onHoverArea?.call(true),
        onExit: (_) => widget.onHoverArea?.call(false),
        child: widget.child,
      ),
    );

    // just put one context menu inherited widget.
    final contextMenu = context.maybeRead<MDContextMenuState>();
    if (contextMenu == null) {
      child = MDProvider(data: this, child: child);
    }

    return child;
  }
}

class MDContextMenuItemController extends ChangeNotifier {
  MDContextMenuItemController({
    required this.itemKey,
    bool hovered = false,
    bool focused = false,
  })  : _hovered = hovered,
        _focused = focused;

  bool _hovered = false;
  bool get hovered => _hovered;
  void setHovered(bool hovered) {
    if (hovered == _hovered) return;
    _hovered = hovered;
    notifyListeners();
  }

  bool _focused = false;
  bool get focused => _focused;
  void setFocused(bool focused) {
    if (focused == _focused) return;
    _focused = focused;
    notifyListeners();
  }

  final Key itemKey;

  /// Maps the item key to the item controller
  final Map<Key, MDContextMenuItemController> items = {};

  bool get selected =>
      _hovered || _focused || items.values.any((e) => e.selected);

  void registerSubItem(MDContextMenuItemController controller) {
    items[controller.itemKey] = controller;
  }

  void unregisterSubItem(MDContextMenuItemController controller) {
    items.remove(controller.itemKey);
  }
}

/// The variant of the context menu item.
enum MDContextMenuItemVariant {
  primary,
  inset,
}

class MDContextMenuItem extends StatefulWidget {
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
  })  : variant = MDContextMenuItemVariant.primary,
        insetPadding = null;

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
  }) : variant = MDContextMenuItemVariant.inset;

  /// {@template MDContextMenuItem.variant}
  /// The variant of the context menu item, defaults to
  /// [MDContextMenuItemVariant.primary].
  /// {@endtemplate}
  final MDContextMenuItemVariant variant;

  /// {@template MDContextMenuItem.child}
  /// The child of the context menu item.
  /// {@endtemplate}
  final Widget child;

  /// {@template MDContextMenuItem.enabled}
  /// Whether the context menu item is enabled, defaults to true.
  /// {@endtemplate}
  final bool enabled;

  /// {@template MDContextMenuItem.leading}
  /// The leading widget of the context menu item.
  /// {@endtemplate}
  final Widget? leading;

  /// {@template MDContextMenuItem.trailing}
  /// The trailing widget of the context menu item.
  /// {@endtemplate}
  final Widget? trailing;

  /// {@template MDContextMenuItem.leadingPadding}
  /// The padding of the leading widget, defaults to
  /// `EdgeInsets.only(right: 8)`.
  /// {@endtemplate}
  final EdgeInsetsGeometry? leadingPadding;

  /// {@template MDContextMenuItem.trailingPadding}
  /// The padding of the trailing widget, defaults to
  /// `EdgeInsets.only(left: 8)`.
  /// {@endtemplate}
  final EdgeInsetsGeometry? trailingPadding;

  /// {@template MDContextMenuItem.padding}
  /// The padding of the context menu item, defaults to
  /// `EdgeInsets.symmetric(horizontal: 4)`.
  /// {@endtemplate}
  final EdgeInsetsGeometry? padding;

  /// {@template MDContextMenuItem.insetPadding}
  /// The padding of the context menu item when it is inset, defaults to
  /// `EdgeInsets.only(left: 32, right: 8)` when the variant is inset, otherwise
  /// `EdgeInsets.symmetric(horizontal: 8)`
  /// {@endtemplate}
  final EdgeInsetsGeometry? insetPadding;

  /// {@template MDContextMenuItem.onPressed}
  /// The callback called when the context menu item is pressed.
  /// {@endtemplate}
  final VoidCallback? onPressed;

  /// {@template MDContextMenuItem.anchor}
  /// The anchor of the context menu item, defaults to
  /// `MDAnchor(overlayAlignment:
  /// Alignment.topRight, offset: Offset(-8, -3))`.
  /// {@endtemplate}
  final MDAnchorBase? anchor;

  /// {@template MDContextMenuItem.showDelay}
  /// The delay before the context menu is shown, defaults to 100ms.
  ///
  /// This is useful when the mouse is moved outside the item and towards the
  /// submenu, to avoid losing the focus on the item.
  /// {@endtemplate}
  final Duration? showDelay;

  /// {@template MDContextMenuItem.height}
  /// The height of the context menu item, defaults to 32.
  /// {@endtemplate}
  final double? height;

  /// {@template MDContextMenuItem.buttonVariant}
  /// The variant of the button of the context menu item, defaults to
  /// [MDButtonVariant.ghost].
  /// {@endtemplate}
  final ShadButtonVariant? buttonVariant;

  /// {@template MDContextMenuItem.decoration}
  /// The decoration of the context menu item, defaults to
  /// `MDDecoration(secondaryBorder: MDBorder.none)`.
  /// {@endtemplate}
  final MDDecoration? decoration;

  /// {@template MDContextMenuItem.textStyle}
  /// The text style of the context menu item, defaults to
  /// `small.copyWith(fontWeight: FontWeight.normal)`.
  /// {@endtemplate}
  final TextStyle? textStyle;

  /// {@template MDContextMenuItem.trailingTextStyle}
  /// The text style of the trailing widget, defaults to
  /// `muted.copyWith(fontSize: 12, height: 1)`.
  /// {@endtemplate}
  final TextStyle? trailingTextStyle;

  /// {@macro MDContextMenu.constraints}
  final BoxConstraints? constraints;

  /// {@macro MDContextMenu.padding}
  final EdgeInsetsGeometry? subMenuPadding;

  /// {@template MDContextMenuItem.backgroundColor}
  /// The background color of the context menu item, defaults to
  /// `null`.
  /// {@endtemplate}
  final Color? backgroundColor;

  /// {@template MDContextMenuItem.selectedBackgroundColor}
  /// The background color of the context menu item when it is selected,
  /// defaults to `theme.colorScheme.accent`.
  /// {@endtemplate}
  final Color? selectedBackgroundColor;

  /// {@template MDContextMenuItem.closeOnTap}
  /// Whether the context menu should be closed when the item is tapped,
  /// defaults to `true` when [items] is empty, otherwise `false`.
  /// {@endtemplate}
  final bool? closeOnTap;

  /// {@template MDContextMenuItem.items}
  /// The submenu items of the context menu item.
  /// {@endtemplate}
  final List<Widget> items;

  @override
  State<MDContextMenuItem> createState() => _MDContextMenuItemState();
}

class _MDContextMenuItemState extends State<MDContextMenuItem> {
  final itemKey = UniqueKey();
  late final controller = MDContextMenuItemController(itemKey: itemKey);
  // get the parent item controller, if any, meaning this item is a submenu
  late final parentItemController =
      context.maybeRead<MDContextMenuItemController>();

  bool get hasTrailingIcon => widget.items.isNotEmpty;

  @override
  void initState() {
    super.initState();
    // register the subitem controller if this item is a submenu
    parentItemController?.registerSubItem(controller);
  }

  @override
  void dispose() {
    parentItemController?.unregisterSubItem(controller);
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    final contextMenu = context.read<MDContextMenuState>();

    final effectivePadding = widget.padding ??
        theme.contextMenuTheme.itemPadding ??
        const EdgeInsets.symmetric(horizontal: 4);

    final defaultInsetPadding = switch (widget.variant) {
      MDContextMenuItemVariant.primary =>
        const EdgeInsets.symmetric(horizontal: 8),
      MDContextMenuItemVariant.inset =>
        const EdgeInsets.only(left: 32, right: 8),
    };

    final effectiveInsetPadding = widget.insetPadding ??
        theme.contextMenuTheme.insetPadding ??
        defaultInsetPadding;

    final effectiveLeadingPadding = widget.leadingPadding ??
        theme.contextMenuTheme.leadingPadding ??
        const EdgeInsets.only(right: 8);

    final effectiveTrailingPadding = widget.trailingPadding ??
        theme.contextMenuTheme.trailingPadding ??
        const EdgeInsets.only(left: 8);

    final effectiveAnchor = widget.anchor ??
        theme.contextMenuTheme.anchor ??
        MDAnchor(
          overlayAlignment: Alignment.topRight,
          offset: Offset(-8, parentItemController != null ? -5 : -3),
        );

    final effectiveHeight =
        widget.height ?? theme.contextMenuTheme.height ?? 32;

    final effectiveButtonVariant = widget.buttonVariant ??
        theme.contextMenuTheme.buttonVariant ??
        ShadButtonVariant.ghost;

    final effectiveDecoration = const MDDecoration(
      secondaryBorder: MDBorder.none,
      secondaryFocusedBorder: MDBorder.none,
    )
        .mergeWith(theme.contextMenuTheme.itemDecoration)
        .mergeWith(widget.decoration);

    final effectiveTextStyle = widget.textStyle ??
        theme.contextMenuTheme.textStyle ??
        theme.fonts.paragraph.small.copyWith(fontWeight: FontWeight.normal);

    final effectiveTrailingTextStyle = widget.trailingTextStyle ??
        theme.contextMenuTheme.trailingTextStyle ??
        theme.fonts.paragraph.small.copyWith(
          fontSize: 12,
          height: 1,
        );

    final effectiveBackgroundColor =
        widget.backgroundColor ?? theme.contextMenuTheme.backgroundColor;

    final effectiveSelectedBackgroundColor = widget.selectedBackgroundColor ??
        theme.contextMenuTheme.selectedBackgroundColor ??
        theme.colors.accent;

    final effectiveCloseOnTap = widget.closeOnTap ??
        theme.contextMenuTheme.closeOnTap ??
        widget.items.isEmpty;

    /// if the item has submenu items, use the current item key,
    /// otherwise use the parent item controller's item key
    /// or the current item key if there is no parent item
    final effectiveGroupId = widget.items.isNotEmpty
        ? itemKey
        : parentItemController?.itemKey ?? itemKey;

    Widget child = ListenableBuilder(
      listenable: controller,
      builder: (context, child) {
        return MDContextMenu(
          visible: controller.selected,
          anchor: effectiveAnchor,
          constraints: widget.constraints,
          padding: widget.subMenuPadding,
          groupId: effectiveGroupId,
          onHoverArea: controller.setHovered,
          items: widget.items,
          child: Padding(
            padding: effectivePadding,
            child: MDTap.raw(
              height: effectiveHeight,
              enabled: widget.enabled,
              variant: effectiveButtonVariant,
              // decoration: effectiveDecoration,
              width: double.infinity,
              padding: effectiveInsetPadding,
              backgroundColor: controller.selected
                  ? effectiveSelectedBackgroundColor
                  : effectiveBackgroundColor,
              onFocusChange: controller.setFocused,
              onPressed: () {
                widget.onPressed?.call();
                if (effectiveCloseOnTap) contextMenu.setVisible(false);
              },
              child: child,
            ),
          ),
        );
      },
      child: Expanded(
        child: Row(
          children: [
            if (widget.leading != null)
              Padding(
                padding: effectiveLeadingPadding,
                child: widget.leading,
              ),
            Expanded(
              child: DefaultTextStyle(
                style: effectiveTextStyle,
                child: widget.child,
              ),
            ),
            if (widget.trailing != null)
              Padding(
                padding: effectiveTrailingPadding,
                child: DefaultTextStyle(
                  style: effectiveTrailingTextStyle,
                  child: widget.trailing!,
                ),
              ),
          ],
        ),
      ),
    );

    // if the item has at least one submenu item, wrap it in a provider to
    //provide the controller to the submenu items
    if (widget.items.isNotEmpty) {
      child = MDProvider(
        data: controller,
        child: child,
      );
    }

    return child;
  }
}
