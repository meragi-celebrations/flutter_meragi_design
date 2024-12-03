import 'package:flutter/material.dart';
import 'package:flutter_meragi_design/flutter_meragi_design.dart';
import 'package:flutter_meragi_design/src/components/json/json_interface.dart';

class JsonTextField extends JsonWidget {
  JsonTextField({super.key}) : _controller = JsonTextFieldController();

  static String get inputType => "text";

  @override
  JsonWidgetState<JsonTextField> createState() => _JsonTextFieldState();

  final JsonTextFieldController _controller;

  @override
  JsonTextFieldController get controller => _controller;

  @override
  Map<String, Function(String? p1)> setters() => {
        "hintText": (value) => controller.options?.hintText = value,
        ...super.setters()
      };
}

class _JsonTextFieldState extends JsonWidgetState<JsonTextField> {
  @override
  Widget buildWidget(BuildContext context) {
    return Column(
      children: [
        Text(widget.controller.options!.question!),
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: MDFormItem(
            label: Text(widget.controller.options!.question!),
            child: MDTextField(
              name: widget.controller.options!.id!,
              initialValue: widget.controller.value,
            ),
          ),
        )
      ],
    );
  }
}

class JsonTextFieldController extends JsonController {
  final TextFieldOptions _options;
  @override
  TextFieldOptions? get options => _options;
  JsonTextFieldController() : _options = TextFieldOptions();
}

class TextFieldOptions extends Options {
  String? hintText;
}
