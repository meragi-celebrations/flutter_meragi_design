import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

/// A wrapper around ShadSelect that provides a more consistent API for Meragi Design
class MDSelect<T> extends StatefulWidget {
  const MDSelect({
    super.key,
    this.options,
    this.optionsBuilder,
    this.selectedOptionBuilder,
    this.selectedOptionsBuilder,
    this.controller,
    this.enabled = true,
    this.placeholder,
    this.initialValue,
    this.initialValues = const [],
    this.onChanged,
    this.focusNode,
    this.closeOnTapOutside = true,
    this.minWidth,
    this.maxWidth,
    this.maxHeight,
    this.decoration,
    this.trailing,
    this.padding,
    this.optionsPadding,
    this.showScrollToBottomChevron,
    this.showScrollToTopChevron,
    this.scrollController,
    this.anchor,
    this.effects,
    this.shadows,
    this.filter,
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
        searchPlaceholder = null,
        searchInputPrefix = null,
        onMultipleChanged = null,
        searchPadding = null,
        search = null,
        clearSearchOnClose = false,
        assert(
          options != null || optionsBuilder != null,
          'Either options or optionsBuilder must be provided',
        ),
        assert(
          (selectedOptionBuilder != null) ^ (selectedOptionsBuilder != null),
          '''Either selectedOptionBuilder or selectedOptionsBuilder must be provided''',
        );

  const MDSelect.withSearch({
    super.key,
    this.options,
    this.optionsBuilder,
    this.selectedOptionBuilder,
    required ValueChanged<String> this.onSearchChanged,
    this.onChanged,
    this.controller,
    this.searchDivider,
    this.searchInputPrefix,
    this.searchPlaceholder,
    this.searchPadding,
    this.search,
    this.clearSearchOnClose,
    this.enabled = true,
    this.placeholder,
    this.initialValue,
    this.initialValues = const [],
    this.focusNode,
    this.closeOnTapOutside = true,
    this.minWidth,
    this.maxWidth,
    this.maxHeight,
    this.decoration,
    this.trailing,
    this.padding,
    this.optionsPadding,
    this.showScrollToBottomChevron,
    this.showScrollToTopChevron,
    this.scrollController,
    this.anchor,
    this.effects,
    this.shadows,
    this.filter,
    this.header,
    this.footer,
    this.closeOnSelect = true,
    this.allowDeselection = false,
    this.groupId,
    this.itemCount,
    this.shrinkWrap,
  })  : variant = MDSelectVariant.search,
        selectedOptionsBuilder = null,
        onMultipleChanged = null,
        assert(
          options != null || optionsBuilder != null,
          'Either options or optionsBuilder must be provided',
        );

  const MDSelect.multiple({
    super.key,
    this.options,
    this.optionsBuilder,
    required this.selectedOptionsBuilder,
    this.controller,
    this.enabled = true,
    this.placeholder,
    this.initialValues = const [],
    ValueChanged<List<T>>? onChanged,
    this.focusNode,
    this.closeOnTapOutside = true,
    this.minWidth,
    this.maxWidth,
    this.maxHeight,
    this.decoration,
    this.trailing,
    this.padding,
    this.optionsPadding,
    this.showScrollToBottomChevron,
    this.showScrollToTopChevron,
    this.scrollController,
    this.anchor,
    this.effects,
    this.shadows,
    this.filter,
    this.header,
    this.footer,
    this.allowDeselection = true,
    this.closeOnSelect = true,
    this.groupId,
    this.itemCount,
    this.shrinkWrap,
  })  : variant = MDSelectVariant.multiple,
        onSearchChanged = null,
        initialValue = null,
        selectedOptionBuilder = null,
        searchDivider = null,
        searchPlaceholder = null,
        searchInputPrefix = null,
        searchPadding = null,
        search = null,
        clearSearchOnClose = false,
        onChanged = null,
        onMultipleChanged = onChanged,
        assert(
          options != null || optionsBuilder != null,
          'Either options or optionsBuilder must be provided',
        );

  const MDSelect.multipleWithSearch({
    super.key,
    this.options,
    this.optionsBuilder,
    required ValueChanged<String> this.onSearchChanged,
    required this.selectedOptionsBuilder,
    ValueChanged<List<T>>? onChanged,
    this.controller,
    this.searchDivider,
    this.searchInputPrefix,
    this.searchPlaceholder,
    this.searchPadding,
    this.search,
    this.clearSearchOnClose,
    this.enabled = true,
    this.placeholder,
    this.initialValues = const [],
    this.focusNode,
    this.closeOnTapOutside = true,
    this.minWidth,
    this.maxWidth,
    this.maxHeight,
    this.decoration,
    this.trailing,
    this.padding,
    this.optionsPadding,
    this.showScrollToBottomChevron,
    this.showScrollToTopChevron,
    this.scrollController,
    this.anchor,
    this.effects,
    this.shadows,
    this.filter,
    this.header,
    this.footer,
    this.allowDeselection = true,
    this.closeOnSelect = true,
    this.groupId,
    this.itemCount,
    this.shrinkWrap,
  })  : variant = MDSelectVariant.multipleWithSearch,
        selectedOptionBuilder = null,
        onChanged = null,
        onMultipleChanged = onChanged,
        initialValue = null,
        assert(
          options != null || optionsBuilder != null,
          'Either options or optionsBuilder must be provided',
        );

  /// The callback that is called when the value of the [MDSelect] changes.
  final ValueChanged<T?>? onChanged;

  /// The callback that is called when the values of the [MDSelect] changes.
  /// Called only when the variant is [MDSelect.multiple].
  final ValueChanged<List<T>>? onMultipleChanged;

  /// Whether the [MDSelect] allows deselection, defaults to `false`.
  final bool allowDeselection;

  /// Whether the [MDSelect] is enabled, defaults to true.
  final bool enabled;

  /// The initial value of the [MDSelect], defaults to `null`.
  final T? initialValue;

  /// The initial values of the [MDSelect], defaults to `[]`.
  final List<T> initialValues;

  /// The placeholder of the [MDSelect], displayed when the value is null.
  final Widget? placeholder;

  /// The builder for the selected option of the [MDSelect].
  final ShadSelectedOptionBuilder<T>? selectedOptionBuilder;

  /// The builder for the selected options of the [MDSelect].
  final ShadSelectedOptionBuilder<List<T>>? selectedOptionsBuilder;

  /// The options of the [MDSelect].
  final Iterable<Widget>? options;

  /// The builder for the options of the [MDSelect].
  final Widget? Function(BuildContext, int)? optionsBuilder;

  /// The focus node of the [MDSelect].
  final FocusNode? focusNode;

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

  /// The type of the [MDSelect].
  final MDSelectVariant variant;

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

  /// The effects of the [MDSelect].
  final List<Effect>? effects;

  /// The shadows of the [MDSelect].
  final List<BoxShadow>? shadows;

  /// The filter of the [MDSelect].
  final ImageFilter? filter;

  /// The controller of the [MDSelect].
  final ShadPopoverController? controller;

  /// The header of the [MDSelect].
  final Widget? header;

  /// The footer of the [MDSelect].
  final Widget? footer;

  /// Whether to close the [MDSelect] when a value is selected.
  final bool closeOnSelect;

  /// The group ID of the [MDSelect].
  final Object? groupId;

  /// The number of items in the options.
  final int? itemCount;

  /// Whether the options should shrink wrap.
  final bool? shrinkWrap;

  @override
  State<MDSelect<T>> createState() => _MDSelectState<T>();
}

enum MDSelectVariant {
  primary,
  search,
  multiple,
  multipleWithSearch,
}

class _MDSelectState<T> extends State<MDSelect<T>> {
  @override
  Widget build(BuildContext context) {
    switch (widget.variant) {
      case MDSelectVariant.primary:
        return ShadSelect<T>(
          options: widget.options,
          optionsBuilder: widget.optionsBuilder,
          selectedOptionBuilder: widget.selectedOptionBuilder,
          controller: widget.controller,
          enabled: widget.enabled,
          placeholder: widget.placeholder,
          initialValue: widget.initialValue,
          initialValues: widget.initialValues,
          onChanged: widget.onChanged,
          focusNode: widget.focusNode,
          closeOnTapOutside: widget.closeOnTapOutside,
          minWidth: widget.minWidth,
          maxWidth: widget.maxWidth,
          maxHeight: widget.maxHeight,
          decoration: widget.decoration,
          trailing: widget.trailing,
          padding: widget.padding,
          optionsPadding: widget.optionsPadding,
          showScrollToBottomChevron: widget.showScrollToBottomChevron,
          showScrollToTopChevron: widget.showScrollToTopChevron,
          scrollController: widget.scrollController,
          anchor: widget.anchor,
          effects: widget.effects,
          shadows: widget.shadows,
          filter: widget.filter,
          header: widget.header,
          footer: widget.footer,
          closeOnSelect: widget.closeOnSelect,
          allowDeselection: widget.allowDeselection,
          groupId: widget.groupId,
          itemCount: widget.itemCount,
          shrinkWrap: widget.shrinkWrap,
        );
      case MDSelectVariant.search:
        return ShadSelect<T>.withSearch(
          options: widget.options,
          optionsBuilder: widget.optionsBuilder,
          selectedOptionBuilder: widget.selectedOptionBuilder,
          onSearchChanged: widget.onSearchChanged!,
          controller: widget.controller,
          searchDivider: widget.searchDivider,
          searchInputPrefix: widget.searchInputPrefix,
          searchPlaceholder: widget.searchPlaceholder,
          searchPadding: widget.searchPadding,
          search: widget.search,
          clearSearchOnClose: widget.clearSearchOnClose,
          enabled: widget.enabled,
          placeholder: widget.placeholder,
          initialValue: widget.initialValue,
          initialValues: widget.initialValues,
          onChanged: widget.onChanged,
          focusNode: widget.focusNode,
          closeOnTapOutside: widget.closeOnTapOutside,
          minWidth: widget.minWidth,
          maxWidth: widget.maxWidth,
          maxHeight: widget.maxHeight,
          decoration: widget.decoration,
          trailing: widget.trailing,
          padding: widget.padding,
          optionsPadding: widget.optionsPadding,
          showScrollToBottomChevron: widget.showScrollToBottomChevron,
          showScrollToTopChevron: widget.showScrollToTopChevron,
          scrollController: widget.scrollController,
          anchor: widget.anchor,
          effects: widget.effects,
          shadows: widget.shadows,
          filter: widget.filter,
          header: widget.header,
          footer: widget.footer,
          closeOnSelect: widget.closeOnSelect,
          allowDeselection: widget.allowDeselection,
          groupId: widget.groupId,
          itemCount: widget.itemCount,
          shrinkWrap: widget.shrinkWrap,
        );
      case MDSelectVariant.multiple:
        return ShadSelect<T>.multiple(
          options: widget.options,
          optionsBuilder: widget.optionsBuilder,
          selectedOptionsBuilder: widget.selectedOptionsBuilder!,
          controller: widget.controller,
          enabled: widget.enabled,
          placeholder: widget.placeholder,
          initialValues: widget.initialValues,
          onChanged: widget.onMultipleChanged,
          focusNode: widget.focusNode,
          closeOnTapOutside: widget.closeOnTapOutside,
          minWidth: widget.minWidth,
          maxWidth: widget.maxWidth,
          maxHeight: widget.maxHeight,
          decoration: widget.decoration,
          trailing: widget.trailing,
          padding: widget.padding,
          optionsPadding: widget.optionsPadding,
          showScrollToBottomChevron: widget.showScrollToBottomChevron,
          showScrollToTopChevron: widget.showScrollToTopChevron,
          scrollController: widget.scrollController,
          anchor: widget.anchor,
          effects: widget.effects,
          shadows: widget.shadows,
          filter: widget.filter,
          header: widget.header,
          footer: widget.footer,
          allowDeselection: widget.allowDeselection,
          closeOnSelect: widget.closeOnSelect,
          groupId: widget.groupId,
          itemCount: widget.itemCount,
          shrinkWrap: widget.shrinkWrap,
        );
      case MDSelectVariant.multipleWithSearch:
        return ShadSelect<T>.multipleWithSearch(
          options: widget.options,
          optionsBuilder: widget.optionsBuilder,
          onSearchChanged: widget.onSearchChanged!,
          selectedOptionsBuilder: widget.selectedOptionsBuilder!,
          onChanged: widget.onMultipleChanged,
          controller: widget.controller,
          searchDivider: widget.searchDivider,
          searchInputPrefix: widget.searchInputPrefix,
          searchPlaceholder: widget.searchPlaceholder,
          searchPadding: widget.searchPadding,
          search: widget.search,
          clearSearchOnClose: widget.clearSearchOnClose,
          enabled: widget.enabled,
          placeholder: widget.placeholder,
          initialValues: widget.initialValues,
          focusNode: widget.focusNode,
          closeOnTapOutside: widget.closeOnTapOutside,
          minWidth: widget.minWidth,
          maxWidth: widget.maxWidth,
          maxHeight: widget.maxHeight,
          decoration: widget.decoration,
          trailing: widget.trailing,
          padding: widget.padding,
          optionsPadding: widget.optionsPadding,
          showScrollToBottomChevron: widget.showScrollToBottomChevron,
          showScrollToTopChevron: widget.showScrollToTopChevron,
          scrollController: widget.scrollController,
          anchor: widget.anchor,
          effects: widget.effects,
          shadows: widget.shadows,
          filter: widget.filter,
          header: widget.header,
          footer: widget.footer,
          allowDeselection: widget.allowDeselection,
          closeOnSelect: widget.closeOnSelect,
          groupId: widget.groupId,
          itemCount: widget.itemCount,
          shrinkWrap: widget.shrinkWrap,
        );
    }
  }

  ShadSelectVariant _convertVariant(MDSelectVariant variant) {
    switch (variant) {
      case MDSelectVariant.primary:
        return ShadSelectVariant.primary;
      case MDSelectVariant.search:
        return ShadSelectVariant.search;
      case MDSelectVariant.multiple:
        return ShadSelectVariant.multiple;
      case MDSelectVariant.multipleWithSearch:
        return ShadSelectVariant.multipleWithSearch;
    }
  }
}

/// A wrapper around ShadOption that provides a more consistent API for Meragi Design
class MDOption<T> extends StatelessWidget {
  const MDOption({
    super.key,
    required this.value,
    required this.child,
    this.hoveredBackgroundColor,
    this.padding,
    this.selectedIcon,
    this.radius,
  });

  /// The value of the [MDOption].
  final T value;

  /// The child widget.
  final Widget child;

  /// The background color of the [MDOption] when hovered.
  final Color? hoveredBackgroundColor;

  /// The padding of the [MDOption].
  final EdgeInsets? padding;

  /// The icon of the [MDOption] when selected.
  final Widget? selectedIcon;

  /// The radius of the [MDOption].
  final BorderRadius? radius;

  @override
  Widget build(BuildContext context) {
    return ShadOption<T>(
      value: value,
      child: child,
      hoveredBackgroundColor: hoveredBackgroundColor,
      padding: padding,
      selectedIcon: selectedIcon,
      radius: radius,
    );
  }
}
