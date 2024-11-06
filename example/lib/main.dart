import 'package:example/buttons.dart';
import 'package:example/cards.dart';
import 'package:example/crud/repo.dart';
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
      initialStory: "Data/Typography",
      stories: [
        Story(
          name: "Data/Typography",
          builder: (context) {
            String textKnob = context.knobs.text(label: "Text", initial: "The quick brown fox jumps over the lazy dog");

            TextType type = context.knobs.options(
              label: "Type",
              initial: TextType.primary,
              options: TextType.values.map((e) => Option(label: e.name, value: e)).toList(),
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
                  options: ButtonType.values.map((e) => Option(label: e.name, value: e)).toList(),
                ),
                size: context.knobs.options(
                  label: "Button Size",
                  initial: ButtonSize.rg,
                  options: ButtonSize.values.map((e) => Option(label: e.name, value: e)).toList(),
                ),
                variant: context.knobs.options(
                  label: "Button Variant",
                  initial: ButtonVariant.filled,
                  options: ButtonVariant.values.map((e) => Option(label: e.name, value: e)).toList(),
                ),
              ),
              onTap: () {},
              icon: context.knobs.boolean(label: "Show Icon", initial: true) ? Icons.import_contacts : null,
              isLoading: context.knobs.boolean(label: "Is Loading", initial: false),
              child: context.knobs.boolean(label: "Show Child", initial: true)
                  ? Text(
                      context.knobs.text(label: "Label text", initial: "Button"),
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
                  options: ButtonType.values.map((e) => Option(label: e.name, value: e)).toList(),
                ),
                size: context.knobs.options(
                  label: "Button Size",
                  initial: ButtonSize.rg,
                  options: ButtonSize.values.map((e) => Option(label: e.name, value: e)).toList(),
                ),
                variant: context.knobs.options(
                  label: "Button Variant",
                  initial: ButtonVariant.filled,
                  options: ButtonVariant.values.map((e) => Option(label: e.name, value: e)).toList(),
                ),
              ),
              onTap: () {},
              icon: context.knobs.boolean(label: "Show Icon", initial: true) ? Icons.import_contacts : null,
              isLoading: context.knobs.boolean(label: "Is Loading", initial: false),
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
                      context.knobs.text(label: "Label text", initial: "Button"),
                    )
                  : null,
            );
          },
        ),
        Story(
            name: "Button/Segmented",
            builder: (context) {
              return const SegmentedButtonStory();
            }),
        Story(
          name: "Data/Description",
          builder: (context) {
            return MDDescription(
              direction: context.knobs.options(
                label: "Direction",
                initial: Axis.horizontal,
                options: Axis.values.map((e) => Option(label: e.name, value: e)).toList(),
              ),
              spacingBetweenItem: context.knobs.sliderInt(label: "Space Between Item", initial: 5).toDouble(),
              spacingBetweenKeyAndValue:
                  context.knobs.sliderInt(label: "Space Between Key and Value", initial: 3).toDouble(),
              minColumns: context.knobs.sliderInt(label: "Min columns", initial: 1),
              maxColumns: context.knobs.sliderInt(label: "Max columns", initial: 3),
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
          name: 'Data/Card',
          builder: (context) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: MDCard(
                    alignment: context.knobs.options(
                      label: "Alignment",
                      initial: CrossAxisAlignment.center,
                      options: CrossAxisAlignment.values.map((e) => Option(label: e.name, value: e)).toList(),
                    ),
                    decoration: CardDecoration(
                      context: context,
                      type: context.knobs.options(
                        label: "Card Type",
                        initial: CardType.primary,
                        options: CardType.values.map((e) => Option(label: e.name, value: e)).toList(),
                      ),
                      size: context.knobs.options(
                        label: "Card Size",
                        initial: CardSize.rg,
                        options: CardSize.values.map((e) => Option(label: e.name, value: e)).toList(),
                      ),
                    ),
                    header:
                        context.knobs.boolean(label: "Show Header", initial: true) ? const H2(text: "Header") : null,
                    body: const BodyText(text: "Body"),
                    footer: context.knobs.boolean(label: "Show footer", initial: true)
                        ? const BodyText(text: "Footer")
                        : null,
                  ),
                ),
              ],
            );
          },
        ),
        Story(
          name: "Helper/Loading Indicator",
          builder: (context) {
            return MDLoadingIndicator(
              color: Colors.black,
              radius: context.knobs.sliderInt(label: "Radius", initial: 20).toDouble(),
              strokeWidth: context.knobs.sliderInt(label: "Stroke Width", initial: 2).toDouble(),
              isLoading: context.knobs.boolean(label: "Is Loading", initial: true),
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
          name: "Layout/Navigation Rail",
          builder: (context) {
            return const NavigationRailStory();
          },
        ),
        Story(
          name: "Helper/Gesture Detector",
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
          name: "Layout/App Bar",
          builder: (context) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: MDScaffold(
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
          name: "Layout/Base",
          builder: (context) {
            return MDLayout(
              sider: MDNavigationRail(
                destinations: const [],
                onDestinationSelected: (_) {},
              ),
              content: const MDScaffold(
                body: SizedBox(),
              ),
            );
          },
        ),
        Story(
          name: "Layout/Split Scaffold",
          builder: (context) {
            return MDLayout(
              sider: MDNavigationRail(
                destinations: const [],
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
              isClearable: context.knobs.boolean(label: "Is Clearable", initial: true),
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
              isClearable: context.knobs.boolean(label: "Is Clearable", initial: true),
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
                    label: const Text("Text"),
                    child: MDTextField(name: "text"),
                  ),
                  MDFormItem(
                    label: const Text("Checkbox 1"),
                    child: MDFormCheckboxList(
                      key: const ValueKey('services'), // Ensure unique key
                      name: "checkbox1",
                      options: List.generate(
                        5,
                        (index) => MDCheckboxOption("Item $index", index.toString()),
                      ),
                    ),
                  ),
                  MDFormItem(
                    label: const Text("Checkbox 2"),
                    child: MDFormCheckboxList.dynamic(
                      key: const ValueKey('status'), // Ensure unique key
                      name: "checkbox2",
                      isMultiSelect: false,
                      optionBuilder: (item) {
                        return MDCheckboxOption("${item.title} ${item.id}", item.id.toString());
                      },
                      listBloc: GetListBloc<TodoModel>(
                        url: "https://jsonplaceholder.typicode.com/todos/",
                        repo: ExampleRepo(),
                        fromJson: TodoModel.staticFromJson,
                        isInfinite: true,
                      ),
                    ),
                  ),
                ],
                onFilterSubmit: (_) {},
                filterBuilder: (key, value) {
                  print("key $key value $value");
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
              options: Axis.values.map((e) => Option(label: e.name, value: e)).toList(),
            );
            bool isGrid = context.knobs.boolean(label: "Is Grid", initial: false);
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
            var getListBloc = GetListBloc<TodoModel>(
              url: "https://jsonplaceholder.typicode.com/todos/",
              repo: ExampleRepo(),
              fromJson: TodoModel.staticFromJson,
            );
            return FormBuilder(
              key: _formKey,
              child: Column(
                children: [
                  MDFormItem(
                    label: const Text("Text"),
                    labelPosition: labelPostion,
                    isGrid: isGrid,
                    gridValues: gridValues,
                    contentSpace: contentSpace,
                    child: MDTextField(
                      name: "text",
                      validator: FormBuilderValidators.compose([FormBuilderValidators.required()]),
                    ),
                  ),
                  MDFormItem(
                    label: const Text("Checkbox"),
                    labelPosition: labelPostion,
                    isGrid: isGrid,
                    gridValues: gridValues,
                    contentSpace: contentSpace,
                    child: MDFormCheckboxList(
                      name: "checkbox",
                      options: List.generate(
                        5,
                        (index) => MDCheckboxOption(
                          "Item $index",
                          index.toString(),
                        ),
                      ),
                      validator: FormBuilderValidators.compose([FormBuilderValidators.required()]),
                    ),
                  ),
                  MDSearchableDropdown<int, TodoModel>(
                    name: "select",
                    getListBloc: getListBloc,
                    optionBuilder: (e) => MDDropdownMenuEntry(
                      label: e.title!,
                      value: e.id!,
                    ),
                  ),
                  MDFormItem(
                    label: const Text("Checkbox"),
                    labelPosition: labelPostion,
                    isGrid: isGrid,
                    gridValues: gridValues,
                    contentSpace: contentSpace,
                    child: MDFormCheckbox(
                      name: "checkbox",
                      validator: FormBuilderValidators.compose([FormBuilderValidators.required()]),
                    ),
                  ),
                  MDButton(
                    onTap: () {
                      _formKey.currentState?.saveAndValidate();
                      print("save ${_formKey.currentState?.value}");
                    },
                    child: const Text("Save"),
                  )
                ],
              ),
            );
          },
        ),
        Story(
          name: "Data/Image",
          builder: (context) => MDNetworkImage(
            src: "https://picsum.photos/1008",
            preview: context.knobs.boolean(
              label: "Preview",
              initial: true,
            ),
          ),
        ),
        Story(
          name: "Data/Tag",
          builder: (context) => MDTag(
            text: context.knobs.boolean(label: "Text", initial: true) ? "Warehouse" : null,
            icon: context.knobs.boolean(label: "Icon", initial: true) ? Icons.warehouse : null,
            decoration: TagDecoration(
              context: context,
              type: context.knobs.options(
                label: "Type",
                initial: TagType.defaultType,
                options: TagType.values.map((e) => Option(label: e.name, value: e)).toList(),
              ),
              size: context.knobs.options(
                label: "Size",
                initial: TagSize.rg,
                options: TagSize.values.map((e) => Option(label: e.name, value: e)).toList(),
              ),
            ),
          ),
        ),
        Story(
          name: "Dialog/Alert Dialog",
          builder: (context) {
            String? title = context.knobs.nullable.text(label: "Title", enabled: false);
            String? okText = context.knobs.nullable.text(
              label: "OK Text",
              enabled: false,
            );
            String? cancelText = context.knobs.nullable.text(
              label: "Cancel Text",
              enabled: false,
            );
            String? backText = context.knobs.nullable.text(
              label: "Back Text",
              enabled: false,
            );

            bool showBack = context.knobs.boolean(
              label: "Show Back",
              initial: false,
            );

            bool isDestructive = context.knobs.boolean(
              label: "Destructive",
              initial: false,
            );

            CardType type = context.knobs.options(
              label: "Type",
              initial: CardType.defaultType,
              options: CardType.values.map((e) => Option(label: e.name, value: e)).toList(),
            );

            return MDScaffold(
                body: Center(
              child: MDButton(
                child: const Text("Show"),
                onTap: () {
                  showMDAlertDialog(
                    context: context,
                    builder: (context) {
                      return MDAlertDialog(
                        title: title,
                        content: const Text("heelo"),
                        okText: okText,
                        cancelText: cancelText,
                        backText: backText,
                        onOk: () {},
                        onBack: showBack ? () {} : null,
                        isDestructive: isDestructive,
                        type: type,
                      );
                    },
                  );
                },
              ),
            ));
          },
        ),
        Story(
          name: "Dialog/Drawer",
          builder: (context) {
            SlidePosition position = context.knobs.options(
              label: "Position",
              initial: SlidePosition.right,
              options: SlidePosition.values.map((e) => Option(label: e.name, value: e)).toList(),
            );
            double width = context.knobs
                .sliderInt(
                  label: "Width",
                  initial: 500,
                  min: 300,
                  max: 1000,
                  divisions: 50,
                )
                .toDouble();
            double height = context.knobs
                .sliderInt(
                  label: "Height",
                  initial: 350,
                  min: 300,
                  max: 1000,
                  divisions: 50,
                )
                .toDouble();
            return MDScaffold(
              body: Center(
                child: MDButton(
                  onTap: () {
                    showMDDrawer(
                      context: context,
                      position: position,
                      width: width,
                      height: height,
                      builder: (context) {
                        return const MDCard(
                            header: Row(
                              children: [
                                H4(
                                  text: "Drawer",
                                )
                              ],
                            ),
                            body: BodyText(
                              text: "Body",
                            ));
                      },
                    );
                  },
                  child: const Text("Show"),
                ),
              ),
            );
          },
        ),
        Story(
          name: 'Helper/Divider',
          builder: (context) {
            var rotateChild = context.knobs.boolean(label: "Rotate Child", initial: false);
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Horizontal Dividers
                  MDDivider(rotateChild: rotateChild),
                  MDDivider(
                    rotateChild: rotateChild,
                    position: DividerPosition.start,
                    child: const Text('Start Text'),
                  ),
                  const SizedBox(height: 20),
                  const MDDivider(
                    position: DividerPosition.center,
                    color: Colors.red,
                    child: Text('Center Text'),
                  ),
                  const SizedBox(height: 20),
                  MDDivider(
                    position: DividerPosition.end,
                    rotateChild: rotateChild,
                    child: const Text('End Text'),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: Row(
                      children: [
                        MDDivider(
                          direction: Axis.vertical,
                          rotateChild: rotateChild,
                        ),
                        MDDivider(
                          direction: Axis.vertical,
                          rotateChild: rotateChild,
                          position: DividerPosition.start,
                          child: const Text('Top Text'),
                        ),
                        const SizedBox(width: 20),
                        MDDivider(
                          direction: Axis.vertical,
                          rotateChild: rotateChild,
                          position: DividerPosition.center,
                          child: const Text('Middle Text'),
                        ),
                        const SizedBox(width: 20),
                        MDDivider(
                          direction: Axis.vertical,
                          rotateChild: rotateChild,
                          position: DividerPosition.end,
                          child: const Text('Bottom Text'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        Story(
            name: "Data/Carousel",
            builder: (context) {
              return MDScaffold(
                body: MDCarousel(
                  showNavButtons: context.knobs.boolean(
                    label: "Show Nav Buttons",
                    initial: true,
                  ),
                  showPagination: context.knobs.boolean(
                    label: "Show Pagination",
                    initial: true,
                  ),
                  preview: context.knobs.boolean(
                    label: "Preview",
                    initial: false,
                  ),
                  controller: MDCarouselController(
                    itemExtent: context.knobs
                        .sliderInt(
                          label: "Width",
                          initial: 200,
                          min: 200,
                          max: 500,
                          divisions: 50,
                        )
                        .toDouble(),
                  ),
                  children: List.generate(
                    25,
                    (e) => CarouselItem(
                      child: MDNetworkImage(
                        src: "https://picsum.photos/id/${e}/300",
                        fit: BoxFit.cover,
                      ),
                      previewChild: MDZoomableImage(
                        image: MDNetworkImage(
                          src: "https://picsum.photos/id/${e}/300",
                          preview: false,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),
        Story(
            name: "Form/Fields/Date Picker",
            builder: (context) {
              return MDScaffold(
                body: Center(
                  child: Center(
                    child: MDButton(
                      onTap: () {
                        showMDDaterPicker(
                          context: context,
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2025),
                        );
                      },
                      child: const Text("Open Date Picker"),
                    ),
                  ),
                ),
              );
            }),
        Story(
            name: "Form/Fields/Date Range Picker",
            builder: (context) {
              return MDScaffold(
                body: Center(
                  child: Center(
                    child: MDButton(
                      onTap: () {
                        showMDDateRangePicker(
                          context: context,
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2025),
                        );
                      },
                      child: const Text("Open Date Picker"),
                    ),
                  ),
                ),
              );
            }),
        Story(
          name: "Form/Fields/Searchable Dropdown",
          builder: (context) {
            var getListBloc = GetListBloc<TodoModel>(
              url: "https://jsonplaceholder.typicode.com/todos/",
              repo: ExampleRepo(),
              fromJson: TodoModel.staticFromJson,
            );

            GlobalKey<FormBuilderState> _key = GlobalKey();

            return MDScaffold(
              body: Center(
                child: Center(
                  child: FormBuilder(
                    key: _key,
                    onChanged: () {
                      print("form changed, ${_key.currentState?.value}");
                    },
                    child: MDSearchableDropdown<int, TodoModel>(
                      name: "select",
                      getListBloc: getListBloc,
                      optionBuilder: (e) => MDDropdownMenuEntry(
                        label: e.title!,
                        value: e.id!,
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
        Story(
          name: "Form/Fields/HTML Editor",
          builder: (context) {
            return MDScaffold(
              body: Center(child: MDHtmlEditor(name: "html")),
            );
          },
        ),
        Story(
          name: "Enhanced Widget",
          builder: (context) {
            WidgetStatesController _controller = WidgetStatesController();

            return MDScaffold(
              body: Center(
                child: MDWidget(
                  statesController: _controller,
                  mouseCursor: MDWidgetStateResolver<MouseCursor>(
                          {WidgetState.hovered: SystemMouseCursors.click, "default": SystemMouseCursors.basic})
                      .resolveWith(),
                  builder: (context, states, _) {
                    return Container(
                      decoration: BoxDecoration(
                        color: MDWidgetStateResolver<Color>({
                          WidgetState.hovered: Colors.red,
                          WidgetState.pressed: Colors.yellow,
                          WidgetState.focused: Colors.green,
                          "default": Colors.blue
                        }).resolve(states),
                      ),
                      child: const BodyText(text: "Hello"),
                    );
                  },
                ),
              ),
            );
          },
        ),
        Story(
          name: 'List',
          builder: (context) {
            return ListStory();
          },
        ),
      ],
    );
  }
}

class MoodboardStory extends StatefulWidget {
  MoodboardStory({super.key});

  @override
  State<MoodboardStory> createState() => _MoodboardStoryState();
}

class _MoodboardStoryState extends State<MoodboardStory> {
  final List<String> images = [
    'https://d1p55htxo8z8mf.cloudfront.net/product/11013/59a659a8-8f6a-457a-905f-c36316343a06.jpg',
    "https://d1p55htxo8z8mf.cloudfront.net/product/10011/3618c085-ae85-4dea-8441-34ef1cb93c2d.jpg",
    "https://d1p55htxo8z8mf.cloudfront.net/product/10011/dbfff9ee-a114-47a3-b0dd-198b78bf9773.jpg",
    "https://d1p55htxo8z8mf.cloudfront.net/product/7936/41d87583-6182-4796-82dc-68a2a895e7a6.png",
    "https://d1p55htxo8z8mf.cloudfront.net/product/321/11962e0b-a039-4f64-b172-484be70f83ad.jpg",
    "https://d1p55htxo8z8mf.cloudfront.net/product/384/8b2a3c47-fdbb-413d-8e8f-1730e9c7c200.png",
    "https://d1p55htxo8z8mf.cloudfront.net/product/767/14a52fb7-90b1-48b5-9a25-34dc814d17ff.png",
    "https://d1p55htxo8z8mf.cloudfront.net/product/13591/dc40ebdf-f4e3-486d-85e3-5a8b0c4bc7c0.jpg",
    "https://d1p55htxo8z8mf.cloudfront.net/product/771/8c340059-6325-468b-9a0b-752fbed7dd3e.png",
    "https://d1p55htxo8z8mf.cloudfront.net/product/771/f7d9304d-833c-4c68-9857-4fdc228ffb57.png",
    "https://d1p55htxo8z8mf.cloudfront.net/product/29858/8ca21f98-c797-4f91-a987-e4f2c9906309.jpg",
    'https://d1p55htxo8z8mf.cloudfront.net/product/11013/59a659a8-8f6a-457a-905f-c36316343a06.jpg',
    "https://d1p55htxo8z8mf.cloudfront.net/product/10011/3618c085-ae85-4dea-8441-34ef1cb93c2d.jpg",
    "https://d1p55htxo8z8mf.cloudfront.net/product/10011/dbfff9ee-a114-47a3-b0dd-198b78bf9773.jpg",
    "https://d1p55htxo8z8mf.cloudfront.net/product/7936/41d87583-6182-4796-82dc-68a2a895e7a6.png",
    "https://d1p55htxo8z8mf.cloudfront.net/product/321/11962e0b-a039-4f64-b172-484be70f83ad.jpg",
    "https://d1p55htxo8z8mf.cloudfront.net/product/384/8b2a3c47-fdbb-413d-8e8f-1730e9c7c200.png",
    "https://d1p55htxo8z8mf.cloudfront.net/product/767/14a52fb7-90b1-48b5-9a25-34dc814d17ff.png",
    "https://d1p55htxo8z8mf.cloudfront.net/product/13591/dc40ebdf-f4e3-486d-85e3-5a8b0c4bc7c0.jpg",
    "https://d1p55htxo8z8mf.cloudfront.net/product/771/8c340059-6325-468b-9a0b-752fbed7dd3e.png",
    "https://d1p55htxo8z8mf.cloudfront.net/product/771/f7d9304d-833c-4c68-9857-4fdc228ffb57.png",
    "https://d1p55htxo8z8mf.cloudfront.net/product/29858/8ca21f98-c797-4f91-a987-e4f2c9906309.jpg"
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MDScaffold(
      body: MDMoodboard(
        // constraints: BoxConstraints(maxWidth: maxWidth),
        fillGaps: true,
        children: images
            .map(
              (i) => MDMoodboardItem(
                childrenCount: images.length,
                child: MDNetworkImage(src: i),
              ),
            )
            .toList(),
      ),
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
          onExpandTap: context.knobs.boolean(label: "Show Expand Button", initial: true)
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
  {"icon": const Icon(Icons.add_box), "label": "Scaffold", "widget": const ScaffoldDetails()},
  {"icon": const Icon(Icons.text_fields), "label": "Typography", "widget": const TypographyDetails()},
  {"icon": const Icon(Icons.text_fields), "label": "Buttons", "widget": const ButtonsDetails()},
  {"icon": const Icon(Icons.text_fields), "label": "Cards", "widget": const CardDetails()},
  {"icon": const Icon(Icons.text_fields), "label": "Tags", "widget": const TagDetails()},
  {"icon": const Icon(Icons.text_fields), "label": "Description", "widget": const DescriptionDetails()},
  {"icon": const Icon(Icons.text_fields), "label": "Fields", "widget": const FieldDetails()},
  {"icon": const Icon(Icons.text_fields), "label": "Crud", "widget": const CrudMain()},
];

class LayoutView extends StatefulWidget {
  const LayoutView({
    super.key,
  });

  @override
  State<LayoutView> createState() => _LayoutViewState();
}

class _LayoutViewState extends State<LayoutView> {
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

class SegmentedButtonStory extends StatefulWidget {
  const SegmentedButtonStory({super.key});

  @override
  State<SegmentedButtonStory> createState() => _SegmentedButtonStoryState();
}

enum Calendar { day, week, month, year }

class _SegmentedButtonStoryState extends State<SegmentedButtonStory> {
  Calendar calendarView = Calendar.day;
  @override
  Widget build(BuildContext context) {
    return MDSegmentedButton<Calendar>(
      segments: const <ButtonSegment<Calendar>>[
        ButtonSegment<Calendar>(value: Calendar.day, label: Text('Day'), icon: Icon(Icons.calendar_view_day)),
        ButtonSegment<Calendar>(value: Calendar.week, label: Text('Week'), icon: Icon(Icons.calendar_view_week)),
        ButtonSegment<Calendar>(value: Calendar.month, label: Text('Month'), icon: Icon(Icons.calendar_view_month)),
        ButtonSegment<Calendar>(value: Calendar.year, label: Text('Year'), icon: Icon(Icons.calendar_today)),
      ],
      selected: <Calendar>{calendarView},
      onSelectionChanged: (Set<Calendar> newSelection) {
        setState(() {
          // By default there is only a single segment that can be
          // selected at one time, so its value is always the first
          // item in the selected set.
          calendarView = newSelection.first;
        });
      },
    );
  }
}

class ListStory extends StatefulWidget {
  const ListStory({super.key});

  @override
  State<ListStory> createState() => _ListStoryState();
}

class _ListStoryState extends State<ListStory> {
  late GetListBloc<TodoModel> getListBloc;

  @override
  void initState() {
    super.initState();
    getListBloc = GetListBloc<TodoModel>(
      url: "https://jsonplaceholder.typicode.com/todos/",
      repo: ExampleRepo(),
      fromJson: TodoModel.staticFromJson,
    );
    getListBloc.get();
  }

  @override
  Widget build(BuildContext context) {
    return MDScaffold(
      body: MDList(
        listBloc: getListBloc,
        itemBuilder: (context, index) {
          FocusNode focusNode = FocusNode();
          return MDListTile(
            focusNode: focusNode,
            onTap: () {
              focusNode.requestFocus();
            },
            child: Text(getListBloc.list.value[index].title ?? ""),
          );
        },
      ),
    );
  }
}
