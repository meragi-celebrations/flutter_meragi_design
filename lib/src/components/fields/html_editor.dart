import 'package:flutter/material.dart';
import 'package:flutter_meragi_design/src/components/fields/form_builder_field.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:vsc_quill_delta_to_html/vsc_quill_delta_to_html.dart';

class MDHtmlEditor extends MDFormBuilderField<String> {
  final QuillController? controller;
  final Size? size;

  MDHtmlEditor({
    super.key,
    required super.name,
    super.validator,
    super.initialValue,
    super.onChanged,
    super.valueTransformer,
    super.enabled,
    super.onSaved,
    super.autovalidateMode,
    super.onReset,
    super.focusNode,
    super.restorationId,
    this.controller,
    this.size,
  }) : super(
          builder: (FormFieldState<String?> field) {
            final state = field as _MDHtmlEditor;

            double height = size?.height ?? 300;

            return Container(
              height: height,
              width: size?.width ?? 500,
              padding: EdgeInsets.all(2),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(10),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(7.5),
                child: Column(
                  children: [
                    QuillSimpleToolbar(
                      controller: state.controller,
                      configurations: const QuillSimpleToolbarConfigurations(
                        toolbarIconAlignment: WrapAlignment.start,
                        toolbarIconCrossAlignment: WrapCrossAlignment.start,
                        showBoldButton: true,
                        showLink: true,
                        showListBullets: true,
                        showListNumbers: true,
                        showFontSize: true,
                        showUnderLineButton: true,
                        multiRowsDisplay: false,
                        showAlignmentButtons: false,
                        showBackgroundColorButton: false,
                        showCenterAlignment: false,
                        showClearFormat: false,
                        showClipboardCopy: false,
                        showCodeBlock: false,
                        showDirection: false,
                        showDividers: false,
                        showFontFamily: false,
                        showInlineCode: false,
                        showIndent: false,
                        showClipboardCut: false,
                        showClipboardPaste: false,
                        showColorButton: false,
                        showHeaderStyle: false,
                        showItalicButton: true,
                        showJustifyAlignment: false,
                        showLeftAlignment: false,
                        showLineHeightButton: false,
                        showListCheck: false,
                        showQuote: false,
                        showRedo: false,
                        showRightAlignment: false,
                        showSearchButton: false,
                        showSmallButton: false,
                        showStrikeThrough: false,
                        showSubscript: false,
                        showSuperscript: false,
                        showUndo: false,
                      ),
                    ),
                    Expanded(
                      child: QuillEditor.basic(
                        focusNode: state.focusNode,
                        controller: state.controller,
                        configurations: QuillEditorConfigurations(
                          showCursor: true,
                          minHeight: height,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        );

  @override
  MDFormBuilderFieldState<MDHtmlEditor, String> createState() =>
      _MDHtmlEditor();
}

class _MDHtmlEditor extends MDFormBuilderFieldState<MDHtmlEditor, String> {
  late final QuillController controller;
  late final FocusNode focusNode;

  @override
  void initState() {
    super.initState();
    controller = widget.controller ?? QuillController.basic();
    if (value != null) {
      controller.document = Document.fromHtml(value!);
    }
    controller.changes.listen((event) {
      didChange(_deltaToHtml());
    });

    focusNode = widget.focusNode ?? FocusNode();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  String _deltaToHtml() {
    final converter = QuillDeltaToHtmlConverter(
      controller.document.toDelta().toJson(),
      ConverterOptions.forEmail(),
    );
    return converter.convert();
  }
}
