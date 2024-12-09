import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_meragi_design/flutter_meragi_design.dart';

abstract class JsonWidget<T extends JsonController, W extends JsonWidgetState> extends StatefulWidget
    with JsonSetters, JsonControllerMixin<T, W> {
  const JsonWidget({super.key});
}

abstract class JsonWidgetState<T extends JsonControllerMixin> extends State<T> {
  Widget buildWidget(BuildContext context);

  @override
  @nonVirtual
  Widget build(BuildContext context) {
    Widget rtn = buildWidget(context);
    return rtn;
  }
}

abstract class JsonController<T extends Options> {
  T options;
  dynamic value;

  JsonController(this.options);

  @nonVirtual
  Map<String, Function(dynamic)> baseSetters() => {
        "value": (value) => this.value = value,
        "labelText": (value) => options.labelText = value,
        "question": (value) => options.question = value,
        "id": (value) => options.id = value
      };
}

mixin JsonSetters {
  Map<String, Function(dynamic)> setters();

  @mustCallSuper
  void setProperty(MapEntry<String, dynamic> setterEntry) {
    if (this is JsonControllerMixin) {
      Function(dynamic)? func =
          (this as JsonControllerMixin).controller.baseSetters()[setterEntry.key] ?? setters()[setterEntry.key];
      if (func != null) {
        func.call(setterEntry.value);
      }
    }
  }
}

mixin JsonControllerMixin<T extends JsonController, W extends State> on StatefulWidget {
  T get controller;
}

abstract class JsonStatelessWidget<T extends JsonController> extends StatelessWidget with JsonSetters {
  const JsonStatelessWidget({super.key});
}

abstract class Options {
  String? question;
  String? labelText;
  String? id;
  Options({this.question, this.id, this.labelText});
}

class JsonData {
  final List _json;
  final GlobalKey<FormBuilderState> _formKey;
  const JsonData({required final List json, required final GlobalKey<FormBuilderState> formKey})
      : _json = json,
        _formKey = formKey;

  List get json => _json;
  GlobalKey<FormBuilderState> get formKey => _formKey;

  List<Map<String, dynamic>> parseJson() {
    List<Map<String, dynamic>> parsedJson = [];
    for (Map<String, dynamic> jsonWidget in _json) {
      String jsonWidgetType = (jsonWidget["type"] as String).trim();
      Map<String, dynamic> widgetRegistryPropertiesMap = {};
      Map<String, dynamic> others = {};
      for (var jsonWidgetProperty in jsonWidget.entries) {
        if (jsonWidgetProperty.key == "type") {
          widgetRegistryPropertiesMap.addAll({ParsedJsonEnum.widget.name: jsonMap[jsonWidgetType]!});
        } else if (jsonWidgetProperty.key == "options") {
          widgetRegistryPropertiesMap.addAll({ParsedJsonEnum.options.name: jsonWidget["options"]!});
        } else {
          others.addAll({jsonWidgetProperty.key: jsonWidgetProperty.value});
        }
      }
      widgetRegistryPropertiesMap.addAll({ParsedJsonEnum.others.name: others});
      parsedJson.add(widgetRegistryPropertiesMap);
    }
    return parsedJson;
  }

  Map<String, dynamic> initialValueMap() {
    final Map<String, dynamic> initialValue = {};
    for (Map<String, dynamic> jsonWidget in _json) {
      if (jsonWidget["type"] == JsonMdDropdown.inputType && jsonWidget["options"]["multiSelect"] == true) {
        initialValue.addAll({
          jsonWidget["id"]: jsonWidget["value"] != null
              ? (jsonWidget["value"] is List)
                  ? (jsonWidget["value"] as List).cast<String>().toSet()
                  : <String>{jsonWidget["value"]}
              : null
        });
      } else {
        initialValue.addAll({jsonWidget["id"]: jsonWidget["value"]});
      }
    }
    return initialValue;
  }
}

class JsonRootWidget extends StatelessWidget {
  const JsonRootWidget({super.key, required this.jsonData});
  final JsonData jsonData;

  @override
  Widget build(BuildContext context) => JsonDataManager(jsonData: jsonData, child: const _JsonRootWidget());
}

class _JsonRootWidget extends StatefulWidget {
  const _JsonRootWidget();

  @override
  State<_JsonRootWidget> createState() => _JsonRootWidgetState();
}

class _JsonRootWidgetState extends State<_JsonRootWidget> {
  final List<Widget> _widgets = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _widgets.addAll(JsonUtil.buildWidgetChildren(JsonDataManager.of(context).jsonData.parseJson()));
  }

  @override
  Widget build(BuildContext context) {
    return FormBuilder(
      key: JsonDataManager.of(context).jsonData.formKey,
      initialValue: JsonDataManager.of(context).jsonData.initialValueMap(),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: _widgets),
    );
  }
}

enum ParsedJsonEnum {
  widget("widgetFun"),
  options("options"),
  value("value"),
  others("others");

  final String name;
  const ParsedJsonEnum(this.name);
}
