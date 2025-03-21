import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_meragi_design/flutter_meragi_design.dart';
import 'package:flutter_meragi_design/src/components/fields/editor/handlers/user_mention.dart';
import 'package:flutter_meragi_design/src/components/fields/editor/inline_actions_command.dart';
import 'package:flutter_meragi_design/src/components/fields/editor/inline_actions_service.dart';

typedef BlockIconBuilder = Widget Function(BuildContext context, Node node);

class MDEditor extends StatefulWidget {
  final bool readOnly;
  @Deprecated('Use theme from context.theme.editorTheme')
  final MDInputTheme? decoration;
  final MDEditorTheme? theme;
  final bool isExpanded;

  final EditorState? editorState;
  final Function(TransactionTime, Transaction)? onTransactionChanged;

  const MDEditor({
    super.key,
    this.readOnly = false,
    this.decoration,
    this.theme,
    this.isExpanded = false,
    this.editorState,
    this.onTransactionChanged,
  });

  @override
  State<MDEditor> createState() => _MDEditorState();
}

class _MDEditorState extends State<MDEditor> {
  late final EditorScrollController editorScrollController;
  StreamSubscription<(TransactionTime, Transaction)>?
      transactionStreamSubscription;
  late final EditorState editorState;
  late final InlineActionsService inlineActionsService = InlineActionsService(
      context: context, handlers: [InlineUserMentionService()]);

  @override
  void initState() {
    super.initState();
    editorState = widget.editorState ??
        EditorState.blank(
          withInitialText: true,
        ); // Ensure editorState is not null
    editorScrollController = EditorScrollController(
      editorState: editorState,
      shrinkWrap: true,
    );
    transactionStreamSubscription = editorState.transactionStream.listen(
      (onData) {
        widget.onTransactionChanged?.call(onData.$1, onData.$2);
      },
    );
  }

  @override
  void dispose() {
    if (widget.editorState == null) editorState.dispose();
    transactionStreamSubscription?.cancel();
    transactionStreamSubscription = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = widget.theme ??
        context.theme
            .editorTheme; // Ensure theme is not null // Use centralized customBlock

    final editor = FloatingToolbar(
      items: [
        paragraphItem,
        ...headingItems,
        ...markdownFormatItems.sublist(
          0,
          markdownFormatItems.length - 1,
        ), // This is to remove "code block" format
        quoteItem,
        bulletedListItem,
        numberedListItem,
        linkItem,
      ],
      tooltipBuilder: (context, _, message, child) {
        return Tooltip(
          message: message,
          preferBelow: false,
          child: child,
        );
      },
      style: theme.floatingToolbarStyle ?? const FloatingToolbarStyle(),
      editorState: editorState,
      editorScrollController: editorScrollController,
      textDirection: TextDirection.ltr,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: AppFlowyEditor(
          editorState: editorState,
          editable: !widget.readOnly,
          blockComponentBuilders: theme.editorBlockComponents,
          shrinkWrap: true,
          editorStyle: theme.editorStyle,
          characterShortcutEvents: [
            ...standardCharacterShortcutEvents,
            inlineActionsCommand(inlineActionsService),
          ],
        ),
      ),
    );

    final wrapper = IntrinsicHeight(
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: theme.p?.color ?? Colors.grey),
          borderRadius: const BorderRadius.all(Radius.circular(5)),
        ),
        constraints: widget.readOnly
            ? null
            : const BoxConstraints(
                minHeight: 150,
              ),
        child: editor,
      ),
    );

    if (widget.isExpanded) {
      return Expanded(
        child: wrapper,
      );
    }

    return wrapper;
  }
}
