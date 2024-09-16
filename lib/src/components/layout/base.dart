import 'package:flutter/material.dart';

class MDLayout extends StatelessWidget {
  final Widget sider;
  final Widget content;
  const MDLayout({super.key, required this.sider, required this.content});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: const Color(0xfff1f0f5),
      ),
      child: Row(
        children: [
          sider,
          Expanded(
            child: content,
          )
        ],
      ),
    );
  }
}
