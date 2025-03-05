import 'package:flutter/material.dart';
import 'package:flutter_meragi_design/flutter_meragi_design.dart';
import 'package:flutter_meragi_design/src/components/fields/form_builder_field.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

/// A form field that wraps the [MDToggle] widget.
class MDToggleFormField extends MDFormBuilderField<bool> {
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

  /// Defines whether the field input expands to fill the entire width
  /// of the row field.
  ///
  /// By default `false`
  final bool shouldExpandedField;

  /// A widget that is displayed at the start of the row.
  ///
  /// The [prefix] parameter is displayed at the start of the row. Standard iOS
  /// guidelines encourage passing a [Text] widget to [prefix] to detail the
  /// nature of the row's [child] widget. If null, the [child] widget will take
  /// up all horizontal space in the row.
  final Widget? prefix;

  /// Content padding for the row.
  ///
  /// Defaults to the standard iOS padding for form rows. If no edge insets are
  /// intended, explicitly pass [EdgeInsets.zero] to [contentPadding].
  final EdgeInsetsGeometry? contentPadding;

  /// A widget that is displayed underneath the [prefix] and [child] widgets.
  ///
  /// The [helper] appears in primary label coloring, and is meant to inform the
  /// user about interaction with the child widget. The row becomes taller in
  /// order to display the [helper] widget underneath [prefix] and [child]. If
  /// null, the row is shorter.
  final Widget? helper;

  /// A builder widget that is displayed underneath the [prefix] and [child] widgets.
  ///
  /// The [error] widget is primarily used to inform users of input errors. When
  /// a [Text] is given to [error], it will be shown in
  /// [CupertinoColors.destructiveRed] coloring and medium-weighted font. The
  /// row becomes taller in order to display the [helper] widget underneath
  /// [prefix] and [child]. If null, the row is shorter.
  final Widget? Function(String error)? errorBuilder;

  /// Creates a form field that wraps the [MDToggle] widget.
  MDToggleFormField({
    super.key,
    required super.name,
    super.validator,
    super.initialValue,
    super.onChanged,
    super.valueTransformer,
    super.enabled,
    super.onSaved,
    super.autovalidateMode,
    super.onReset,
    super.restorationId,
    super.focusNode,
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
    this.shouldExpandedField = false,
    this.errorBuilder,
    this.helper,
    this.contentPadding,
    this.prefix,
  }) : super(
          builder: (FormFieldState<bool?> field) {
            final state = field as _MDToggleFormFieldState;

            final fieldWidget = MDToggle(
              value: state.value ?? false,
              enabled: state.enabled,
              onChanged: state.enabled
                  ? (value) {
                      field.didChange(value);
                    }
                  : null,
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

            return fieldWidget;
          },
        );

  @override
  MDFormBuilderFieldState<MDToggleFormField, bool> createState() => _MDToggleFormFieldState();
}

class _MDToggleFormFieldState extends MDFormBuilderFieldState<MDToggleFormField, bool> {
  @override
  Widget build(BuildContext context) {
    return super.build(context);
  }
}
