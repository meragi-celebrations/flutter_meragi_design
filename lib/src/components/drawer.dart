import 'package:flutter/material.dart';

/// Show a dialog with a drawer that slides in from a given [SlidePosition].
///
/// The dialog is shown with [showGeneralDialog] and the drawer is positioned
/// relative to the root navigator's context.
///
/// The [builder] is called with the context of the dialog and should return the
/// widget that will be displayed in the drawer.
///
/// The [useRootNavigator] parameter controls whether the dialog should be shown
/// in the root navigator or the current navigator.
///
/// The [position] parameter controls the position of the drawer.
///
/// The [height] and [width] parameters can be used to specify the size of the
/// drawer.
Future<T?> showMDDrawer<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  bool useRootNavigator = true,
  SlidePosition position = SlidePosition.right,
  double? height,
  double? width,
}) {
  final CapturedThemes themes = InheritedTheme.capture(
    from: context,
    to: Navigator.of(
      context,
      rootNavigator: useRootNavigator,
    ).context,
  );

  return showGeneralDialog<T>(
    context: context,
    barrierDismissible: true,
    barrierLabel: "SlidingDrawer",
    pageBuilder: (context, _, __) {
      Widget page = builder(context);
      page = themes.wrap(page);
      return SlidingDrawer(
        position: position,
        height: height,
        width: width,
        child: page,
      );
    },
    transitionBuilder: (context, anim1, anim2, child) {
      final Tween<Offset> tween;
      switch (position) {
        case SlidePosition.top:
          tween = Tween(begin: const Offset(0, -1), end: Offset.zero);
          break;
        case SlidePosition.bottom:
          tween = Tween(begin: const Offset(0, 1), end: Offset.zero);
          break;
        case SlidePosition.left:
          tween = Tween(begin: const Offset(-1, 0), end: Offset.zero);
          break;
        case SlidePosition.right:
          tween = Tween(begin: const Offset(1, 0), end: Offset.zero);
          break;
      }
      return SlideTransition(
        position: tween.animate(anim1),
        child: child,
      );
    },
  );
}

/// A widget that displays its [child] in a drawer that slides in from a given
/// [SlidePosition].
///
/// The [position] parameter controls the position of the drawer.
///
/// The [height] and [width] parameters can be used to specify the size of the
/// drawer.
class SlidingDrawer extends StatelessWidget {
  final SlidePosition position;
  final Widget child;
  final double? height;
  final double? width;

  const SlidingDrawer({
    Key? key,
    required this.child,
    this.position = SlidePosition.right,
    this.height,
    this.width,
  }) : super(key: key);

  /// Whether the drawer is vertical.
  bool get isVertical =>
      position == SlidePosition.left || position == SlidePosition.right;

  /// The alignment of the drawer.
  Alignment _getAlignment() {
    switch (position) {
      case SlidePosition.top:
        return Alignment.topCenter;
      case SlidePosition.bottom:
        return Alignment.bottomCenter;
      case SlidePosition.left:
        return Alignment.topLeft;
      case SlidePosition.right:
        return Alignment.topRight;
    }
  }

  @override
  Widget build(BuildContext context) {
    final alignment = _getAlignment();
    return Align(
      alignment: alignment,
      child: SizedBox(
        width: isVertical ? (width ?? 500) : MediaQuery.of(context).size.width,
        height:
            isVertical ? MediaQuery.of(context).size.height : (height ?? 350),
        child: child,
      ),
    );
  }
}

/// The position of the drawer.
enum SlidePosition { top, bottom, left, right }
