import 'package:flutter/material.dart';
import 'package:flutter_meragi_design/flutter_meragi_design.dart';
import 'package:sliver_tools/sliver_tools.dart';

class MDSectionView extends StatelessWidget {
  final MDSectionHeader header;
  final EdgeInsets? margin;
  final List<Widget> children;
  const MDSectionView({super.key, required this.header, required this.children, this.margin});

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: margin ?? EdgeInsets.zero,
      sliver: MultiSliver(
        pushPinnedChildren: true,
        children: [
          SliverStack(
            children: [
              SliverPositioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      )
                    ],
                  ),
                ),
              ),
              MultiSliver(
                children: [
                  header,
                  ...children,
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class MDSectionHeader extends StatelessWidget {
  final Widget? leading;
  final Widget child;
  final List<Widget>? actions;
  const MDSectionHeader({super.key, this.leading, this.actions, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(10),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (leading != null) leading!,
          if (leading != null) SizedBox(width: 10),
          Expanded(child: child),
          if (actions != null) ...actions!,
        ],
      ),
    );
  }
}

class MDSectionTile extends StatelessWidget {
  final Widget? leading;
  final Widget child;
  final List<Widget>? actions;
  final EdgeInsets? padding;
  final VoidCallback? onTap;
  final EdgeInsets leadingPadding;
  const MDSectionTile({
    super.key,
    this.leading,
    this.actions,
    this.padding,
    required this.child,
    this.onTap,
    this.leadingPadding = const EdgeInsets.only(right: 10),
  });

  @override
  Widget build(BuildContext context) {
    return MDGestureDetector(
      onTap: onTap,
      child: Container(
        padding: padding ?? const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (leading != null) Padding(padding: leadingPadding, child: leading),
            Expanded(child: child),
            if (actions != null) ...actions!,
          ],
        ),
      ),
    );
  }
}
