import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_meragi_design/flutter_meragi_design.dart';

class AnyKeyActivator implements ShortcutActivator {
  @override
  bool accepts(KeyEvent event, HardwareKeyboard state) {
    if (state.isShiftPressed || state.isAltPressed || state.isControlPressed || state.isMetaPressed) {
      return false;
    }
    return true;
  }

  @override
  String debugDescribeKeys() {
    return "";
  }

  @override
  // TODO: implement triggers
  Iterable<LogicalKeyboardKey>? get triggers => null;
}

class ControlCommandActivator extends ShortcutActivator {
  final LogicalKeyboardKey key;
  const ControlCommandActivator(this.key) : super();

  @override
  bool accepts(KeyEvent event, HardwareKeyboard state) =>
      event is KeyDownEvent && isControlCommandPressed(state) && event.logicalKey == key;

  bool isControlCommandPressed(HardwareKeyboard state) {
    if (isPlatform([MeragiPlatform.macos])) {
      if (state.isMetaPressed) {
        return true;
      }
    } else {
      if (state.isControlPressed) {
        return true;
      }
    }
    return false;
  }

  @override
  String debugDescribeKeys() {
    return isPlatform([MeragiPlatform.macos]) ? "Meta + $key" : "Ctrl + $key";
  }

  @override
  Iterable<LogicalKeyboardKey> get triggers => [key];
}
