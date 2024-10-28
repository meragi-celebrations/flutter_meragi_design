import 'package:flutter/material.dart';

class MDWidgetStateResolver<T> {
  final Map<dynamic, T> propertyMap;

  List<WidgetState> clickablePriority = [
    WidgetState.pressed,
    WidgetState.selected,
    WidgetState.focused,
    WidgetState.dragged,
    WidgetState.error,
    WidgetState.disabled,
    WidgetState.scrolledUnder,
    WidgetState.hovered
  ];

  MDWidgetStateResolver(this.propertyMap)
      : assert(propertyMap.containsKey("default"),
            "The propertyMap must contains a key called 'default'");

  WidgetStateProperty<T> resolveWith() {
    return WidgetStateProperty.resolveWith<T>((states) {
      T value = propertyMap["default"]!;
      for (var state in clickablePriority) {
        if (states.contains(state) && propertyMap.containsKey(state)) {
          return propertyMap[state]!;
        }
      }
      return value;
    });
  }

  T resolve(Set<WidgetState> states) {
    T value = propertyMap["default"]!;
    for (var state in clickablePriority) {
      if (states.contains(state) && propertyMap.containsKey(state)) {
        return propertyMap[state]!;
      }
    }
    return value;
  }
}
