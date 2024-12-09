import 'package:flutter/material.dart';
import 'package:flutter_meragi_design/flutter_meragi_design.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';

class MDNavigationRail extends StatefulWidget {
  final List<MDNavigationRailDestination>? destinations;
  final int selectedIndex;
  final Function(int index)? onDestinationSelected;
  final Widget Function(BuildContext context, bool isExpanded)? builder;
  final Widget? logo;
  final Widget? expandedLogo;
  final Widget? trailing;
  final Function()? onExpandTap;
  final MDNavigationRailController? controller;
  final MDNavigationRailDecoration? decoration;

  /// Used only if you are using [Builder].
  /// It wraps your builder with [Expanded] or [Flexible]
  /// It only does this if [MDNavigationRailController.expandedButton] is ```true``` or [trailing] is true (or both)
  final BuilderFlexType type;

  /// This puts the [trailing] widget on top of ```MDNavigationRailController.expandedButton``` widget.
  /// Provided that [trailing] is given and ```MDNavigationRailController.expandedButton = true```
  final bool trailingFirst;

  const MDNavigationRail({
    super.key,
    this.onDestinationSelected,
    this.destinations,
    this.builder,
    this.selectedIndex = 0,
    this.logo,
    this.expandedLogo,
    this.onExpandTap,
    this.controller,
    this.decoration,
    this.trailing,
    this.type = BuilderFlexType.expanded,
    this.trailingFirst = true,
  }) : assert(
            destinations == null && builder != null ||
                destinations != null && builder == null && onDestinationSelected != null,
            "Please ensure that you provider destinations or builder but not both. Make sure that both parameters are not null. Also if you are providing the destinations, please ensure that onDestinations is also present");

  @override
  State<MDNavigationRail> createState() => _MDNavigationRailState();
}

class _MDNavigationRailState extends State<MDNavigationRail> {
  late final MDNavigationRailController controller;

  @override
  void initState() {
    controller = widget.controller ?? MDNavigationRailController();
    super.initState();
  }

  List<Widget>? _build(MDNavigationRailController controller) => widget.trailing != null
      ? controller.expandedButton
          ? widget.trailingFirst
              ? [widget.trailing!, expandedButton(controller)]
              : [expandedButton(controller), widget.trailing!]
          : [widget.trailing!]
      : controller.expandedButton
          ? [expandedButton(controller)]
          : null;

  Widget expandedButton(MDNavigationRailController controller) {
    return MDButton(
      decoration: ButtonDecoration(
        context: context,
        variant: ButtonVariant.outline,
        type: ButtonType.secondary,
      ),
      expand: true,
      onTap: () {
        if (controller.isExpanded) {
          controller.close();
        } else {
          controller.open();
        }
        widget.onExpandTap?.call();
      },
      icon: controller.isExpanded ? PhosphorIconsRegular.caretLeft : PhosphorIconsRegular.caretRight,
    );
  }

  Widget _wrapAroundChild(BuilderFlexType type, Widget child) {
    switch (type) {
      case BuilderFlexType.expanded:
        return Expanded(child: child);
      case BuilderFlexType.flexible:
        return Flexible(child: child);
      case BuilderFlexType.none:
        return child;
    }
  }

  @override
  Widget build(BuildContext context) {
    MDNavigationRailDecoration finalDecoration = MDNavigationRailDecoration(context: context).merge(widget.decoration);
    return ChangeNotifierProvider<MDNavigationRailController>.value(
      value: controller,
      builder: (context, child) {
        var mdController = context.read<MDNavigationRailController>();
        return MouseRegion(
          onExit: (event) {
            if (mdController.isExpanded && mdController.isHoverable) {
              mdController.close();
            }
          },
          onEnter: (event) {
            if (!mdController.isExpanded && mdController.isHoverable) {
              mdController.open();
            }
          },
          child: Consumer<MDNavigationRailController>(
            builder: (context, value, child) {
              return AnimatedContainer(
                duration: finalDecoration.animationDuration,
                width: value.isExpanded ? finalDecoration.expandedWidth : finalDecoration.collapsedWidth,
                decoration: BoxDecoration(
                    color: finalDecoration.backgroundColor,
                    borderRadius: finalDecoration.borderRadius,
                    boxShadow: finalDecoration.boxShadow),
                padding: finalDecoration.contentPadding,
                child: widget.builder != null
                    ? _build(controller) != null
                        ? Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _wrapAroundChild(widget.type, widget.builder!.call(context, value.isExpanded)),
                              ..._build(controller)!
                            ],
                          )
                        : widget.builder!.call(context, value.isExpanded)
                    : _MDNavigationContent(
                        logo: widget.logo,
                        expandedLogo: widget.expandedLogo,
                        destinations: widget.destinations!,
                        onExpandTap: widget.onExpandTap,
                        value: value,
                        selectedIndex: widget.selectedIndex,
                        trailing: widget.trailing,
                        onDestinationSelected: (index) {
                          widget.onDestinationSelected?.call(index);
                        },
                      ),
              );
            },
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      controller.dispose();
    }
    super.dispose();
  }
}

class _MDNavigationContent extends StatelessWidget {
  const _MDNavigationContent({
    required this.logo,
    required this.expandedLogo,
    required this.destinations,
    required this.onExpandTap,
    required this.value,
    required this.selectedIndex,
    required this.onDestinationSelected,
    this.trailing,
  });

  final Widget? logo;
  final Widget? expandedLogo;
  final List<MDNavigationRailDestination> destinations;
  final Function()? onExpandTap;
  final Function(int) onDestinationSelected;
  final MDNavigationRailController value;
  final Widget? trailing;
  final int selectedIndex;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (logo != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 50),
            child: (expandedLogo != null)
                ? Row(
                    children: [
                      Expanded(
                        child: AnimatedCrossFade(
                          duration: const Duration(milliseconds: 300),
                          crossFadeState: value.isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                          firstChild: logo!,
                          secondChild: expandedLogo!,
                        ),
                      ),
                    ],
                  )
                : logo!,
          ),
        Expanded(
          child: ListView(
            physics: const ClampingScrollPhysics(),
            children: destinations
                .map((destination) {
                  int index = destinations.indexOf(destination);
                  return _NavigationItem(
                    destination: destination,
                    selectedIndex: selectedIndex,
                    index: index,
                    isExpanded: value.isExpanded,
                    onDestinationSelected: onDestinationSelected,
                  );
                })
                .toList()
                .withSpaceBetween(height: 10),
          ),
        ),
        if (trailing != null) trailing!,
        if (value.expandedButton)
          MDButton(
            decoration: ButtonDecoration(
              context: context,
              variant: ButtonVariant.outline,
              type: ButtonType.secondary,
            ),
            expand: true,
            onTap: () {
              if (value.isExpanded) {
                value.close();
              } else {
                value.open();
              }
              onExpandTap?.call();
            },
            icon: value.isExpanded ? PhosphorIconsRegular.caretLeft : PhosphorIconsRegular.caretRight,
          )
      ],
    );
  }
}

class _NavigationItem extends StatefulWidget {
  const _NavigationItem({
    required this.destination,
    required this.selectedIndex,
    required this.onDestinationSelected,
    required this.index,
    required bool isExpanded,
  }) : _isExpanded = isExpanded;

  final MDNavigationRailDestination destination;
  final int selectedIndex;
  final Function(int) onDestinationSelected;
  final int index;
  final bool _isExpanded;

  @override
  State<_NavigationItem> createState() => _NavigationItemState();
}

class _NavigationItemState extends State<_NavigationItem> {
  bool _isHovering = false;
  late final MDNavigationRailDestinationDecoration decoration;

  @override
  void initState() {
    super.initState();
    decoration = MDNavigationRailDestinationDecoration(context: context).merge(widget.destination.decoration);
  }

  @override
  Widget build(BuildContext context) {
    bool isSelected = widget.index == widget.selectedIndex;

    return MouseRegion(
      onEnter: (event) {
        setState(() {
          _isHovering = true;
        });
      },
      onExit: (event) {
        setState(() {
          _isHovering = false;
        });
      },
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          widget.onDestinationSelected.call(widget.index);
        },
        child: TooltipVisibility(
          visible: !widget._isExpanded,
          child: Tooltip(
            message: widget.destination.label,
            waitDuration: const Duration(milliseconds: 700),
            child: Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: isSelected
                    ? _isHovering
                        ? decoration.selectedHoverColor
                        : decoration.selectedColor
                    : _isHovering
                        ? decoration.nonSelectedHoverColor
                        : decoration.nonSelectedColor,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  if (isSelected && widget.destination.selectedIcon != null)
                    widget.destination.selectedIcon!
                  else
                    widget.destination.icon,
                  Expanded(
                    child: Material(
                      color: Colors.transparent,
                      child: AnimatedCrossFade(
                        crossFadeState: widget._isExpanded ? CrossFadeState.showFirst : CrossFadeState.showSecond,
                        duration: const Duration(milliseconds: 300),
                        firstChild: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: BodyText(
                            text: widget.destination.label,
                            maxLines: 1,
                          ),
                        ),
                        secondChild: const BodyText(text: ""),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class MDNavigationRailDestination {
  final Widget icon;
  final Widget? selectedIcon;
  final String label;
  final MDNavigationRailDestinationDecoration? decoration;

  MDNavigationRailDestination({
    required this.icon,
    required this.label,
    this.selectedIcon,
    this.decoration,
  });
}

class MDNavigationRailEmpty extends StatelessWidget {
  const MDNavigationRailEmpty({super.key, this.decoration});

  final MDNavigationRailDecoration? decoration;
  @override
  Widget build(BuildContext context) {
    final MDNavigationRailDecoration finalDecoration = MDNavigationRailDecoration(context: context).merge(decoration);
    return Container(
      height: double.infinity,
      width: finalDecoration.collapsedWidth - 8,
      margin: const EdgeInsets.only(top: 8, right: 8, bottom: 8),
      decoration: BoxDecoration(color: finalDecoration.backgroundColor, borderRadius: finalDecoration.borderRadius),
    );
  }
}
