import 'package:flutter/material.dart';
import 'package:flutter_meragi_design/flutter_meragi_design.dart';

class JsonMdDropdown extends JsonWidget<DropdownController, _JsonMdDropdownState> {
  JsonMdDropdown({super.key}) : _controller = DropdownController();

  @override
  JsonWidgetState<JsonMdDropdown> createState() => _JsonMdDropdownState();

  static const String inputType = "dropdown";

  final DropdownController _controller;

  @override
  DropdownController get controller => _controller;

  @override
  Map<String, Function(dynamic)> setters() => {
        "items": (value) => controller.items = [
              ...(value as List)
                  .map((item) => DropdownMenuItem<String>(value: item["value"], child: Text(item["label"])))
            ]
      };
}

class _JsonMdDropdownState extends JsonWidgetState<JsonMdDropdown> {
  @override
  Widget buildWidget(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: MDFormItem(
          label: Text(widget.controller.options.question!),
          child: MDDropdown<String, String>(items: widget.controller.items!, name: widget.controller.options.id!)),
    );
  }
}

class DropdownController extends JsonController<DropdownOptions> {
  List<DropdownMenuItem<String>>? items;
  DropdownController() : super(DropdownOptions());
}

class DropdownOptions extends Options {}
