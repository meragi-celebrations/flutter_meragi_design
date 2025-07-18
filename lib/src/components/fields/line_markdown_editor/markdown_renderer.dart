import 'package:flutter/material.dart';
import 'package:flutter_meragi_design/flutter_meragi_design.dart';
import 'markdown_parser.dart';

/// Converts parsed markdown nodes to formatted widgets
class MarkdownRenderer {
  /// Render a markdown node to a widget
  static Widget renderNode(MarkdownNode node, {TextStyle? baseStyle}) {
    final widget = _renderNodeRecursive(node, baseStyle: baseStyle);
    return widget;
  }

  /// Recursively render a markdown node
  static Widget _renderNodeRecursive(MarkdownNode node, {TextStyle? baseStyle}) {
    if (node is MarkdownTextNode) {
      return Text(node.text, style: baseStyle);
    } else if (node is ContainerNode) {
      if (node.children.isEmpty) {
        return const SizedBox.shrink();
      } else if (node.children.length == 1) {
        return _renderNodeRecursive(node.children.first, baseStyle: baseStyle);
      } else {
        // Multiple children - create RichText with multiple spans
        return _createRichTextFromNodes(node.children, baseStyle: baseStyle);
      }
    } else if (node is HeaderNode) {
      return _renderHeader(node, baseStyle: baseStyle);
    } else if (node is BoldNode) {
      return _renderBold(node, baseStyle: baseStyle);
    } else if (node is ItalicNode) {
      return _renderItalic(node, baseStyle: baseStyle);
    } else if (node is CodeNode) {
      return _renderCode(node, baseStyle: baseStyle);
    } else if (node is BulletListNode) {
      return _renderBulletList(node, baseStyle: baseStyle);
    } else if (node is NumberedListNode) {
      return _renderNumberedList(node, baseStyle: baseStyle);
    } else if (node is BlockquoteNode) {
      return _renderBlockquote(node, baseStyle: baseStyle);
    } else if (node is LinkNode) {
      return _renderLink(node, baseStyle: baseStyle);
    } else if (node is CodeBlockNode) {
      return _renderCodeBlock(node, baseStyle: baseStyle);
    } else {
      return const SizedBox.shrink();
    }
  }

  /// Render a header node
  static Widget _renderHeader(HeaderNode node, {TextStyle? baseStyle}) {
    final contentWidget = _renderNodeRecursive(node.content, baseStyle: baseStyle);
    
    // For headings, we want to preserve the theme font sizes but use the baseStyle color
    final headingStyle = baseStyle != null 
        ? TextStyle(color: baseStyle.color) 
        : null;
    
    switch (node.level) {
      case 1:
        return H1(text: _extractTextFromNode(node.content), style: headingStyle);
      case 2:
        return H2(text: _extractTextFromNode(node.content), style: headingStyle);
      case 3:
        return H3(text: _extractTextFromNode(node.content), style: headingStyle);
      default:
        return contentWidget;
    }
  }

  /// Render a bold node
  static Widget _renderBold(BoldNode node, {TextStyle? baseStyle}) {
    final contentWidget = _renderNodeRecursive(node.content, baseStyle: baseStyle);
    
    if (contentWidget is Text) {
      return Text(
        contentWidget.data!,
        style: (contentWidget.style ?? baseStyle ?? const TextStyle()).copyWith(
          fontWeight: FontWeight.bold,
        ),
      );
    } else {
      // For complex content, use RichText
      return _createRichTextFromNodes([node.content], 
        baseStyle: (baseStyle ?? const TextStyle()).copyWith(fontWeight: FontWeight.bold));
    }
  }

  /// Render an italic node
  static Widget _renderItalic(ItalicNode node, {TextStyle? baseStyle}) {
    final contentWidget = _renderNodeRecursive(node.content, baseStyle: baseStyle);
    
    if (contentWidget is Text) {
      return Text(
        contentWidget.data!,
        style: (contentWidget.style ?? baseStyle ?? const TextStyle()).copyWith(
          fontStyle: FontStyle.italic,
        ),
      );
    } else {
      // For complex content, use RichText
      return _createRichTextFromNodes([node.content], 
        baseStyle: (baseStyle ?? const TextStyle()).copyWith(fontStyle: FontStyle.italic));
    }
  }

  /// Render a code node
  static Widget _renderCode(CodeNode node, {TextStyle? baseStyle}) {
    final contentWidget = _renderNodeRecursive(node.content, baseStyle: baseStyle);
    
    if (contentWidget is Text) {
      return Text(
        contentWidget.data!,
        style: (contentWidget.style ?? baseStyle ?? const TextStyle()).copyWith(
          fontFamily: 'monospace',
          backgroundColor: const Color(0xFFF0F0F0),
          color: const Color(0xFFE83E8C),
        ),
      );
    } else {
      // For complex content, use RichText
      return _createRichTextFromNodes([node.content], 
        baseStyle: (baseStyle ?? const TextStyle()).copyWith(
          fontFamily: 'monospace',
          backgroundColor: const Color(0xFFF0F0F0),
          color: const Color(0xFFE83E8C),
        ));
    }
  }

  /// Render a bullet list node
  static Widget _renderBulletList(BulletListNode node, {TextStyle? baseStyle}) {
    final contentWidget = _renderNodeRecursive(node.content, baseStyle: baseStyle);
    
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('• ', style: baseStyle?.copyWith(fontWeight: FontWeight.bold)),
        Expanded(child: contentWidget),
      ],
    );
  }

  /// Render a numbered list node
  static Widget _renderNumberedList(NumberedListNode node, {TextStyle? baseStyle}) {
    final contentWidget = _renderNodeRecursive(node.content, baseStyle: baseStyle);
    
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('${node.number}. ', style: baseStyle?.copyWith(fontWeight: FontWeight.bold)),
        Expanded(child: contentWidget),
      ],
    );
  }

  /// Render a blockquote node
  static Widget _renderBlockquote(BlockquoteNode node, {TextStyle? baseStyle}) {
    final contentWidget = _renderNodeRecursive(node.content, baseStyle: baseStyle);
    
    return Container(
      padding: const EdgeInsets.only(left: 16.0),
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(
            color: baseStyle?.color ?? Colors.grey,
            width: 4.0,
          ),
        ),
      ),
      child: contentWidget,
    );
  }

  /// Render a link node
  static Widget _renderLink(LinkNode node, {TextStyle? baseStyle}) {
    final textWidget = _renderNodeRecursive(node.text, baseStyle: baseStyle);
    
    if (node.url != null && node.url!.isNotEmpty) {
      return GestureDetector(
        onTap: () {
          // TODO: Implement link opening functionality
        },
        child: Text(
          _extractTextFromNode(node.text),
          style: (baseStyle ?? const TextStyle()).copyWith(
            color: Colors.blue,
            decoration: TextDecoration.underline,
          ),
        ),
      );
    } else {
      return textWidget;
    }
  }

  /// Render a code block node
  static Widget _renderCodeBlock(CodeBlockNode node, {TextStyle? baseStyle}) {
    final contentWidget = _renderNodeRecursive(node.content, baseStyle: baseStyle);
    
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(4.0),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: contentWidget,
    );
  }

  /// Create RichText widget from multiple nodes
  static Widget _createRichTextFromNodes(List<MarkdownNode> nodes, {TextStyle? baseStyle}) {
    final textSpans = <TextSpan>[];
    
    for (final node in nodes) {
      textSpans.addAll(_createTextSpansFromNode(node, baseStyle));
    }
    
    return RichText(
      text: TextSpan(
        style: baseStyle,
        children: textSpans,
      ),
    );
  }

  /// Create TextSpans from a node
  static List<TextSpan> _createTextSpansFromNode(MarkdownNode node, TextStyle? baseStyle) {
    if (node is MarkdownTextNode) {
      return [TextSpan(text: node.text, style: baseStyle)];
    } else if (node is ContainerNode) {
      final spans = <TextSpan>[];
      for (final child in node.children) {
        spans.addAll(_createTextSpansFromNode(child, baseStyle));
      }
      return spans;
    } else if (node is BoldNode) {
      final childSpans = _createTextSpansFromNode(node.content, baseStyle);
      return childSpans.map((span) => TextSpan(
        text: span.text,
        style: (span.style ?? baseStyle ?? const TextStyle()).copyWith(
          fontWeight: FontWeight.bold,
        ),
      )).toList();
    } else if (node is ItalicNode) {
      final childSpans = _createTextSpansFromNode(node.content, baseStyle);
      return childSpans.map((span) => TextSpan(
        text: span.text,
        style: (span.style ?? baseStyle ?? const TextStyle()).copyWith(
          fontStyle: FontStyle.italic,
        ),
      )).toList();
    } else if (node is CodeNode) {
      final childSpans = _createTextSpansFromNode(node.content, baseStyle);
      return childSpans.map((span) => TextSpan(
        text: span.text,
        style: (span.style ?? baseStyle ?? const TextStyle()).copyWith(
          fontFamily: 'monospace',
          backgroundColor: const Color(0xFFF0F0F0),
          color: const Color(0xFFE83E8C),
        ),
      )).toList();
    } else {
      return [];
    }
  }

  /// Extract plain text from a node (for simple widgets like headers)
  static String _extractTextFromNode(MarkdownNode node) {
    if (node is MarkdownTextNode) {
      return node.text;
    } else if (node is ContainerNode) {
      return node.children.map(_extractTextFromNode).join('');
    } else if (node is BoldNode) {
      return _extractTextFromNode(node.content);
    } else if (node is ItalicNode) {
      return _extractTextFromNode(node.content);
    } else if (node is CodeNode) {
      return _extractTextFromNode(node.content);
    } else if (node is BulletListNode) {
      return '• ${_extractTextFromNode(node.content)}';
    } else if (node is NumberedListNode) {
      return '${node.number}. ${_extractTextFromNode(node.content)}';
    } else if (node is BlockquoteNode) {
      return '> ${_extractTextFromNode(node.content)}';
    } else if (node is LinkNode) {
      return _extractTextFromNode(node.text);
    } else if (node is CodeBlockNode) {
      return _extractTextFromNode(node.content);
    } else {
      return '';
    }
  }

  // Legacy methods for backward compatibility
  /// Render a markdown element to a widget (legacy)
  static Widget renderElement(MarkdownElement element) {
    // Create the base text widget based on element type
    Widget baseWidget;
    switch (element.type) {
      case MarkdownElementType.h1:
        baseWidget = H1(text: element.text);
      case MarkdownElementType.h2:
        baseWidget = H2(text: element.text);
      case MarkdownElementType.h3:
        baseWidget = H3(text: element.text);
      case MarkdownElementType.body:
        baseWidget = BodyText(text: element.text);
    }
    
    // If there are inline elements, render with rich text
    if (element.inlineElements.isNotEmpty) {
      return _renderWithInlineElements(element);
    }
    
    return baseWidget;
  }
  
  /// Render text with inline formatting elements (legacy)
  static Widget _renderWithInlineElements(MarkdownElement element) {
    final textSpans = <TextSpan>[];
    int currentIndex = 0;
    
    // Sort inline elements by start index
    final sortedElements = List<InlineElement>.from(element.inlineElements)
      ..sort((a, b) => a.startIndex.compareTo(b.startIndex));
    
    for (final inlineElement in sortedElements) {
      // Add text before the inline element
      if (inlineElement.startIndex > currentIndex) {
        final beforeText = element.text.substring(currentIndex, inlineElement.startIndex);
        textSpans.add(TextSpan(text: beforeText));
      }
      
      // Add the inline element
      textSpans.add(_createTextSpanForInlineElement(inlineElement));
      
      currentIndex = inlineElement.endIndex;
    }
    
    // Add remaining text after the last inline element
    if (currentIndex < element.text.length) {
      final afterText = element.text.substring(currentIndex);
      textSpans.add(TextSpan(text: afterText));
    }
    
    // Create RichText widget with appropriate base style
    final baseStyle = _getBaseTextStyle(element.type);
    
    return RichText(
      text: TextSpan(
        style: baseStyle,
        children: textSpans,
      ),
    );
  }
  
  /// Create a TextSpan for an inline element (legacy)
  static TextSpan _createTextSpanForInlineElement(InlineElement element) {
    switch (element.type) {
      case InlineElementType.bold:
        return TextSpan(
          text: element.text,
          style: const TextStyle(fontWeight: FontWeight.bold),
        );
      case InlineElementType.italic:
        return TextSpan(
          text: element.text,
          style: const TextStyle(fontStyle: FontStyle.italic),
        );
      case InlineElementType.code:
        return TextSpan(
          text: element.text,
          style: const TextStyle(
            fontFamily: 'monospace',
            backgroundColor: Color(0xFFF0F0F0),
            color: Color(0xFFE83E8C),
          ),
        );
    }
  }
  
  /// Get the base text style for the element type (legacy)
  static TextStyle _getBaseTextStyle(MarkdownElementType type) {
    switch (type) {
      case MarkdownElementType.h1:
        return const TextStyle(fontSize: 32, fontWeight: FontWeight.w400);
      case MarkdownElementType.h2:
        return const TextStyle(fontSize: 24, fontWeight: FontWeight.w400);
      case MarkdownElementType.h3:
        return const TextStyle(fontSize: 18, fontWeight: FontWeight.w400);
      case MarkdownElementType.body:
        return const TextStyle(fontSize: 14);
    }
  }
} 