import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_meragi_design/flutter_meragi_design.dart';
import 'package:flutter_meragi_design/src/components/fields/editor/handlers/user_mention.dart';
import 'package:flutter_meragi_design/src/components/fields/editor/inline_actions_command.dart';
import 'package:flutter_meragi_design/src/components/fields/editor/inline_actions_service.dart';

typedef BlockIconBuilder = Widget Function(BuildContext context, Node node);

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
  StreamSubscription<EditorTransactionValue>? transactionStreamSubscription;
  late final EditorState editorState;
  late final InlineActionsService inlineActionsService =
      InlineActionsService(context: context, handlers: [InlineUserMentionService()]);

  @override
  void initState() {
    super.initState();
    editorState = widget.editorState != null ? widget.editorState! : EditorState.blank(withInitialText: true);
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
    Map<String, BlockComponentBuilder> customBlock = {
      ...standardBlockComponentBuilderMap,
      BulletedListBlockKeys.type: BulletedListBlockComponentBuilder(
        iconBuilder: (context, node) => _BulletedListIcon(node: node, textStyle: context.theme.fonts.paragraph.small),
        configuration: standardBlockComponentConfiguration.copyWith(
          placeholderText: (_) => AppFlowyEditorL10n.current.listItemPlaceholder,
          padding: (node) => const EdgeInsets.only(bottom: 2),
          textStyle: (node, {textSpan}) => context.theme.fonts.paragraph.small.copyWith(height: 1.2),
        ),
      ),
    };

    final MDInputTheme decoration =
        widget.decoration != null ? context.theme.inputTheme.merge(widget.decoration) : context.theme.inputTheme;
    final editor = AppFlowyEditor(
      editorState: editorState,
      editable: !widget.readOnly,
      blockComponentBuilders: customBlock,
      shrinkWrap: true,
      editorStyle: EditorStyle.desktop(
        cursorColor: widget.readOnly ? Colors.transparent : decoration.cursorColor,
        cursorWidth: widget.readOnly ? 0 : 2,
        selectionColor: decoration.selectionColor,
        padding: decoration.padding,
        textStyleConfiguration: TextStyleConfiguration(
          bold: context.theme.fonts.paragraph.medium,
          text: context.theme.fonts.paragraph.small,
          lineHeight: 1.5,
        ),
      ),
      characterShortcutEvents: [
        ...standardCharacterShortcutEvents,
        inlineActionsCommand(inlineActionsService),
      ],
    );

    final wrapper = IntrinsicHeight(
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: decoration.borderColor!),
          borderRadius: BorderRadius.all(
            Radius.circular(decoration.borderRadius ?? 5),
          ),
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
    return Focus(onKeyEvent: (node, event) => KeyEventResult.skipRemainingHandlers, child: wrapper);
  }
}

class _BulletedListIcon extends StatelessWidget {
  const _BulletedListIcon({
    required this.node,
    required this.textStyle,
  });

  final Node node;
  final TextStyle textStyle;

  static final bulletedListIcons = [
    '●',
    '◯',
    '□',
  ];

  int get level {
    var level = 0;
    var parent = node.parent;
    while (parent != null) {
      if (parent.type == 'bulleted_list') {
        level++;
      }
      parent = parent.parent;
    }
    return level;
  }

  String get icon => bulletedListIcons[level % bulletedListIcons.length];

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(minWidth: 10, minHeight: (textStyle.fontSize ?? 12) * (1.2)),
      padding: const EdgeInsets.only(right: 4.0),
      child: Center(
        child: Text(
          icon,
          style: textStyle.copyWith(fontSize: 5),
        ),
      ),
    );
  }
}
