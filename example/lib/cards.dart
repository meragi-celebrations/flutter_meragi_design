import 'package:flutter/material.dart';
import 'package:flutter_meragi_design/flutter_meragi_design.dart';

class CardDetails extends StatefulWidget {
  const CardDetails({super.key});

  @override
  State<CardDetails> createState() => _CardDetailsState();
}

class _CardDetailsState extends State<CardDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cards"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const MDCard(
              header: Text("Default Card"),
              body: Text("Body"),
              footer: Text("Footer"),
            ),
            MDCard(
              decoration: CardDecoration(
                context: context,
                type: CardType.primary,
              ),
              body: const Text("Primary Just the Body"),
            ),
            MDCard(
              decoration: CardDecoration(
                context: context,
                type: CardType.danger,
              ),
              body: const Text("Danger Body without header"),
              footer: const Text("Footer"),
            ),
            MDCard(
              decoration: CardDecoration(
                  context: context, type: CardType.success, size: CardSize.lg),
              header: const Text("success Card"),
              body: const Text("This is a large Card"),
              footer: const Text("Footer"),
            ),
            MDCard(
              decoration: CardDecoration(
                context: context,
                type: CardType.warning,
                size: CardSize.sm,
              ),
              header: const Text("warning Card"),
              body: const Text(
                  "Small Card with Body without footer and the alignment is start"),
              alignment: CrossAxisAlignment.start,
            ),
          ],
        ),
      ),
    );
  }
}
