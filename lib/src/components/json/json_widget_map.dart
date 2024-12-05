import 'package:flutter_meragi_design/flutter_meragi_design.dart';

/// After making any widget using ```JsonWidget''', add those in the jsonMap
Map<String, JsonWidget Function()> jsonMap = {
  JsonTextField.inputType: () => JsonTextField(),
  JsonMdDropdown.inputType: () => JsonMdDropdown()
};
