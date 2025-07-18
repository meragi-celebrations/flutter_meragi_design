import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_meragi_design/flutter_meragi_design.dart';

void main() {
  group('LineMarkdownEditor Enter Key Tests', () {
    Widget createTestWidget(String initialText) {
      return MeragiTheme(
        token: lightWide_v2,
        child: MaterialApp(
          home: Scaffold(
            body: LineMarkdownEditor(
              initialText: initialText,
              width: 400,
              height: 200,
            ),
          ),
        ),
      );
    }

    testWidgets('Enter key should split line at cursor position', (WidgetTester tester) async {
      // Build the widget with proper theme
      await tester.pumpWidget(createTestWidget('Hello World'));

      // Wait for the widget to build
      await tester.pumpAndSettle();

      // Find the first line (which should be focused initially)
      final textField = find.byType(TextField);
      expect(textField, findsOneWidget);

      // Set cursor position to after "Hello " (position 6)
      await tester.tap(textField);
      await tester.pumpAndSettle();
      
      // Simulate typing to set cursor position
      await tester.enterText(textField, 'Hello World');
      await tester.pumpAndSettle();
      
      // Move cursor to position 6 (after "Hello ")
      final textFieldWidget = tester.widget<TextField>(textField);
      final controller = textFieldWidget.controller;
      controller?.selection = TextSelection.collapsed(offset: 6);
      await tester.pumpAndSettle();

      // Press Enter key
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pumpAndSettle();

      // Verify that the line was split correctly
      // The first line should contain "Hello "
      // The second line should contain "World"
      
      // Check that we now have two text fields
      final textFields = find.byType(TextField);
      expect(textFields, findsNWidgets(2));
      
      // Verify the content of the first line
      final firstTextField = tester.widget<TextField>(textFields.first);
      expect(firstTextField.controller?.text, 'Hello ');
      
      // Verify the content of the second line
      final secondTextField = tester.widget<TextField>(textFields.last);
      expect(secondTextField.controller?.text, 'World');
    });

    testWidgets('Enter key at end of line should create empty new line', (WidgetTester tester) async {
      // Build the widget with proper theme
      await tester.pumpWidget(createTestWidget('Hello World'));

      // Wait for the widget to build
      await tester.pumpAndSettle();

      // Find the text field
      final textField = find.byType(TextField);
      expect(textField, findsOneWidget);

      // Tap to focus
      await tester.tap(textField);
      await tester.pumpAndSettle();
      
      // Enter text and move cursor to end
      await tester.enterText(textField, 'Hello World');
      await tester.pumpAndSettle();
      
      // Move cursor to end of line
      final textFieldWidget = tester.widget<TextField>(textField);
      final controller = textFieldWidget.controller;
      controller?.selection = TextSelection.collapsed(offset: 11); // End of "Hello World"
      await tester.pumpAndSettle();

      // Press Enter key
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pumpAndSettle();

      // Verify that we now have two text fields
      final textFields = find.byType(TextField);
      expect(textFields, findsNWidgets(2));
      
      // Verify the content of the first line
      final firstTextField = tester.widget<TextField>(textFields.first);
      expect(firstTextField.controller?.text, 'Hello World');
      
      // Verify the content of the second line (should be empty)
      final secondTextField = tester.widget<TextField>(textFields.last);
      expect(secondTextField.controller?.text, '');
    });

    testWidgets('Enter key at beginning of line should create empty line above', (WidgetTester tester) async {
      // Build the widget with proper theme
      await tester.pumpWidget(createTestWidget('Hello World'));

      // Wait for the widget to build
      await tester.pumpAndSettle();

      // Find the text field
      final textField = find.byType(TextField);
      expect(textField, findsOneWidget);

      // Tap to focus
      await tester.tap(textField);
      await tester.pumpAndSettle();
      
      // Enter text and move cursor to beginning
      await tester.enterText(textField, 'Hello World');
      await tester.pumpAndSettle();
      
      // Move cursor to beginning of line
      final textFieldWidget = tester.widget<TextField>(textField);
      final controller = textFieldWidget.controller;
      controller?.selection = TextSelection.collapsed(offset: 0);
      await tester.pumpAndSettle();

      // Press Enter key
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pumpAndSettle();

      // Verify that we now have two text fields
      final textFields = find.byType(TextField);
      expect(textFields, findsNWidgets(2));
      
      // Verify the content of the first line (should be empty)
      final firstTextField = tester.widget<TextField>(textFields.first);
      expect(firstTextField.controller?.text, '');
      
      // Verify the content of the second line
      final secondTextField = tester.widget<TextField>(textFields.last);
      expect(secondTextField.controller?.text, 'Hello World');
    });
  });

  group('MarkdownParser Node-Based Tests', () {
    test('should parse plain text', () {
      final node = MarkdownParser.parseLine('This is plain text');
      expect(node, isA<MarkdownTextNode>());
      expect((node as MarkdownTextNode).text, equals('This is plain text'));
    });

    test('should parse header 1', () {
      final node = MarkdownParser.parseLine('# Header 1');
      expect(node, isA<HeaderNode>());
      final headerNode = node as HeaderNode;
      expect(headerNode.level, equals(1));
      expect(headerNode.content, isA<MarkdownTextNode>());
      expect((headerNode.content as MarkdownTextNode).text, equals('Header 1'));
    });

    test('should parse header 2', () {
      final node = MarkdownParser.parseLine('## Header 2');
      expect(node, isA<HeaderNode>());
      final headerNode = node as HeaderNode;
      expect(headerNode.level, equals(2));
      expect(headerNode.content, isA<MarkdownTextNode>());
      expect((headerNode.content as MarkdownTextNode).text, equals('Header 2'));
    });

    test('should parse header 3', () {
      final node = MarkdownParser.parseLine('### Header 3');
      expect(node, isA<HeaderNode>());
      final headerNode = node as HeaderNode;
      expect(headerNode.level, equals(3));
      expect(headerNode.content, isA<MarkdownTextNode>());
      expect((headerNode.content as MarkdownTextNode).text, equals('Header 3'));
    });

    test('should parse bold text', () {
      final node = MarkdownParser.parseLine('This is **bold** text');
      expect(node, isA<ContainerNode>());
      final containerNode = node as ContainerNode;
      expect(containerNode.children.length, equals(3));
      
      // First text node
      expect(containerNode.children[0], isA<MarkdownTextNode>());
      expect((containerNode.children[0] as MarkdownTextNode).text, equals('This is '));
      
      // Bold node
      expect(containerNode.children[1], isA<BoldNode>());
      final boldNode = containerNode.children[1] as BoldNode;
      expect(boldNode.content, isA<MarkdownTextNode>());
      expect((boldNode.content as MarkdownTextNode).text, equals('bold'));
      
      // Last text node
      expect(containerNode.children[2], isA<MarkdownTextNode>());
      expect((containerNode.children[2] as MarkdownTextNode).text, equals(' text'));
    });

    test('should parse italic text', () {
      final node = MarkdownParser.parseLine('This is *italic* text');
      expect(node, isA<ContainerNode>());
      final containerNode = node as ContainerNode;
      expect(containerNode.children.length, equals(3));
      
      // First text node
      expect(containerNode.children[0], isA<MarkdownTextNode>());
      expect((containerNode.children[0] as MarkdownTextNode).text, equals('This is '));
      
      // Italic node
      expect(containerNode.children[1], isA<ItalicNode>());
      final italicNode = containerNode.children[1] as ItalicNode;
      expect(italicNode.content, isA<MarkdownTextNode>());
      expect((italicNode.content as MarkdownTextNode).text, equals('italic'));
      
      // Last text node
      expect(containerNode.children[2], isA<MarkdownTextNode>());
      expect((containerNode.children[2] as MarkdownTextNode).text, equals(' text'));
    });

    test('should parse inline code', () {
      final node = MarkdownParser.parseLine('This is `code` text');
      expect(node, isA<ContainerNode>());
      final containerNode = node as ContainerNode;
      expect(containerNode.children.length, equals(3));
      
      // First text node
      expect(containerNode.children[0], isA<MarkdownTextNode>());
      expect((containerNode.children[0] as MarkdownTextNode).text, equals('This is '));
      
      // Code node
      expect(containerNode.children[1], isA<CodeNode>());
      final codeNode = containerNode.children[1] as CodeNode;
      expect(codeNode.content, isA<MarkdownTextNode>());
      expect((codeNode.content as MarkdownTextNode).text, equals('code'));
      
      // Last text node
      expect(containerNode.children[2], isA<MarkdownTextNode>());
      expect((containerNode.children[2] as MarkdownTextNode).text, equals(' text'));
    });

    test('should parse multiple inline elements', () {
      final node = MarkdownParser.parseLine('This is **bold** and *italic* and `code`');
      expect(node, isA<ContainerNode>());
      final containerNode = node as ContainerNode;
      expect(containerNode.children.length, equals(7)); // 4 text nodes + 3 formatting nodes
      
      // Check that we have the expected node types
      final nodeTypes = containerNode.children.map((child) => child.runtimeType).toList();
      expect(nodeTypes, containsAll([
        MarkdownTextNode,
        BoldNode,
        MarkdownTextNode,
        ItalicNode,
        MarkdownTextNode,
        CodeNode,
        MarkdownTextNode,
      ]));
    });

    test('should parse inline elements in headers', () {
      final node = MarkdownParser.parseLine('# Header with **bold** text');
      expect(node, isA<HeaderNode>());
      final headerNode = node as HeaderNode;
      expect(headerNode.level, equals(1));
      expect(headerNode.content, isA<ContainerNode>());
      
      final contentContainer = headerNode.content as ContainerNode;
      expect(contentContainer.children.length, equals(3));
      
      // Check that the bold node is present
      expect(contentContainer.children[1], isA<BoldNode>());
      final boldNode = contentContainer.children[1] as BoldNode;
      expect((boldNode.content as MarkdownTextNode).text, equals('bold'));
    });

    test('should handle nested inline elements', () {
      final node = MarkdownParser.parseLine('**Bold with *italic* and `code`**');
      expect(node, isA<BoldNode>());
      final boldNode = node as BoldNode;
      expect(boldNode.content, isA<ContainerNode>());
      
      final contentContainer = boldNode.content as ContainerNode;
      expect(contentContainer.children.length, equals(5)); // text + italic + text + code + text
      
      // Check that we have italic and code nodes within the bold
      final nodeTypes = contentContainer.children.map((child) => child.runtimeType).toList();
      expect(nodeTypes, containsAll([ItalicNode, CodeNode]));
    });

    test('should handle unclosed formatting as plain text', () {
      final node = MarkdownParser.parseLine('This is **unclosed bold');
      expect(node, isA<ContainerNode>());
      final containerNode = node as ContainerNode;
      expect(containerNode.children.length, equals(2));
      
      // First text node
      expect(containerNode.children[0], isA<MarkdownTextNode>());
      expect((containerNode.children[0] as MarkdownTextNode).text, equals('This is '));
      
      // The unclosed ** should be treated as plain text
      expect(containerNode.children[1], isA<MarkdownTextNode>());
      expect((containerNode.children[1] as MarkdownTextNode).text, equals('**'));
    });
  });
} 