import 'package:flutter/cupertino.dart';

enum ButtonState {
  hovered,
  pressed,
  disabled
}

class ButtonStateController extends ValueNotifier<Set<ButtonState>> {
  ButtonStateController({Set<ButtonState>? value}) : super({...?value});

  void updateState(ButtonState newState) {
    bool isUpdated = value.contains(newState) ? value.remove(newState) : value.add(newState);
    if(isUpdated) {
      notifyListeners();
    }
  }
}