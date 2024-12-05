import 'package:flutter/material.dart';
import 'package:flutter_meragi_design/flutter_meragi_design.dart';

class JsonTextField extends JsonWidget {
  JsonTextField({super.key}) : _controller = JsonTextFieldController();

  static String inputType = "text";

  @override
  JsonWidgetState<JsonTextField> createState() => _JsonTextFieldState();

  final JsonTextFieldController _controller;

  @override
  JsonTextFieldController get controller => _controller;

  @override
  Map<String, Function(dynamic)> setters() => {
        "hintText": (value) => controller.options.hintText = value,
        "maxLines": (value) => controller.options.maxLines = value,
      };
}

class _JsonTextFieldState extends JsonWidgetState<JsonTextField> {
  @override
  Widget buildWidget(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: MDFormItem(
        label: Text(widget.controller.options.question!),
        child: MDTextField(
          maxLines: widget.controller.options.maxLines,
          name: widget.controller.options.id!,
          placeholder: widget.controller.options.hintText,
        ),
      ),
    );
  }
}

class JsonTextFieldController extends JsonController<TextFieldOptions> {
  JsonTextFieldController() : super(TextFieldOptions());
}

class TextFieldOptions extends Options {
  String? hintText;
  int? maxLines;
}
