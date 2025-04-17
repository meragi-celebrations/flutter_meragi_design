import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_meragi_design/flutter_meragi_design.dart';
import 'package:flutter_meragi_design/src/components/fields/form_builder_field.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class SelectDropdown<T, U> extends StatefulWidget {
  final num? initialValue;
  final ValueChanged? onSelected;
  final String? label;
  final String? errorText;
  final String? helperText;
  final double? width;
  final bool shouldMakeInitialCall;
  final bool requestFocusOnTap;
  final InputDecorationTheme? decoration;
  final GetListBloc<U> getListBloc;
  final GetOneBloc<U>? getOneBloc;
  final MDDropdownMenuEntry<T> Function(dynamic item) optionBuilder;
  final FocusNode? focusNode;
  final TextEditingController? controller;
  final bool canClear;
  final Function(TextEditingController controller, U data)? onInitialData;

  const SelectDropdown({
    super.key,
    required this.getListBloc,
    this.initialValue,
    this.getOneBloc,
    required this.onSelected,
    this.label,
    this.errorText,
    this.helperText,
    this.decoration,
    this.shouldMakeInitialCall = false,
    this.requestFocusOnTap = true,
    required this.optionBuilder,
    this.width,
    this.focusNode,
    this.controller,
    this.canClear = false,
    this.onInitialData,
  }) : assert(!(initialValue != null && getOneBloc == null), "GetOneBloc cant be null if initialValue is not null");

  @override
  State<SelectDropdown<T, U>> createState() => _SelectDropdownState();
}

class _SelectDropdownState<T, U> extends State<SelectDropdown<T, U>> {
  late TextEditingController controller;
  final Debounce _debounce = Debounce(const Duration(milliseconds: 400));
  String prevText = "";
  @override
  void initState() {
    super.initState();
    if (widget.shouldMakeInitialCall) {
      widget.getListBloc.reset();
    }

    if (widget.initialValue != null) {
      widget.getOneBloc!.onSuccess = (data) {
        widget.getListBloc.list.value.add(data);
        widget.getListBloc.list.notifyListeners();
        widget.onInitialData?.call(controller, data as U);
      };
      widget.getOneBloc!.id.value = widget.initialValue.toString();
      widget.getOneBloc!.get();
    }
    controller = widget.controller ?? TextEditingController();
    controller.addListener(() {
      _debounce(() {
        if (controller.text.isNotEmpty && prevText != controller.text) {
          widget.getListBloc.addFilters([MDFilter(field: "search", operator: "eq", value: controller.text)]);
          widget.getListBloc.reset();
        }
        prevText = controller.text;
      });
    });
    controller = widget.controller ?? TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return MDMultiListenableBuilder(
      listenables: [
        widget.getListBloc.list,
        widget.getListBloc.requestState,
      ],
      builder: (context, _) {
        List<MDDropdownMenuEntry> data = widget.getListBloc.list.value.map((e) => widget.optionBuilder(e)).toList();
        bool loadingList = widget.getListBloc.requestState.value == RequestState.loading;
        return LayoutBuilder(
          builder: (context, constraints) {
            return MDDropdownMenu(
              controller: controller,
              initialSelection: widget.initialValue,
              dropdownMenuEntries: data,
              onSelected: (value) {
                if (widget.onSelected != null) {
                  widget.onSelected!(value);
                }
              },
              width: widget.width ?? (kIsWeb ? 400 : constraints.maxWidth),
              label: Text(widget.label ?? ""),
              requestFocusOnTap: widget.requestFocusOnTap,
              focusNode: widget.focusNode,
              trailingIcon: loadingList
                  ? const MDLoadingIndicator()
                  : (widget.canClear && controller.text.isNotEmpty)
                      ? MDButton(
                          icon: PhosphorIconsBold.x,
                          decoration: ButtonDecoration(
                            context: context,
                            type: ButtonType.standard,
                            variant: ButtonVariant.ghost,
                            size: ButtonSize.sm,
                          ),
                          onTap: () {
                            controller.clear();
                            widget.onSelected!.call(null);
                          },
                        )
                      : null,
              selectedTrailingIcon: loadingList ? const MDLoadingIndicator() : null,
              inputDecorationTheme: widget.decoration,
              errorText: widget.errorText,
              helperText: widget.helperText,
              menuHeight: 300,
            );
          },
        );
      },
    );
  }

  @override
  void dispose() {
    controller.removeListener(() {});
    super.dispose();
  }
}

abstract class SelectBaseModel {
  late num? id;
  late String? name;

  SelectBaseModel fromJsonToBaseModel(dynamic json);
}

class MDSearchableDropdown<T, U> extends MDFormBuilderField<T> {
  final GetListBloc<U> getListBloc;
  final GetOneBloc<U>? getOneBloc;
  final MDDropdownMenuEntry<T> Function(dynamic item) optionBuilder;
  final ValueChanged? onSelected;
  final double? width;
  final bool shouldMakeInitialCall;
  final bool requestFocusOnTap;
  final bool canClear;
  final Function(TextEditingController controller, U data)? onInitialData;

  MDSearchableDropdown({
    super.key,
    required super.name,
    required this.getListBloc,
    this.getOneBloc,
    required this.optionBuilder,
    super.validator,
    super.initialValue,
    super.onChanged,
    super.valueTransformer,
    super.enabled,
    super.onSaved,
    super.autovalidateMode = AutovalidateMode.disabled,
    super.onReset,
    super.focusNode,
    super.restorationId,
    this.onSelected,
    this.width,
    this.shouldMakeInitialCall = false,
    this.requestFocusOnTap = true,
    this.canClear = false,
    this.onInitialData,
  }) : super(
          builder: (FormFieldState<T?> field) {
            final state = field as _MDSearchableDropdownState;
            print("state.initialValue: ${state.initialValue.runtimeType}");

            return SelectDropdown<T, U>(
              getListBloc: getListBloc,
              optionBuilder: optionBuilder,
              // label: state.decoration.labelText,
              controller: state.controller,
              focusNode: state.focusNode,
              onSelected: (value) {
                if (state.enabled) {
                  state.didChange(value);
                }
                if (onSelected != null) {
                  onSelected(value);
                }
              },
              initialValue: state.initialValue,
              getOneBloc: getOneBloc,
              width: width,
              shouldMakeInitialCall: shouldMakeInitialCall,
              requestFocusOnTap: requestFocusOnTap,
              canClear: canClear,
              onInitialData: onInitialData,
            );
          },
        );

  @override
  MDFormBuilderFieldState<MDSearchableDropdown<T, U>, T> createState() => _MDSearchableDropdownState();
}

class _MDSearchableDropdownState<T, U> extends MDFormBuilderFieldState<MDSearchableDropdown<T, U>, T> {
  late final FocusNode focusNode;

  final TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    focusNode = widget.focusNode ?? FocusNode();
    // if (widget.initialValue != null) {
    //   controller.text = widget.initialValue.toString();
    // }
  }

  @override
  void reset() {
    super.reset();
    controller.text = "";
  }
}
