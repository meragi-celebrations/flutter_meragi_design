import 'package:flutter/material.dart';

class MDLoadingIndicator extends StatelessWidget {
  final double radius, strokeWidth;
  final Color color;
  final Widget? child;
  final bool isLoading;

  const MDLoadingIndicator({
    Key? key,
    this.radius = 20,
    this.color = Colors.white,
    this.strokeWidth = 2,
    this.child,
    this.isLoading = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget loader = SizedBox(
      height: radius,
      width: radius,
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(color),
        strokeWidth: strokeWidth,
      ),
    );

    return Stack(
      alignment: Alignment.center,
      children: [
        child ?? const SizedBox(),
        if (child != null)
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(.4),
            ),
          ),
        if (isLoading) loader,
      ],
    );
  }
}
