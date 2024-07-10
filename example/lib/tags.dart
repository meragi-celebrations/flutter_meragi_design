import 'package:flutter/material.dart';
import 'package:flutter_meragi_design/flutter_meragi_design.dart';

class TagDetails extends StatefulWidget {
  const TagDetails({super.key});

  @override
  State<TagDetails> createState() => _TagDetailsState();
}

class _TagDetailsState extends State<TagDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tags"),
      ),
      body: const SingleChildScrollView(
        child: Column(
          children: [
            MDTag(text: "Default"),
            MDTag(text: "Danger Large", size: TagSize.lg, type: TagType.danger),
            MDTag(
                text: "Primary Small", type: TagType.primary, size: TagSize.sm),
            MDTag(
                text: "Warning",
                icon: Icons.currency_exchange_outlined,
                type: TagType.warning),
            MDTag(body: Text("Tag secondary"), type: TagType.secondary),
            MDTag(body: Text("Custom body success"), type: TagType.success),
            MDTag(text: "Just a string", type: TagType.success),
            MDTag(
                text: "Text and Icon",
                icon: Icons.check,
                type: TagType.success),
          ],
        ),
      ),
    );
  }
}
