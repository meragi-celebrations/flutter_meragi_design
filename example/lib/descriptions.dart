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
      body: SingleChildScrollView(
        child: Column(
          children: [
            MDCard(
              decoration: CardDecoration(
                context: context,
                type: CardType.primary,
              ),
              header: const Text("Min COlumn: 2, Max Column: 5, Horizontal"),
              body: const MDDescription(
                data: [
                  DescriptionItem(
                    label: Text('Label 1'),
                    value: Text('Value 1'),
                  ),
                  DescriptionItem(
                    label: Text('Label 2'),
                    value: Text('Value 2'),
                  ),
                  DescriptionItem(
                    label: Text('Label 3'),
                    value: Text('Value 3'),
                  ),
                  DescriptionItem(
                    label: Text('Label 4'),
                    value: Text('Value 4'),
                  ),
                  DescriptionItem(
                    label: Text('Label 5'),
                    value: Text('Value 5'),
                  ),
                  DescriptionItem(
                    label: Text('Label 6'),
                    value: Text('Value 6'),
                  ),
                  DescriptionItem(
                    label: Text('Label 7'),
                    value: Text('Value 7'),
                  ),
                ],
                minColumns: 2,
                maxColumns: 5,
              ),
            ),
            MDCard(
              decoration: CardDecoration(
                context: context,
                type: CardType.success,
              ),
              header: const Text("Min COlumn: 2, Max Column: 5, Vertical"),
              body: const MDDescription(
                data: [
                  DescriptionItem(
                    label: Text('Label 1'),
                    value: Text('Value 1'),
                  ),
                  DescriptionItem(
                    label: Text('Label 2'),
                    value: Text('Value 2'),
                  ),
                  DescriptionItem(
                    label: Text('Label 3'),
                    value: Text('Value 3'),
                  ),
                  DescriptionItem(
                    label: Text('Label 4'),
                    value: Text('Value 4'),
                  ),
                  DescriptionItem(
                    label: Text('Label 5'),
                    value: Text('Value 5'),
                  ),
                  DescriptionItem(
                    label: Text('Label 6'),
                    value: Text('Value 6'),
                  ),
                  DescriptionItem(
                    label: Text('Label 7'),
                    value: Text('Value 7'),
                  ),
                ],
                minColumns: 2,
                maxColumns: 5,
                direction: Axis.vertical,
              ),
            ),
            MDCard(
              decoration: CardDecoration(
                context: context,
                type: CardType.danger,
              ),
              header: const Text("Min COlumn: 1, Max Column: 3, Vertical"),
              body: const MDDescription(
                data: [
                  DescriptionItem(
                    label: Text('Label 1'),
                    value: Text('Value 1'),
                  ),
                  DescriptionItem(
                    label: Text('Label 2'),
                    value: Text('Value 2'),
                  ),
                  DescriptionItem(
                    label: Text('Label 3'),
                    value: Text('Value 3'),
                  ),
                  DescriptionItem(
                    label: Text('Label 4'),
                    value: Text('Value 4'),
                  ),
                  DescriptionItem(
                    label: Text('Label 5'),
                    value: Text('Value 5'),
                  ),
                  DescriptionItem(
                    label: Text('Label 6'),
                    value: Text('Value 6'),
                  ),
                  DescriptionItem(
                    label: Text('Label 7'),
                    value: Text('Value 7'),
                  ),
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
