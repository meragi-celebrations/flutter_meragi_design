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
            MDCard(
              decoration: CardDecoration(
                context: context,
                type: CardType.primary,
              ),
              header: const Text("MDSlider"),
              body: const MDDescription(
                data: [
                  DescriptionItem(
                    label: Text('Description'),
                    value: Text('A slider component that supports both single and range selection modes. '
                        'Can be used standalone or within forms. Provides visual feedback with value bubbles '
                        'and supports min/max labels.'),
                  ),
                ],
                minColumns: 1,
                maxColumns: 1,
              ),
            ),
            MDCard(
              decoration: CardDecoration(
                context: context,
                type: CardType.primary,
              ),
              header: const Text("Code Example"),
              body: const MDDescription(
                data: [
                  DescriptionItem(
                    label: Text('Code'),
                    value: Text('''
// Single value slider
MDSlider(
  label: "Select Value",
  min: 0,
  max: 100,
  value: 50,
  onChanged: (value) => print(value),
),

// Range slider
MDSlider(
  label: "Select Range",
  min: 0,
  max: 100,
  isRange: true,
  values: RangeValues(30, 70),
  onRangeChanged: (values) => print(values),
),

// Form builder usage
FormBuilderMDSlider(
  name: 'slider',
  min: 0,
  max: 100,
  decoration: InputDecoration(
    labelText: 'Select Value',
    helperText: 'Drag to select a value',
  ),
),
'''),
                  ),
                ],
                minColumns: 1,
                maxColumns: 1,
              ),
            ),
            MDCard(
              decoration: CardDecoration(
                context: context,
                type: CardType.primary,
              ),
              header: const Text("Example"),
              body: MDDescription(
                data: [
                  DescriptionItem(
                    label: Text('Example'),
                    value: Column(
                      children: [
                        MDSlider(
                          label: "Single Value Slider",
                          min: 0,
                          max: 100,
                          value: 50,
                          onChanged: (value) => print("Value changed: $value"),
                        ),
                        const SizedBox(height: 32),
                        MDRangeSliderFormBuilder(
                          name: 'range_slider',
                          min: 0,
                          max: 100,
                          initialValue: const RangeValues(30, 70),
                          labelText: "Range Slider",
                          onChanged: (value) => print("Range changed: $value"),
                        ),
                        const SizedBox(height: 32),
                        MDSingleSliderFormBuilder(
                          name: 'slider_example',
                          min: 0,
                          max: 100,
                          helperText: 'This slider is part of a form',
                          labelText: 'Form Slider',
                          onChanged: (value) => print("Form value changed: $value"),
                        ),
                      ],
                    ),
                  ),
                ],
                minColumns: 1,
                maxColumns: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
