import 'package:flutter/material.dart';
import 'package:flutter_meragi_design/flutter_meragi_design.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = CoralThemeColor();
    return MeragiTheme(
      token: lightWide_v2,
      child: MDApp(
        theme: MDTheme(
          colors: colors,
          typography: MDDefaultTypography(color: colors.content.primary),
          dimensions: const MDDefaultDimension(),
        ),
        home: const HomePage(),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<MDNavigationRailDestination> _items = [
    MDNavigationRailDestination(
      icon: const Icon(Icons.list),
      label: 'Buttons',
    ),
    MDNavigationRailDestination(
      icon: const Icon(Icons.card_giftcard),
      label: 'Card',
    ),
    MDNavigationRailDestination(
      icon: const Icon(Icons.select_all),
      label: 'Select',
    ),
    MDNavigationRailDestination(
      icon: const Icon(Icons.input),
      label: 'Input',
    ),
    MDNavigationRailDestination(
      icon: const Icon(Icons.format_align_center),
      label: 'Form',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return MDScaffold(
      body: Row(
        children: [
          MDNavigationRail(
            controller: MDNavigationRailController(isExpanded: true),
            selectedIndex: _selectedIndex,
            onDestinationSelected: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            destinations: _items,
          ),
          Expanded(
            child: [
              const ButtonsStory(),
              const CardStory(),
              const SelectStory(),
              const InputStory(),
              const FormStory(),
            ][_selectedIndex],
          ),
        ],
      ),
    );
  }
}

class CardStory extends StatelessWidget {
  const CardStory({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MDScaffold(
      appBar: const MDAppBar(
        title: Text('Card'),
        asPageHeader: true,
      ),
      body: MDPanel(
        width: 450,
        title: const Text('Title'),
        description: const Text('Description'),
        footer: MDTap(
          width: double.infinity,
          icon: const Padding(
            padding: EdgeInsets.only(right: 8),
            child: Icon(PhosphorIconsRegular.check),
          ),
          onPressed: () {},
          child: const Text('Mark all as read'),
        ),
        child: const Text('Footer'),
      ),
    );
  }
}

class ButtonsStory extends StatelessWidget {
  const ButtonsStory({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MDScaffold(
      appBar: const MDAppBar(
        title: Text('Buttons'),
        asPageHeader: true,
      ),
      body: Center(
        child: Column(
          children: [
            Row(
              children: [
                ...ShadButtonSize.values
                    .map(
                      (e) => MDTap(
                        size: e,
                        child: Text('Primary, ${e.name}'),
                      ),
                    )
                    .toList(),
                const MDTap(
                  isLoading: true,
                  child: Text('Primary'),
                ),
                const MDTap(
                  enabled: false,
                  child: Text('Disabled'),
                ),
                const MDTap(
                  icon: Icon(PhosphorIconsRegular.check),
                ),
              ],
            ),
            Row(
              children: [
                ...ShadButtonSize.values
                    .map(
                      (e) => MDTap.secondary(
                        size: e,
                        child: Text('Secondary, ${e.name}'),
                      ),
                    )
                    .toList(),
                const MDTap.secondary(
                  isLoading: true,
                  child: Text('Secondary'),
                ),
                const MDTap.secondary(
                  enabled: false,
                  child: Text('Disabled'),
                ),
                const MDTap.secondary(
                  icon: Icon(PhosphorIconsRegular.check),
                ),
              ],
            ),
            Row(
              children: [
                ...ShadButtonSize.values
                    .map(
                      (e) => MDTap.outline(
                        size: e,
                        child: Text('Outline, ${e.name}'),
                      ),
                    )
                    .toList(),
                const MDTap.outline(
                  isLoading: true,
                  child: Text('Outline'),
                ),
                const MDTap.outline(
                  enabled: false,
                  child: Text('Disabled'),
                ),
                const MDTap.outline(
                  icon: Icon(PhosphorIconsRegular.check),
                ),
              ],
            ),
            Row(
              children: [
                ...ShadButtonSize.values
                    .map(
                      (e) => MDTap.ghost(
                        size: e,
                        child: Text('Ghost, ${e.name}'),
                      ),
                    )
                    .toList(),
                const MDTap.ghost(
                  isLoading: true,
                  child: Text('Ghost'),
                ),
                const MDTap.ghost(
                  enabled: false,
                  child: Text('Disabled'),
                ),
                const MDTap.ghost(
                  icon: Icon(PhosphorIconsRegular.check),
                ),
              ],
            ),
            Row(
              children: [
                ...ShadButtonSize.values
                    .map(
                      (e) => MDTap.destructive(
                        size: e,
                        child: Text('Destructive, ${e.name}'),
                      ),
                    )
                    .toList(),
                const MDTap.destructive(
                  isLoading: true,
                  child: Text('Destructive'),
                ),
                const MDTap.destructive(
                  enabled: false,
                  child: Text('Disabled'),
                ),
                const MDTap.destructive(
                  icon: Icon(PhosphorIconsRegular.check),
                ),
              ],
            ),
            Row(
              children: [
                ...ShadButtonSize.values
                    .map(
                      (e) => MDTap.link(
                        size: e,
                        child: Text('Link, ${e.name}'),
                      ),
                    )
                    .toList(),
                const MDTap.link(
                  isLoading: true,
                  child: Text('Link'),
                ),
                const MDTap.link(
                  enabled: false,
                  child: Text('Disabled'),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

class SelectStory extends StatelessWidget {
  const SelectStory({super.key});

  @override
  Widget build(BuildContext context) {
    return MDScaffold(
        body: Column(
      children: [
        Row(
          children: [
            const Text('Single'),
            MDSelect<String>(
              options: const [
                MDOption(value: 'Option 1', child: Text('Option 1')),
                MDOption(value: 'Option 2', child: Text('Option 2')),
              ],
              placeholder: const Text('Select an option'),
              selectedOptionBuilder: (context, value) => Text(value),
              onChanged: (value) => print(value),
            ),
          ].withSpaceBetween(width: 10),
        ),
        Row(
          children: [
            const Text('Multiple'),
            MDSelect<String>.multiple(
              closeOnSelect: false,
              options: const [
                MDOption(value: 'Option 1', child: Text('Option 1')),
                MDOption(value: 'Option 2', child: Text('Option 2')),
              ],
              placeholder: const Text('Select options'),
              selectedOptionsBuilder: (context, values) => Text(values.join(', ')),
              onChanged: (values) => print(values),
            ),
          ].withSpaceBetween(width: 10),
        ),
        Row(
          children: [
            const Text('Search'),
            MDSelect<String>.withSearch(
              options: const [
                MDOption(value: 'Option 1', child: Text('Option 1')),
                MDOption(value: 'Option 2', child: Text('Option 2')),
              ],
              placeholder: const Text('Select options'),
              onChanged: (values) => print(values),
              onSearchChanged: (value) => print(value),
            ),
          ].withSpaceBetween(width: 10),
        ),
        Row(
          children: [
            const Text('Multiple with Search'),
            MDSelect<String>.multipleWithSearch(
              options: const [
                MDOption(value: 'Option 1', child: Text('Option 1')),
                MDOption(value: 'Option 2', child: Text('Option 2')),
              ],
              placeholder: const Text('Select options'),
              selectedOptionsBuilder: (context, values) => Text(values.join(', ')),
              onChanged: (values) => print(values),
              onSearchChanged: (value) => print(value),
            ),
          ].withSpaceBetween(width: 10),
        ),
      ],
    ));
  }
}

class FormStory extends StatefulWidget {
  const FormStory({super.key});

  @override
  State<FormStory> createState() => _FormStoryState();
}

class _FormStoryState extends State<FormStory> {
  final formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return MDScaffold(
      appBar: const MDAppBar(
        title: Text('Form'),
        asPageHeader: true,
      ),
      body: MDPanel(
        width: 450,
        title: const Text('Form'),
        description: const Text('This is a simple form that prints the values of the form to the console when the submit button is pressed'),
      footer: MDTap(
        width: double.infinity,
        onPressed: () {
          formKey.currentState?.save();
          print(formKey.currentState?.value);
        },
        child: const Text('Submit'),
      ),
        child: Column(
          children: [
            const MDDivider(),
            FormBuilder(
              key: formKey,
              child: Column(
                children: [
                  MDFormItem(
                    label: const Text('Input'),
                    child: MDInputFormField(
                      name: 'input',
                      placeholder: const Text('Input'),
                    ),
                  ),
                  MDFormItem(
                    label: const Text('Select'),
                    child: MDSelectFormField<String>(
                      name: 'select',
                      placeholder: const Text('Select an option'),
                      minWidth: double.infinity,
                      
                      options: const [
                        MDOption(value: 'Option 1', child: Text('Option 1')),
                        MDOption(value: 'Option 2', child: Text('Option 2')),
                        MDOption(value: 'Option 3', child: Text('Option 3')),
                        MDOption(value: 'Option 4', child: Text('Option 4')),
                        MDOption(value: 'Option 5', child: Text('Option 5')),
                      ],
                      selectedOptionBuilder: (context, value) => Text(value),
                    ),
                  ),
                  MDFormItem(
                    label: const Text('Select with Search'),
                    child: MDSelectFormField<String>.search(
                      name: 'select_search',
                      placeholder: const Text('Select an option'),
                      minWidth: double.infinity,
                      onSearchChanged: (value) => print(value),
                      options: const [
                        MDOption(value: 'Option 1', child: Text('Option 1')),
                        MDOption(value: 'Option 2', child: Text('Option 2')),
                        MDOption(value: 'Option 3', child: Text('Option 3')),
                        MDOption(value: 'Option 4', child: Text('Option 4')),
                        MDOption(value: 'Option 5', child: Text('Option 5')),
                      ],
                      selectedOptionBuilder: (context, value) => Text(value),
                    ),
                  ),
                  MDFormItem(
                    label: const Text('Multiple Select'),
                    error: const Text('Error'),
                    child: MDMultipleSelectFormField<String>(
                      name: 'multiple_select',
                      placeholder: const Text('Select an option'),
                      minWidth: double.infinity,
                      closeOnSelect: false,
                      options: const [
                        MDOption(value: 'Option 1', child: Text('Option 1')),
                        MDOption(value: 'Option 2', child: Text('Option 2')),
                        MDOption(value: 'Option 3', child: Text('Option 3')),
                        MDOption(value: 'Option 4', child: Text('Option 4')),
                        MDOption(value: 'Option 5', child: Text('Option 5')),
                      ],
                      selectedOptionsBuilder: (context, values) => Text(values.join(', ')),
                    ),
                  )
                ],
              ),
                  ),
          ],
        ),
    ),
    );
  }
}

class InputStory extends StatelessWidget {
  const InputStory({super.key});

  @override
  Widget build(BuildContext context) {
    return MDScaffold(
      appBar: const MDAppBar(
        title: Text('Input'),
        asPageHeader: true,
      ),
      body: MDPanel(
        width: 450,
        child: Column(
          children: [
            MDInput(placeholder: const Text('Input'), onChanged: (value) => print(value)),
          ],
        ),
      ),
    );
  }
}
