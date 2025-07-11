import 'package:flutter/widgets.dart';
import 'package:flutter_meragi_design/src/extensions/context.dart';
import 'package:flutter_meragi_design/src/theme/components/app_colors.dart';
import 'package:flutter_meragi_design/src/theme/components/dimensions.dart';
import 'package:flutter_meragi_design/src/theme/components/typography.dart';
import 'package:flutter_meragi_design/src/theme/extensions/colors.dart';
import 'package:flutter_meragi_design/src/theme/extensions/dimensions.dart';
import 'package:flutter_meragi_design/src/theme/extensions/typography.dart';

extension MDThemeStateExtension on State {
  AppColor get colors => context.theme.colors;
  AppDimension get dimensions => context.theme.dimensions;
  double get padding => dimensions.padding;
  MDHeadingTypography get heading => context.theme.fonts.heading;
  MDParagraphTypography get paragraph => context.theme.fonts.paragraph;
}
