import 'package:flutter/material.dart';
import 'package:flutter_meragi_design/flutter_meragi_design.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';

class MDNavigationRail extends StatelessWidget {
  final List<MDNavigationRailDestination>? destinations;
  final int selectedIndex;
  final Function(int index)? onDestinationSelected;
  final Function(BuildContext context, bool isExpanded)? builder;
  final Widget? logo;
  final Widget? expandedLogo;
  final Function()? onExpandTap;
  final MDNavigationRailController? controller;
  final MDNavigationRailDecoration? decoration;

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
  }) : assert(
            destinations == null && builder != null ||
                destinations != null && builder == null && onDestinationSelected != null,
            "Please ensure that you provider destinations or builder but not both. Make sure that both parameters are not null. Also if you are providing the destinations, please ensure that onDestinations is also present");

  @override
  Widget build(BuildContext context) {
    MDNavigationRailDecoration finalDecoration = MDNavigationRailDecoration(context: context).merge(decoration);
    return ChangeNotifierProvider<MDNavigationRailController>(
        create: (context) => controller ?? MDNavigationRailController(),
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
                    child: builder != null
                        ? builder!.call(context, value.isExpanded)
                        : _MDNavigationContent(
                            logo: logo,
                            expandedLogo: expandedLogo,
                            destinations: destinations!,
                            onExpandTap: onExpandTap,
                            value: value,
                            widget: this));
              },
            ),
          );
        });
  }
}

class _MDNavigationContent extends StatelessWidget {
  const _MDNavigationContent({
    required this.logo,
    required this.expandedLogo,
    required this.destinations,
    required this.onExpandTap,
    required this.value,
    required this.widget,
  });

  final Widget? logo;
  final Widget? expandedLogo;
  final List<MDNavigationRailDestination> destinations;
  final Function()? onExpandTap;
  final MDNavigationRailController value;
  final MDNavigationRail widget;

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
                    rail: widget,
                    index: index,
                    isExpanded: value.isExpanded,
                  );
                })
                .toList()
                .withSpaceBetween(height: 10),
          ),
        ),
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
    required this.rail,
    required this.index,
    required bool isExpanded,
  }) : _isExpanded = isExpanded;

  final MDNavigationRailDestination destination;
  final MDNavigationRail rail;
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
    bool isSelected = widget.index == widget.rail.selectedIndex;

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
          widget.rail.onDestinationSelected!.call(widget.index);
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
