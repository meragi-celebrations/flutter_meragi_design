import 'package:flutter/material.dart';
import 'package:flutter_meragi_design/flutter_meragi_design.dart';
import 'package:flutter_meragi_design/src/components/fields/form_builder_field.dart';

/// A form field that builds a list of form fields.
///
/// This class extends [MDFormBuilderField] with a type parameter of [List].
/// It is used to create a form field that can handle a list of values.
class MDFormListField extends MDFormBuilderField<List> {
  final Widget Function(int index, Function remove) formBuilder;
  final Widget Function(List<Widget> forms, Function add) wrapperBuilder;
  final int extra;
  final Function(int index, Map<String, dynamic>? newValue)?
      onIndividualFormChange;

  /// Creates On/Off Cupertino switch field
  MDFormListField({
    super.key,
    required name,
    super.validator,
    super.initialValue,
    super.onChanged,
    super.valueTransformer,
    super.enabled,
    super.onSaved,
    super.autovalidateMode,
    super.onReset,
    super.focusNode,
    super.restorationId,
    required this.formBuilder,
    required this.wrapperBuilder,
    this.extra = 0,
    this.onIndividualFormChange,
  }) : super(
          name: name,
          builder: (field) {
            final state = field as _MDFormListFieldState;
            return wrapperBuilder(state.forms.values.toList(), state.add);
          },
        );

  @override
  MDFormBuilderFieldState<MDFormListField, List> createState() =>
      _MDFormListFieldState();
}

class _MDFormListFieldState
    extends MDFormBuilderFieldState<MDFormListField, List> {
  final Map<int, Widget> forms = {};
  int counter = 0;

  @override

  /// Initializes the state of the form list field.
  ///
  /// This method creates all the children forms with the initial values
  /// and assigns them to the [forms] map. The keys of the map are the
  /// indices of the forms, and the values are the forms themselves.
  ///
  /// The [setValue] method is called at the end with the list of initial
  /// values of the forms.
  void initState() {
    super.initState();
    int length = (initialValue?.length ?? 0) + widget.extra;

    var tempValue = [];

    for (int i = 0; i < length; i++) {
      counter++;

      Map<String, dynamic> formInitialValue =
          i < (initialValue?.length ?? 0) ? (initialValue?[i] ?? {}) : {};

      forms[i] = _createFormBuilder(i, formInitialValue);

      tempValue.add(formInitialValue);
    }

    setValue(tempValue);
  }

  /// Add a new form to the list of forms, and rebuild the widget.
  ///
  /// The new form will be added with a key that is one greater than the previous
  /// highest key.
  void add() {
    int length = counter++;

    forms[length] = _createFormBuilder(length, {});

    setState(() {});

    didChangeFor(length);
  }

  /// Removes a form at the specified index from the list of forms.
  ///
  /// Updates the current value by removing the element at the given index
  /// and triggers the `didChange` method with the updated list.
  ///
  /// Also removes the form from the `forms` map corresponding to the index.
  ///
  void remove(int index) {
    List currentValue = List.from(value ?? <dynamic>[]);
    currentValue.removeAt(index);

    didChange(currentValue);

    forms.remove(index);

    setState(() {});
  }

  @override
  void save() {
    super.save();
    for (Widget form in forms.values) {
      GlobalKey<FormBuilderState> key = form.key as GlobalKey<FormBuilderState>;
      key.currentState?.save();
    }
  }

  @override
  void reset() {
    super.reset();
    for (Widget form in forms.values) {
      GlobalKey<FormBuilderState> key = form.key as GlobalKey<FormBuilderState>;
      key.currentState?.reset();
    }
  }

  @override
  void dispose() {
    for (Widget form in forms.values) {
      GlobalKey<FormBuilderState> key = form.key as GlobalKey<FormBuilderState>;
      key.currentState?.dispose();
    }
    super.dispose();
  }

  /// Updates the form value at the specified index and triggers a change notification.
  ///
  /// This method retrieves the current form value from the form at the given index,
  /// updates the list of form values, and calls `didChange` to notify listeners of the change.
  ///
  /// If the index is greater than or equal to the length of the current list of values,
  /// the new form value is added to the list. Otherwise, the form value at the specified
  /// index is replaced with the new form value.
  ///
  /// Args:
  ///   index (int): The index of the form to update.
  void didChangeFor(int index) {
    List currentValue = List.from(value ?? <dynamic>[]);

    Map<String, dynamic>? formValue =
        (forms[index]?.key as GlobalKey<FormBuilderState>)
            .currentState
            ?.instantValue;

    if (currentValue.length <= index) {
      currentValue.add(formValue);
    } else {
      currentValue[index] = formValue;
    }

    didChange(currentValue);
  }

  /// Creates a form builder widget for the given index and initial value.
  ///
  /// This method generates a form builder widget based on the provided index
  /// and initial value map. It is used to dynamically create form fields
  /// within a list.
  ///
  /// Parameters:
  /// - `index` (`int`): The index of the form field in the list.
  /// - `initialValue` (`Map<String, dynamic>`): A map containing the initial
  ///   values for the form fields.
  ///
  /// Returns:
  /// - `Widget`: A widget representing the form builder for the specified index
  ///   and initial value.
  Widget _createFormBuilder(int index, Map<String, dynamic> initialValue,
      {GlobalKey<FormBuilderState>? key}) {
    var globalKey = key ?? GlobalKey<FormBuilderState>();

    return FormBuilder(
      key: globalKey,
      initialValue: initialValue,
      child: widget.formBuilder(index, remove),
      onChanged: () {
        if (widget.onIndividualFormChange != null) {
          widget.onIndividualFormChange!(
              index, globalKey.currentState?.instantValue);
        }
        didChangeFor(index);
      },
    );
  }
}
