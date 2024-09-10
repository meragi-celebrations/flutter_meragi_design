import 'package:flutter/material.dart';

class MDAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? title;
  final Widget? leading;
  final List<Widget>? actions;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? elevation;
  final Color? shadowColor;
  final Color? surfaceTintColor;
  final IconThemeData? iconTheme;
  final IconThemeData? actionsIconTheme;
  final bool? centerTitle;
  final bool excludeHeaderSemantics;
  final double? titleSpacing;
  final double toolbarOpacity;
  final double? leadingWidth;
  final PreferredSizeWidget? bottom;
  final Widget? flexibleSpace;
  final bool primary;
  final bool automaticallyImplyLeading;
  final bool asPageHeader;

  const MDAppBar({
    Key? key,
    this.title,
    this.leading,
    this.actions,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation,
    this.shadowColor,
    this.surfaceTintColor,
    this.iconTheme,
    this.actionsIconTheme,
    this.centerTitle = true,
    this.excludeHeaderSemantics = false,
    this.titleSpacing,
    this.toolbarOpacity = 1.0,
    this.leadingWidth,
    this.bottom,
    this.flexibleSpace,
    this.primary = true,
    this.automaticallyImplyLeading = true,
    this.asPageHeader = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: asPageHeader ? const EdgeInsets.all(3.0) : EdgeInsets.zero,
      child: AppBar(
        title: title,
        leading: leading,
        actions: actions,
        foregroundColor: foregroundColor,
        surfaceTintColor: surfaceTintColor,
        iconTheme: iconTheme,
        actionsIconTheme: actionsIconTheme,
        centerTitle: centerTitle,
        excludeHeaderSemantics: excludeHeaderSemantics,
        titleSpacing: titleSpacing,
        toolbarOpacity: toolbarOpacity,
        leadingWidth: leadingWidth,
        bottom: bottom,
        flexibleSpace: flexibleSpace,
        primary: primary,
        automaticallyImplyLeading: automaticallyImplyLeading,
        backgroundColor:
            asPageHeader ? Colors.deepPurple.shade100.withOpacity(.3) : null,
        toolbarHeight: 40,
        shadowColor: asPageHeader ? null : Colors.grey.shade200,
        shape: asPageHeader
            ? const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(15 * .75),
                ),
              )
            : null,
        elevation: 2,
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(40);

  MDAppBar merge(MDAppBar? other) {
    if (other == null) {
      return this;
    }
    return MDAppBar(
      key: key ?? other.key,
      title: other.title ?? title,
      leading: other.leading ?? leading,
      actions: other.actions ?? actions,
      backgroundColor: other.backgroundColor ?? backgroundColor,
      foregroundColor: other.foregroundColor ?? foregroundColor,
      elevation: other.elevation ?? elevation,
      shadowColor: other.shadowColor ?? shadowColor,
      surfaceTintColor: other.surfaceTintColor ?? surfaceTintColor,
      iconTheme: other.iconTheme ?? iconTheme,
      actionsIconTheme: other.actionsIconTheme ?? actionsIconTheme,
      centerTitle: other.centerTitle ?? centerTitle,
      excludeHeaderSemantics: other.excludeHeaderSemantics,
      titleSpacing: other.titleSpacing ?? titleSpacing,
      toolbarOpacity: other.toolbarOpacity,
      leadingWidth: other.leadingWidth ?? leadingWidth,
      bottom: other.bottom ?? bottom,
      flexibleSpace: other.flexibleSpace ?? flexibleSpace,
      primary: other.primary,
      automaticallyImplyLeading: other.automaticallyImplyLeading,
      asPageHeader: other.asPageHeader,
    );
  }

  MDAppBar copyWith({
    Key? key,
    Widget? title,
    Widget? leading,
    List<Widget>? actions,
    Color? backgroundColor,
    Color? foregroundColor,
    double? elevation,
    Color? shadowColor,
    Color? surfaceTintColor,
    IconThemeData? iconTheme,
    IconThemeData? actionsIconTheme,
    bool? centerTitle,
    bool? excludeHeaderSemantics,
    double? titleSpacing,
    double? toolbarOpacity,
    double? leadingWidth,
    PreferredSizeWidget? bottom,
    Widget? flexibleSpace,
    bool? primary,
    bool? automaticallyImplyLeading,
    bool? asPageHeader,
  }) {
    return MDAppBar(
      key: key ?? this.key,
      title: title ?? this.title,
      leading: leading ?? this.leading,
      actions: actions ?? this.actions,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      foregroundColor: foregroundColor ?? this.foregroundColor,
      elevation: elevation ?? this.elevation,
      shadowColor: shadowColor ?? this.shadowColor,
      surfaceTintColor: surfaceTintColor ?? this.surfaceTintColor,
      iconTheme: iconTheme ?? this.iconTheme,
      actionsIconTheme: actionsIconTheme ?? this.actionsIconTheme,
      centerTitle: centerTitle ?? this.centerTitle,
      excludeHeaderSemantics:
          excludeHeaderSemantics ?? this.excludeHeaderSemantics,
      titleSpacing: titleSpacing ?? this.titleSpacing,
      toolbarOpacity: toolbarOpacity ?? this.toolbarOpacity,
      leadingWidth: leadingWidth ?? this.leadingWidth,
      bottom: bottom ?? this.bottom,
      flexibleSpace: flexibleSpace ?? this.flexibleSpace,
      primary: primary ?? this.primary,
      automaticallyImplyLeading:
          automaticallyImplyLeading ?? this.automaticallyImplyLeading,
      asPageHeader: asPageHeader ?? this.asPageHeader,
    );
  }
}
