import 'package:flutter/material.dart';
import 'package:flutter_meragi_design/src/components/fields/input.dart';

class CanvaNumberProperty extends StatelessWidget {
  const CanvaNumberProperty(
      {super.key,
      required this.controller,
      required this.prefix,
      this.onChanged,
      this.onSubmitted,
      this.onEditingComplete});

  final TextEditingController controller;
  final Widget prefix;
  final dynamic onChanged;
  final dynamic onSubmitted;
  final dynamic onEditingComplete;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: MDInput(
        controller: controller,
        keyboardType:
            const TextInputType.numberWithOptions(decimal: true, signed: false),
        onChanged: onChanged,
        onSubmitted: onSubmitted,
        onEditingComplete: onEditingComplete,
        prefix: prefix,
      ),
    );
  }
}
