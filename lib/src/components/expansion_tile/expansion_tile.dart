library md_expansiontile;

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_meragi_design/src/components/gesture_detector.dart';
import 'package:flutter_meragi_design/src/theme/style.dart';
import 'package:provider/provider.dart';

part 'expansion_tile_controller.dart';
part 'expansion_tile_decoration.dart';

class MDExpansionTile extends StatelessWidget {
  const MDExpansionTile({
    super.key,
    required this.title,
    final MDExpansionTileController? controller,
    this.onTap,
    this.trailingIcon,
    this.expandedChildren = const <Widget>[],
    this.onExpansionChanged,
    this.decoration,
    this.initiallyExpanded = false,
    this.shouldOnTileTapExpand = true,
    this.showExpandMoreIcon = true,
  }) : _controller = controller;

  final Widget title;
  final VoidCallback? onTap;
  final Widget? trailingIcon;
  final List<Widget> expandedChildren;
  final void Function(bool)? onExpansionChanged;
  final MDExpansionTileController? _controller;
  final MDExpansionTileDecoration? decoration;
  final bool initiallyExpanded;
  final bool shouldOnTileTapExpand;
  final bool showExpandMoreIcon;

  @override
  Widget build(BuildContext context) {
    return _controller == null
        ? ChangeNotifierProvider(
            create: (context) => MDExpansionTileController().._setInitialValue(initiallyExpanded),
            builder: (context, child) =>
                expansionWidget(context, decoration ?? MDExpansionTileDecoration(context: context)))
        : ChangeNotifierProvider.value(
            value: _controller.._setInitialValue(initiallyExpanded),
            builder: (context, child) =>
                expansionWidget(context, decoration ?? MDExpansionTileDecoration(context: context)));
  }

  Widget expansionWidget(BuildContext context, MDExpansionTileDecoration decoration) {
    return Theme(
      data: Theme.of(context).copyWith(
          splashColor: decoration.expansionTileSplashColor,
          hoverColor: decoration.expansionTileHoverColor,
          splashFactory: decoration.expansionTileSplashFactory,
          dividerColor: Colors.transparent,
          listTileTheme: ListTileTheme.of(context).copyWith(minVerticalPadding: 0)),
      child: ExpansionTile(
          controller: context.read<MDExpansionTileController>()._controller,
          initiallyExpanded: initiallyExpanded,
          dense: true,
          showTrailingIcon: false,
          expansionAnimationStyle: decoration.expansionAnimationStyle,
          tilePadding: EdgeInsets.zero,
          visualDensity: decoration.visualDensity,
          shape: decoration.expansionTileExpandedShape,
          collapsedShape: decoration.expansionTileCollapsedShape,
          onExpansionChanged: onExpansionChanged,
          title: MDGestureDetector(
              onTap: () {
                if (shouldOnTileTapExpand) {
                  context.read<MDExpansionTileController>().value
                      ? context.read<MDExpansionTileController>().collapse()
                      : context.read<MDExpansionTileController>().expand();
                }
                onTap?.call();
              },
              child: Container(
                padding: decoration.expansiontitlePadding,
                color: decoration.expansionTileBackgroundColor,
                child: showExpandMoreIcon
                    ? Row(
                        children: [
                          Expanded(child: title),
                          Consumer<MDExpansionTileController>(builder: (context, ref, child) {
                            return IconButton(
                              onPressed: () => ref.value ? ref.collapse() : ref.expand(),
                              icon: AnimatedRotation(
                                turns: ref.value ? 0.5 : 0,
                                duration:
                                    decoration.expansionAnimationStyle.duration ?? const Duration(milliseconds: 200),
                                child: trailingIcon ?? const Icon(Icons.expand_more),
                              ),
                            );
                          })
                        ],
                      )
                    : trailingIcon != null
                        ? Row(children: [Expanded(child: title), trailingIcon!])
                        : title,
              )),
          children: expandedChildren),
    );
  }
}
