import 'package:flutter/material.dart';
import 'package:flutter_meragi_design/flutter_meragi_design.dart';
import 'package:flutter_meragi_design/src/theme/theme_tokens.dart';
import 'package:flutter_meragi_design/src/utils/map.dart';

class Style {
  final BuildContext context;

  const Style({required this.context});

  ThemeToken get token => MeragiTheme.of(context).token;

  Map get styles => {};

  dynamic getStyle(dynamic cat, String key) {
    return valueFromMap(cat, styles)[key];
  }
}
