import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

/// A modified [GestureDetector] which can be disabled and show a disabled
/// cursor.
///
/// If [isDisabled] is true, this widget will not respond to any gestures and
/// will show a disabled cursor.
///
/// If [showDisabledCursor] is true, this widget will show a disabled cursor,
/// even if [isDisabled] is false.
class MDGestureDetector extends GestureDetector {
  /// If true, this widget will not respond to any gestures and will show a
  /// disabled cursor.
  final bool isDisabled;

  void Function(PointerEnterEvent)? onEnter;
  void Function(PointerExitEvent)? onExit;
  void Function(PointerHoverEvent)? onHover;

  MDGestureDetector({
    Key? key,
    Widget? child,
    GestureTapCallback? onTap,
    GestureTapDownCallback? onTapDown,
    GestureTapUpCallback? onTapUp,
    GestureTapCallback? onTapCancel,
    GestureLongPressCallback? onLongPress,
    GestureLongPressUpCallback? onLongPressUp,
    GestureLongPressDownCallback? onLongPressDown,
    GestureDragStartCallback? onVerticalDragStart,
    GestureDragStartCallback? onHorizontalDragStart,
    GestureDragUpdateCallback? onVerticalDragUpdate,
    GestureDragUpdateCallback? onHorizontalDragUpdate,
    GestureDragEndCallback? onVerticalDragEnd,
    GestureDragEndCallback? onHorizontalDragEnd,
    GestureDragCancelCallback? onVerticalDragCancel,
    GestureDragCancelCallback? onHorizontalDragCancel,
    GestureScaleStartCallback? onScaleStart,
    GestureScaleUpdateCallback? onScaleUpdate,
    GestureScaleEndCallback? onScaleEnd,
    GestureForcePressStartCallback? onForcePressStart,
    GestureForcePressPeakCallback? onForcePressPeak,
    GestureForcePressUpdateCallback? onForcePressUpdate,
    GestureForcePressEndCallback? onForcePressEnd,
    GestureForcePressEndCallback? onForcePressEndWithVelocity,
    GestureDragDownCallback? onPanDown,
    GestureDragStartCallback? onPanStart,
    GestureDragUpdateCallback? onPanUpdate,
    GestureDragEndCallback? onPanEnd,
    GestureDragCancelCallback? onPanCancel,
    HitTestBehavior? behavior,
    bool excludeFromSemantics = false,
    this.onEnter,
    this.onExit,
    this.onHover,
    this.isDisabled = false,
  }) : super(
          key: key,
          child: child,
          onTap: onTap,
          onTapDown: onTapDown,
          onTapUp: onTapUp,
          onTapCancel: onTapCancel,
          onLongPress: onLongPress,
          onLongPressUp: onLongPressUp,
          onLongPressDown: onLongPressDown,
          onVerticalDragStart: onVerticalDragStart,
          onHorizontalDragStart: onHorizontalDragStart,
          onVerticalDragUpdate: onVerticalDragUpdate,
          onHorizontalDragUpdate: onHorizontalDragUpdate,
          onVerticalDragEnd: onVerticalDragEnd,
          onHorizontalDragEnd: onHorizontalDragEnd,
          onVerticalDragCancel: onVerticalDragCancel,
          onHorizontalDragCancel: onHorizontalDragCancel,
          onScaleStart: onScaleStart,
          onScaleUpdate: onScaleUpdate,
          onScaleEnd: onScaleEnd,
          onForcePressStart: onForcePressStart,
          onForcePressPeak: onForcePressPeak,
          onForcePressUpdate: onForcePressUpdate,
          onForcePressEnd: onForcePressEnd,
          onPanDown: onPanDown,
          onPanStart: onPanStart,
          onPanUpdate: onPanUpdate,
          onPanEnd: onPanEnd,
          onPanCancel: onPanCancel,
          behavior: behavior,
          excludeFromSemantics: excludeFromSemantics,
        );

  @override
  Widget build(BuildContext context) {
    Widget absorbing = AbsorbPointer(
      absorbing: isDisabled,
      child: super.build(context),
    );

    // If isDisabled is true, this widget will not respond to any gestures and
    // will show a disabled cursor.
    if (isDisabled) {
      return absorbing;
    }

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: onEnter,
      onExit: onExit,
      onHover: onHover,
      child: absorbing,
    );
  }
}
