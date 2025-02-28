import 'package:flutter/material.dart';
import 'package:flutter_meragi_design/flutter_meragi_design.dart';
import 'package:flutter_meragi_design/src/components/fields/editor/handlers/user_mention.dart';
import 'package:flutter_meragi_design/src/components/fields/editor/inline_actions_command.dart';
import 'package:flutter_meragi_design/src/components/fields/editor/inline_actions_service.dart';

class MDEditor extends StatefulWidget {
  final bool readOnly;
  final MDInputTheme? decoration;
  final bool isExpanded;

  final EditorState? editorState;
  final Function(TransactionTime, Transaction)? onTransactionChanged;

  const MDEditor({
    super.key,
    this.readOnly = false,
    this.decoration,
    this.isExpanded = false,
    this.editorState,
    this.onTransactionChanged,
  });

  @override
  State<MDEditor> createState() => _MDEditorState();
}

class _MDEditorState extends State<MDEditor> {
  late final EditorScrollController editorScrollController;
  late final EditorState editorState;

  late final InlineActionsService inlineActionsService = InlineActionsService(
    context: context,
    handlers: [
      InlineUserMentionService(),
    ],
  );

  @override
  void initState() {
    super.initState();

    editorState = widget.editorState != null
        ? widget.editorState!
        : EditorState.blank(withInitialText: true);
    editorScrollController = EditorScrollController(
      editorState: editorState,
      shrinkWrap: false,
    );
    editorState.transactionStream.listen(
      (onData) {
        widget.onTransactionChanged?.call(onData.$1, onData.$2);
      },
    );

    // editorStyle = _buildDesktopEditorStyle();
    // blockComponentBuilders = _buildBlockComponentBuilders();
    // commandShortcuts = _buildCommandShortcuts();
  }

  @override
  void dispose() {
    editorScrollController.dispose();
    editorState.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    late final MDInputTheme decoration;
    decoration = widget.decoration ?? context.theme.inputTheme;
    final editor = AppFlowyEditor(
      editorState: editorState,
      editable: !widget.readOnly,
      editorScrollController: editorScrollController,
      editorStyle: EditorStyle.desktop(
        cursorColor:
            widget.readOnly ? Colors.transparent : decoration.cursorColor,
        cursorWidth: widget.readOnly ? 0 : 2,
        selectionColor: decoration.selectionColor,
        padding: decoration.padding,
        textStyleConfiguration: TextStyleConfiguration(
          text: context.theme.fonts.paragraph.medium,
          lineHeight: context.theme.fonts.paragraph.medium.height ?? 1.2,
        ),
      ),
      characterShortcutEvents: [
        ...standardCharacterShortcutEvents,
        inlineActionsCommand(inlineActionsService),
      ],
    );

    final wrapper = DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(color: decoration.borderColor!),
        borderRadius: BorderRadius.all(
          Radius.circular(decoration.borderRadius ?? 5),
        ),
      ),
      child: editor,
    );

    if (widget.isExpanded) {
      return Expanded(
        child: wrapper,
      );
    }

    return wrapper;
  }
}
