import 'package:flutter/material.dart';
import 'package:flutter_meragi_design/flutter_meragi_design.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class MDRadio<T> extends StatefulWidget {
  const MDRadio({
    super.key,
    required this.value,
    this.enabled = true,
    this.focusNode,
    this.decoration,
    this.size,
    this.circleSize,
    this.duration,
    this.color,
    this.label,
    this.sublabel,
    this.padding,
  });

  /// The value of the radio.
  final T value;

  final bool enabled;

  /// The focus node of the radio.
  final FocusNode? focusNode;

  /// The decoration of the radio.
  final ShadDecoration? decoration;

  /// The size of the radio, defaults to 16.
  final double? size;

  /// The circle size of the radio, defaults to 10.
  final double? circleSize;

  /// The duration of the radio animation, defaults to 100ms.
  final Duration? duration;

  /// The color of the radio.
  final Color? color;

  /// An optional label for the radio, displayed on the right side if
  /// the [direction] is `TextDirection.ltr`.
  final Widget? label;

  /// An optional sublabel for the radio, displayed below the label.
  final Widget? sublabel;

  /// The padding between the radio and the label, defaults to
  /// `EdgeInsets.only(left: 8)`.
  final EdgeInsets? padding;

  @override
  State<MDRadio<T>> createState() => _MDRadioState<T>();
}

class _MDRadioState<T> extends State<MDRadio<T>> {
  @override
  Widget build(BuildContext context) {

    final inheritedRadioGroup = ShadRadioGroup.of<T>(context);

    final selected = inheritedRadioGroup.selected == widget.value;

    return ShadRadio<T>(
      value: widget.value,
      enabled: widget.enabled,
      focusNode: widget.focusNode,
      decoration: (widget.decoration ?? ShadDecoration()).copyWith(
        border: ShadBorder.all(
          color: selected ? context.theme.colors.primary : context.theme.colors.border.opaque,
        ),
      ),
      size: widget.size,
      circleSize: widget.circleSize,
      duration: widget.duration,
      color: widget.color,
      label: widget.label,
      sublabel: widget.sublabel,
      padding: widget.padding,
    );
  }
}

class MDRadioGroup<T> extends StatefulWidget {
  const MDRadioGroup({
    super.key,
    required this.items,
    this.initialValue,
    this.onChanged,
    this.enabled = true,
    this.axis,
    this.alignment,
    this.runAlignment,
    this.crossAxisAlignment,
    this.spacing,
    this.runSpacing,
  });

  /// The initial value of the radio group.
  final T? initialValue;

  /// The items of the radio group, any Widget can be used.
  final Iterable<Widget> items;

  /// Called when the user toggles a radio on.
  final ValueChanged<T?>? onChanged;

  /// Whether the radio [items] are enabled, defaults to true.
  final bool enabled;

  /// The axis of the radio group, defaults to [Axis.vertical].
  final Axis? axis;

  /// The main axis spacing of the radio group items, defaults to 4
  final double? spacing;

  /// The cross axis spacing of the radio group items, defaults to 0
  final double? runSpacing;

  /// The main axis alignment of the radio group items, defaults to
  /// [WrapAlignment.start]
  final WrapAlignment? alignment;

  /// The cross axis alignment of the radio group items, defaults to
  /// [WrapAlignment.start]
  final WrapAlignment? runAlignment;

  /// The cross axis alignment of the radio group items, defaults to
  /// [WrapCrossAlignment.start]
  final WrapCrossAlignment? crossAxisAlignment;

  @override
  State<MDRadioGroup<T>> createState() => _MDRadioGroupState<T>();

  static _MDRadioGroupState<T> of<T>(BuildContext context) {
    return maybeOf<T>(context)!;
  }

  static _MDRadioGroupState<T>? maybeOf<T>(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<
            ShadInheritedRadioGroupContainer<T>>()
        ?.data as _MDRadioGroupState<T>?;
  }
}

class _MDRadioGroupState<T> extends State<MDRadioGroup<T>> {
  @override
  Widget build(BuildContext context) {
    return ShadRadioGroup<T>(
      items: widget.items,
      initialValue: widget.initialValue,
      onChanged: widget.onChanged,
      enabled: widget.enabled,
      axis: widget.axis,
      alignment: widget.alignment,
      runAlignment: widget.runAlignment,
      crossAxisAlignment: widget.crossAxisAlignment,
      spacing: widget.spacing,
      runSpacing: widget.runSpacing,
    );
  }
}
