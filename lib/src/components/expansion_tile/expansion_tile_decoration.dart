part of md_expansiontile;

class MDExpansionTileDecoration extends Style {
  const MDExpansionTileDecoration({
    required super.context,
    final Color? expansionTileSplashColorOverride,
    final Color? expansionTileHoverColorOverride,
    final InteractiveInkFeatureFactory? expansionTileSplashFactoryOverride,
    final Color? expansionTileBackgroundColorOverride,
    final EdgeInsets? expansiontitlePaddingOverride,
    final AnimationStyle? expansionAnimationStyleOverride,
    final VisualDensity? visualDensityOverride,
    final ShapeBorder? expansionTileCollapsedShapeOverride,
    final ShapeBorder? expansionTileExpandedShapeOverride,
  })  : _expansionTileSplashColorOverride = expansionTileSplashColorOverride,
        _expansionTileHoverColorOverride = expansionTileHoverColorOverride,
        _expansionTileSplashFactoryOverride = expansionTileSplashFactoryOverride,
        _expansionTileBackgroundColorOverride = expansionTileBackgroundColorOverride,
        _expansiontitlePaddingOverride = expansiontitlePaddingOverride,
        _expansionAnimationStyleOverride = expansionAnimationStyleOverride,
        _visualDensityOverride = visualDensityOverride,
        _expansionTileCollapsedShapeOverride = expansionTileCollapsedShapeOverride,
        _expansionTileExpandedShapeOverride = expansionTileExpandedShapeOverride;

  final Color? _expansionTileSplashColorOverride;
  final Color? _expansionTileHoverColorOverride;
  final InteractiveInkFeatureFactory? _expansionTileSplashFactoryOverride;
  final Color? _expansionTileBackgroundColorOverride;
  final EdgeInsets? _expansiontitlePaddingOverride;
  final AnimationStyle? _expansionAnimationStyleOverride;
  final VisualDensity? _visualDensityOverride;
  final ShapeBorder? _expansionTileCollapsedShapeOverride;
  final ShapeBorder? _expansionTileExpandedShapeOverride;

  Color get expansionTileSplashColor => _expansionTileSplashColorOverride ?? token.expansionTileSplashColor;

  Color get expansionTileHoverColor => _expansionTileHoverColorOverride ?? token.expansionTileHoverColor;

  InteractiveInkFeatureFactory get expansionTileSplashFactory =>
      _expansionTileSplashFactoryOverride ?? token.expansionTileSplashFactory;

  Color get expansionTileBackgroundColor => _expansionTileBackgroundColorOverride ?? token.expansionTileBackgroundColor;

  EdgeInsets get expansiontitlePadding => _expansiontitlePaddingOverride ?? token.expansiontitlePadding;

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
      expansionTileSplashColorOverride: expansionTileSplashColorOverride ?? expansionTileSplashColor,
      expansionTileHoverColorOverride: expansionTileHoverColorOverride ?? expansionTileHoverColor,
      expansionTileSplashFactoryOverride: expansionTileSplashFactoryOverride ?? expansionTileSplashFactory,
      expansionTileBackgroundColorOverride: expansionTileBackgroundColorOverride ?? expansionTileBackgroundColor,
      expansiontitlePaddingOverride: expansiontitlePaddingOverride ?? expansiontitlePadding,
      expansionAnimationStyleOverride: expansionAnimationStyleOverride ?? expansionAnimationStyle,
      visualDensityOverride: visualDensityOverride ?? visualDensity,
      expansionTileCollapsedShapeOverride: expansionTileCollapsedShapeOverride ?? expansionTileCollapsedShape,
      expansionTileExpandedShapeOverride: expansionTileExpandedShapeOverride ?? expansionTileExpandedShape,
    );
  }

  MDExpansionTileDecoration merge({MDExpansionTileDecoration? other}) {
    if (other == null) return this;

    return copyWith(
      expansionTileSplashColorOverride: other.expansionTileSplashColor,
      expansionTileHoverColorOverride: other.expansionTileHoverColor,
      expansionTileSplashFactoryOverride: other.expansionTileSplashFactory,
      expansionTileBackgroundColorOverride: other.expansionTileBackgroundColor,
      expansiontitlePaddingOverride: other.expansiontitlePadding,
      expansionAnimationStyleOverride: other.expansionAnimationStyle,
      visualDensityOverride: other.visualDensity,
      expansionTileCollapsedShapeOverride: other.expansionTileCollapsedShape,
      expansionTileExpandedShapeOverride: other.expansionTileExpandedShape,
    );
  }
}
