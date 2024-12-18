import 'package:flutter/material.dart';
import 'package:flutter_meragi_design/flutter_meragi_design.dart';
import 'package:flutter_meragi_design/src/components/fields/form_builder_field.dart';

class MDFormListField extends MDFormBuilderField<List> {
  final Widget Function(int index, Function remove) formBuilder;
  final Widget Function(List<Widget> forms, Function add) wrapperBuilder;
  final int extra;

  /// Creates On/Off Cupertino switch field
  MDFormListField(
      {super.key,
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
      this.extra = 0})
      : super(
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

      var globalKey = GlobalKey<FormBuilderState>();

      forms[i] = FormBuilder(
        key: globalKey,
        initialValue: formInitialValue,
        child: widget.formBuilder(i, remove),
        onChanged: () {
          didChangeFor(i);
        },
      );

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

    forms[length] = FormBuilder(
      key: GlobalKey<FormBuilderState>(),
      child: widget.formBuilder(length, remove),
      onChanged: () {
        didChangeFor(length);
      },
    );

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

    print("forms $forms");
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
}
