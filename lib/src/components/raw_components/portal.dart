import 'package:flutter/material.dart';

/// The position of the [MDPortal] in the global coordinate system.
sealed class MDAnchorBase {
  const MDAnchorBase();
}

/// Automatically infers the position of the [MDPortal] in the global
/// coordinate system adjusting according to the [verticalOffset] and
/// [preferBelow] properties.
@immutable
class MDAnchorAuto extends MDAnchorBase {
  const MDAnchorAuto({
    this.verticalOffset = 0,
    this.preferBelow = true,
    this.followTargetOnResize = true,
  });

  /// The vertical offset of the overlay from the start of target widget.
  final double verticalOffset;

  /// Whether the overlay is displayed below its widget by default, if there is
  /// enough space.
  final bool preferBelow;

  /// Whether the overlay is automatically adjusted to follow the target
  /// widget when the target widget moves dues to a window resize.
  final bool followTargetOnResize;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MDAnchorAuto &&
        other.verticalOffset == verticalOffset &&
        other.preferBelow == preferBelow &&
        other.followTargetOnResize == followTargetOnResize;
  }

  @override
  int get hashCode =>
      verticalOffset.hashCode ^
      preferBelow.hashCode ^
      followTargetOnResize.hashCode;
}

/// Manually specifies the position of the [MDPortal] in the global
/// coordinate system.
@immutable
class MDAnchor extends MDAnchorBase {
  const MDAnchor({
    this.childAlignment = Alignment.topLeft,
    this.overlayAlignment = Alignment.bottomLeft,
    this.offset = Offset.zero,
  });

  final Alignment childAlignment;
  final Alignment overlayAlignment;
  final Offset offset;

  static const center = MDAnchor(
    childAlignment: Alignment.topCenter,
    overlayAlignment: Alignment.bottomCenter,
  );

  MDAnchor copyWith({
    Alignment? childAlignment,
    Alignment? overlayAlignment,
    Offset? offset,
  }) {
    return MDAnchor(
      childAlignment: childAlignment ?? this.childAlignment,
      overlayAlignment: overlayAlignment ?? this.overlayAlignment,
      offset: offset ?? this.offset,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MDAnchor &&
        other.childAlignment == childAlignment &&
        other.overlayAlignment == overlayAlignment &&
        other.offset == offset;
  }

  @override
  int get hashCode {
    return childAlignment.hashCode ^
        overlayAlignment.hashCode ^
        offset.hashCode;
  }
}

@immutable
class MDGlobalAnchor extends MDAnchorBase {
  const MDGlobalAnchor(this.offset);

  /// The global offset where the overlay is positioned.
  final Offset offset;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MDGlobalAnchor && other.offset == offset;
  }

  @override
  int get hashCode => offset.hashCode;
}

class MDPortal extends StatefulWidget {
  const MDPortal({
    super.key,
    required this.child,
    required this.portalBuilder,
    required this.visible,
    required this.anchor,
  });

  final Widget child;
  final WidgetBuilder portalBuilder;
  final bool visible;
  final MDAnchorBase anchor;

  @override
  State<MDPortal> createState() => _MDPortalState();
}

class _MDPortalState extends State<MDPortal> {
  final layerLink = LayerLink();
  final overlayPortalController = OverlayPortalController();

  @override
  void initState() {
    super.initState();
    updateVisibility();
  }

  @override
  void didUpdateWidget(covariant MDPortal oldWidget) {
    super.didUpdateWidget(oldWidget);
    updateVisibility();
  }

  @override
  void dispose() {
    hide();
    super.dispose();
  }

  void updateVisibility() {
    final shouldShow = widget.visible;

    WidgetsBinding.instance.addPostFrameCallback((timer) {
      shouldShow ? show() : hide();
    });
  }

  void hide() {
    if (overlayPortalController.isShowing) {
      overlayPortalController.hide();
    }
  }

  void show() {
    if (!overlayPortalController.isShowing) {
      overlayPortalController.show();
    }
  }

  Widget buildAutoPosition(
    BuildContext context,
    MDAnchorAuto anchor,
  ) {
    if (anchor.followTargetOnResize) {
      MediaQuery.sizeOf(context);
    }
    final overlayState = Overlay.of(context, debugRequiredFor: widget);
    final box = this.context.findRenderObject()! as RenderBox;
    final target = box.localToGlobal(
      box.size.center(Offset.zero),
      ancestor: overlayState.context.findRenderObject(),
    );
    return CustomSingleChildLayout(
      delegate: MDPositionDelegate(
        target: target,
        verticalOffset: anchor.verticalOffset,
        preferBelow: anchor.preferBelow,
      ),
      child: widget.portalBuilder(context),
    );
  }

  Widget buildManualPosition(
    BuildContext context,
    MDAnchor anchor,
  ) {
    return CompositedTransformFollower(
      link: layerLink,
      offset: anchor.offset,
      followerAnchor: anchor.childAlignment,
      targetAnchor: anchor.overlayAlignment,
      child: widget.portalBuilder(context),
    );
  }

  Widget buildGlobalPosition(
    BuildContext context,
    MDGlobalAnchor anchor,
  ) {
    return CustomSingleChildLayout(
      delegate: MDPositionDelegate(
        target: anchor.offset,
        verticalOffset: 0,
        preferBelow: true,
      ),
      child: widget.portalBuilder(context),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: layerLink,
      child: OverlayPortal(
        controller: overlayPortalController,
        overlayChildBuilder: (context) {
          return Material(
            type: MaterialType.transparency,
            child: Center(
              widthFactor: 1,
              heightFactor: 1,
              child: switch (widget.anchor) {
                final MDAnchorAuto anchor => buildAutoPosition(context, anchor),
                final MDAnchor anchor => buildManualPosition(context, anchor),
                final MDGlobalAnchor anchor =>
                  buildGlobalPosition(context, anchor),
              },
            ),
          );
        },
        child: widget.child,
      ),
    );
  }
}

/// A delegate for computing the layout of an overlay to be displayed above or
/// below a target specified in the global coordinate system.
class MDPositionDelegate extends SingleChildLayoutDelegate {
  /// Creates a delegate for computing the layout of an overlay.
  MDPositionDelegate({
    required this.target,
    required this.verticalOffset,
    required this.preferBelow,
  });

  /// The offset of the target the overlay is positioned near in the global
  /// coordinate system.
  final Offset target;

  /// The amount of vertical distance between the target and the displayed
  /// overlay.
  final double verticalOffset;

  /// Whether the overlay is displayed below its widget by default.
  ///
  /// If there is insufficient space to display the tooltip in the preferred
  /// direction, the tooltip will be displayed in the opposite direction.
  final bool preferBelow;

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) =>
      constraints.loosen();

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    return positionDependentBox(
      size: size,
      childSize: childSize,
      target: target,
      verticalOffset: verticalOffset,
      preferBelow: preferBelow,
    );
  }

  @override
  bool shouldRelayout(MDPositionDelegate oldDelegate) {
    return target != oldDelegate.target ||
        verticalOffset != oldDelegate.verticalOffset ||
        preferBelow != oldDelegate.preferBelow;
  }
}
