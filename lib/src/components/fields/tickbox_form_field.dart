import 'package:flutter/material.dart';
import 'package:flutter_meragi_design/flutter_meragi_design.dart';
import 'package:flutter_meragi_design/src/components/fields/form_builder_field.dart';
import 'package:shadcn_ui/shadcn_ui.dart' hide TextDirection;

/// A form field that wraps the [MDTickbox] widget.
class MDTickboxFormField extends MDFormBuilderField<bool> {
  /// Whether the checkbox is enabled, defaults to true.
  final bool enabled;

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
  final CrossAxisAlignment? crossAxisAlignment;

  /// Defines whether the field input expands to fill the entire width
  /// of the row field.
  ///
  /// By default `false`
  final bool shouldExpandedField;

  /// A widget that is displayed at the start of the row.
  final Widget? prefix;

  /// Content padding for the row.
  final EdgeInsetsGeometry? contentPadding;

  /// A widget that is displayed underneath the [prefix] and [child] widgets.
  final Widget? helper;

  /// A builder widget that is displayed underneath the [prefix] and [child] widgets.
  final Widget? Function(String error)? errorBuilder;

  final FocusNode? focusNode;

  /// Creates a form field that wraps the [MDTickbox] widget.
  MDTickboxFormField({
    super.key,
    required super.name,
    super.validator,
    super.initialValue,
    super.onChanged,
    super.valueTransformer,
    super.onSaved,
    super.autovalidateMode,
    super.onReset,
    super.restorationId,
    this.focusNode,
    this.enabled = true,
    this.decoration,
    this.size,
    this.duration,
    this.icon,
    this.color,
    this.direction,
    this.label,
    this.sublabel,
    this.padding,
    this.crossAxisAlignment,
    this.shouldExpandedField = false,
    this.errorBuilder,
    this.helper,
    this.contentPadding,
    this.prefix,
  }) : super(
          enabled: enabled,
          builder: (FormFieldState<bool?> field) {
            final state = field as _MDTickboxFormFieldState;

            final fieldWidget = MDTickbox(
              value: state.value ?? false,
              enabled: state.enabled,
              onChanged: state.enabled
                  ? (value) {
                      field.didChange(value);
                    }
                  : null,
              focusNode: state.focusNode,
              decoration: decoration,
              size: size,
              duration: duration,
              icon: icon,
              color: color,
              label: label,
              sublabel: sublabel,
              padding: padding,
              direction: direction,
              crossAxisAlignment: crossAxisAlignment,
            );

            return fieldWidget;
          },
        );

  @override
  MDFormBuilderFieldState<MDTickboxFormField, bool> createState() =>
      _MDTickboxFormFieldState();
}

class _MDTickboxFormFieldState
    extends MDFormBuilderFieldState<MDTickboxFormField, bool> {
  late final FocusNode focusNode;

  @override
  void initState() {
    super.initState();
    focusNode = widget.focusNode ?? FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    return super.build(context);
  }
}
