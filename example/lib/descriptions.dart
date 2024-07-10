import 'package:flutter/material.dart';
import 'package:flutter_meragi_design/flutter_meragi_design.dart';

class DescriptionDetails extends StatefulWidget {
  const DescriptionDetails({super.key});

  @override
  State<DescriptionDetails> createState() => _DescriptionDetailsState();
}

class _DescriptionDetailsState extends State<DescriptionDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tags"),
      ),
      body: const SingleChildScrollView(
        child: Column(
          children: [
            MDCard(
              type: CardType.primary,
              header: Text("Min COlumn: 2, Max Column: 5, Horizontal"),
              body: MDDescription(
                data: [
                  {
                    'label': Text('Label 1'),
                    'value': Text('Value 1'),
                  },
                  {
                    'label': Text('Label 2'),
                    'value': Text('Value 2'),
                  },
                  {
                    'label': Text('Label 3'),
                    'value': Text('Value 3'),
                  },
                  {
                    'label': Text('Label 4'),
                    'value': Text('Value 4'),
                  },
                  {
                    'label': Text('Label 5'),
                    'value': Text('Value 5'),
                  },
                  {
                    'label': Text('Label 6'),
                    'value': Text('Value 6'),
                  },
                ],
                minColumns: 2,
                maxColumns: 5,
              ),
            ),
            MDCard(
              type: CardType.success,
              header: Text("Min COlumn: 2, Max Column: 5, Vertical"),
              body: MDDescription(
                data: [
                  {
                    'label': Text('Label 1'),
                    'value': Text('Value 1'),
                  },
                  {
                    'label': Text('Label 2'),
                    'value': Text('Value 2'),
                  },
                  {
                    'label': Text('Label 3'),
                    'value': Text('Value 3'),
                  },
                  {
                    'label': Text('Label 4'),
                    'value': Text('Value 4'),
                  },
                  {
                    'label': Text('Label 5'),
                    'value': Text('Value 5'),
                  },
                  {
                    'label': Text('Label 6'),
                    'value': Text('Value 6'),
                  },
                ],
                minColumns: 2,
                maxColumns: 5,
                direction: Axis.vertical,
              ),
            ),
            MDCard(
              type: CardType.danger,
              header: Text("Min COlumn: 1, Max Column: 3, Vertical"),
              body: MDDescription(
                data: [
                  {
                    'label': Text('Label 1'),
                    'value': Text('Value 1'),
                  },
                  {
                    'label': Text('Label 2'),
                    'value': Text('Value 2'),
                  },
                  {
                    'label': Text('Label 3'),
                    'value': Text('Value 3'),
                  },
                  {
                    'label': Text('Label 4'),
                    'value': Text('Value 4'),
                  },
                  {
                    'label': Text('Label 5'),
                    'value': Text('Value 5'),
                  },
                  {
                    'label': Text('Label 6'),
                    'value': Text('Value 6'),
                  },
                ],
                minColumns: 1,
                maxColumns: 3,
                direction: Axis.vertical,
                spacingBetweenItem: 10,
                spacingBetweenKeyAndValue: 5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
