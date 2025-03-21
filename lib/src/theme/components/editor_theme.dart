import 'package:flutter/material.dart';
import 'package:flutter_meragi_design/flutter_meragi_design.dart';

class MDEditorTheme {
  final double baseFontSize;
  final TextStyle? h1;
  final TextStyle? h2;
  final TextStyle? h3;
  final TextStyle? h4;
  final TextStyle? h5;
  final TextStyle? h6;
  final TextStyle? p;
  final TextStyle? list;
  final TextStyle? blockquote;
  final TextStyle? code;
  final Map<String, BlockComponentBuilder>? editorBlockComponents;
  final FloatingToolbarStyle? floatingToolbarStyle;
  final EditorStyle editorStyle;

  const MDEditorTheme({
    this.baseFontSize = 14,
    this.h1,
    this.h2,
    this.h3,
    this.h4,
    this.h5,
    this.h6,
    this.p,
    this.list,
    this.blockquote,
    this.code,
    this.editorBlockComponents,
    this.floatingToolbarStyle,
    required this.editorStyle,
  });

  factory MDEditorTheme.fromBase(double baseFontSize) {
    final h1 =
        TextStyle(fontSize: baseFontSize * 2, fontWeight: FontWeight.bold);
    final h2 =
        TextStyle(fontSize: baseFontSize * 1.5, fontWeight: FontWeight.bold);
    final h3 =
        TextStyle(fontSize: baseFontSize * 1.17, fontWeight: FontWeight.bold);
    final h4 =
        TextStyle(fontSize: baseFontSize * 1.12, fontWeight: FontWeight.bold);
    final h5 =
        TextStyle(fontSize: baseFontSize * 1.11, fontWeight: FontWeight.bold);
    final h6 =
        TextStyle(fontSize: baseFontSize * 1.05, fontWeight: FontWeight.bold);
    final p = TextStyle(fontSize: baseFontSize);
    final list = TextStyle(fontSize: baseFontSize);
    final blockquote =
        TextStyle(fontSize: baseFontSize, fontStyle: FontStyle.italic);
    final code = TextStyle(fontSize: baseFontSize * 0.9);
    const floatingToolbarStyle = FloatingToolbarStyle();

    return MDEditorTheme(
      baseFontSize: baseFontSize,
      h1: h1,
      h2: h2,
      h3: h3,
      h4: h4,
      h5: h5,
      h6: h6,
      p: p,
      list: list,
      blockquote: blockquote,
      code: code,
      // editorBlockComponents: customBlockComponents(
      //   h1: h1,
      //   h2: h2,
      //   h3: h3,
      //   h4: h4,
      //   h5: h5,
      //   h6: h6,
      //   p: p,
      //   list: list,
      //   blockquote: blockquote,
      //   code: code,
      // ),
      floatingToolbarStyle: floatingToolbarStyle,
      editorStyle: EditorStyle.desktop(
        cursorColor: Colors.black,
        cursorWidth: 2,
        selectionColor: Colors.grey.withOpacity(0.5),
        padding: const EdgeInsets.all(16),
        textStyleConfiguration: TextStyleConfiguration(
          bold: p.copyWith(fontWeight: FontWeight.bold),
          italic: p.copyWith(fontStyle: FontStyle.italic),
          text: p,
        ),
      ),
    );
  }

  MDEditorTheme copyWith({
    double? baseFontSize,
    TextStyle? h1,
    TextStyle? h2,
    TextStyle? h3,
    TextStyle? h4,
    TextStyle? h5,
    TextStyle? h6,
    TextStyle? p,
    TextStyle? list,
    TextStyle? blockquote,
    TextStyle? code,
    Map<String, BlockComponentBuilder>? editorBlockComponents,
    FloatingToolbarStyle? floatingToolbarStyle,
    EditorStyle? editorStyle,
  }) {
    return MDEditorTheme(
      baseFontSize: baseFontSize ?? this.baseFontSize,
      h1: h1 ?? this.h1,
      h2: h2 ?? this.h2,
      h3: h3 ?? this.h3,
      h4: h4 ?? this.h4,
      h5: h5 ?? this.h5,
      h6: h6 ?? this.h6,
      p: p ?? this.p,
      list: list ?? this.list,
      blockquote: blockquote ?? this.blockquote,
      code: code ?? this.code,
      editorBlockComponents:
          editorBlockComponents ?? this.editorBlockComponents,
      floatingToolbarStyle: floatingToolbarStyle ?? this.floatingToolbarStyle,
      editorStyle: editorStyle ?? this.editorStyle, // Allow overriding
    );
  }

  // static Map<String, BlockComponentBuilder> customBlockComponents({
  //   required TextStyle h1,
  //   required TextStyle h2,
  //   required TextStyle h3,
  //   required TextStyle h4,
  //   required TextStyle h5,
  //   required TextStyle h6,
  //   required TextStyle p,
  //   required TextStyle list,
  //   required TextStyle blockquote,
  //   required TextStyle code,
  // }) {
  //   return {
  //     ...standardBlockComponentBuilderMap,
  //     HeadingBlockKeys.type: HeadingBlockComponentBuilder(
  //       textStyleBuilder: (level) {
  //         switch (level) {
  //           case 1:
  //             return h1;
  //           case 2:
  //             return h2;
  //           case 3:
  //             return h3;
  //           case 4:
  //             return h4;
  //           case 5:
  //             return h5;
  //           case 6:
  //             return h6;
  //           default:
  //             return p;
  //         }
  //       },
  //     ),
  //     ParagraphBlockKeys.type: ParagraphBlockComponentBuilder(
  //       configuration: standardBlockComponentConfiguration.copyWith(
  //         textStyle: (node) => p,
  //       ),
  //     ),
  //     NumberedListBlockKeys.type: NumberedListBlockComponentBuilder(
  //       configuration: standardBlockComponentConfiguration.copyWith(
  //         placeholderText: (_) =>
  //             AppFlowyEditorL10n.current.listItemPlaceholder,
  //         padding: (node) => const EdgeInsets.only(bottom: 30),
  //         textStyle: (node) => list,
  //       ),
  //     ),
  //     BulletedListBlockKeys.type: BulletedListBlockComponentBuilder(
  //       iconBuilder: (context, node) =>
  //           _BulletedListIcon(node: node, textStyle: p),
  //       configuration: standardBlockComponentConfiguration.copyWith(
  //         placeholderText: (_) =>
  //             AppFlowyEditorL10n.current.listItemPlaceholder,
  //         padding: (node) => const EdgeInsets.only(bottom: 3),
  //         textStyle: (node) => list,
  //       ),
  //     ),
  //   };
  // }
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
      constraints: BoxConstraints(
          minWidth: 10, minHeight: (textStyle.fontSize ?? 12) * (1.2)),
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
