import 'package:flutter/material.dart';
import 'package:flutter_meragi_design/flutter_meragi_design.dart';
import 'package:flutter_meragi_design/src/components/json/json_data_manager.dart';
import 'package:flutter_meragi_design/src/components/json/json_util.dart';
import 'package:flutter_meragi_design/src/components/json/json_widget_map.dart';

abstract class JsonWidget<T extends JsonController, W extends JsonWidgetState>
    extends StatefulWidget with JsonSetters, JsonControllerMixin<T, W> {
  const JsonWidget({super.key});

  /// When doing setter override, make sure to add the entries by
  /// calling ```super.setters()``` into the map so that map from 
  /// the abstract widgets can also be added
  @override
  @mustCallSuper
  Map<String, Function(String? p1)> setters() {
    return {
      "value": (value) => controller.value = value,
      "labelText": (value) => controller.options?.labelText = value,
      "question": (value) => controller.options?.question = value,
      "id": (value) => controller.options?.id = value
    };
  }
}

abstract class JsonWidgetState<T extends JsonControllerMixin> extends State<T> {
  Widget buildWidget(BuildContext context);

  @override
  Widget build(BuildContext context) {
    Widget rtn = buildWidget(context);
    return rtn;
  }
}

/// Make sure that you are initiating this ```JsonController```
/// in the constructor of the ```JsonWidget```
abstract class JsonController {
  Options? options;
  String? value;
}

mixin JsonSetters {
  Map<String, Function(String?)> setters();

  void setProperty(MapEntry<String, dynamic> setterEntry) {
    Function(String?)? func = setters()[setterEntry.key];
    if (func != null && this is JsonControllerMixin) {
      func.call(setterEntry.value);
    }
  }
}

mixin JsonControllerMixin<T extends JsonController, W extends State>
    on StatefulWidget {
  T get controller;
}

abstract class JsonStatelessWidget<T extends JsonController>
    extends StatelessWidget with JsonSetters {
  const JsonStatelessWidget({super.key});
}

/// Make sure that you are initiating this [Options] in the constructor of the [JsonController]
abstract class Options {
  String? question;
  String? labelText;
  String? id;
}

class JsonData {
  final List _json;
  final GlobalKey<FormBuilderState> _formKey;
  const JsonData(
      {required final List json,
      required final GlobalKey<FormBuilderState> formKey})
      : _json = json,
        _formKey = formKey;

  List get json => _json;
  GlobalKey<FormBuilderState> get formKey => _formKey;

  List<Map<String, dynamic>> parseJson() {
    List<Map<String, dynamic>> parsedJson = [];
    for (Map<String, dynamic> jsonWidget in _json) {
      String jsonWidgetType = (jsonWidget["type"] as String).trim();
      Map<String, dynamic> widgetRegistryPropertiesMap = {};
      for (var jsonWidgetProperty in jsonWidget.entries) {
        if (jsonWidgetProperty.key == "type") {
          widgetRegistryPropertiesMap
              .addAll({ParsedJsonEnum.widget.name: jsonMap[jsonWidgetType]!});
        } else if (jsonWidgetProperty.key == "options") {
          widgetRegistryPropertiesMap
              .addAll({ParsedJsonEnum.options.name: jsonWidget["options"]!});
        } else if (jsonWidgetProperty.key == "options") {
          widgetRegistryPropertiesMap
              .addAll({ParsedJsonEnum.value.name: jsonWidget["value"]!});
        } else {
          widgetRegistryPropertiesMap.addAll({
            ParsedJsonEnum.others.name: {
              jsonWidgetProperty.key: jsonWidgetProperty.value
            }
          });
        }
      }
      parsedJson.add(widgetRegistryPropertiesMap);
    }
    return parsedJson;
  }
}

class JsonRootWidget extends StatelessWidget {
  const JsonRootWidget(
      {super.key, required this.jsonData, required this.formKey});
  final JsonData jsonData;
  final GlobalKey<FormBuilderState> formKey;

  @override
  Widget build(BuildContext context) =>
      JsonDataManager(jsonData: jsonData, child: const _JsonRootWidget());
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
    _widgets.addAll(JsonUtil.buildWidgetChildren(
        JsonDataManager.of(context).jsonData.parseJson()));
  }

  @override
  Widget build(BuildContext context) {
    return FormBuilder(
      key: JsonDataManager.of(context).jsonData.formKey,
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center, children: _widgets),
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
