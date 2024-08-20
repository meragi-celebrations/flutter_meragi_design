import 'package:example/cards.dart';
import 'package:example/crud_main.dart';
import 'package:example/descriptions.dart';
import 'package:example/fields.dart';
import 'package:example/tags.dart';
import 'package:example/typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_meragi_design/flutter_meragi_design.dart';

import 'buttons.dart';

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
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          Button(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const TypographyDetails(),
                ),
              );
            },
            // expand: true,
            child: const Text("Typography"),
          ),
          Button(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ButtonsDetails(),
                ),
              );
            },
            // expand: true,
            child: const Text("Buttons"),
          ),
          Button(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CardDetails(),
                ),
              );
            },
            // expand: true,
            child: const Text("Cards"),
          ),
          Button(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const TagDetails(),
                ),
              );
            },
            // expand: true,
            child: const Text("Tags"),
          ),
          Button(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const DescriptionDetails(),
                ),
              );
            },
            // expand: true,
            child: const Text("Descriptions"),
          ),
          Button(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const FieldDetails(),
                ),
              );
            },
            // expand: true,
            child: const Text("Fields"),
          ),
          Button(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CrudMain(),
                ),
              );
            },
            // expand: true,
            child: const Text("CRUD"),
          ),
        ],
      ),
    );
  }
}
