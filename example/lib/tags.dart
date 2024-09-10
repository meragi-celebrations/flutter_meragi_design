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
      body: SingleChildScrollView(
        child: Column(
          children: [
            const MDTag(text: "Default"),
            MDTag(
              text: "Danger Large",
              decoration: TagDecoration(
                  context: context, size: TagSize.lg, type: TagType.danger),
            ),
            MDTag(
              text: "Primary Small",
              decoration: TagDecoration(
                  context: context, type: TagType.primary, size: TagSize.sm),
            ),
            MDTag(
              text: "Warning",
              icon: Icons.currency_exchange_outlined,
              decoration: TagDecoration(
                context: context,
                type: TagType.warning,
              ),
            ),
            MDTag(
              body: Text("Tag secondary"),
              decoration:
                  TagDecoration(context: context, type: TagType.secondary),
            ),
            MDTag(
              body: Text("Custom body success"),
              decoration:
                  TagDecoration(context: context, type: TagType.success),
            ),
            MDTag(
              text: "Just a string",
              decoration:
                  TagDecoration(context: context, type: TagType.success),
            ),
            MDTag(
              text: "Text and Icon",
              icon: Icons.check,
              decoration:
                  TagDecoration(context: context, type: TagType.success),
            ),
            MDTag(
              text: "Text and Icon",
              icon: Icons.check,
              decoration: TagDecoration(
                context: context,
                type: TagType.info,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
