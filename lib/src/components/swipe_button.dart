import 'package:flutter/material.dart';
import 'package:flutter_meragi_design/flutter_meragi_design.dart';

/// A customizable swipe button widget that allows users to perform an action
/// by swiping a button horizontally. The button can be styled and configured
/// with various properties.
///
/// The [MDSwipeButton] widget provides a draggable button that triggers the
/// [onSwipe] callback when swiped to the end of the track. If the swipe fails
/// (i.e., the button is not dragged to the end), the [onFailedSwipe] callback
/// is triggered (if provided).
///
/// ### Features:
/// - Customizable colors for the track, background, and button.
/// - Adjustable dimensions such as height, button width, and corner radius.
/// - Optional icon and label for the button.
/// - Disabled and loading states.
///
/// ### Example Usage:
/// ```dart
/// MDSwipeButton(
///   label: 'Swipe to Confirm',
///   onSwipe: () {
///     print('Swiped successfully!');
///   },
///   onFailedSwipe: () {
///     print('Swipe failed.');
///   },
///   trackColor: Colors.green,
///   backgroundColor: Colors.grey[200],
///   buttonColor: Colors.blue,
///   height: 50.0,
///   buttonWidth: 60.0,
///   radius: 12.0,
///   isDisabled: false,
///   isLoading: false,
///   icon: Icons.arrow_forward,
/// )
/// ```
///
/// ### Parameters:
/// - [label]: The text displayed in the center of the swipe button.
/// - [onSwipe]: The callback triggered when the button is successfully swiped
///   to the end of the track.
/// - [onFailedSwipe]: An optional callback triggered when the swipe fails.
/// - [trackColor]: The color of the track that appears as the button is swiped.
/// - [backgroundColor]: The background color of the swipe button.
/// - [buttonColor]: The color of the draggable button.
/// - [height]: The height of the swipe button. Defaults to the theme's input height.
/// - [buttonWidth]: The width of the draggable button. Defaults to the theme's input height.
/// - [radius]: The corner radius of the button and track. Defaults to the theme's radius.
/// - [isDisabled]: Whether the swipe button is disabled. Defaults to `false`.
/// - [isLoading]: Whether the swipe button is in a loading state. Defaults to `false`.
/// - [icon]: An optional icon displayed inside the draggable button.
///
/// ### Notes:
/// - The widget uses an animation to reset the button position if the swipe fails.
/// - The [isDisabled] and [isLoading] states prevent user interaction with the button.
class MDSwipeButton extends StatefulWidget {
  final String label;
  final VoidCallback onSwipe;
  final VoidCallback? onFailedSwipe;
  final Color? trackColor;
  final Color? backgroundColor;
  final Color? buttonColor;
  final double? height;
  final double? buttonWidth;
  final double? radius;
  final bool isDisabled;
  final bool isLoading;
  final IconData? icon;

  const MDSwipeButton({
    Key? key,
    required this.label,
    required this.onSwipe,
    this.onFailedSwipe,
    this.trackColor,
    this.backgroundColor,
    this.buttonColor,
    this.height,
    this.buttonWidth,
    this.radius,
    this.isDisabled = false,
    this.isLoading = false,
    this.icon,
  }) : super(key: key);

  @override
  _MDSwipeButtonState createState() => _MDSwipeButtonState();
}

class _MDSwipeButtonState extends State<MDSwipeButton>
    with SingleTickerProviderStateMixin {
  double _dragPosition = 0.0;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller)
      ..addListener(() {
        setState(() {
          _dragPosition = _animation.value;
        });
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final colors = theme.colors;

    final resolvedHeight = widget.height ?? theme.dimensions.inputHeight;
    final resolvedButtonWidth =
        widget.buttonWidth ?? theme.dimensions.inputHeight;
    final resolvedBackgroundColor =
        widget.backgroundColor ?? colors.background.secondary;
    final resolvedTrackColor = widget.trackColor ?? colors.primary;
    final resolvedButtonColor = widget.buttonColor ?? colors.primary;
    final resolvedLabelColor = colors.content.primary;
    final resolvedIconColor = colors.content.onColor;
    final resolvedRadius = widget.radius ?? theme.dimensions.radius;

    return LayoutBuilder(
      builder: (context, constraints) {
        final maxDrag = constraints.maxWidth - resolvedButtonWidth;
        return IgnorePointer(
          ignoring: widget.isDisabled || widget.isLoading,
          child: Stack(
            children: [
              Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: resolvedHeight,
                    decoration: BoxDecoration(
                      color: resolvedBackgroundColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(resolvedRadius),
                        bottomLeft: Radius.circular(resolvedRadius),
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      widget.label,
                      style: theme.fonts.heading.small.copyWith(
                        color: resolvedLabelColor,
                      ),
                    ),
                  ),
                  Container(
                    width: _dragPosition + resolvedButtonWidth / 2,
                    height: resolvedHeight,
                    decoration: BoxDecoration(
                      color: resolvedTrackColor,
                      borderRadius: BorderRadius.circular(resolvedRadius),
                    ),
                  ),
                  Positioned(
                    left: _dragPosition,
                    child: MDGestureDetector(
                      isDisabled: widget.isDisabled || widget.isLoading,
                      onHorizontalDragUpdate:
                          widget.isDisabled || widget.isLoading
                              ? null
                              : (details) {
                                  if (_controller.isAnimating) {
                                    _controller.stop();
                                  }
                                  setState(() {
                                    _dragPosition =
                                        (_dragPosition + details.delta.dx)
                                            .clamp(0.0, maxDrag);
                                  });
                                },
                      onHorizontalDragEnd: widget.isDisabled || widget.isLoading
                          ? null
                          : (details) {
                              final currentPosition = _dragPosition;
                              if (_dragPosition >= maxDrag) {
                                widget.onSwipe();
                              } else {
                                widget.onFailedSwipe?.call();
                                _animation = Tween<double>(
                                  begin: currentPosition,
                                  end: 0.0,
                                ).animate(_controller)
                                  ..addListener(() {
                                    setState(() {
                                      _dragPosition = _animation.value;
                                    });
                                  });
                                _controller.forward(from: 0.0);
                              }
                            },
                      child: Container(
                        width: resolvedButtonWidth,
                        height: resolvedHeight,
                        decoration: BoxDecoration(
                          color: resolvedButtonColor,
                          borderRadius: BorderRadius.circular(resolvedRadius),
                        ),
                        child: widget.isLoading
                            ? Center(
                                child: SizedBox(
                                  width: resolvedHeight * 0.5,
                                  height: resolvedHeight * 0.5,
                                  child: MDLoadingIndicator(
                                    color: resolvedIconColor,
                                  ),
                                ),
                              )
                            : Icon(
                                widget.icon ?? PhosphorIconsRegular.caretRight,
                                color: resolvedIconColor,
                              ),
                      ),
                    ),
                  ),
                ],
              ),
              if (widget.isDisabled)
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(resolvedRadius),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
