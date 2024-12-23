import 'package:appflowy_editor/appflowy_editor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_meragi_design/src/components/fields/editor/inline_actions_delegate.dart';
import 'package:flutter_meragi_design/src/components/fields/editor/inline_actions_menu.dart';
import 'package:flutter_meragi_design/src/components/fields/editor/inline_actions_result.dart';

class InlineUserMentionService extends InlineActionsDelegate {
  InlineUserMentionService();

  // final String currentViewId;

  @override
  Future<InlineActionsResult> search(String? search) async {
    print("search: $search");
    final List<InlineActionsMenuItem> results = List.generate(5, (index) {
      return InlineActionsMenuItem(
        label: "User $index",
        onSelected: (context, editorState, service, replacement) =>
            _onSelected(context, editorState, service, replacement, search),
      );
    });
    // if (search != null && search.isNotEmpty) {
    //   results.add(
    //     InlineActionsMenuItem(
    //       label: ,
    //       icon: (_) => const FlowySvg(FlowySvgs.add_s),
    // onSelected: (context, editorState, service, replacement) =>
    //     _onSelected(context, editorState, service, replacement, search),
    //     ),
    //   );
    // }

    return InlineActionsResult(results: results);
  }

  Future<void> _onSelected(
    BuildContext context,
    EditorState editorState,
    InlineActionsMenuService service,
    (int, int) replacement,
    String? search,
  ) async {
    final selection = editorState.selection;
    if (selection == null || !selection.isCollapsed) {
      return;
    }

    final node = editorState.getNodeAtPath(selection.start.path);
    final delta = node?.delta;
    if (node == null || delta == null) {
      return;
    }

    // final view = (await ViewBackendService.createView(
    //   layoutType: ViewLayoutPB.Document,
    //   parentViewId: currentViewId,
    //   name: search!,
    // ))
    //     .toNullable();

    // if (view == null) {
    //   return Log.error('Failed to create view');
    // }

    final transaction = editorState.transaction
      ..replaceText(
        node,
        replacement.$1,
        replacement.$2,
        search!,
        // attributes: {
        //   MentionBlockKeys.mention: {
        //     MentionBlockKeys.type: MentionType.childPage.name,
        //     MentionBlockKeys.pageId: view.id,
        //   },
        // },
      );

    await editorState.apply(transaction);
  }
}
