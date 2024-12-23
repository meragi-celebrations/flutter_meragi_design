import 'package:appflowy_editor/appflowy_editor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_meragi_design/flutter_meragi_design.dart';
import 'package:flutter_meragi_design/src/components/fields/editor/handlers/user_mention.dart';
import 'package:flutter_meragi_design/src/components/fields/editor/inline_actions_command.dart';
import 'package:flutter_meragi_design/src/components/fields/editor/inline_actions_service.dart';

class MDEditor extends StatefulWidget {
  final bool readOnly;
  final MDInputDecoration? decoration;
  final bool isExpanded;

  final String? initialText;

  const MDEditor({
    super.key,
    this.readOnly = false,
    this.decoration,
    this.isExpanded = false,
    this.initialText,
  });

  @override
  State<MDEditor> createState() => _MDEditorState();
}

class _MDEditorState extends State<MDEditor> {
  late final EditorScrollController editorScrollController;
  late final EditorState editorState;

  late final MDInputDecoration decoration;

  late final InlineActionsService inlineActionsService = InlineActionsService(
    context: context,
    handlers: [
      InlineUserMentionService(),
    ],
  );

  @override
  void initState() {
    super.initState();

    decoration = widget.decoration ?? MDInputDecoration(context: context);

    editorState = (widget.initialText == null)
        ? EditorState.blank(withInitialText: true)
        : EditorState(
            document: markdownToDocument(widget.initialText!),
          );

    editorScrollController = EditorScrollController(
      editorState: editorState,
      shrinkWrap: false,
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
      ),
      characterShortcutEvents: [
        ...standardCharacterShortcutEvents,
        inlineActionsCommand(inlineActionsService),
      ],
    );

    final wrapper = DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(color: decoration.borderColor),
        borderRadius: BorderRadius.all(
          Radius.circular(decoration.borderRadius),
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
