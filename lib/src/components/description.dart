import 'dart:ui';

import 'package:flutter/material.dart';

/// A widget to display a list of key-value pairs in a responsive grid
///
/// The widget will layout the items in a grid with the specified number of
/// columns. The width of each item is calculated based on the available width
/// and the number of columns. The spacing between items is also customizable.
///
/// The [direction] parameter controls the direction of the grid. If set to
/// [Axis.horizontal], the items will be laid out horizontally. If set to
/// [Axis.vertical], the items will be laid out vertically.
///
/// The [spacingBetweenItem] parameter controls the spacing between items.
///
/// The [spacingBetweenKeyAndValue] parameter controls the spacing between the key
/// and value of each item.
class MDDescription extends StatelessWidget {
  /// The list of key-value pairs to display
  final List<DescriptionItem> data;

  /// The minimum number of columns to display
  final int minColumns;

  /// The maximum number of columns to display
  final int maxColumns;

  /// The direction of the grid
  final Axis direction;

  /// The spacing between items
  final double spacingBetweenItem;

  /// The spacing between the key and value of each item
  final double spacingBetweenKeyAndValue;

  const MDDescription({
    required this.data,
    this.minColumns = 1,
    this.maxColumns = 3,
    this.direction = Axis.horizontal,
    this.spacingBetweenItem = 5,
    this.spacingBetweenKeyAndValue = 3,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final columns = lerpDouble(minColumns.toDouble(), maxColumns.toDouble(),
            (screenWidth / 800).clamp(0, 1))!
        .toInt();

    return LayoutBuilder(
      builder: (context, constraints) {
        final itemWidth = constraints.maxWidth / columns;

        return Wrap(
          runSpacing: spacingBetweenItem,
          children: data.map((item) {
            return SizedBox(
              width: itemWidth,
              child: Wrap(
                spacing: spacingBetweenKeyAndValue,
                direction: direction,
                children: [
                  item.label,
                  item.value,
                ],
              ),
            );
          }).toList(),
        );
      },
    );
  }
}

/// A single key-value pair to display in a [MDDescription]
class DescriptionItem {
  /// The label of the item
  final Widget label;

  /// The value of the item
  final Widget value;

  const DescriptionItem({required this.label, required this.value});
}
