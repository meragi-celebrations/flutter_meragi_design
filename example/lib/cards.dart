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
      body: const SingleChildScrollView(
        child: Column(
          children: [
            MDCard(
              header: Text("Default Card"),
              body: Text("Body"),
              footer: Text("Footer"),
            ),
            MDCard(
              type: CardType.primary,
              body: Text("Primary Just the Body"),
            ),
            MDCard(
              type: CardType.danger,
              body: Text("Danger Body without header"),
              footer: Text("Footer"),
            ),
            MDCard(
              type: CardType.success,
              header: Text("success Card"),
              body: Text("This is a large Card"),
              footer: Text("Footer"),
              size: CardSize.lg,
            ),
            MDCard(
              type: CardType.warning,
              header: Text("warning Card"),
              body: Text(
                  "Small Card with Body without footer and the alignment is start"),
              size: CardSize.sm,
              alignment: CrossAxisAlignment.start,
            ),
          ],
        ),
      ),
    );
  }
}
