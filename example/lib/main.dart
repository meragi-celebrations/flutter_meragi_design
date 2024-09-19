import 'package:example/buttons.dart';
import 'package:example/cards.dart';
import 'package:example/crud_main.dart';
import 'package:example/descriptions.dart';
import 'package:example/fields.dart';
import 'package:example/scaffold_detail.dart';
import 'package:example/tags.dart';
import 'package:example/typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_meragi_design/flutter_meragi_design.dart';
import 'package:storybook_flutter/storybook_flutter.dart';

void main() async {
  await MeragiCrud.initCache();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MeragiTheme(
      token: isPlatform([MeragiPlatform.android, MeragiPlatform.ios])
          ? light
          : lightWide.copyWithColors(
              primary: Colors.deepPurple,
              success: Colors.green,
              error: Colors.redAccent,
              warning: Colors.orange,
              info: Colors.blue,
              secondary: Colors.deepPurpleAccent.shade100,
            ),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Meragi Design',
        theme: ThemeData(
          // This is the theme of your application.
          //
          // TRY THIS: Try running your application with "flutter run". You'll see
          // the application has a blue toolbar. Then, without quitting the app,
          // try changing the seedColor in the colorScheme below to Colors.green
          // and then invoke "hot reload" (save your changes or press the "hot
          // reload" button in a Flutter-supported IDE, or press "r" if you used
          // the command line to start the app).
          //
          // Notice that the counter didn't reset back to zero; the application
          // state is not lost during the reload. To reset the state, use hot
          // restart instead.
          //
          // This works for code too, not just values: Most code changes can be
          // tested with just a hot reload.
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const MyHomePage(title: 'Meragi Design'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    // return const Scaffold(
    //   body: Layout(),
    // );

    return Storybook(
      stories: [
        Story(
          name: "Typography",
          builder: (context) {
            String textKnob = context.knobs.text(
                label: "Text",
                initial: "The quick brown fox jumps over the lazy dog");

            TextType type = context.knobs.options(
              label: "Type",
              initial: TextType.primary,
              options: TextType.values
                  .map((e) => Option(label: e.name, value: e))
                  .toList(),
            );
            return Column(
              children: [
                DisplayText(
                  text: "DisplayText: $textKnob",
                  type: type,
                ),
                H1(
                  text: "H1: $textKnob",
                  type: type,
                ),
                H2(
                  text: "H2: $textKnob",
                  type: type,
                ),
                H3(
                  text: "H3: $textKnob",
                  type: type,
                ),
                H4(
                  text: "H4: $textKnob",
                  type: type,
                ),
                H5(
                  text: "H5: $textKnob",
                  type: type,
                ),
                H6(
                  text: "H6: $textKnob",
                  type: type,
                ),
                BodyText(
                  text: "BodyText: $textKnob",
                  type: type,
                ),
                LinkText(
                  text: "LinkText: $textKnob",
                  type: type,
                ),
                CaptionText(
                  text: "CaptionText: $textKnob",
                  type: type,
                ),
                CodeText(
                  text: "CodeText: $textKnob",
                  type: type,
                ),
                QuoteText(
                  text: "QuoteText: $textKnob",
                  type: type,
                ),
              ],
            );
          },
        ),
        Story(
          name: "Button/Simple",
          builder: (context) {
            return MDButton(
              decoration: ButtonDecoration(
                context: context,
                type: context.knobs.options(
                  label: "Button Type",
                  initial: ButtonType.primary,
                  options: ButtonType.values
                      .map((e) => Option(label: e.name, value: e))
                      .toList(),
                ),
                size: context.knobs.options(
                  label: "Button Size",
                  initial: ButtonSize.rg,
                  options: ButtonSize.values
                      .map((e) => Option(label: e.name, value: e))
                      .toList(),
                ),
                variant: context.knobs.options(
                  label: "Button Variant",
                  initial: ButtonVariant.filled,
                  options: ButtonVariant.values
                      .map((e) => Option(label: e.name, value: e))
                      .toList(),
                ),
              ),
              onTap: () {},
              icon: context.knobs.boolean(label: "Show Icon", initial: true)
                  ? Icons.import_contacts
                  : null,
              isLoading:
                  context.knobs.boolean(label: "Is Loading", initial: false),
              child: context.knobs.boolean(label: "Show Child", initial: true)
                  ? Text(
                      context.knobs
                          .text(label: "Label text", initial: "Button"),
                    )
                  : null,
            );
          },
        ),
        Story(
          name: "Button/Dropdown",
          builder: (context) {
            return MDButton.dropdown(
              decoration: ButtonDecoration(
                context: context,
                type: context.knobs.options(
                  label: "Button Type",
                  initial: ButtonType.primary,
                  options: ButtonType.values
                      .map((e) => Option(label: e.name, value: e))
                      .toList(),
                ),
                size: context.knobs.options(
                  label: "Button Size",
                  initial: ButtonSize.rg,
                  options: ButtonSize.values
                      .map((e) => Option(label: e.name, value: e))
                      .toList(),
                ),
                variant: context.knobs.options(
                  label: "Button Variant",
                  initial: ButtonVariant.filled,
                  options: ButtonVariant.values
                      .map((e) => Option(label: e.name, value: e))
                      .toList(),
                ),
              ),
              onTap: () {},
              icon: context.knobs.boolean(label: "Show Icon", initial: true)
                  ? Icons.import_contacts
                  : null,
              isLoading:
                  context.knobs.boolean(label: "Is Loading", initial: false),
              menuChildren: [
                MDButton(
                  onTap: () {},
                  icon: Icons.filter,
                  child: const Text("menu item"),
                )
              ],
              builder: (context, controller, child) {
                return MDGestureDetector(
                  onTap: () {
                    if (!controller.isOpen) {
                      controller.open();
                    } else {
                      controller.close();
                    }
                  },
                  child: const Icon(Icons.add),
                );
              },
              child: context.knobs.boolean(label: "Show Child", initial: true)
                  ? Text(
                      context.knobs
                          .text(label: "Label text", initial: "Button"),
                    )
                  : null,
            );
          },
        ),
        Story(
          name: "Description",
          builder: (context) {
            return MDDescription(
              direction: context.knobs.options(
                label: "Direction",
                initial: Axis.horizontal,
                options: Axis.values
                    .map((e) => Option(label: e.name, value: e))
                    .toList(),
              ),
              spacingBetweenItem: context.knobs
                  .sliderInt(label: "Space Between Item", initial: 5)
                  .toDouble(),
              spacingBetweenKeyAndValue: context.knobs
                  .sliderInt(label: "Space Between Key and Value", initial: 3)
                  .toDouble(),
              minColumns:
                  context.knobs.sliderInt(label: "Min columns", initial: 1),
              maxColumns:
                  context.knobs.sliderInt(label: "Max columns", initial: 3),
              data: List.generate(
                  context.knobs.sliderInt(label: "Item Count", initial: 8),
                  (index) => DescriptionItem(
                        label: Text('Label $index'),
                        value: Text('Value $index'),
                      )),
            );
          },
        ),
        Story(
          name: 'Card',
          builder: (context) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: MDCard(
                    alignment: context.knobs.options(
                      label: "Alignment",
                      initial: CrossAxisAlignment.center,
                      options: CrossAxisAlignment.values
                          .map((e) => Option(label: e.name, value: e))
                          .toList(),
                    ),
                    decoration: CardDecoration(
                      context: context,
                      type: context.knobs.options(
                        label: "Card Type",
                        initial: CardType.primary,
                        options: CardType.values
                            .map((e) => Option(label: e.name, value: e))
                            .toList(),
                      ),
                      size: context.knobs.options(
                        label: "Card Size",
                        initial: CardSize.rg,
                        options: CardSize.values
                            .map((e) => Option(label: e.name, value: e))
                            .toList(),
                      ),
                    ),
                    header: context.knobs
                            .boolean(label: "Show Header", initial: true)
                        ? const H2(text: "Header")
                        : null,
                    body: const BodyText(text: "Body"),
                    footer: context.knobs
                            .boolean(label: "Show footer", initial: true)
                        ? const BodyText(text: "Footer")
                        : null,
                  ),
                ),
              ],
            );
          },
        ),
        Story(
          name: "Loading Indicator",
          builder: (context) {
            return MDLoadingIndicator(
              color: Colors.black,
              radius: context.knobs
                  .sliderInt(label: "Radius", initial: 20)
                  .toDouble(),
              strokeWidth: context.knobs
                  .sliderInt(label: "Stroke Width", initial: 2)
                  .toDouble(),
              isLoading:
                  context.knobs.boolean(label: "Is Loading", initial: true),
              child: context.knobs.boolean(label: "Show child", initial: false)
                  ? Container(
                      height: 200,
                      width: 200,
                      color: Colors.yellow,
                    )
                  : null,
            );
          },
        ),
        Story(
          name: "Navigation Rail",
          builder: (context) {
            return const NavigationRailStory();
          },
        ),
        Story(
          name: "Gesture Detector",
          builder: (context) {
            return MDGestureDetector(
              onTap: () {},
              isDisabled: context.knobs.boolean(
                label: "Is Disabled",
                initial: false,
              ),
              child: Container(
                height: 200,
                width: 200,
                color: Colors.yellow,
              ),
            );
          },
        ),
        Story(
          name: "App Bar",
          builder: (context) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Scaffold(
                appBar: MDAppBar(
                  title: Text(
                    context.knobs.text(label: "Title", initial: "Title"),
                  ),
                  asPageHeader: context.knobs.boolean(
                    label: "As Page Header",
                    initial: false,
                  ),
                ),
                body: const SizedBox(),
              ),
            );
          },
        ),
        Story(
          name: "Layout",
          builder: (context) {
            return MDLayout(
              sider: MDNavigationRail(
                destinations: [],
                onDestinationSelected: (_) {},
              ),
              content: const MDScaffold(
                body: SizedBox(),
              ),
            );
          },
        ),
        Story(
          name: "Split Scaffold",
          builder: (context) {
            return MDLayout(
              sider: MDNavigationRail(
                destinations: [],
                onDestinationSelected: (_) {},
              ),
              content: const MDScaffold.split(
                leftChild: SizedBox(),
                rightChild: SizedBox(),
              ),
            );
          },
        ),
        Story(
          name: "Form/Fields/Text",
          builder: (context) {
            return MDTextField(
              name: "text",
              isClearable:
                  context.knobs.boolean(label: "Is Clearable", initial: true),
              onChanged: (_) {},
            );
          },
        ),
        Story(
          name: "Form/Fields/Switch",
          builder: (context) {
            return MDSwitch(name: "This is name");
          },
        ),
        Story(
          name: "Form/Fields/Dropdown",
          builder: (context) {
            return MDDropdown(
              name: "drowpdown",
              isClearable:
                  context.knobs.boolean(label: "Is Clearable", initial: true),
              items: List.generate(
                5,
                (index) => DropdownMenuItem(
                  child: Text("Item $index"),
                  value: index,
                ),
              ),
            );
          },
        ),
        Story(
          name: "Form/Fields/Checkbox|Radio List",
          builder: (context) {
            return MDFormCheckboxList(
              name: "drowpdown",
              isMultiSelect: context.knobs.boolean(
                label: "Is Multiselect",
                initial: true,
              ),
              options: List.generate(
                5,
                (index) => MDCheckboxOption(
                  "Item $index",
                  index.toString(),
                ),
              ),
            );
          },
        ),
        Story(
          name: "Form/Filter",
          builder: (context) {
            return MDFilterFormView(
                formKey: GlobalKey<FormBuilderState>(),
                formItems: [
                  MDFormItem(
                    label: Text("Text"),
                    child: MDTextField(name: "text"),
                  ),
                  MDFormItem(
                    label: Text("Checkbox"),
                    child: MDFormCheckboxList(
                      name: "text",
                      options: List.generate(
                        5,
                        (index) => MDCheckboxOption(
                          "Item $index",
                          index.toString(),
                        ),
                      ),
                    ),
                  ),
                ],
                onFilterSubmit: (_) {},
                filterBuilder: (key, value) {
                  return MDFilter(field: key, operator: "eq", value: value);
                });
          },
        ),
        Story(
          name: "Form/Form Builder",
          builder: (context) {
            var _formKey = GlobalKey<FormBuilderState>();
            Axis labelPostion = context.knobs.options(
              label: "Label Position",
              initial: Axis.vertical,
              options: Axis.values
                  .map((e) => Option(label: e.name, value: e))
                  .toList(),
            );
            bool isGrid =
                context.knobs.boolean(label: "Is Grid", initial: false);
            GridLayoutValues gridValues = GridLayoutValues(
              context.knobs.sliderInt(label: "Label Flex", initial: 1),
              context.knobs.sliderInt(label: "Field Flex", initial: 9),
            );
            double contentSpace = context.knobs
                .sliderInt(
                  label: "Content Space",
                  initial: 3,
                )
                .toDouble();
            return FormBuilder(
              key: _formKey,
              child: Column(
                children: [
                  MDFormItem(
                    label: Text("Text"),
                    labelPosition: labelPostion,
                    isGrid: isGrid,
                    gridValues: gridValues,
                    contentSpace: contentSpace,
                    child: MDTextField(
                      name: "text",
                      validator: FormBuilderValidators.compose(
                          [FormBuilderValidators.required()]),
                    ),
                  ),
                  MDFormItem(
                    label: Text("Checkbox"),
                    labelPosition: labelPostion,
                    isGrid: isGrid,
                    gridValues: gridValues,
                    contentSpace: contentSpace,
                    child: MDFormCheckboxList(
                      name: "text",
                      options: List.generate(
                        5,
                        (index) => MDCheckboxOption(
                          "Item $index",
                          index.toString(),
                        ),
                      ),
                      validator: FormBuilderValidators.compose(
                          [FormBuilderValidators.required()]),
                    ),
                  ),
                  MDButton(
                    onTap: () {
                      _formKey.currentState?.saveAndValidate();
                    },
                    child: Text("Save"),
                  )
                ],
              ),
            );
          },
        )
      ],
    );
  }
}

class NavigationRailStory extends StatefulWidget {
  const NavigationRailStory({super.key});

  @override
  State<NavigationRailStory> createState() => _NavigationRailStoryState();
}

class _NavigationRailStoryState extends State<NavigationRailStory> {
  int _selectedIndex = 0;
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return MDLayout(
      sider: MDNavigationRail(
          destinations: List.generate(
            context.knobs.sliderInt(label: "Items", initial: 4),
            (index) => MDNavigationRailDestination(
              icon: const Icon(Icons.list),
              label: 'Item $index',
              selectedColor: Colors.deepPurple.shade100.withOpacity(.5),
            ),
          ),
          selectedIndex: _selectedIndex,
          onDestinationSelected: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          isExpanded: _isExpanded,
          onExpandTap:
              context.knobs.boolean(label: "Show Expand Button", initial: true)
                  ? () {
                      setState(() {
                        _isExpanded = !_isExpanded;
                      });
                    }
                  : null),
      content: const MDScaffold(body: Text("this is content")),
    );
  }
}

List<Map<String, dynamic>> pages = [
  {
    "icon": const Icon(Icons.add_box),
    "label": "Scaffold",
    "widget": const ScaffoldDetails()
  },
  {
    "icon": const Icon(Icons.text_fields),
    "label": "Typography",
    "widget": const TypographyDetails()
  },
  {
    "icon": const Icon(Icons.text_fields),
    "label": "Buttons",
    "widget": const ButtonsDetails()
  },
  {
    "icon": const Icon(Icons.text_fields),
    "label": "Cards",
    "widget": const CardDetails()
  },
  {
    "icon": const Icon(Icons.text_fields),
    "label": "Tags",
    "widget": const TagDetails()
  },
  {
    "icon": const Icon(Icons.text_fields),
    "label": "Description",
    "widget": const DescriptionDetails()
  },
  {
    "icon": const Icon(Icons.text_fields),
    "label": "Fields",
    "widget": const FieldDetails()
  },
  {
    "icon": const Icon(Icons.text_fields),
    "label": "Crud",
    "widget": const CrudMain()
  },
];

class Layout extends StatefulWidget {
  const Layout({
    super.key,
  });

  @override
  State<Layout> createState() => _LayoutState();
}

class _LayoutState extends State<Layout> {
  int _currentIndex = 0;
  bool _isExpanded = true;

  @override
  Widget build(BuildContext context) {
    return MDLayout(
      sider: MDNavigationRail(
        logo: const FlutterLogo(
          size: 30,
        ),
        expandedLogo: const Row(
          children: [
            FlutterLogo(
              size: 30,
            ),
            H3(text: "Meragi")
          ],
        ),
        destinations: pages
            .map(
              (item) => MDNavigationRailDestination(
                icon: item['icon'],
                label: item['label'],
                selectedColor: Colors.deepPurple.shade100.withOpacity(.5),
              ),
            )
            .toList(),
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        isExpanded: _isExpanded,
        onExpandTap: () {
          setState(() {
            _isExpanded = !_isExpanded;
          });
        },
      ),
      content: pages[_currentIndex]['widget'],
    );
  }
}
