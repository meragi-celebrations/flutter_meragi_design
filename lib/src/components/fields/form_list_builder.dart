import 'package:flutter/material.dart';
import 'package:flutter_meragi_design/flutter_meragi_design.dart';
import 'package:flutter_meragi_design/src/components/fields/form_builder_field.dart';

/// A dynamic list field that allows adding and deleting individual forms.
///
/// The `MDFormListField` class extends `MDFormBuilderField<List>` and provides
/// functionality to dynamically manage a list of forms. It supports adding and
/// removing forms, and initializes the forms using the provided `initialValue`
/// or the `extra` parameter.
///
/// The `formBuilder` function is used to build each form widget for a given
/// index, and the `wrapperBuilder` function wraps the list of form widgets and
/// provides a function to add a new form.
///
/// The `onIndividualFormChange` callback is triggered when an individual form
/// changes, providing the index of the form and the new value.
///
/// The `MDFormListField` class also overrides methods to save, reset, and
/// dispose the forms.
///
class MDFormListField extends MDFormBuilderField<List> {
  /// A function that builds a form widget for a given index and provides a
  /// function to remove the form.
  ///
  /// [index] - The index of the form to be built.
  /// [remove] - A function to remove the form.
  final Widget Function(int index, Function remove) formBuilder;

  /// A function that wraps a list of form widgets and provides a function to
  /// add a new form.
  ///
  /// [forms] - The list of form widgets to be wrapped.
  /// [add] - A function to add a new form.
  final Widget Function(List<Widget> forms, Function add) wrapperBuilder;

  /// The number of extra forms that will be rendered.
  final int extra;

  /// A callback function that is triggered when an individual form changes.
  ///
  /// [index] - The index of the form that changed.
  /// [newValue] - The new value of the form, which can be null.
  final Function(int index, Map<String, dynamic>? newValue)? onIndividualFormChange;

  /// A callback function that is triggered when a form is added.
  final Function(int index)? onAdded;

  /// A callback function that is triggered when a form is removed.
  final Function(int index)? onRemoved;

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
    this.onAdded,
    this.onRemoved,
  }) : super(
          name: name,
          builder: (field) {
            final state = field as MDFormListFieldState;
            return wrapperBuilder(state.forms.toList(), state.add);
          },
        );

  @override
  MDFormBuilderFieldState<MDFormListField, List> createState() => MDFormListFieldState();
}

class MDFormListFieldState extends MDFormBuilderFieldState<MDFormListField, List> {
  final List<Widget> forms = [];
  // int counter = 0;

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
      // counter++;

      Map<String, dynamic> formInitialValue = i < (initialValue?.length ?? 0) ? (initialValue?[i] ?? {}) : {};

      forms.add(_createFormBuilder(i, formInitialValue));

      tempValue.add(formInitialValue);
    }

    setValue(tempValue);
  }

  /// Add a new form to the list of forms, and rebuild the widget.
  ///
  /// The new form will be added with a key that is one greater than the previous
  /// highest key.
  void add() {
    int index = forms.length;

    // Add a new form to the list
    forms.add(_createFormBuilder(index, <String, dynamic>{}));

    // Update the current value by appending an empty map for the new form
    List<Map<String, dynamic>> currentValue = List<Map<String, dynamic>>.from(value ?? <Map<String, dynamic>>[]);
    currentValue.add(<String, dynamic>{});

    // Notify listeners of the change
    didChange(currentValue);

    // Rebuild the widget
    // setState(() {});

    // Trigger the onAdded callback if provided
    if (widget.onAdded != null) {
      widget.onAdded!(index);
    }
  }

  /// Removes a form at the specified index from the list of forms.
  ///
  /// Updates the current value by removing the element at the given index
  /// and triggers the `didChange` method with the updated list.
  ///
  /// Also removes the form from the `forms` map corresponding to the index.
  ///
  void remove(int index) {
    // Update the current value by removing the element at the given index
    List<Map<String, dynamic>> currentValue = List<Map<String, dynamic>>.from(value ?? <Map<String, dynamic>>[]);
    currentValue.removeAt(index);

    // Rebuild the forms list to match the updated currentValue
    forms.removeAt(index);
    // Notify listeners of the change
    didChange(currentValue);

    // Rebuild the widget
    // setState(() {});

    // Trigger the onRemoved callback if provided
    if (widget.onRemoved != null) {
      widget.onRemoved!(index);
    }
  }

  @override
  void save() {
    super.save();
    for (Widget form in forms) {
      GlobalKey<FormBuilderState> key = form.key as GlobalKey<FormBuilderState>;
      key.currentState?.save();
    }
  }

  @override
  void reset() {
    super.reset();
    for (Widget form in forms) {
      GlobalKey<FormBuilderState> key = form.key as GlobalKey<FormBuilderState>;
      key.currentState?.reset();
    }
  }

  @override
  void dispose() {
    for (Widget form in forms) {
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
    print("didChangeFor:index $index");
    print("didChangeFor:currentValue $currentValue");

    Map<String, dynamic>? formValue = (forms[index].key as GlobalKey<FormBuilderState>).currentState?.instantValue;

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
  Widget _createFormBuilder(int index, Map<String, dynamic> initialValue, {GlobalKey<FormBuilderState>? key}) {
    var globalKey = key ?? GlobalKey<FormBuilderState>();

    return FormBuilder(
      key: globalKey,
      initialValue: initialValue,
      child: widget.formBuilder(index, remove),
      onChanged: () {
        if (widget.onIndividualFormChange != null) {
          widget.onIndividualFormChange!(index, globalKey.currentState?.instantValue);
        }
        didChangeFor(index);
      },
    );
  }

  @override
  bool validate({
    bool clearCustomError = true,
    bool focusOnInvalid = true,
    bool autoScrollWhenFocusOnInvalid = false,
  }) {
    super.validate();
    bool isValid = true;

    for (Widget form in forms) {
      GlobalKey<FormBuilderState> key = form.key as GlobalKey<FormBuilderState>;
      if (!(key.currentState?.validate() ?? true)) {
        isValid = false;
      }
    }

    return isValid;
  }

  void patchValue(int index, Map<String, dynamic> newValue) {
    // Update the value in the currentValue list
    List<Map<String, dynamic>> currentValue = List<Map<String, dynamic>>.from(value ?? <Map<String, dynamic>>[]);
    if (currentValue.length > index) {
      currentValue[index] = newValue;
    } else {
      currentValue.add(newValue);
    }

    // Notify listeners of the change
    didChange(currentValue);

    // Rebuild the specific form
    setState(() {
      forms[index] = _createFormBuilder(index, newValue);
    });
  }
}
