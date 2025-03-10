import 'package:flutter/material.dart';
import 'package:flutter_meragi_design/flutter_meragi_design.dart';

enum DividerPosition { start, center, end }

/// A divider widget that can be used to separate content.
///
/// The [direction] property specifies the direction of the divider.
/// The [position] property specifies the position of the divider.
///
/// The [child] property is an optional child widget that can be placed
/// between the dividers.
///
/// The [thickness], [indent], and [endIndent] properties can be used to
/// customize the appearance of the divider.
///
/// The [color] property can be used to customize the color of the divider.
///
/// The [rotateChild] property is used to rotate the child widget for
/// vertical dividers.
class MDDivider extends StatelessWidget {
  /// The direction of the divider.
  final Axis direction;

  /// The position of the divider.
  final DividerPosition position;

  /// Optional child widget.
  final Widget? child;

  /// The thickness of the divider.
  final double? thickness;

  /// The indent of the divider.
  final double? indent;

  /// The end indent of the divider.
  final double? endIndent;

  /// The color of the divider.
  final Color? color;

  /// Whether to rotate the child widget for vertical dividers.
  final bool rotateChild;

  const MDDivider({
    super.key,
    this.direction = Axis.horizontal,
    this.position = DividerPosition.center,
    this.child,
    this.thickness = 1.0,
    this.indent = 0.0,
    this.endIndent = 0.0,
    this.color,
    this.rotateChild = false,
  });

  @override
  Widget build(BuildContext context) {

    Color effectiveColor = color ?? context.theme.colors.border.opaque;

    if (direction == Axis.horizontal) {
      return Row(
        children: [
          // Start divider
          if (position == DividerPosition.end ||
              position == DividerPosition.center)
            Expanded(
              child: Divider(
                thickness: thickness,
                indent: indent,
                endIndent: endIndent,
                color: effectiveColor,
              ),
            ),
          // Child widget
          if (child != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: child,
            ),
          // End divider
          if (position == DividerPosition.start ||
              position == DividerPosition.center)
            Expanded(
              child: Divider(
                thickness: thickness,
                indent: indent,
                endIndent: endIndent,
                color: effectiveColor,
              ),
            ),
        ],
      );
    } else {
      return Column(
        children: [
          // Start divider
          if (position == DividerPosition.end ||
              position == DividerPosition.center)
            Expanded(
              child: VerticalDivider(
                thickness: thickness,
                indent: indent,
                endIndent: endIndent,
                color: color,
              ),
            ),
          // Child widget
          if (child != null)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: RotatedBox(
                quarterTurns:
                    rotateChild ? 1 : 0, // Rotate child for vertical divider
                child: child,
              ),
            ),
          // End divider
          if (position == DividerPosition.start ||
              position == DividerPosition.center)
            Expanded(
              child: VerticalDivider(
                thickness: thickness,
                indent: indent,
                endIndent: endIndent,
                color: color,
              ),
            ),
        ],
      );
    }
  }
}
