import 'package:flutter/material.dart';
import 'package:flutter_meragi_design/flutter_meragi_design.dart';
import 'package:flutter_meragi_design/src/components/fields/form_builder_field.dart';
import 'package:flutter_meragi_design/src/utils/property_notifier.dart';

class MDFormCheckboxList extends MDFormBuilderField<Set<String>> {
  final GetListBloc? listBloc;
  final List<MDCheckboxOption>? options;
  final MDCheckboxOption Function(dynamic item)? optionBuilder;

  MDFormCheckboxList({
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
    super.focusNode,
    super.restorationId,
    this.options,
  })  : listBloc = null,
        optionBuilder = null,
        super(
          builder: (FormFieldState<Set?> field) {
            final state = field as _MDFormCheckboxList;

            final fieldWidget = SingleChildScrollView(
              child: Column(
                children: [
                  ...options!.map(
                    (option) {
                      return ValueListenableBuilder(
                        valueListenable: state.setValues,
                        builder: (context, selectedSet, _) {
                          return ListTile(
                            title: Text(option.name),
                            dense: true,
                            trailing: MDCheckbox(
                              value: selectedSet.contains(option.value),
                              onChanged: (value) {
                                if (value ?? false) {
                                  state.setValues.value.add(option.value);
                                } else {
                                  state.setValues.value.remove(option.value);
                                }
                                state.setValues.notifyListeners();
                                field.didChange(state.setValues.value);
                              },
                            ),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            );
            return fieldWidget;
          },
        );

  MDFormCheckboxList.dynamic({
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
    super.focusNode,
    super.restorationId,
    this.listBloc,
    required this.optionBuilder,
  })  : options = null,
        super(
          builder: (FormFieldState<Set?> field) {
            final state = field as _MDFormCheckboxList;

            final fieldWidget = MDList(
              listBloc: listBloc!,
              itemBuilder: (context, index) {
                var item = listBloc.list.value[index];
                MDCheckboxOption option = optionBuilder!(item);
                return ValueListenableBuilder(
                  valueListenable: state.setValues,
                  builder: (context, selectedSet, _) {
                    return ListTile(
                      title: Text(option.name),
                      dense: true,
                      trailing: MDCheckbox(
                        value: selectedSet.contains(option.value),
                        onChanged: (value) {
                          if (value ?? false) {
                            state.setValues.value.add(option.value);
                          } else {
                            state.setValues.value.remove(option.value);
                          }
                          state.setValues.notifyListeners();
                          field.didChange(state.setValues.value);
                        },
                      ),
                    );
                  },
                );
              },
            );
            return fieldWidget;
          },
        );

  @override
  MDFormBuilderFieldState<MDFormCheckboxList, Set<String>> createState() => _MDFormCheckboxList();
}

class _MDFormCheckboxList extends MDFormBuilderFieldState<MDFormCheckboxList, Set<String>> {
  PropertyNotifier<Set<String>> setValues = PropertyNotifier({});

  @override
  void initState() {
    super.initState();
    if (widget.listBloc != null) {
      widget.listBloc?.get();
    }
    if (value != null) {
      setValues.value = value!;
    }
  }

  @override
  void reset() {
    super.reset();
    setValues.value = {};
  }

  @override
  void didChange(Set<String>? value) {
    super.didChange(value);
    if (value != null) {
      setValues.value = value;
    }
  }
}

class MDFormCheckbox extends MDFormBuilderField<bool> {
  final bool value;

  MDFormCheckbox({
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
    super.focusNode,
    super.restorationId,
    required this.value,
  }) : super(
          builder: (FormFieldState<bool?> field) {
            final state = field as MDFormCheckbox;
            final fieldWidget = MDCheckbox(
              value: value,
              onChanged: state.enabled
                  ? (value) {
                      field.didChange(value);
                    }
                  : null,
            );
            return fieldWidget;
          },
        );

  @override
  MDFormBuilderFieldState<MDFormCheckbox, bool> createState() => _MDFormCheckbox();
}

class _MDFormCheckbox extends MDFormBuilderFieldState<MDFormCheckbox, bool> {}

class MDCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool?>? onChanged;
  final Color? activeColor;
  final Color? checkColor;
  final bool tristate;
  final MaterialTapTargetSize? materialTapTargetSize;
  final MouseCursor? mouseCursor;
  final FocusNode? focusNode;
  final bool autofocus;

  const MDCheckbox({
    Key? key,
    required this.value,
    required this.onChanged,
    this.activeColor,
    this.checkColor,
    this.tristate = false,
    this.materialTapTargetSize,
    this.mouseCursor,
    this.focusNode,
    this.autofocus = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Checkbox(
      value: value,
      onChanged: onChanged,
      activeColor: activeColor,
      checkColor: checkColor,
      tristate: tristate,
      materialTapTargetSize: materialTapTargetSize,
      mouseCursor: mouseCursor,
      focusNode: focusNode,
      autofocus: autofocus,
    );
  }
}

class MDCheckboxOption {
  final String name;
  final String value;

  MDCheckboxOption(this.name, this.value);
}
