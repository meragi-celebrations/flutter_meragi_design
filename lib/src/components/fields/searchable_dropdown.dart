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
  final MDDropdownMenuEntry<T> Function(dynamic item) optionBuilder;
  final FocusNode? focusNode;
  final TextEditingController? controller;
  final bool canClear;

  const SelectDropdown({
    super.key,
    required this.getListBloc,
    this.initialValue,
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
  });

  @override
  State<SelectDropdown> createState() => _SelectDropdownState();
}

class _SelectDropdownState extends State<SelectDropdown> {
  // late final SelectDropdownBloc bloc;

  late TextEditingController controller;

  @override
  void initState() {
    // bloc = SelectDropdownBloc(widget.url, context.read<CRUDRepository>(), widget.model, selected: widget.initialValue);
    super.initState();
    widget.getListBloc.get();
    controller = widget.controller ?? TextEditingController();
    controller.addListener(() {
      if (controller.text.isNotEmpty) {
        widget.getListBloc.addFilters([
          MDFilter(field: "search", operator: "eq", value: controller.text)
        ]);
        widget.getListBloc.reset();
      }
    });
    // bloc.customFilters.addAll(widget.urlParams);
    // if (widget.shouldMakeInitialCall) {
    //   bloc.getList();
    // }
    controller = widget.controller ?? TextEditingController();
    if (widget.initialValue != null) {
      controller.text = widget.initialValue.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MDMultiListenableBuilder(
      listenables: [
        widget.getListBloc.list,
        widget.getListBloc.requestState,
      ],
      builder: (context, _) {
        List<MDDropdownMenuEntry> data = widget.getListBloc.list.value
            .map((e) => widget.optionBuilder(e))
            .toList();
        bool loadingList =
            widget.getListBloc.requestState.value == RequestState.loading;
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
                  ? const MDLoadingIndicator(color: Colors.deepPurple)
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
              selectedTrailingIcon: loadingList
                  ? const MDLoadingIndicator(color: Colors.deepPurple)
                  : null,
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

// class SelectDropdownBloc<T extends SelectBaseModel> {
//   final String url;
//   final num? selected;
//   final T model;
//   final CRUDRepository _repo;
//   PropertyNotifier<List<T>> data = PropertyNotifier([]);
//   TextEditingController controller = TextEditingController();
//
//   SelectDropdownBloc(this.url, this._repo, this.model, {this.selected}) {
//     if (selected != null) {
//       getSelectedDetail(selected!);
//     }
//   }
//
//   ValueNotifier<bool> loadingList = ValueNotifier(false);
//   ValueNotifier<bool> loadingValue = ValueNotifier(false);
//   List<Map<String, String>> customFilters = [];
//
//   getList({String? query}) async {
//     try {
//       if (loadingList.value) {
//         return;
//       }
//       loadingList.value = true;
//       List<Map<String, String>> filters = [];
//       if (query != null) {
//         filters.add({
//           "field": "search",
//           "operator": "eq",
//           "value": query,
//         });
//       }
//       filters.addAll(customFilters);
//       var res = await _repo.getList(url, filters: filters);
//       data.value = List.from(((res ?? []) as List).map((e) => model.fromJsonToBaseModel(e)));
//     } catch (e, s) {
//       debugPrint("$e");
//       debugPrintStack(stackTrace: s);
//     } finally {
//       loadingList.value = false;
//     }
//   }
//
//   ValueNotifier<T?> selectedData = ValueNotifier(null);
//
//   getSelectedDetail(num id) async {
//     try {
//       if (loadingValue.value) {
//         return;
//       }
//       loadingValue.value = true;
//       var res = await _repo.retrieveData("$url$id/");
//       selectedData.value = model.fromJsonToBaseModel(res) as T?;
//       if (selectedData.value != null) {
//         if (data.value.where((e) => selectedData.value?.id == e.id).toList().isEmpty) {
//           data.value.add(selectedData.value!);
//           data.notifyListeners();
//         }
//         controller.text = selectedData.value?.name ?? "";
//       }
//     } catch (e, s) {
//       debugPrint("$e");
//       debugPrintStack(stackTrace: s);
//     } finally {
//       loadingValue.value = false;
//     }
//   }
//
//   Timer? _debounceTimer;
//   String checkingQuery = '';
//
//   search(String query) async {
//     try {
//       if (_debounceTimer != null && _debounceTimer!.isActive) {
//         _debounceTimer!.cancel();
//       }
//       _debounceTimer = Timer(const Duration(milliseconds: 350), () async {
//         checkingQuery = query;
//         getList(query: query);
//       });
//     } catch (e, s) {
//       debugPrint("$e");
//       debugPrintStack(stackTrace: s);
//     }
//   }
// }

abstract class SelectBaseModel {
  late num? id;
  late String? name;

  SelectBaseModel fromJsonToBaseModel(dynamic json);
}

class MDSearchableDropdown<T, U> extends MDFormBuilderField<T> {
  final GetListBloc<U> getListBloc;
  final MDDropdownMenuEntry<T> Function(dynamic item) optionBuilder;
  final ValueChanged? onSelected;
  final double? width;
  final bool shouldMakeInitialCall;
  final bool requestFocusOnTap;
  final bool canClear;

  MDSearchableDropdown({
    super.key,
    required super.name,
    required this.getListBloc,
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
  }) : super(
          builder: (FormFieldState<T?> field) {
            final state = field as _MDSearchableDropdownState;

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
              width: width,
              shouldMakeInitialCall: shouldMakeInitialCall,
              requestFocusOnTap: requestFocusOnTap,
              canClear: canClear,
            );
          },
        );

  @override
  MDFormBuilderFieldState<MDSearchableDropdown<T, U>, T> createState() =>
      _MDSearchableDropdownState();
}

class _MDSearchableDropdownState<T, U>
    extends MDFormBuilderFieldState<MDSearchableDropdown<T, U>, T> {
  late final FocusNode focusNode;

  final TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    focusNode = widget.focusNode ?? FocusNode();
    if (widget.initialValue != null) {
      controller.text = widget.initialValue.toString();
    }
  }

  @override
  void reset() {
    super.reset();
    controller.text = "";
  }
}