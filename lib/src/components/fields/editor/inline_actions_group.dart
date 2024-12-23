import 'package:appflowy_editor/appflowy_editor.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_meragi_design/flutter_meragi_design.dart';
import 'package:flutter_meragi_design/src/components/fields/editor/inline_actions_menu.dart';
import 'package:flutter_meragi_design/src/components/fields/editor/inline_actions_result.dart';

class InlineActionsGroup extends StatelessWidget {
  const InlineActionsGroup({
    super.key,
    required this.result,
    required this.editorState,
    required this.menuService,
    required this.style,
    required this.onSelected,
    required this.startOffset,
    required this.endOffset,
    this.isLastGroup = false,
    this.isGroupSelected = false,
    this.selectedIndex = 0,
  });

  final InlineActionsResult result;
  final EditorState editorState;
  final InlineActionsMenuService menuService;
  final InlineActionsMenuStyle style;
  final VoidCallback onSelected;
  final int startOffset;
  final int endOffset;

  final bool isLastGroup;
  final bool isGroupSelected;
  final int selectedIndex;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: isLastGroup ? EdgeInsets.zero : const EdgeInsets.only(bottom: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (result.title != null) ...[
            BodyText(text: result.title!),
            const SizedBox(height: 4),
          ],
          ...result.results.mapIndexed(
            (index, item) => InlineActionsWidget(
              item: item,
              editorState: editorState,
              menuService: menuService,
              isSelected: isGroupSelected && index == selectedIndex,
              style: style,
              onSelected: onSelected,
              startOffset: startOffset,
              endOffset: endOffset,
            ),
          ),
        ],
      ),
    );
  }
}

class InlineActionsWidget extends StatefulWidget {
  const InlineActionsWidget({
    super.key,
    required this.item,
    required this.editorState,
    required this.menuService,
    required this.isSelected,
    required this.style,
    required this.onSelected,
    required this.startOffset,
    required this.endOffset,
  });

  final InlineActionsMenuItem item;
  final EditorState editorState;
  final InlineActionsMenuService menuService;
  final bool isSelected;
  final InlineActionsMenuStyle style;
  final VoidCallback onSelected;
  final int startOffset;
  final int endOffset;

  @override
  State<InlineActionsWidget> createState() => _InlineActionsWidgetState();
}

class _InlineActionsWidgetState extends State<InlineActionsWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: SizedBox(
        width: 300,
        child: MDButton(
          expand: true,
          child: BodyText(
            text: widget.item.label,
            overflow: TextOverflow.ellipsis,
          ),
          onTap: _onPressed,
        ),
      ),
    );
  }

  void _onPressed() {
    widget.onSelected();
    widget.item.onSelected?.call(
      context,
      widget.editorState,
      widget.menuService,
      (widget.startOffset, widget.endOffset),
    );
  }
}
