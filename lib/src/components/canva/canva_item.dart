import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_meragi_design/src/components/canva/items/base.dart';
import 'package:flutter_meragi_design/src/components/canva/scaling.dart';

class CanvasItemWidget extends StatelessWidget {
  const CanvasItemWidget({
    super.key,
    required this.item,
    required this.canvasSize,
    required this.isSelected,
    required this.scale,
  });

  final CanvasItem item;
  final CanvasScaleHandler scale;
  final Size canvasSize;
  final bool isSelected;

  double get _radians => item.rotationDeg * math.pi / 180.0;

  @override
  Widget build(BuildContext context) {
    final posRender = scale.baseToRender(item.position);
    final sizeRender = scale.baseToRenderSize(item.size);

    return Positioned(
      left: posRender.dx,
      top: posRender.dy,
      width: sizeRender.width,
      height: sizeRender.height,
      child: Transform.rotate(
        angle: _radians,
        alignment: Alignment.center,
        child: SizedBox.expand(
          child: item.buildContent(scale),
        ),
      ),
    );
  }
}
