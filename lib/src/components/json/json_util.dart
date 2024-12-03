import 'package:flutter/material.dart';
import 'package:flutter_meragi_design/src/components/json/json_interface.dart';

class JsonUtil {
  static List<Widget> buildWidgetChildren(
      List<Map<String, dynamic>> parsedList) {
    final List<Widget> widgets = [];
    for (var jsonWidgetMap in parsedList) {
      var w = (jsonWidgetMap[ParsedJsonEnum.widget.name] as JsonWidget<
                  JsonController,
                  JsonWidgetState<
                      JsonControllerMixin<JsonController,
                          State<StatefulWidget>>>>
              Function())
          .call();
      for (var optionSetter
          in jsonWidgetMap[ParsedJsonEnum.options.name]!.entries) {
        w.setProperty(optionSetter);
      }
      for (var setter in jsonWidgetMap[ParsedJsonEnum.others.name]!.entries) {
        w.setProperty(setter);
      }
      widgets.add(w);
    }
    return widgets;
  }
}
