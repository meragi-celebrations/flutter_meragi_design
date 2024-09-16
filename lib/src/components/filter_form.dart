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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Filters"),
        leading: IconButton(
          icon: const Icon(PhosphorIconsBold.x),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Button(
            decoration: ButtonDecoration(context: context, type: ButtonType.primary, variant: ButtonVariant.ghost),
            onTap: () {
              widget.formKey.currentState?.reset();
            },
            child: const Text("Clear"),
          ),
          const SizedBox(width: 10),
          Button(
            decoration: ButtonDecoration(context: context, type: ButtonType.primary),
            onTap: () {
              List<MDFilter> filters = [];
              if (!widget.formKey.currentState!.saveAndValidate()) {
                return;
              }
              Map<String, dynamic> formValue = widget.formKey.currentState!.value;
              for (MapEntry<String, dynamic> data in formValue.entries) {
                if (data.value != null) {
                  // MDFilter(
                  //   field: data.key,
                  //   operator: "in",
                  //   value: data.value.toList().join(","),
                  // )
                  filters.add(widget.filterBuilder(data.key, data.value));
                }
              }
              widget.onFilterSubmit(filters);
              Navigator.pop(context);
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
