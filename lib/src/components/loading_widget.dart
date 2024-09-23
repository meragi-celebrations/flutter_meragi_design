import 'package:flutter/material.dart';

/// A widget that displays a loading indicator.
///
/// The loading indicator is a [CircularProgressIndicator] widget displayed on
/// top of a [Container] widget with a black color and opacity of 0.4. The
/// [Container] widget is used to dim the background of the loading indicator.
///
/// The [child] property is an optional widget that can be placed behind the
/// loading indicator.
///
/// The [isLoading] property is used to control whether the loading indicator is
/// displayed or not. If [isLoading] is false, the loading indicator is not
/// displayed, and the [child] widget is displayed instead.
class MDLoadingIndicator extends StatelessWidget {
  /// The radius of the loading indicator
  final double radius;

  /// The stroke width of the loading indicator
  final double strokeWidth;

  /// The color of the loading indicator
  final Color color;

  /// The child widget that is displayed behind the loading indicator
  final Widget? child;

  /// Whether the loading indicator is displayed or not
  final bool isLoading;

  /// Creates a new [MDLoadingIndicator] widget with the given properties
  const MDLoadingIndicator({
    Key? key,
    this.radius = 20,
    this.color = Colors.white,
    this.strokeWidth = 2,
    this.child,
    this.isLoading = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    /// The loading indicator widget
    Widget loader = SizedBox(
      height: radius,
      width: radius,
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(color),
        strokeWidth: strokeWidth,
      ),
    );

    /// The dim background widget
    Widget dimBackground = Positioned.fill(
      child: Container(
        color: Colors.black.withOpacity(.4),
      ),
    );

    /// The child widget that is displayed behind the loading indicator
    Widget childWidget = child ?? const SizedBox();

    return Stack(
      alignment: Alignment.center,
      children: [
        childWidget,
        if (child != null && isLoading) dimBackground,
        if (isLoading) loader,
      ],
    );
  }
}
