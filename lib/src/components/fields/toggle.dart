import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class MDToggle extends StatelessWidget {
  const MDToggle({
    super.key,
    required this.value,
    this.enabled = true,
    this.onChanged,
    this.focusNode,
    this.thumbColor,
    this.uncheckedTrackColor,
    this.checkedTrackColor,
    this.width,
    this.height,
    this.margin,
    this.duration,
    this.decoration,
    this.direction,
    this.label,
    this.sublabel,
    this.padding,
  });

  /// Whether the toggle is on or off.
  final bool value;

  /// Whether the toggle is enabled, defaults to true.
  final bool enabled;

  /// Called when the user toggles the switch on or off.
  final ValueChanged<bool>? onChanged;

  /// The focus node of the toggle.
  final FocusNode? focusNode;

  /// The color of the toggle thumb.
  final Color? thumbColor;

  /// The color of the unchecked track.
  final Color? uncheckedTrackColor;

  /// The color of the checked track.
  final Color? checkedTrackColor;

  /// The width of the toggle, defaults to 44.
  final double? width;

  /// The height of the toggle, defaults to 24.
  final double? height;

  /// The margin of the toggle, defaults to 2.
  final double? margin;

  /// The duration of the toggle animation, defaults to 100ms.
  final Duration? duration;

  /// The decoration of the toggle.
  final ShadDecoration? decoration;

  /// An optional label for the toggle, displayed on the right side if
  /// the [direction] is `TextDirection.ltr`.
  final Widget? label;

  /// An optional sublabel for the toggle, displayed below the label.
  final Widget? sublabel;

  /// The padding between the toggle and the label, defaults to
  /// `EdgeInsets.only(left: 8)`.
  final EdgeInsets? padding;

  /// The direction of the toggle.
  final TextDirection? direction;

  @override
  Widget build(BuildContext context) {
    return ShadSwitch(
      value: value,
      enabled: enabled,
      onChanged: onChanged,
      focusNode: focusNode,
      thumbColor: thumbColor,
      uncheckedTrackColor: uncheckedTrackColor,
      checkedTrackColor: checkedTrackColor,
      width: width,
      height: height,
      margin: margin,
      duration: duration,
      decoration: decoration,
      label: label,
      sublabel: sublabel,
      padding: padding,
    );
  }
}
