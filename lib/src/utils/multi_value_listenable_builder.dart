import 'package:flutter/material.dart';

class MDMultiListenableBuilder extends StatelessWidget {
  final List<Listenable> listenables;
  final TransitionBuilder builder;
  final Widget? child;

  const MDMultiListenableBuilder(
      {super.key,
      required this.listenables,
      required this.builder,
      this.child});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge(listenables),
      builder: (context, child) {
        return builder(context, child);
      },
      child: child,
    );
  }
}
