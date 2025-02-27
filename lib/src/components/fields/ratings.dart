import 'package:flutter/material.dart';
import 'package:flutter_meragi_design/flutter_meragi_design.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class MDRating extends StatelessWidget {
  const MDRating({
    Key? key,
    required this.value,
    this.onValueChanged,
    this.starSize = 20,
    this.starColor,
    this.starBuilder,
    this.iconType = IconType.filled,
  }) : super(key: key);

  final double value;
  final ValueChanged<double>? onValueChanged;
  final double starSize;
  final Color? starColor;
  final Widget Function(int, Color?)? starBuilder;
  final IconType iconType;

  @override
  Widget build(BuildContext context) {
    return RatingStars(
      value: value,
      onValueChanged: onValueChanged,
      animationDuration: const Duration(milliseconds: 500),
      maxValueVisibility: false,
      valueLabelVisibility: false,
      starColor: starColor ?? context.theme.colors.accent,
      starSize: starSize,
      starBuilder: (index, color) {
        return starBuilder?.call(index, color) ??
            Icon(
              iconType == IconType.filled
                  ? PhosphorIconsFill.star
                  : PhosphorIconsRegular.star,
              color: color,
              size: starSize,
            );
      },
    );
  }
}

enum IconType {
  filled,
  outline,
}
