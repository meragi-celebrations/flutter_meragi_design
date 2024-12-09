import 'package:flutter/material.dart';
import 'package:flutter_meragi_design/flutter_meragi_design.dart';

class JsonMdDropdown extends JsonWidget {
  JsonMdDropdown({super.key}) : _controller = DropdownController();

  @override
  JsonWidgetState<JsonMdDropdown> createState() => _JsonMdDropdownState();

  static const String inputType = "dropdown";

  final DropdownController _controller;

  @override
  DropdownController get controller => _controller;

  @override
  Map<String, Function(dynamic)> setters() => {
        "items": (value) => controller.items = [...(value as List).map((item) => (item["value"], item["label"]))],
        "multiSelect": (value) => controller.options.isMultiSelect = value ?? false
      };
}

class _JsonMdDropdownState extends JsonWidgetState<JsonMdDropdown> {
  @override
  Widget buildWidget(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: widget.controller.options.isMultiSelect!
          ? MDFormItem(
              label: Text(widget.controller.options.question!),
              child: MDFormCheckboxList(
                name: widget.controller.options.id!,
                isMultiSelect: true,
                options: widget.controller.items!.map((item) => MDCheckboxOption(item.$2, item.$1)).toList(),
              ))
          : MDFormItem(
              label: Text(widget.controller.options.question!),
              child: MDDropdown<String, String>(
                  name: widget.controller.options.id!,
                  items: widget.controller.items!
                      .map((item) => DropdownMenuItem<String>(value: item.$1, child: Text(item.$2)))
                      .toList())),
    );
  }
}

class DropdownController extends JsonController<DropdownOptions> {
  /// $1 is value, $2 is label
  List<(String, String)>? items;
  DropdownController() : super(DropdownOptions());
}

class DropdownOptions extends Options {
  bool? isMultiSelect = false;
}
