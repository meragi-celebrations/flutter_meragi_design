import 'package:flutter/material.dart';
import 'package:flutter_meragi_design/flutter_meragi_design.dart';

class MarkdownEditorStory extends StatefulWidget {
  const MarkdownEditorStory({super.key});

  @override
  State<MarkdownEditorStory> createState() => _MarkdownEditorStoryState();
}

class _MarkdownEditorStoryState extends State<MarkdownEditorStory> {
  String _editorText = '# Welcome to Markdown Editor\n\nThis is a **line-by-line** markdown editor with **inline formatting** support.\n\n## Features\n\n- Click on any line to edit it\n- See formatted preview when not focused\n- Supports headers (# ## ###)\n- Supports **bold text** with `**text**`\n- Supports *italic text* with `*text*`\n- Supports `inline code` with backticks\n- Supports bullet lists with `-`, `*`, or `+`\n- Supports numbered lists with `1.`, `2.`, etc.\n- Supports blockquotes with `>`\n- Supports links with `[text](url)`\n- Supports code blocks with ```\n\n### Try it out!\n\nType some markdown and see it render in real-time. Try:\n- **Bold text** using `**text**`\n- *Italic text* using `*text*`\n- `Inline code` using backticks\n- Combine them: **Bold with *italic* and `code`**\n\n### Lists\n\n- First bullet item\n- Second bullet item with **bold text**\n- Third bullet item with *italic text*\n\n1. First numbered item\n2. Second numbered item with `code`\n3. Third numbered item\n\n### Blockquotes\n\n> This is a blockquote with **bold text** and *italic text*\n> It can span multiple lines\n> And support inline formatting like `code`\n\n### Links\n\nCheck out [Flutter](https://flutter.dev) and [Dart](https://dart.dev) for more information. You can also create links with **bold text** like [**Flutter Docs**](https://docs.flutter.dev).\n\n### Code Blocks\n\n```dart\nvoid main() {\n  print("Hello, Flutter!");\n}\n```\n\n```json\n{\n  "name": "Flutter",\n  "type": "framework"\n}\n```';

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    
    return MDScaffold(
      appBar: const MDAppBar(
        title: Text('Markdown Editor'),
        asPageHeader: true,
      ),
      body: MDPanel(
        width: 600,
        title: const Text('Line-by-Line Markdown Editor'),
        description: const Text(
          'Edit markdown content line by line. Click on any line to edit it, and see the formatted preview when not focused. Now supports inline formatting!',
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Expanded(
              child: LineMarkdownEditor(
                initialText: _editorText,
                onChanged: (text) {
                },
                width: double.infinity,
                height: 400,
              ),
            ),
            const SizedBox(height: 20),
            const Text('Instructions:'),
            const Text('• Click on any line to edit it'),
            const Text('• Type # for H1, ## for H2, ### for H3'),
            const Text('• Type **text** for bold formatting'),
            const Text('• Type *text* for italic formatting'),
            const Text('• Type `code` for inline code formatting'),
            const Text('• Type - item for bullet lists'),
            const Text('• Type 1. item for numbered lists'),
            const Text('• Type > text for blockquotes'),
            const Text('• Type [text](url) for links'),
            const Text('• Type ``` for code blocks'),
            const Text('• Click outside to see formatted preview'),
          ],
        ),
      ),
    );
  }
} 