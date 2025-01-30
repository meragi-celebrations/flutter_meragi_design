import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_meragi_design/src/components/gesture_detector.dart';
import 'package:flutter_meragi_design/src/theme/style.dart';
import 'package:provider/provider.dart';

class MDExpansionTile extends StatelessWidget {
  const MDExpansionTile({
    super.key,
    required this.title,
    this.onTap,
    this.trailingIcon,
    this.expandedChildren = const <Widget>[],
    this.controller,
    this.onExpansionChanged,
    this.decoration,
  });

  final Widget title;
  final VoidCallback? onTap;
  final Widget? trailingIcon;
  final List<Widget> expandedChildren;
  final void Function(bool)? onExpansionChanged;
  final MDExpansionTileController? controller;
  final MDExpansionTileDecoration? decoration;

  @override
  Widget build(BuildContext context) {
    return controller == null
        ? ChangeNotifierProvider(
            create: (context) => MDExpansionTileController(),
            builder: (context, child) =>
                expansionWidget(context, decoration ?? MDExpansionTileDecoration(context: context)))
        : ChangeNotifierProvider.value(
            value: controller,
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
          initiallyExpanded: decoration.initiallyExpanded,
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
                if (decoration.shouldOnTileTapExpand) {
                  context.read<MDExpansionTileController>().value
                      ? context.read<MDExpansionTileController>().collapse()
                      : context.read<MDExpansionTileController>().expand();
                }
                onTap?.call();
              },
              child: Container(
                padding: decoration.expansiontitlePadding,
                color: decoration.expansionTileBackgroundColor,
                child: decoration.showExpandMoreIcon
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

class MDExpansionTileController extends ChangeNotifier implements ValueListenable<bool> {
  final ExpansionTileController _controller;
  MDExpansionTileController() : _controller = ExpansionTileController();

  void expand({bool notifyListeners = true}) {
    _controller.expand();
    if (notifyListeners) this.notifyListeners();
  }

  void collapse({bool notifyListeners = true}) {
    _controller.collapse();
    if (notifyListeners) this.notifyListeners();
  }

  @override
  bool get value => _controller.isExpanded;
}

class MDExpansionTileDecoration extends Style {
  const MDExpansionTileDecoration({
    required super.context,
    final bool? initiallyExpandedOverride,
    final Color? expansionTileSplashColorOverride,
    final Color? expansionTileHoverColorOverride,
    final InteractiveInkFeatureFactory? expansionTileSplashFactoryOverride,
    final bool? shouldOnTileTapExpandOverride,
    final Color? expansionTileBackgroundColorOverride,
    final EdgeInsets? expansiontitlePaddingOverride,
    final bool? showExpandMoreIconOverride,
    final AnimationStyle? expansionAnimationStyleOverride,
    final VisualDensity? visualDensityOverride,
    final ShapeBorder? expansionTileCollapsedShapeOverride,
    final ShapeBorder? expansionTileExpandedShapeOverride,
  })  : _initiallyExpandedOverride = initiallyExpandedOverride,
        _expansionTileSplashColorOverride = expansionTileSplashColorOverride,
        _expansionTileHoverColorOverride = expansionTileHoverColorOverride,
        _expansionTileSplashFactoryOverride = expansionTileSplashFactoryOverride,
        _shouldOnTileTapExpandOverride = shouldOnTileTapExpandOverride,
        _expansionTileBackgroundColorOverride = expansionTileBackgroundColorOverride,
        _expansiontitlePaddingOverride = expansiontitlePaddingOverride,
        _showExpandMoreIconOverride = showExpandMoreIconOverride,
        _expansionAnimationStyleOverride = expansionAnimationStyleOverride,
        _visualDensityOverride = visualDensityOverride,
        _expansionTileCollapsedShapeOverride = expansionTileCollapsedShapeOverride,
        _expansionTileExpandedShapeOverride = expansionTileExpandedShapeOverride;

  final bool? _initiallyExpandedOverride;
  final Color? _expansionTileSplashColorOverride;
  final Color? _expansionTileHoverColorOverride;
  final InteractiveInkFeatureFactory? _expansionTileSplashFactoryOverride;
  final bool? _shouldOnTileTapExpandOverride;
  final Color? _expansionTileBackgroundColorOverride;
  final EdgeInsets? _expansiontitlePaddingOverride;
  final bool? _showExpandMoreIconOverride;
  final AnimationStyle? _expansionAnimationStyleOverride;
  final VisualDensity? _visualDensityOverride;
  final ShapeBorder? _expansionTileCollapsedShapeOverride;
  final ShapeBorder? _expansionTileExpandedShapeOverride;

  bool get initiallyExpanded => _initiallyExpandedOverride ?? token.initiallyExpanded;

  Color get expansionTileSplashColor => _expansionTileSplashColorOverride ?? token.expansionTileSplashColor;

  Color get expansionTileHoverColor => _expansionTileHoverColorOverride ?? token.expansionTileHoverColor;

  InteractiveInkFeatureFactory get expansionTileSplashFactory =>
      _expansionTileSplashFactoryOverride ?? token.expansionTileSplashFactory;

  bool get shouldOnTileTapExpand => _shouldOnTileTapExpandOverride ?? token.shouldOnTileTapExpand;

  Color get expansionTileBackgroundColor => _expansionTileBackgroundColorOverride ?? token.expansionTileBackgroundColor;

  EdgeInsets get expansiontitlePadding => _expansiontitlePaddingOverride ?? token.expansiontitlePadding;

  bool get showExpandMoreIcon => _showExpandMoreIconOverride ?? token.showExpandMoreIcon;

  AnimationStyle get expansionAnimationStyle => _expansionAnimationStyleOverride ?? token.expansionAnimationStyle;

  VisualDensity get visualDensity => _visualDensityOverride ?? token.visualDensity;

  ShapeBorder get expansionTileExpandedShape => _expansionTileExpandedShapeOverride ?? token.expansionTileExpandedShape;

  ShapeBorder get expansionTileCollapsedShape =>
      _expansionTileCollapsedShapeOverride ?? token.expansionTileCollapsedShape;

  MDExpansionTileDecoration copyWith({
    final bool? initiallyExpandedOverride,
    final Color? expansionTileSplashColorOverride,
    final Color? expansionTileHoverColorOverride,
    final InteractiveInkFeatureFactory? expansionTileSplashFactoryOverride,
    final bool? shouldOnTileTapExpandOverride,
    final Color? expansionTileBackgroundColorOverride,
    final EdgeInsets? expansiontitlePaddingOverride,
    final bool? showExpandMoreIconOverride,
    final AnimationStyle? expansionAnimationStyleOverride,
    final VisualDensity? visualDensityOverride,
    final ShapeBorder? expansionTileCollapsedShapeOverride,
    final ShapeBorder? expansionTileExpandedShapeOverride,
  }) {
    return MDExpansionTileDecoration(
      context: context,
      initiallyExpandedOverride: initiallyExpandedOverride ?? initiallyExpanded,
      expansionTileSplashColorOverride: expansionTileSplashColorOverride ?? expansionTileSplashColor,
      expansionTileHoverColorOverride: expansionTileHoverColorOverride ?? expansionTileHoverColor,
      expansionTileSplashFactoryOverride: expansionTileSplashFactoryOverride ?? expansionTileSplashFactory,
      shouldOnTileTapExpandOverride: shouldOnTileTapExpandOverride ?? shouldOnTileTapExpand,
      expansionTileBackgroundColorOverride: expansionTileBackgroundColorOverride ?? expansionTileBackgroundColor,
      expansiontitlePaddingOverride: expansiontitlePaddingOverride ?? expansiontitlePadding,
      showExpandMoreIconOverride: showExpandMoreIconOverride ?? showExpandMoreIcon,
      expansionAnimationStyleOverride: expansionAnimationStyleOverride ?? expansionAnimationStyle,
      visualDensityOverride: visualDensityOverride ?? visualDensity,
      expansionTileCollapsedShapeOverride: expansionTileCollapsedShapeOverride ?? expansionTileCollapsedShape,
      expansionTileExpandedShapeOverride: expansionTileExpandedShapeOverride ?? expansionTileExpandedShape,
    );
  }

  MDExpansionTileDecoration merge({MDExpansionTileDecoration? other}) {
    if (other == null) return this;

    return copyWith(
      initiallyExpandedOverride: other.initiallyExpanded,
      expansionTileSplashColorOverride: other.expansionTileSplashColor,
      expansionTileHoverColorOverride: other.expansionTileHoverColor,
      expansionTileSplashFactoryOverride: other.expansionTileSplashFactory,
      shouldOnTileTapExpandOverride: other.shouldOnTileTapExpand,
      expansionTileBackgroundColorOverride: other.expansionTileBackgroundColor,
      expansiontitlePaddingOverride: other.expansiontitlePadding,
      showExpandMoreIconOverride: other.showExpandMoreIcon,
      expansionAnimationStyleOverride: other.expansionAnimationStyle,
      visualDensityOverride: other.visualDensity,
      expansionTileCollapsedShapeOverride: other.expansionTileCollapsedShape,
      expansionTileExpandedShapeOverride: other.expansionTileExpandedShape,
    );
  }
}
