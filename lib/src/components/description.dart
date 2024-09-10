import 'dart:ui';

import 'package:flutter/material.dart';

class MDDescription extends StatelessWidget {
  final List<DescriptionItem> data;
  final int minColumns;
  final int maxColumns;
  final Axis direction;
  final double spacingBetweenItem;
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

class DescriptionItem {
  final Widget label;
  final Widget value;

  const DescriptionItem({required this.label, required this.value});
}
