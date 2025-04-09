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
      label: 'Taps',
    ),
    MDNavigationRailDestination(
      icon: const Icon(Icons.card_giftcard),
      label: 'Panel',
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
    MDNavigationRailDestination(
      icon: const Icon(Icons.radio_button_checked),
      label: 'Popover',
    ),
    MDNavigationRailDestination(
      icon: const Icon(Icons.calendar_today),
      label: 'Calendar',
    ),
    MDNavigationRailDestination(
      icon: const Icon(Icons.settings),
      label: 'Context Menu',
    ),
    MDNavigationRailDestination(
      icon: const Icon(Icons.slideshow),
      label: 'Dialogs/Sliders',
    ),
    MDNavigationRailDestination(
      icon: const Icon(Icons.menu),
      label: 'Moodboard',
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
              PopoverStory(),
              const CalendarStory(),
              const ContextMenuStory(),
              const MDAlertDialogStory(),
              MoodboardStory(),
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
      body: ShadContextMenuRegion(
        items: [
          const ShadContextMenuItem(
            child: Text('Item 1'),
          ),
          const ShadContextMenuItem(
            child: Text('Item 2'),
          ),
        ],
        child: MDPanel(
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
      ),
    );
  }
}

class ButtonsStory extends StatefulWidget {
  const ButtonsStory({
    super.key,
  });

  @override
  State<ButtonsStory> createState() => _ButtonsStoryState();
}

class _ButtonsStoryState extends State<ButtonsStory> {
  bool _isSwipeLoading = false;

  @override
  Widget build(BuildContext context) {
    return MDScaffold(
      appBar: const MDAppBar(
        title: Text('Buttons'),
        asPageHeader: true,
      ),
      body: Column(
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
                iconData: PhosphorIconsBold.check,
                size: ShadButtonSize.sm,
              ),
              const MDTap(
                iconData: PhosphorIconsBold.check,
                child: Text('Check'),
                size: ShadButtonSize.sm,
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
                iconData: PhosphorIconsRegular.check,
              ),
              const MDTap.secondary(
                iconData: PhosphorIconsRegular.check,
                size: ShadButtonSize.sm,
                child: Text('Check'),
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
                iconData: PhosphorIconsRegular.check,
              ),
              const MDTap.outline(
                iconData: PhosphorIconsRegular.check,
                size: ShadButtonSize.sm,
                child: Text('Check'),
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
                iconData: PhosphorIconsRegular.check,
              ),
              const MDTap.ghost(
                iconData: PhosphorIconsRegular.check,
                size: ShadButtonSize.sm,
                child: Text('Check'),
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
                iconData: PhosphorIconsRegular.check,
              ),
              const MDTap.destructive(
                iconData: PhosphorIconsRegular.check,
                size: ShadButtonSize.sm,
                child: Text('Check'),
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
          ),
          MDSwipeButton(
            label: 'Swipe to delete',
            isLoading: _isSwipeLoading,
            onSwipe: () {
              print("Drag successful");
              setState(() {
                _isSwipeLoading = !_isSwipeLoading;
              });
            },
          ),
          MDDivider(),
          MDSwipeButton(
            label: 'Swipe to delete (disabled)',
            isDisabled: true,
            onSwipe: () {
              print("Drag successful");
            },
          )
        ],
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
              selectedOptionsBuilder: (context, values) =>
                  Text(values.join(', ')),
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
              selectedOptionsBuilder: (context, values) =>
                  Text(values.join(', ')),
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
        description: const Text(
            'This is a simple form that prints the values of the form to the console when the submit button is pressed'),
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
            const MDDivider(
              style: MDDividerStyle.swiggly,
              child: Text("Squiggly Divider"),
            ),
            FormBuilder(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                      placeholderText: 'Select option',
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
                    child: MDSelectFormField<String>.withSearch(
                      name: 'select_search',
                      placeholderText: 'Select option with search',
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
                    child: MDMultipleSelectFormField<String>(
                      name: 'multiple_select',
                      placeholderText: 'Select options',
                      minWidth: double.infinity,
                      options: const [
                        MDOption(value: 'Option 1', child: Text('Option 1')),
                        MDOption(value: 'Option 2', child: Text('Option 2')),
                        MDOption(value: 'Option 3', child: Text('Option 3')),
                        MDOption(value: 'Option 4', child: Text('Option 4')),
                        MDOption(value: 'Option 5', child: Text('Option 5')),
                      ],
                      selectedOptionsBuilder: (context, values) =>
                          Text(values.join(', ')),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      MDTickboxFormField(
                        name: 'tickbox',
                        label: const Text('Yes, Call me'),
                      ),
                    ],
                  ),
                  const MDDivider(
                    style: MDDividerStyle.handDrawn,
                    thickness: 2,
                    amplitude: 7,
                  ),
                  MDToggleFormField(
                    name: 'toggle',
                    label: const Text('I accept the terms and conditions'),
                    sublabel: const Text(
                        'You must accept the terms and conditions to continue'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class InputStory extends StatefulWidget {
  const InputStory({super.key});

  @override
  State<InputStory> createState() => _InputStoryState();
}

class _InputStoryState extends State<InputStory> {
  bool _toggleValue = false;
  bool? _tickboxValue = false;
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
            MDInput(
                placeholder: const Text('Input'),
                onChanged: (value) => print(value)),
            MDToggle(
              value: _toggleValue,
              onChanged: (value) => setState(() => _toggleValue = value),
              label: const Text('Toggle'),
            ),
            Row(
              children: [
                MDTickbox(
                  value: _tickboxValue,
                  onChanged: (value) {
                    print("Tickbox value changed to: $value");
                    setState(() => _tickboxValue = value);
                  },
                  label: const Text('Tickbox'),
                  tristate: true,
                ),
                FocusTraversalGroup(
                  child: MDRadioGroup<String>(
                    onChanged: (value) => {
                      setState(
                        () => _tickboxValue =
                            value == 'mid' ? null : value == 'true',
                      ),
                    },
                    items: const [
                      MDRadio(
                        label: Text('Mid'),
                        value: 'mid',
                      ),
                      MDRadio(
                        label: Text('False'),
                        value: 'false',
                      ),
                      MDRadio(
                        label: Text('True'),
                        value: 'true',
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const MDEditor(),
          ],
        ),
      ),
    );
  }
}

class PopoverStory extends StatelessWidget {
  PopoverStory({super.key});

  final MDPopoverController _controller = MDPopoverController();

  @override
  Widget build(BuildContext context) {
    return MDScaffold(
      appBar: const MDAppBar(
        title: Text('Popover'),
        asPageHeader: true,
      ),
      body: MDPanel(
        width: 450,
        child: MDPopover(
            controller: _controller,
            child: MDTap(
              child: const Text('Open Popover'),
              onPressed: () {
                _controller.toggle();
              },
            ),
            popover: (context) {
              return MDPopoverMenu(
                child: SingleChildScrollView(
                  child: Column(
                    children: List.generate(
                      6,
                      (index) => MDPopoverItem(
                        iconData: PhosphorIconsRegular.check,
                        child: Text('Item $index'),
                      ),
                    ),
                  ),
                ),
              );
            }),
      ),
    );
  }
}

class CalendarStory extends StatelessWidget {
  const CalendarStory({super.key});

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();

    return MDScaffold(
      appBar: const MDAppBar(
        title: Text('Calendar'),
        asPageHeader: true,
      ),
      body: SingleChildScrollView(
        child: Wrap(
          children: [
            MDPanel(
              title: Text(
                'Single',
                style: context.theme.fonts.heading.medium,
              ),
              width: 450,
              child: Center(
                child: MDCalendar(
                  selected: today,
                  fromMonth: DateTime(today.year - 1),
                  toMonth: DateTime(today.year, 12),
                ),
              ),
            ),
            MDPanel(
              title: Text(
                'Multiple',
                style: context.theme.fonts.heading.medium,
              ),
              width: 450,
              child: Center(
                child: MDCalendar.multiple(
                  numberOfMonths: 2,
                  fromMonth: DateTime(today.year),
                  toMonth: DateTime(today.year + 1, 12),
                  min: 5,
                  max: 10,
                ),
              ),
            ),
            MDPanel(
              title: Text(
                'Range',
                style: context.theme.fonts.heading.medium,
              ),
              width: 450,
              child: const Center(
                child: MDCalendar.range(
                  min: 2,
                  max: 5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ContextMenuStory extends StatelessWidget {
  const ContextMenuStory({super.key});

  @override
  Widget build(BuildContext context) {
    return const MDScaffold(
      appBar: MDAppBar(
        title: Text('Context Menu'),
        asPageHeader: true,
      ),
      body: MDPanel(
        width: 450,
        child: MDContextMenuRegion(
          items: [
            MDContextMenuItem.inset(
              child: Text('Item 1'),
            ),
            MDContextMenuItem.inset(
              child: Text('Item 2'),
            ),
          ],
          child: Center(
            child: Text('Open Context Menu'),
          ),
        ),
      ),
    );
  }
}

class MDAlertDialogStory extends StatelessWidget {
  const MDAlertDialogStory({super.key});

  @override
  Widget build(BuildContext context) {
    return MDScaffold(
      appBar: const MDAppBar(
        title: Text('Alert Dialog'),
        asPageHeader: true,
      ),
      body: Column(
        children: [
          MDTap(
            onPressed: () {
              showMDAlertDialog(
                context: context,
                builder: (context) {
                  return const MDAlertDialog(
                    title: 'Alert Dialog',
                    content: Text('This is an alert dialog'),
                    okText: 'OK',
                    cancelText: 'Cancel',
                  );
                },
              );
            },
            child: const Text('Show Alert'),
          ),
          MDTap(
            onPressed: () {
              showMDAlertDialog(
                context: context,
                builder: (context) {
                  return MDAlertDialog(
                    title: 'Alert Dialog',
                    description:
                        const Text("You can add a description if you want to"),
                    content: const Text(
                        'This is an alert dialog, with a long text that should be wrapped correctly and not overflow the screen. This is an alert dialog, with a long text that should be wrapped correctly and not overflow the screen. This is an alert dialog, with a long text that should be wrapped correctly and not overflow the screen.'),
                    okText: 'OK',
                    onOk: () {
                      Navigator.pop(context);
                    },
                    cancelText: 'Cancel',
                    hideCancel: true,
                  );
                },
              );
            },
            child: const Text('Alert without cancel'),
          ),
          MDTap(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return const MDDialog(
                    title: Text("This is title"),
                    description: Text("This is Description"),
                    child: Text("This is child"),
                  );
                },
              );
            },
            child: const Text('Dialog'),
          ),
          MDTap(
            onPressed: () {
              showMDDrawer(
                context: context,
                builder: (context) {
                  return const MDSlidingDrawer(
                    child: MDPanel(
                      title: Text("This is child"),
                      description: Text("This is description"),
                      footer: Text("This is footer"),
                      child: Text("This is child"),
                    ),
                  );
                },
              );
            },
            child: const Text('Drawer'),
          ),
        ],
      ),
    );
  }
}

class MoodboardStory extends StatelessWidget {
  MoodboardStory({super.key});

  final List<Map<String, Object>> tiles = [
    {'url': 'https://picsum.photos/id/1/200/300', 'span': 3},
    {'url': 'https://picsum.photos/id/2/200/300', 'span': 2},
    {'url': 'https://picsum.photos/id/3/200/300', 'span': 1},
    {'url': 'https://picsum.photos/id/4/200/300', 'span': 4},
  ];

  @override
  Widget build(BuildContext context) {
    return MDScaffold(
      appBar: MDAppBar(
        title: const Text('Moodboard'),
        asPageHeader: true,
      ),
      body: Center(
        child: MDPanel(
          width: 450,
          child: MDMoodboard(
            crossAxisCount: 8,
            tileCount: tiles.length,
            tileBuilder: (context, index, crossAxisCount, crossAxisSpacing,
                mainAxisSpacing, cellWidth, onTileHeightComputed) {
              return MDAsyncImageTile(
                  imageUrl: tiles[index]['url'] as String,
                  tileCrossAxisSpan: tiles[index]['span'] as int,
                  onTileHeightComputed: onTileHeightComputed,
                  cellWidth: cellWidth,
                  crossAxisSpacing: crossAxisSpacing,
                  mainAxisSpacing: mainAxisSpacing,
                  builder: (context, url) {
                    return MDNetworkImage(
                      src: url,
                    );
                  });
            },
          ),
        ),
      ),
    );
  }
}
