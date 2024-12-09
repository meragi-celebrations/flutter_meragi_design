import 'package:flutter/material.dart';
import 'package:flutter_meragi_design/flutter_meragi_design.dart';
import 'package:flutter_meragi_design/src/components/fields/form_builder_field.dart';
import 'package:flutter_meragi_design/src/theme/theme_tokens.dart';
import 'package:flutter_meragi_design/src/utils/property_notifier.dart';

class MDFormCheckboxList extends MDFormBuilderField<Set<String>> {
  final GetListBloc? listBloc;
  final List<MDCheckboxOption>? options;
  final bool isMultiSelect;
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
    required this.options,
    this.isMultiSelect = true,
  })  : listBloc = null,
        optionBuilder = null,
        super(
          builder: (FormFieldState<Set<String>?> field) {
            final state = field as _MDFormCheckboxList;

            final fieldWidget = SingleChildScrollView(
              child: Column(
                children: [
                  ...options!.map(
                    (option) {
                      return _checkboxOption(state, option, field, isMultiSelect, onChanged);
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
    this.isMultiSelect = true,
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
                return _checkboxOption(state, option, field, isMultiSelect, onChanged);
              },
            );
            return fieldWidget;
          },
        );

  static ValueListenableBuilder<Set<String>> _checkboxOption(_MDFormCheckboxList state, MDCheckboxOption option,
      _MDFormCheckboxList field, bool isMultiSelect, Function(Set<String>? value)? onChanged) {
    return ValueListenableBuilder(
      valueListenable: state.setValues,
      builder: (context, selectedSet, _) {
        return ListTile(
          title: Text(option.name),
          dense: true,
          trailing: MDCheckbox(
            value: selectedSet.contains(option.value),
            shape: !isMultiSelect ? RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)) : null,
            onChanged: (value) {
              if (!isMultiSelect) {
                state.setValues.value = {option.value};
                field.didChange(state.setValues.value);
              } else {
                if (value ?? false) {
                  state.setValues.value.add(option.value);
                } else {
                  state.setValues.value.remove(option.value);
                }
                state.setValues.notifyListeners();
                field.didChange(state.setValues.value);
              }
              // onChanged!(state.setValues.value);
            },
          ),
          onTap: () {
            // Handle tap interaction based on multi-select
            if (isMultiSelect) {
              if (selectedSet.contains(option.value)) {
                state.setValues.value.remove(option.value);
              } else {
                state.setValues.value.add(option.value);
              }
            } else {
              state.setValues.value = {option.value};
            }
            state.setValues.notifyListeners();
            field.didChange(state.setValues.value);
          },
        );
      },
    );
  }

  @override
  MDFormBuilderFieldState<MDFormCheckboxList, Set<String>> createState() => _MDFormCheckboxList();
}

class _MDFormCheckboxList extends MDFormBuilderFieldState<MDFormCheckboxList, Set<String>> {
  PropertyNotifier<Set<String>> setValues = PropertyNotifier({});

  @override
  void initState() {
    super.initState();
    if (widget.listBloc != null) {
      widget.listBloc?.reset();
    }
    // Ensure that the initial value is correctly set for each checkbox list independently
    if (value != null) {
      setValues.value = value!;
    } else {
      setValues.value = widget.initialValue ?? {};
    }
  }

  @override
  void reset() {
    super.reset();
    setValues.value = widget.initialValue ?? {};
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
  }) : super(
          builder: (FormFieldState<bool?> field) {
            final state = field as _MDFormCheckboxState;
            final fieldWidget = MDCheckbox(
              value: state.value,
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
  MDFormBuilderFieldState<MDFormCheckbox, bool> createState() => _MDFormCheckboxState();
}

class _MDFormCheckboxState extends MDFormBuilderFieldState<MDFormCheckbox, bool> {}

class MDCheckbox extends StatelessWidget {
  final bool? value;
  final ValueChanged<bool?>? onChanged;
  final Color? activeColor;
  final Color? checkColor;
  final bool tristate;
  final MaterialTapTargetSize? materialTapTargetSize;
  final OutlinedBorder? shape;
  final MouseCursor? mouseCursor;
  final FocusNode? focusNode;
  final bool autofocus;
  final BorderSide? side;

  const MDCheckbox({
    Key? key,
    required this.value,
    required this.onChanged,
    this.activeColor,
    this.checkColor,
    this.tristate = false,
    this.materialTapTargetSize,
    this.shape,
    this.mouseCursor,
    this.focusNode,
    this.autofocus = false,
    this.side,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeToken token = MeragiTheme.of(context).token;
    return Checkbox(
      value: value,
      onChanged: onChanged,
      activeColor: activeColor,
      checkColor: checkColor,
      tristate: tristate,
      materialTapTargetSize: materialTapTargetSize,
      shape: shape ??
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
      mouseCursor: mouseCursor,
      focusNode: focusNode,
      autofocus: autofocus,
      side: side ?? BorderSide(width: 1, color: token.primaryButtonColor),
    );
  }
}

class MDCheckboxOption {
  final String name;
  final String value;

  MDCheckboxOption(this.name, this.value);
}
