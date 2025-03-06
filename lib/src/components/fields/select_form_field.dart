import 'dart:ui' as ui show ImageFilter;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_meragi_design/flutter_meragi_design.dart';
import 'package:flutter_meragi_design/src/components/fields/form_builder_field.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class MDSelectFormField<T> extends MDFormBuilderField<T> {
  /// The options of the [MDSelect].
  final Iterable<Widget>? options;

  /// The builder for the options of the [MDSelect].
  final Widget? Function(BuildContext, int)? optionsBuilder;

  /// The builder for the selected option of the [MDSelect].
  final ShadSelectedOptionBuilder<T>? selectedOptionBuilder;

  /// The builder for the selected options of the [MDSelect].
  final ShadSelectedOptionBuilder<List<T>>? selectedOptionsBuilder;

  /// The placeholder of the [MDSelect], displayed when the value is null.
  final Widget? placeholder;

  final String? placeholderText;

  /// Whether to close the [MDSelect] when the user taps outside of it,
  /// defaults to `true`.
  final bool closeOnTapOutside;

  /// The minimum width of the [MDSelect].
  final double? minWidth;

  /// The maximum width of the [MDSelect].
  final double? maxWidth;

  /// The maximum height of the [MDSelect].
  final double? maxHeight;

  /// The decoration of the [MDSelect].
  final ShadDecoration? decoration;

  /// The trailing widget of the [MDSelect].
  final Widget? trailing;

  /// The padding of the [MDSelect].
  final EdgeInsets? padding;

  /// The padding of the options of the [MDSelect].
  final EdgeInsets? optionsPadding;

  /// Whether to show the scroll-to-top chevron.
  final bool? showScrollToTopChevron;

  /// Whether to show the scroll-to-bottom chevron.
  final bool? showScrollToBottomChevron;

  /// The scroll controller of the [MDSelect].
  final ScrollController? scrollController;

  /// The anchor of the [MDSelect].
  final ShadAnchorBase? anchor;

  /// The effects of the [MDSelect].
  final List<Effect>? effects;

  /// The shadows of the [MDSelect].
  final List<BoxShadow>? shadows;

  /// The filter of the [MDSelect].
  final ui.ImageFilter? filter;

  /// The controller of the [MDSelect].
  final ShadPopoverController? controller;

  /// The header of the [MDSelect].
  final Widget? header;

  /// The footer of the [MDSelect].
  final Widget? footer;

  /// Whether to close the [MDSelect] when a value is selected.
  final bool closeOnSelect;

  /// Whether to allow deselection.
  final bool allowDeselection;

  /// The group ID of the [MDSelect].
  final Object? groupId;

  /// The number of items in the options.
  final int? itemCount;

  /// Whether the options should shrink wrap.
  final bool? shrinkWrap;

  /// The callback that is called when the search value changes.
  final ValueChanged<String>? onSearchChanged;

  /// The widget that is displayed between the search input and the options.
  final Widget? searchDivider;

  /// The prefix of the search input.
  final Widget? searchInputPrefix;

  /// The placeholder of the search input.
  final Widget? searchPlaceholder;

  /// The padding of the search input.
  final EdgeInsets? searchPadding;

  /// A complete customizable search input.
  final Widget? search;

  /// Whether to clear the search input when the popover is closed.
  final bool? clearSearchOnClose;

  /// The type of the [MDSelect].
  final MDSelectVariant variant;

  MDSelectFormField({
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
    this.options,
    this.optionsBuilder,
    this.selectedOptionBuilder,
    this.selectedOptionsBuilder,
    this.placeholder,
    this.placeholderText,
    this.closeOnTapOutside = true,
    this.minWidth,
    this.maxWidth,
    this.maxHeight,
    this.decoration,
    this.trailing,
    this.padding,
    this.optionsPadding,
    this.showScrollToTopChevron,
    this.showScrollToBottomChevron,
    this.scrollController,
    this.anchor,
    this.effects,
    this.shadows,
    this.filter,
    this.controller,
    this.header,
    this.footer,
    this.closeOnSelect = true,
    this.allowDeselection = false,
    this.groupId,
    this.itemCount,
    this.shrinkWrap,
  })  : variant = MDSelectVariant.primary,
        onSearchChanged = null,
        searchDivider = null,
        searchInputPrefix = null,
        searchPlaceholder = null,
        searchPadding = null,
        search = null,
        clearSearchOnClose = false,
        super(
          builder: (FormFieldState<T?> field) {
            final state = field as _MDSelectFormFieldState<T>;

            return MDSelect<T>(
              options: options,
              optionsBuilder: optionsBuilder,
              selectedOptionBuilder: selectedOptionBuilder,
              controller: controller,
              enabled: state.enabled,
              placeholder: placeholder,
              placeholderText: placeholderText,
              initialValue: state.value,
              onChanged: (value) {
                if (state.enabled) {
                  state.didChange(value);
                }
                if (onChanged != null) {
                  onChanged(value);
                }
              },
              focusNode: state.effectiveFocusNode,
              closeOnTapOutside: closeOnTapOutside,
              minWidth: minWidth,
              maxWidth: maxWidth,
              maxHeight: maxHeight,
              decoration: decoration,
              trailing: trailing,
              padding: padding,
              optionsPadding: optionsPadding,
              showScrollToBottomChevron: showScrollToBottomChevron,
              showScrollToTopChevron: showScrollToTopChevron,
              scrollController: scrollController,
              anchor: anchor,
              effects: effects,
              shadows: shadows,
              filter: filter,
              header: header,
              footer: footer,
              closeOnSelect: closeOnSelect,
              allowDeselection: allowDeselection,
              groupId: groupId,
              itemCount: itemCount,
              shrinkWrap: shrinkWrap,
            );
          },
        );

  MDSelectFormField.withSearch({
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
    required ValueChanged<String> this.onSearchChanged,
    this.options,
    this.optionsBuilder,
    this.selectedOptionBuilder,
    this.searchDivider,
    this.searchInputPrefix,
    this.searchPlaceholder,
    this.searchPadding,
    this.search,
    this.clearSearchOnClose,
    this.placeholder,
    this.placeholderText,
    this.closeOnTapOutside = true,
    this.minWidth,
    this.maxWidth,
    this.maxHeight,
    this.decoration,
    this.trailing,
    this.padding,
    this.optionsPadding,
    this.showScrollToTopChevron,
    this.showScrollToBottomChevron,
    this.scrollController,
    this.anchor,
    this.effects,
    this.shadows,
    this.filter,
    this.controller,
    this.header,
    this.footer,
    this.closeOnSelect = true,
    this.allowDeselection = false,
    this.groupId,
    this.itemCount,
    this.shrinkWrap,
  })  : variant = MDSelectVariant.search,
        selectedOptionsBuilder = null,
        super(
          builder: (FormFieldState<T?> field) {
            final state = field as _MDSelectFormFieldState<T>;

            return MDSelect<T>.withSearch(
              options: options,
              optionsBuilder: optionsBuilder,
              selectedOptionBuilder: selectedOptionBuilder,
              onSearchChanged: onSearchChanged,
              controller: controller,
              focusNode: state.effectiveFocusNode,
              searchDivider: searchDivider,
              searchInputPrefix: searchInputPrefix,
              searchPlaceholder: searchPlaceholder,
              searchPadding: searchPadding,
              search: search,
              clearSearchOnClose: clearSearchOnClose,
              enabled: state.enabled,
              placeholder: placeholder,
              placeholderText: placeholderText,
              initialValue: state.value,
              onChanged: (value) {
                if (state.enabled) {
                  state.didChange(value);
                }
                if (onChanged != null) {
                  onChanged(value);
                }
              },
              closeOnTapOutside: closeOnTapOutside,
              minWidth: minWidth,
              maxWidth: maxWidth,
              maxHeight: maxHeight,
              decoration: decoration,
              trailing: trailing,
              padding: padding,
              optionsPadding: optionsPadding,
              showScrollToBottomChevron: showScrollToBottomChevron,
              showScrollToTopChevron: showScrollToTopChevron,
              scrollController: scrollController,
              anchor: anchor,
              effects: effects,
              shadows: shadows,
              filter: filter,
              header: header,
              footer: footer,
              closeOnSelect: closeOnSelect,
              allowDeselection: allowDeselection,
              groupId: groupId,
              itemCount: itemCount,
              shrinkWrap: shrinkWrap,
            );
          },
        );

  @override
  MDFormBuilderFieldState<MDSelectFormField<T>, T> createState() => _MDSelectFormFieldState<T>();
}

class _MDSelectFormFieldState<T> extends MDFormBuilderFieldState<MDSelectFormField<T>, T> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void reset() {
    super.reset();
  }
}

class MDMultipleSelectFormField<T> extends MDFormBuilderField<List<T>> {
  /// The options of the [MDSelect].
  final Iterable<Widget>? options;

  /// The builder for the options of the [MDSelect].
  final Widget? Function(BuildContext, int)? optionsBuilder;

  /// The builder for the selected options of the [MDSelect].
  final ShadSelectedOptionBuilder<List<T>>? selectedOptionsBuilder;

  /// The placeholder of the [MDSelect], displayed when the value is null.
  final Widget? placeholder;

  final String? placeholderText;

  /// Whether to close the [MDSelect] when the user taps outside of it,
  /// defaults to `true`.
  final bool closeOnTapOutside;

  /// The minimum width of the [MDSelect].
  final double? minWidth;

  /// The maximum width of the [MDSelect].
  final double? maxWidth;

  /// The maximum height of the [MDSelect].
  final double? maxHeight;

  /// The decoration of the [MDSelect].
  final ShadDecoration? decoration;

  /// The trailing widget of the [MDSelect].
  final Widget? trailing;

  /// The padding of the [MDSelect].
  final EdgeInsets? padding;

  /// The padding of the options of the [MDSelect].
  final EdgeInsets? optionsPadding;

  /// Whether to show the scroll-to-top chevron.
  final bool? showScrollToTopChevron;

  /// Whether to show the scroll-to-bottom chevron.
  final bool? showScrollToBottomChevron;

  /// The scroll controller of the [MDSelect].
  final ScrollController? scrollController;

  /// The anchor of the [MDSelect].
  final ShadAnchorBase? anchor;

  /// The effects of the [MDSelect].
  final List<Effect>? effects;

  /// The shadows of the [MDSelect].
  final List<BoxShadow>? shadows;

  /// The filter of the [MDSelect].
  final ui.ImageFilter? filter;

  /// The controller of the [MDSelect].
  final ShadPopoverController? controller;

  /// The header of the [MDSelect].
  final Widget? header;

  /// The footer of the [MDSelect].
  final Widget? footer;

  /// Whether to close the [MDSelect] when a value is selected.
  final bool closeOnSelect;

  /// Whether to allow deselection.
  final bool allowDeselection;

  /// The group ID of the [MDSelect].
  final Object? groupId;

  /// The number of items in the options.
  final int? itemCount;

  /// Whether the options should shrink wrap.
  final bool? shrinkWrap;

  /// The callback that is called when the search value changes.
  final ValueChanged<String>? onSearchChanged;

  /// The widget that is displayed between the search input and the options.
  final Widget? searchDivider;

  /// The prefix of the search input.
  final Widget? searchInputPrefix;

  /// The placeholder of the search input.
  final Widget? searchPlaceholder;

  /// The padding of the search input.
  final EdgeInsets? searchPadding;

  /// A complete customizable search input.
  final Widget? search;

  /// Whether to clear the search input when the popover is closed.
  final bool? clearSearchOnClose;

  /// The type of the [MDSelect].
  final MDSelectVariant variant;

  MDMultipleSelectFormField({
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
    required this.selectedOptionsBuilder,
    this.options,
    this.optionsBuilder,
    this.placeholder,
    this.placeholderText,
    this.closeOnTapOutside = true,
    this.minWidth,
    this.maxWidth,
    this.maxHeight,
    this.decoration,
    this.trailing,
    this.padding,
    this.optionsPadding,
    this.showScrollToTopChevron,
    this.showScrollToBottomChevron,
    this.scrollController,
    this.anchor,
    this.effects,
    this.shadows,
    this.filter,
    this.controller,
    this.header,
    this.footer,
    this.allowDeselection = true,
    this.closeOnSelect = false,
    this.groupId,
    this.itemCount,
    this.shrinkWrap,
  })  : variant = MDSelectVariant.multiple,
        onSearchChanged = null,
        searchDivider = null,
        searchInputPrefix = null,
        searchPlaceholder = null,
        searchPadding = null,
        search = null,
        clearSearchOnClose = false,
        super(
          builder: (FormFieldState<List<T>?> field) {
            final state = field as _MDMultipleSelectFormFieldState<T>;

            return MDSelect<T>.multiple(
              options: options,
              optionsBuilder: optionsBuilder,
              selectedOptionsBuilder: selectedOptionsBuilder!,
              controller: controller,
              enabled: state.enabled,
              placeholder: placeholder,
              placeholderText: placeholderText,
              initialValues: state.value ?? [],
              onChanged: (values) {
                if (state.enabled) {
                  state.didChange(values);
                }
                if (onChanged != null) {
                  onChanged(values);
                }
              },
              focusNode: state.effectiveFocusNode,
              closeOnTapOutside: closeOnTapOutside,
              minWidth: minWidth,
              maxWidth: maxWidth,
              maxHeight: maxHeight,
              decoration: decoration,
              trailing: trailing,
              padding: padding,
              optionsPadding: optionsPadding,
              showScrollToBottomChevron: showScrollToBottomChevron,
              showScrollToTopChevron: showScrollToTopChevron,
              scrollController: scrollController,
              anchor: anchor,
              effects: effects,
              shadows: shadows,
              filter: filter,
              header: header,
              footer: footer,
              allowDeselection: allowDeselection,
              closeOnSelect: closeOnSelect,
              groupId: groupId,
              itemCount: itemCount,
              shrinkWrap: shrinkWrap,
            );
          },
        );

  MDMultipleSelectFormField.withSearch({
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
    required ValueChanged<String> this.onSearchChanged,
    required this.selectedOptionsBuilder,
    this.options,
    this.optionsBuilder,
    this.searchDivider,
    this.searchInputPrefix,
    this.searchPlaceholder,
    this.searchPadding,
    this.search,
    this.clearSearchOnClose,
    this.placeholder,
    this.placeholderText,
    this.closeOnTapOutside = true,
    this.minWidth,
    this.maxWidth,
    this.maxHeight,
    this.decoration,
    this.trailing,
    this.padding,
    this.optionsPadding,
    this.showScrollToTopChevron,
    this.showScrollToBottomChevron,
    this.scrollController,
    this.anchor,
    this.effects,
    this.shadows,
    this.filter,
    this.controller,
    this.header,
    this.footer,
    this.allowDeselection = true,
    this.closeOnSelect = false,
    this.groupId,
    this.itemCount,
    this.shrinkWrap,
  })  : variant = MDSelectVariant.multipleWithSearch,
        super(
          builder: (FormFieldState<List<T>?> field) {
            final state = field as _MDMultipleSelectFormFieldState<T>;

            return MDSelect<T>.multipleWithSearch(
              options: options,
              optionsBuilder: optionsBuilder,
              onSearchChanged: onSearchChanged,
              selectedOptionsBuilder: selectedOptionsBuilder!,
              onChanged: (values) {
                if (state.enabled) {
                  state.didChange(values);
                }
                if (onChanged != null) {
                  onChanged(values);
                }
              },
              controller: controller,
              searchDivider: searchDivider,
              searchInputPrefix: searchInputPrefix,
              searchPlaceholder: searchPlaceholder,
              searchPadding: searchPadding,
              search: search,
              clearSearchOnClose: clearSearchOnClose,
              enabled: state.enabled,
              placeholder: placeholder,
              placeholderText: placeholderText,
              initialValues: state.value ?? [],
              focusNode: state.effectiveFocusNode,
              closeOnTapOutside: closeOnTapOutside,
              minWidth: minWidth,
              maxWidth: maxWidth,
              maxHeight: maxHeight,
              decoration: decoration,
              trailing: trailing,
              padding: padding,
              optionsPadding: optionsPadding,
              showScrollToBottomChevron: showScrollToBottomChevron,
              showScrollToTopChevron: showScrollToTopChevron,
              scrollController: scrollController,
              anchor: anchor,
              effects: effects,
              shadows: shadows,
              filter: filter,
              header: header,
              footer: footer,
              allowDeselection: allowDeselection,
              closeOnSelect: closeOnSelect,
              groupId: groupId,
              itemCount: itemCount,
              shrinkWrap: shrinkWrap,
            );
          },
        );

  @override
  MDFormBuilderFieldState<MDMultipleSelectFormField<T>, List<T>> createState() => _MDMultipleSelectFormFieldState<T>();
}

class _MDMultipleSelectFormFieldState<T> extends MDFormBuilderFieldState<MDMultipleSelectFormField<T>, List<T>> {  
  @override
  void initState() {
    super.initState();
    effectiveFocusNode = widget.focusNode ?? FocusNode(debugLabel: widget.name);
  }

  @override
  void reset() {
    super.reset();
  }
}
