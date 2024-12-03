import 'package:flutter_meragi_design/src/components/json/json_interface.dart';
import 'package:flutter_meragi_design/src/components/json/json_md_text_field.dart';

/// After making any widget using ```JsonWidget''', add those in the jsonMap
Map<String, JsonWidget Function()> jsonMap = {
  JsonTextField.inputType: () => JsonTextField()
};
