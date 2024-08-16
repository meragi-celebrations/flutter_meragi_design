import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

enum OptionsOrientation { horizontal, vertical, wrap }

enum ControlAffinity { leading, trailing }

typedef ValueTransformer<T> = dynamic Function(T value);

/// A single form field.
///
/// This widget maintains the current state of the form field, so that updates
/// and validation errors are visually reflected in the UI.
class MDFormBuilderField<T> extends FormBuilderField<T> {
  Function(bool isValid, String? error)? onError;

  /// Creates a single form field.
  MDFormBuilderField({
    super.key,
    super.onSaved,
    super.initialValue,
    super.autovalidateMode = AutovalidateMode.onUserInteraction,
    super.enabled = true,
    super.validator,
    super.restorationId,
    required super.builder,
    required super.name,
    super.valueTransformer,
    super.onChanged,
    super.onReset,
    super.focusNode,
    this.onError,
  });

  @override
  MDFormBuilderFieldState<MDFormBuilderField<T>, T> createState() =>
      MDFormBuilderFieldState<MDFormBuilderField<T>, T>();
}

class MDFormBuilderFieldState<F extends MDFormBuilderField<T>, T>
    extends FormBuilderFieldState<F, T> {
  bool isFocused = false;

  @override
  void initState() {
    super.initState();

    effectiveFocusNode.addListener(() {
      setState(() {
        isFocused = effectiveFocusNode.hasFocus;
      });
    });
  }

  @override
  bool validate({
    bool clearCustomError = true,
    bool focusOnInvalid = true,
    bool autoScrollWhenFocusOnInvalid = false,
  }) {
    final isValid = super.validate(
      clearCustomError: clearCustomError,
      focusOnInvalid: focusOnInvalid,
      autoScrollWhenFocusOnInvalid: autoScrollWhenFocusOnInvalid,
    );

    widget.onError?.call(isValid, errorText);

    return isValid;
  }
}
