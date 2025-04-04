import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_meragi_design/flutter_meragi_design.dart';

enum DividerPosition { start, center, end }

/// Enum to define the style of the divider.
enum MDDividerStyle { solid, swiggly, handDrawn } // Add handDrawn style

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
///
/// The [style] property is used to define the style of the divider.
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

  /// The style of the divider.
  final MDDividerStyle style;

  /// The amplitude of the swiggly divider.
  final double amplitude;

  /// The frequency of the swiggly divider.
  final double frequency;

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
    this.style = MDDividerStyle.solid,
    this.amplitude = 2.0,
    this.frequency = 30.0,
  });

  @override
  Widget build(BuildContext context) {
    Color effectiveColor = color ?? context.theme.colors.border.opaque;

    Widget _buildDivider() {
      if (style == MDDividerStyle.swiggly) {
        return Padding(
          padding: EdgeInsets.symmetric(
            horizontal: direction == Axis.horizontal ? indent ?? 0.0 : 0.0,
            vertical: direction == Axis.vertical ? indent ?? 0.0 : 0.0,
          ),
          child: direction == Axis.horizontal
              ? CustomPaint(
                  size: Size(double.infinity, thickness ?? 1.0),
                  painter: _SwigglyDividerPainter(
                    color: effectiveColor,
                    thickness: thickness ?? 1.0,
                    amplitude: amplitude,
                    frequency: frequency,
                  ),
                )
              : RotatedBox(
                  quarterTurns: 1,
                  child: CustomPaint(
                    size: Size(double.infinity, thickness ?? 1.0),
                    painter: _SwigglyDividerPainter(
                      color: effectiveColor,
                      thickness: thickness ?? 1.0,
                      amplitude: amplitude,
                      frequency: frequency,
                    ),
                  ),
                ),
        );
      } else if (style == MDDividerStyle.handDrawn) {
        return Padding(
          padding: EdgeInsets.symmetric(
            horizontal: direction == Axis.horizontal ? indent ?? 0.0 : 0.0,
            vertical: direction == Axis.vertical ? indent ?? 0.0 : 0.0,
          ),
          child: direction == Axis.horizontal
              ? CustomPaint(
                  size: Size(double.infinity, thickness ?? 1.0),
                  painter: _HandDrawnDividerPainter(
                    color: effectiveColor,
                    thickness: thickness ?? 1.0,
                    amplitude: amplitude,
                  ),
                )
              : RotatedBox(
                  quarterTurns: 1,
                  child: CustomPaint(
                    size: Size(double.infinity, thickness ?? 1.0),
                    painter: _HandDrawnDividerPainter(
                      color: effectiveColor,
                      thickness: thickness ?? 1.0,
                      amplitude: amplitude,
                    ),
                  ),
                ),
        );
      } else {
        return Padding(
          padding: EdgeInsets.symmetric(
            horizontal: indent ?? 0.0,
            vertical: endIndent ?? 0.0,
          ),
          child: direction == Axis.horizontal
              ? Divider(
                  thickness: thickness,
                  indent: indent,
                  endIndent: endIndent,
                  color: effectiveColor,
                )
              : VerticalDivider(
                  thickness: thickness,
                  indent: indent,
                  endIndent: endIndent,
                  color: effectiveColor,
                ),
        );
      }
    }

    Widget _buildChild() {
      if (child == null) return SizedBox.shrink();
      return Padding(
        padding: direction == Axis.horizontal
            ? const EdgeInsets.symmetric(horizontal: 8.0)
            : const EdgeInsets.symmetric(vertical: 8.0),
        child: direction == Axis.vertical && rotateChild
            ? RotatedBox(quarterTurns: 1, child: child)
            : child,
      );
    }

    Widget _buildWithChild() {
      return Flex(
        direction: direction,
        children: [
          if (position == DividerPosition.end ||
              position == DividerPosition.center)
            Expanded(child: _buildDivider()),
          _buildChild(),
          if (position == DividerPosition.start ||
              position == DividerPosition.center)
            Expanded(child: _buildDivider()),
        ],
      );
    }

    return child != null ? _buildWithChild() : _buildDivider();
  }
}

class _SwigglyDividerPainter extends CustomPainter {
  final Color color;
  final double thickness;
  final double amplitude;
  final double frequency;

  _SwigglyDividerPainter({
    required this.color,
    required this.thickness,
    required this.amplitude,
    required this.frequency,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = thickness
      ..style = PaintingStyle.stroke;

    final path = ui.Path();

    for (double x = 0; x < size.width; x++) {
      final y = amplitude * sin(2 * pi * x / frequency) + size.height / 2;
      if (x == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _HandDrawnDividerPainter extends CustomPainter {
  final Color color;
  final double thickness;
  final double amplitude;

  _HandDrawnDividerPainter({
    required this.color,
    required this.thickness,
    required this.amplitude,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = thickness
      ..style = PaintingStyle.stroke;

    final path = ui.Path();
    final random = Random();

    double y = size.height / 2;
    for (double x = 0; x < size.width; x += 1) {
      // Gradually reduce the amplitude as x increases with randomness
      final baseTaperFactor = 1 - (x / size.width).clamp(0, 1);
      final randomFactor =
          1 + (random.nextDouble() - 0.5) * 0.1; // Add slight randomness
      final taperFactor =
          baseTaperFactor * randomFactor; // Adjust taperFactor with randomness
      final adjustedAmplitude = amplitude * taperFactor;
      final yOffset =
          adjustedAmplitude * sin(2 * pi * x / 50); // Smooth sine wave

      if (x == 0) {
        path.moveTo(x, y + yOffset);
      } else {
        path.lineTo(x, y + yOffset);
      }
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
