import 'package:flutter/material.dart';
import 'package:flutter_meragi_design/flutter_meragi_design.dart';

class MDSwipeButton extends StatefulWidget {
  final String label;
  final VoidCallback onSwipe;
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
