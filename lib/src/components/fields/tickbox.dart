import 'package:flutter/material.dart';
import 'package:flutter_meragi_design/flutter_meragi_design.dart';

class MDTickbox extends StatefulWidget {
  const MDTickbox({
    super.key,
    required this.value,
    this.enabled = true,
    this.onChanged,
    this.focusNode,
    this.decoration,
    this.size,
    this.duration,
    this.icon,
    this.color,
    this.label,
    this.sublabel,
    this.padding,
    this.direction,
    this.crossAxisAlignment,
    this.tristate = false,
  });

  /// Whether the checkbox is on, off, or in a mixed state (tristate).
  final bool? value;

  /// Whether the checkbox is enabled, defaults to true.
  final bool enabled;

  /// Whether the checkbox can be in a mixed state, defaults to false.
  final bool tristate;

  /// Called when the user toggles the checkbox on, off, or in a mixed state (tristate).
  final ValueChanged<bool?>? onChanged;

  /// The focus node of the checkbox.
  final FocusNode? focusNode;

  /// The decoration of the checkbox.
  final ShadDecoration? decoration;

  /// The size of the checkbox, defaults to 16.
  final double? size;

  /// The duration of the checkbox animation, defaults to 100ms.
  final Duration? duration;

  /// The icon of the checkbox.
  final Widget? icon;

  /// The color of the checkbox.
  final Color? color;

  /// An optional label for the checkbox, displayed on the right side if
  /// the [direction] is `TextDirection.ltr`.
  final Widget? label;

  /// An optional sublabel for the checkbox, displayed below the label.
  final Widget? sublabel;

  /// The padding between the checkbox and the label, defaults to
  /// `EdgeInsets.only(left: 8)`.
  final EdgeInsets? padding;

  /// The direction of the checkbox.
  final TextDirection? direction;

  /// The alignment of the checkbox and the label/sublabel.
  /// Defaults to [CrossAxisAlignment.start] when [label] and [sublabel] are
  /// both not null, and [CrossAxisAlignment.center] otherwise.
  final CrossAxisAlignment? crossAxisAlignment;

  @override
  State<MDTickbox> createState() => _MDTickboxState();
}

class _MDTickboxState extends State<MDTickbox> {
  @override
  Widget build(BuildContext context) {
    ShadThemeData shadTheme = ShadTheme.of(context);

    bool isInteractive = (widget.value == null || widget.value!);

    double effectiveSize = widget.size ?? shadTheme.checkboxTheme.size ?? 16;

    Widget? effectiveIcon() {
      if (widget.icon != null) {
        return widget.icon!;
      }

      if (widget.value == null) {
        return ShadImage.square(
          PhosphorIconsBold.minus,
          size: effectiveSize,
          color: shadTheme.colorScheme.primaryForeground,
        );
      }

      if (widget.value!) {
        return ShadImage.square(
          PhosphorIconsBold.check,
          size: effectiveSize,
          color: shadTheme.colorScheme.primaryForeground,
        );
      }

      return null;
    }

    return ShadCheckbox(
      value: widget.value ?? true,
      enabled: widget.enabled,
      onChanged: widget.onChanged,
      focusNode: widget.focusNode,
      decoration: (widget.decoration ?? const ShadDecoration()).copyWith(
        border: ShadBorder.all(
          color: isInteractive
              ? context.theme.colors.primary
              : context.theme.colors.border.opaque,
        ),
      ),
      size: widget.size,
      duration: widget.duration,
      icon: effectiveIcon(),
      color: widget.color,
      label: widget.label,
      sublabel: widget.sublabel,
      padding: widget.padding,
      direction: widget.direction,
      crossAxisAlignment: widget.crossAxisAlignment,
    );
  }
}
