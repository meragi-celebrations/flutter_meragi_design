import 'package:flutter/material.dart';
import 'package:flutter_meragi_design/flutter_meragi_design.dart';
import 'package:flutter_meragi_design/src/extensions/list.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class MDNavigationRail extends StatefulWidget {
  final List<MDNavigationRailDestination> destinations;
  final int selectedIndex;
  final Function(int index) onDestinationSelected;
  final Widget? logo;
  final Widget? expandedLogo;

  const MDNavigationRail({
    super.key,
    required this.destinations,
    required this.onDestinationSelected,
    this.selectedIndex = 0,
    this.logo,
    this.expandedLogo,
  });

  @override
  State<MDNavigationRail> createState() => _MDNavigationRailState();
}

class _MDNavigationRailState extends State<MDNavigationRail> {
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      color: const Color(0xfff1f0f5),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: _isExpanded ? 250 : 65,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (widget.logo != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 50),
                child: (widget.expandedLogo != null)
                    ? Row(
                        children: [
                          Expanded(
                            child: AnimatedCrossFade(
                              duration: const Duration(milliseconds: 300),
                              crossFadeState: _isExpanded
                                  ? CrossFadeState.showSecond
                                  : CrossFadeState.showFirst,
                              firstChild: widget.logo!,
                              secondChild: widget.expandedLogo!,
                            ),
                          ),
                        ],
                      )
                    : widget.logo!,
              ),
            Expanded(
              child: ListView(
                physics: const ClampingScrollPhysics(),
                children: widget.destinations
                    .map((destination) {
                      int index = widget.destinations.indexOf(destination);
                      return NavigationItem(
                          destination: destination,
                          rail: widget,
                          index: index,
                          isExpanded: _isExpanded);
                    })
                    .toList()
                    .withSpaceBetween(height: 10),
              ),
            ),
            Button(
              decoration: ButtonDecoration(
                context: context,
                variant: ButtonVariant.ghost,
                type: ButtonType.primary,
              ),
              expand: true,
              onTap: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              },
              icon: _isExpanded
                  ? PhosphorIconsRegular.caretLeft
                  : PhosphorIconsRegular.caretRight,
            )
          ],
        ),
      ),
    );
  }
}

class NavigationItem extends StatefulWidget {
  const NavigationItem({
    super.key,
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
  State<NavigationItem> createState() => _NavigationItemState();
}

class _NavigationItemState extends State<NavigationItem> {
  bool _isHovering = false;

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
          widget.rail.onDestinationSelected(widget.index);
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
                    ? widget.destination.selectedColor
                    : _isHovering
                        ? widget.destination.hoverColor
                        : widget.destination.color,
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
                      crossFadeState: widget._isExpanded
                          ? CrossFadeState.showFirst
                          : CrossFadeState.showSecond,
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
  final Color? color;
  final Color? hoverColor;
  final Color? selectedColor;

  MDNavigationRailDestination({
    required this.icon,
    required this.label,
    this.selectedIcon,
    this.color,
    this.hoverColor,
    this.selectedColor,
  });
}
