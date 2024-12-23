import 'package:flutter_meragi_design/src/components/fields/editor/inline_actions_result.dart';

abstract class InlineActionsDelegate {
  Future<InlineActionsResult> search(String? search);

  Future<void> dispose() async {}
}
