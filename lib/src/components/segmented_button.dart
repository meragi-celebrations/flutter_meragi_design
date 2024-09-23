import 'package:flutter/material.dart';
import 'package:flutter_meragi_design/flutter_meragi_design.dart';

class MDSegmentedButton<T> extends StatelessWidget {
  const MDSegmentedButton({
    Key? key,
    required this.segments,
    required this.selected,
    this.onSelectionChanged,
    this.multiSelectionEnabled = false,
    this.emptySelectionAllowed = false,
    this.expandedInsets,
    this.style,
    this.showSelectedIcon = true,
    this.selectedIcon,
  }) : super(key: key);

  final List<ButtonSegment<T>> segments;
  final Set<T> selected;
  final void Function(Set<T>)? onSelectionChanged;
  final bool multiSelectionEnabled;
  final bool emptySelectionAllowed;
  final EdgeInsets? expandedInsets;
  final ButtonStyle? style;
  final bool showSelectedIcon;
  final Icon? selectedIcon;

  @override
  Widget build(BuildContext context) {
    // var finalStyle = ButtonStyle(shape: ).merge(style);
    return SegmentedButton<T>(
      segments: segments,
      selected: selected,
      onSelectionChanged: onSelectionChanged,
      multiSelectionEnabled: multiSelectionEnabled,
      emptySelectionAllowed: emptySelectionAllowed,
      expandedInsets: expandedInsets,
      style: ButtonStyle(
        shape: WidgetStatePropertyAll<OutlinedBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(MeragiTheme.of(context).token.rgBorderRadius),
            ),
          ),
        ),
      ).merge(style),
      showSelectedIcon: showSelectedIcon,
      selectedIcon: selectedIcon,
    );
  }
}
