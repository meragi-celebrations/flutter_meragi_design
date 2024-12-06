import 'package:flutter/material.dart';
import 'package:flutter_meragi_design/flutter_meragi_design.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class MDFilter {
  late String field, operator, value;
  MDFilter({
    required this.field,
    required this.operator,
    required this.value,
  });

  MDFilter.fromJson(dynamic data) {
    field = data['field'];
    operator = data['operator'];
    value = data['value'];
  }

  Map<String, String> toJson() {
    return {
      'field': field,
      'operator': operator,
      'value': value,
    };
  }
}

class MDFilterFormView extends StatefulWidget {
  final List<MDFormItem> formItems;
  final Function(List<MDFilter>) onFilterSubmit;
  final MDFilter Function(String key, dynamic value) filterBuilder;
  final List<MDFilter> initialData;
  final GlobalKey<FormBuilderState> formKey;
  const MDFilterFormView({
    super.key,
    required this.formKey,
    required this.formItems,
    required this.onFilterSubmit,
    required this.filterBuilder,
    this.initialData = const [],
  });

  @override
  State<MDFilterFormView> createState() => _MDFilterFormViewState();
}

class _MDFilterFormViewState extends State<MDFilterFormView> {
  ValueNotifier<int> selectedFilter = ValueNotifier(0);
  late List<MDFormItem> formItems;

  @override
  void initState() {
    super.initState();
    formItems = widget.formItems;
    // formKey = widget.formKey;
  }

  Map<String, dynamic> addInitialData() {
    if (widget.initialData.isEmpty) {
      return {};
    }
    Map<String, dynamic> initialData = {};
    for (MDFilter data in widget.initialData) {
      initialData[data.field] = data.value.split(",").toSet();
    }
    return initialData;
  }

  /// Standardizes filter values into a consistent format
  MDFilter buildFilter(String key, dynamic value) {
    try {
      Set<dynamic> valueSet;
      if (value is String) {
        valueSet = value.split(',').toSet();
      } else if (value is Set) {
        valueSet = value;
      } else if (value is List) {
        valueSet = value.toSet();
      } else {
        debugPrint('Unexpected value type: ${value.runtimeType} for key: $key');
        valueSet = {value};
      }

      return widget.filterBuilder(
        key,
        valueSet.join(","),
      );
    } catch (e, stackTrace) {
      debugPrint('Error building filter - Key: $key, Value: $value');
      debugPrint('Error: $e\n$stackTrace');
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MDScaffold(
      appBar: MDAppBar(
        asPageHeader: true,
        title: const Text("Filters"),
        leading: MDButton(
          decoration: ButtonDecoration(context: context, variant: ButtonVariant.ghost, type: ButtonType.danger),
          icon: PhosphorIconsBold.x,
          onTap: () => Navigator.pop(context),
        ),
        actions: [
          MDButton(
            decoration: ButtonDecoration(
              context: context,
              type: ButtonType.primary,
              variant: ButtonVariant.ghost,
            ),
            onTap: () {
              try {
                widget.formKey.currentState?.reset();
              } catch (e) {
                debugPrint('Error resetting form: $e');
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Error clearing filters')),
                );
              }
            },
            child: const Text("Clear"),
          ),
          const SizedBox(width: 10),
          MDButton(
            decoration: ButtonDecoration(context: context, type: ButtonType.primary),
            onTap: () {
              try {
                if (!widget.formKey.currentState!.saveAndValidate()) {
                  debugPrint('Form validation failed');
                  return;
                }

                List<MDFilter> filters = [];
                Map<String, dynamic> formValue = widget.formKey.currentState!.value;

                for (MapEntry<String, dynamic> data in formValue.entries) {
                  if (data.value != null) {
                    debugPrint(
                        'Processing filter - Key: ${data.key}, Value: ${data.value}, Type: ${data.value.runtimeType}');
                    filters.add(buildFilter(data.key, data.value));
                  }
                }
                widget.onFilterSubmit(filters);
                Navigator.pop(context);
              } catch (e, stackTrace) {
                debugPrint('Error applying filters: $e\n$stackTrace');
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error applying filters: $e')),
                );
              }
            },
            child: const Text("Apply"),
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: FormBuilder(
        key: widget.formKey,
        initialValue: addInitialData(),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: Container(
                decoration: const BoxDecoration(
                  color: Color(0xffF0EAF9),
                ),
                child: ListView.builder(
                  itemCount: formItems.length,
                  itemBuilder: (context, index) {
                    MDFormItem formItem = formItems[index];
                    return MDMultiListenableBuilder(
                      listenables: [selectedFilter],
                      builder: (context, _) {
                        int? id = selectedFilter.value;
                        return Material(
                          type: MaterialType.transparency,
                          child: ListTile(
                            // selected: id==filter.id,
                            tileColor: id == index ? Colors.white : null,
                            title: formItem.label,
                            dense: true,
                            onTap: () {
                              selectedFilter.value = index;
                            },
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
            Expanded(
              flex: 5,
              child: MDMultiListenableBuilder(
                listenables: [selectedFilter],
                builder: (context, _) {
                  int id = selectedFilter.value;
                  if (formItems.isEmpty) {
                    return const SizedBox();
                  }
                  MDFormItem formItem = formItems[id];
                  return formItem.child;
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
