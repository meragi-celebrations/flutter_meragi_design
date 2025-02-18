import 'package:flutter/material.dart';
import 'package:flutter_meragi_design/src/theme/theme_tokens.dart';
import 'package:flutter_meragi_design/src/theme/tokens/light.dart';

class MeragiTheme extends InheritedWidget {
  final ThemeToken token;
  MeragiTheme({super.key, required super.child, ThemeToken? token}) : token = token ?? light;

  @override
  bool updateShouldNotify(covariant MeragiTheme oldWidget) {
    return oldWidget.token != token;
  }

  static MeragiTheme of(BuildContext context) {
    final MeragiTheme? result = maybeOf(context);
    assert(result != null, 'No Meragi Theme found in context');
    return result!;
  }

  static MeragiTheme? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<MeragiTheme>();
  }
}

extension MeragiToken on BuildContext {
  ThemeToken get token => MeragiTheme.of(this).token;
}
