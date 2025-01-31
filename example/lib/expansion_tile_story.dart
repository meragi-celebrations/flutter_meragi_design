import 'package:flutter/material.dart';
import 'package:flutter_meragi_design/flutter_meragi_design.dart';
import 'package:storybook_flutter/storybook_flutter.dart';

class ExpansionTileStory extends StatefulWidget {
  const ExpansionTileStory({super.key});

  @override
  State<ExpansionTileStory> createState() => _ExpansionTileStoryState();
}

class _ExpansionTileStoryState extends State<ExpansionTileStory> {
  late final MDExpansionTileController controller1;
  late final MDExpansionTileController controller2;
  late final MDExpansionTileController controller3;
  bool firstTime = true;

  @override
  void initState() {
    super.initState();
    controller1 = MDExpansionTileController();
    controller2 = MDExpansionTileController();
    controller3 = MDExpansionTileController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    context.knobs.boolean(label: "Expand", initial: false)
        ? WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            firstTime = false;
            if (!firstTime) {
              controller1.expand();
              controller2.expand();
              controller3.expand();
            }
          })
        : WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            if (!firstTime) {
              controller1.collapse();
              controller2.collapse();
              controller3.collapse();
            }
          });
  }

  @override
  void dispose() {
    controller1.dispose();
    controller2.dispose();
    controller3.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.white,
      child: Row(
        children: [
          Expanded(
            child: ListView(
              children: [
                const BodyText(text: "Expandable Programitaclly"),
                MDExpansionTile(
                  decoration: MDExpansionTileDecoration(context: context),
                  controller: controller1,
                  title: const H5(text: "Expansion Tile1"),
                  expandedChildren: const [
                    ListTile(title: H6(text: "Child 1"), subtitle: BodyText(text: "Child 1.1")),
                    ListTile(title: H6(text: "Child 2"), subtitle: BodyText(text: "Child 2.2"))
                  ],
                ),
                const SizedBox(height: 10),
                const BodyText(text: "Initially Expanded"),
                MDExpansionTile(
                  controller: controller2,
                  initiallyExpanded: true,
                  decoration: MDExpansionTileDecoration(context: context),
                  title: const H5(text: "Expansion Tile2"),
                  expandedChildren: const [
                    ListTile(title: H6(text: "Child 1"), subtitle: BodyText(text: "Child 1.1")),
                    ListTile(title: H6(text: "Child 2"), subtitle: BodyText(text: "Child 2.2"))
                  ],
                ),
                const SizedBox(height: 10),
                const BodyText(text: "Custom Expand More button"),
                MDExpansionTile(
                  controller: controller3,
                  trailingIcon: const Icon(Icons.arrow_downward),
                  title: const H5(text: "Expansion Tile3"),
                  expandedChildren: const [
                    ListTile(title: H6(text: "Child 1"), subtitle: BodyText(text: "Child 1.1")),
                    ListTile(title: H6(text: "Child 2"), subtitle: BodyText(text: "Child 2.2"))
                  ],
                )
              ],
            ),
          ),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ValueListenableBuilder(
                  valueListenable: controller1,
                  builder: (context, value, child) => BodyText(text: "Tile 1: ${value ? "Expanded" : "Collapsed"}"),
                ),
                ValueListenableBuilder(
                  valueListenable: controller2,
                  builder: (context, value, child) => BodyText(text: "Tile 2: ${value ? "Expanded" : "Collapsed"}"),
                ),
                ValueListenableBuilder(
                  valueListenable: controller3,
                  builder: (context, value, child) => BodyText(text: "Tile 3: ${value ? "Expanded" : "Collapsed"}"),
                ),
              ].withSpaceBetween(height: 20),
            ),
          )
        ],
      ),
    );
  }
}
