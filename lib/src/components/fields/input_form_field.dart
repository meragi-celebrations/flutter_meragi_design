import 'dart:ui' as ui;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_meragi_design/flutter_meragi_design.dart' show ShadDecoration;
import 'package:flutter_meragi_design/src/components/fields/form_builder_field.dart';
import 'package:flutter_meragi_design/src/components/fields/input.dart' show MDInput;


class MDInputFormField extends MDFormBuilderField<String> {
  /// Controls the text being edited.
  ///
  /// If null, this widget will create its own [TextEditingController].
  final TextEditingController? controller;

  /// {@macro flutter.widgets.editableText.keyboardType}
  final TextInputType? keyboardType;

  /// The type of action button to use for the keyboard.
  ///
  /// Defaults to [TextInputAction.newline] if [keyboardType] is
  /// [TextInputType.multiline] and [TextInputAction.done] otherwise.
  final TextInputAction? textInputAction;

  /// {@macro flutter.widgets.editableText.textCapitalization}
  final TextCapitalization textCapitalization;

  /// The style to use for the text being edited.
  final TextStyle? style;

  /// {@macro flutter.widgets.editableText.strutStyle}
  final StrutStyle? strutStyle;

  /// {@macro flutter.widgets.editableText.textAlign}
  final TextAlign textAlign;

  /// {@macro flutter.widgets.editableText.textDirection}
  final TextDirection? textDirection;

  /// {@macro flutter.widgets.editableText.autofocus}
  final bool autofocus;

  /// {@macro flutter.widgets.editableText.obscuringCharacter}
  final String obscuringCharacter;

  /// {@macro flutter.widgets.editableText.obscureText}
  final bool obscureText;

  /// {@macro flutter.widgets.editableText.autocorrect}
  final bool autocorrect;

  /// {@macro flutter.services.textInput.smartDashesType}
  final SmartDashesType? smartDashesType;

  /// {@macro flutter.services.textInput.smartQuotesType}
  final SmartQuotesType? smartQuotesType;

  /// {@macro flutter.services.textInput.enableSuggestions}
  final bool enableSuggestions;

  /// A lighter colored placeholder hint that appears on the first line of the
  /// text field when the text entry is empty.
  final Widget? placeholder;

  /// The style to use for the placeholder text.
  final TextStyle? placeholderStyle;

  /// {@macro flutter.widgets.editableText.maxLines}
  final int? maxLines;

  /// {@macro flutter.widgets.editableText.minLines}
  final int? minLines;

  /// {@macro flutter.widgets.editableText.expands}
  final bool expands;

  /// {@macro flutter.widgets.EditableText.contextMenuBuilder}
  final EditableTextContextMenuBuilder? contextMenuBuilder;

  /// {@macro flutter.widgets.editableText.showCursor}
  final bool? showCursor;

  /// The maximum number of characters (Unicode grapheme clusters) to allow in
  /// the text field.
  final int? maxLength;

  /// Determines how the [maxLength] limit should be enforced.
  final MaxLengthEnforcement? maxLengthEnforcement;

  /// {@macro flutter.widgets.editableText.onEditingComplete}
  final VoidCallback? onEditingComplete;

  /// {@macro flutter.widgets.editableText.onSubmitted}
  final ValueChanged<String?>? onSubmitted;

  /// {@macro flutter.widgets.editableText.inputFormatters}
  final List<TextInputFormatter>? inputFormatters;

  /// {@macro flutter.widgets.editableText.cursorWidth}
  final double cursorWidth;

  /// {@macro flutter.widgets.editableText.cursorHeight}
  final double? cursorHeight;

  /// {@macro flutter.widgets.editableText.cursorRadius}
  final Radius? cursorRadius;

  /// The color to use when painting the cursor.
  final Color? cursorColor;

  /// Controls how tall the selection highlight boxes are computed to be.
  final ui.BoxHeightStyle selectionHeightStyle;

  /// Controls how wide the selection highlight boxes are computed to be.
  final ui.BoxWidthStyle selectionWidthStyle;

  /// The appearance of the keyboard.
  final Brightness? keyboardAppearance;

  /// {@macro flutter.widgets.editableText.scrollPadding}
  final EdgeInsets scrollPadding;

  /// {@macro flutter.widgets.editableText.enableInteractiveSelection}
  final bool enableInteractiveSelection;

  /// {@macro flutter.widgets.scrollable.dragStartBehavior}
  final DragStartBehavior dragStartBehavior;

  /// {@macro flutter.rendering.editable.selectionEnabled}
  bool get selectionEnabled => enableInteractiveSelection;

  /// {@template flutter.material.textfield.onTap}
  final GestureTapCallback? onPressed;

  /// {@macro flutter.widgets.editableText.scrollPhysics}
  final ScrollPhysics? scrollPhysics;

  /// {@macro flutter.widgets.editableText.scrollController}
  final ScrollController? scrollController;

  /// {@macro flutter.widgets.editableText.autofillHints}
  final Iterable<String>? autofillHints;

  ///{@macro flutter.widgets.text_selection.TextMagnifierConfiguration.intro}
  final TextMagnifierConfiguration? magnifierConfiguration;

  /// By default `false`
  final bool readOnly;

  /// Controls the decoration of the input field
  final ShadDecoration? decoration;

  /// {@macro flutter.widgets.editableText.scribbleEnabled}
  final bool scribbleEnabled;

  /// {@macro flutter.services.TextInputConfiguration.enableIMEPersonalizedLearning}
  final bool enableIMEPersonalizedLearning;

  /// {@macro flutter.widgets.editableText.contentInsertionConfiguration}
  final ContentInsertionConfiguration? contentInsertionConfiguration;

  /// Widget to display before the text input
  final Widget? prefix;

  /// Widget to display after the text input
  final Widget? suffix;

  /// MainAxisAlignment for the input field
  final MainAxisAlignment? mainAxisAlignment;

  /// CrossAxisAlignment for the input field
  final CrossAxisAlignment? crossAxisAlignment;

  /// Alignment for the placeholder
  final Alignment? placeholderAlignment;

  /// Padding for the input field
  final EdgeInsets? inputPadding;

  /// Gap between prefix/suffix and text
  final double? gap;

  /// Whether to always call onPressed
  final bool onPressedAlwaysCalled;

  MDInputFormField({
    super.key,
    required super.name,
    super.validator,
    String? initialValue,
    super.onChanged,
    super.valueTransformer,
    super.enabled,
    super.onSaved,
    super.autovalidateMode,
    super.onReset,
    super.focusNode,
    super.restorationId,
    super.errorBuilder,    
    this.readOnly = false,
    this.maxLines = 1,
    this.obscureText = false,
    this.textCapitalization = TextCapitalization.none,
    this.scrollPadding = const EdgeInsets.all(20.0),
    this.enableInteractiveSelection = true,
    this.maxLengthEnforcement,
    this.textAlign = TextAlign.start,
    this.autofocus = false,
    this.autocorrect = true,
    this.cursorWidth = 2.0,
    this.cursorHeight,
    this.keyboardType,
    this.style,
    this.controller,
    this.textInputAction,
    this.strutStyle,
    this.textDirection,
    this.maxLength,
    this.onEditingComplete,
    this.onSubmitted,
    this.inputFormatters,
    this.cursorRadius,
    this.cursorColor,
    this.keyboardAppearance,
    this.expands = false,
    this.minLines,
    this.showCursor,
    this.onPressed,
    this.enableSuggestions = false,
    this.dragStartBehavior = DragStartBehavior.start,
    this.scrollController,
    this.scrollPhysics,
    this.selectionWidthStyle = ui.BoxWidthStyle.tight,
    this.smartDashesType,
    this.smartQuotesType,
    this.selectionHeightStyle = ui.BoxHeightStyle.tight,
    this.autofillHints,
    this.obscuringCharacter = '•',
    this.contextMenuBuilder,
    this.magnifierConfiguration,
    this.decoration,
    this.enableIMEPersonalizedLearning = true,
    this.scribbleEnabled = true,
    this.contentInsertionConfiguration,
    this.placeholder,
    this.placeholderStyle,
    this.prefix,
    this.suffix,
    this.mainAxisAlignment,
    this.crossAxisAlignment,
    this.placeholderAlignment,
    this.inputPadding,
    this.gap,
    this.onPressedAlwaysCalled = false,
  })  : assert(maxLines == null || maxLines > 0),
        assert(minLines == null || minLines > 0),
        assert(
          (maxLines == null) || (minLines == null) || (maxLines >= minLines),
          "minLines can't be greater than maxLines",
        ),
        assert(
          !expands || (maxLines == null && minLines == null),
          'minLines and maxLines must be null when expands is true.',
        ),
        assert(!obscureText || maxLines == 1, 'Obscured fields cannot be multiline.'),
        assert(maxLength == null || maxLength > 0),
        assert(
          !identical(textInputAction, TextInputAction.newline) ||
              maxLines == 1 ||
              !identical(keyboardType, TextInputType.text),
          'Use keyboardType TextInputType.multiline when using TextInputAction.newline on a multiline TextField.',
        ),
        super(
          initialValue: controller != null ? controller.text : initialValue,
          builder: (FormFieldState<String?> field) {
            final state = field as _FormBuilderMDInputFieldState;

            Widget? finalSuffix = suffix;

            final fieldWidget = MDInput(
              restorationId: restorationId,
              controller: state._effectiveController,
              focusNode: state.effectiveFocusNode,
              decoration: decoration,
              keyboardType: keyboardType,
              textInputAction: textInputAction,
              style: style,
              strutStyle: strutStyle,
              textAlign: textAlign,
              textDirection: textDirection,
              textCapitalization: textCapitalization,
              autofocus: autofocus,
              readOnly: readOnly,
              showCursor: showCursor,
              obscureText: obscureText,
              autocorrect: autocorrect,
              enableSuggestions: enableSuggestions,
              placeholder: placeholder,
              placeholderStyle: placeholderStyle,
              placeholderAlignment: placeholderAlignment,
              maxLengthEnforcement: maxLengthEnforcement,
              maxLines: maxLines,
              minLines: minLines,
              expands: expands,
              maxLength: maxLength,
              onPressed: onPressed,
              onPressedAlwaysCalled: onPressedAlwaysCalled,
              onEditingComplete: onEditingComplete,
              onSubmitted: onSubmitted,
              inputFormatters: inputFormatters,
              enabled: state.enabled,
              cursorWidth: cursorWidth,
              cursorHeight: cursorHeight,
              cursorRadius: cursorRadius,
              cursorColor: cursorColor,
              scrollPadding: scrollPadding,
              keyboardAppearance: keyboardAppearance,
              enableInteractiveSelection: enableInteractiveSelection,
              dragStartBehavior: dragStartBehavior,
              scrollController: scrollController,
              scrollPhysics: scrollPhysics,
              selectionHeightStyle: selectionHeightStyle,
              selectionWidthStyle: selectionWidthStyle,
              smartDashesType: smartDashesType,
              smartQuotesType: smartQuotesType,
              contextMenuBuilder: contextMenuBuilder,
              obscuringCharacter: obscuringCharacter,
              autofillHints: autofillHints,
              magnifierConfiguration: magnifierConfiguration ?? TextMagnifierConfiguration.disabled,
              enableIMEPersonalizedLearning: enableIMEPersonalizedLearning,
              scribbleEnabled: scribbleEnabled,
              contentInsertionConfiguration: contentInsertionConfiguration,
              prefix: prefix,
              suffix: finalSuffix,
              mainAxisAlignment: mainAxisAlignment,
              crossAxisAlignment: crossAxisAlignment,
              inputPadding: inputPadding,
              gap: gap,
            );

            return fieldWidget;
          },
        );

  @override
  MDFormBuilderFieldState<MDInputFormField, String> createState() => _FormBuilderMDInputFieldState();
}

class _FormBuilderMDInputFieldState extends MDFormBuilderFieldState<MDInputFormField, String> {
  late TextEditingController _effectiveController;

  @override
  void initState() {
    super.initState();
    _effectiveController = widget.controller ?? TextEditingController(text: value);
    _effectiveController.addListener(_handleControllerChanged);
  }

    @override
  void reset() {
    super.reset();
    setState(() {
      _effectiveController.text = initialValue ?? '';
    });
  }

  @override
  void dispose() {
    _effectiveController.removeListener(_handleControllerChanged);
    if (widget.controller == null) {
      _effectiveController.dispose();
    }
    super.dispose();
  }

  @override
  void didUpdateWidget(MDInputFormField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != null && widget.controller != oldWidget.controller) {
      oldWidget.controller?.removeListener(_handleControllerChanged);
      _effectiveController = widget.controller!;
      _effectiveController.addListener(_handleControllerChanged);
    }
  }

  @override
  void didChange(String? value) {
    super.didChange(value);
    debugPrint('didChange: $value');
    if (value != _effectiveController.text) {
      _effectiveController.text = value ?? '';
    }
  }

  void _handleControllerChanged() {
    // Suppress changes that originated from within this class.
    //
    // In the case where a controller has been passed in to this widget, we
    // register this change listener. In these cases, we'll also receive change
    // notifications for changes originating from within this class -- for
    // example, the reset() method. In such cases, the FormField value will
    // already have been set.
    if (_effectiveController.text != (value ?? '')) {
      didChange(_effectiveController.text);
    }
  }

  
}
