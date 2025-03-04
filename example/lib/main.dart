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
            child: [const ButtonsStory(), const CardStory()][_selectedIndex],
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
