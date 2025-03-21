import 'package:flutter/material.dart';
import 'package:flutter_meragi_design/flutter_meragi_design.dart';

void main() {
  runApp(const EditorExampleApp());
}

class EditorExampleApp extends StatelessWidget {
  const EditorExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MDEditor Example',
      theme: ThemeData.light(),
      home: const EditorExampleScreen(),
    );
  }
}

class EditorExampleScreen extends StatelessWidget {
  const EditorExampleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final editorState =
        EditorState.blank(withInitialText: true); // Ensure valid initial state

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: MDEditor(
          editorState: editorState, // Pass initialized editor state
        ),
      ),
    );
  }
}
