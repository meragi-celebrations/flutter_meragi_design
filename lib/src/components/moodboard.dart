import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_meragi_design/flutter_meragi_design.dart';
import 'package:flutter_scatter/flutter_scatter.dart';

class MDMoodboard extends StatelessWidget {
  final List<Widget> children;
  final BoxConstraints? constraints;
  final bool fillGaps;
  const MDMoodboard(
      {super.key,
      required this.children,
      this.constraints,
      this.fillGaps = false});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: constraints ?? const BoxConstraints(),
        child: Scatter(
          delegate: FermatSpiralScatterDelegate(
            a: .5,
            b: 15,
            step: 1 / children.length,
          ),
          fillGaps: fillGaps,
          clipBehavior: Clip.hardEdge,
          children: children,
        ),
      ),
    );
  }
}

class MDMoodboardItem extends StatefulWidget {
  final Widget child;
  final int childrenCount;
  final double maxParentWidth;
  const MDMoodboardItem({
    super.key,
    required this.child,
    required this.childrenCount,
    this.maxParentWidth = 1200,
  });

  @override
  State<MDMoodboardItem> createState() => _MDMoodboardItemState();
}

class _MDMoodboardItemState extends State<MDMoodboardItem> {
  late double maxWidth;
  late int columns;
  late double itemWidth;

  @override
  void initState() {
    super.initState();
    maxWidth = widget.maxParentWidth;
    double minCol = 4;
    double maxCol = 8;
    minCol = math.max(4, (widget.childrenCount / 25) * 8);
    maxCol = math.min(8, (widget.childrenCount / 25) * 8 + 4);
    columns = getResponsiveColumnCount(maxWidth, minCol, maxCol);
    itemWidth = maxWidth / columns;
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: itemWidth),
      child: widget.child,
    );
  }
}
