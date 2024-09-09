import 'package:flutter/material.dart';
import 'package:flutter_meragi_design/flutter_meragi_design.dart';

class ScaffoldDetails extends StatefulWidget {
  const ScaffoldDetails({super.key});

  @override
  State<ScaffoldDetails> createState() => _ScaffoldDetailsState();
}

class _ScaffoldDetailsState extends State<ScaffoldDetails> {
  @override
  Widget build(BuildContext context) {
    return const MDScaffold.split(
      leftChild: Text("left"),
      rightChild: Text("right"),
    );
  }
}
