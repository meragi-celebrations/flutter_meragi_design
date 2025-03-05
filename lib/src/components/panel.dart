import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

/// A panel widget that provides a card-like container with customizable styling and layout.
///
/// This widget wraps the [ShadCard] functionality while maintaining consistency with the Meragi Design system.
class MDPanel extends StatelessWidget {
  const MDPanel({
    super.key,
    this.title,
    this.description,
    this.child,
    this.footer,
    this.padding,
    this.backgroundColor,
    this.radius,
    this.border,
    this.shadows,
    this.width,
    this.height,
    this.leading,
    this.trailing,
    this.rowMainAxisAlignment,
    this.rowCrossAxisAlignment,
    this.columnMainAxisAlignment,
    this.columnCrossAxisAlignment,
    this.rowMainAxisSize,
    this.columnMainAxisSize,
  });

  final Widget? title;
  final Widget? description;
  final Widget? child;
  final Widget? footer;

  final EdgeInsets? padding;
  final Color? backgroundColor;
  final BorderRadius? radius;
  final Border? border;
  final List<BoxShadow>? shadows;
  final double? width;
  final double? height;
  final Widget? leading;
  final Widget? trailing;
  final MainAxisAlignment? rowMainAxisAlignment;
  final CrossAxisAlignment? rowCrossAxisAlignment;
  final MainAxisAlignment? columnMainAxisAlignment;
  final CrossAxisAlignment? columnCrossAxisAlignment;
  final MainAxisSize? rowMainAxisSize;
  final MainAxisSize? columnMainAxisSize;

  @override
  Widget build(BuildContext context) {
    return ShadCard(
      title: title,
      description: description,
      footer: footer,
      padding: padding,
      backgroundColor: backgroundColor,
      radius: radius,
      border: border,
      shadows: shadows,
      width: width,
      height: height,
      leading: leading,
      trailing: trailing,
      rowMainAxisAlignment: rowMainAxisAlignment,
      rowCrossAxisAlignment: rowCrossAxisAlignment,
      columnMainAxisAlignment: columnMainAxisAlignment,
      columnCrossAxisAlignment: columnCrossAxisAlignment,
      rowMainAxisSize: rowMainAxisSize,
      columnMainAxisSize: columnMainAxisSize,
      child: child,
    );
  }
}

