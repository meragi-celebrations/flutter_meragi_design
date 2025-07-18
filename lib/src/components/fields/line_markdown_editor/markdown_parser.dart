import 'package:flutter/material.dart';

/// Node-based markdown parsing system
class MarkdownParser {
  /// Parse a single line of markdown text into a tree of nodes
  static MarkdownNode parseLine(String text) {
    final tokens = _tokenize(text);
    final result = _parseTokens(tokens);
    return result;
  }

  /// Tokenize the input text into markdown tokens
  static List<MarkdownToken> _tokenize(String text) {
    final tokens = <MarkdownToken>[];
    int i = 0;
    
    while (i < text.length) {
      // Check for headers
      if (i == 0 || text[i - 1] == ' ') {
        if (text.startsWith('### ', i)) {
          tokens.add(MarkdownToken(type: TokenType.header3, value: '###', startIndex: i));
          i += 3;
          continue;
        } else if (text.startsWith('## ', i)) {
          tokens.add(MarkdownToken(type: TokenType.header2, value: '##', startIndex: i));
          i += 2;
          continue;
        } else if (text.startsWith('# ', i)) {
          tokens.add(MarkdownToken(type: TokenType.header1, value: '#', startIndex: i));
          i += 1;
          continue;
        }
      }
      
      // Check for lists and blockquotes at the beginning of the line
      if (i == 0) {
        // Check for blockquotes: >
        if (text.startsWith('> ', i)) {
          tokens.add(MarkdownToken(type: TokenType.blockquote, value: '>', startIndex: i));
          i += 1;
          continue;
        }
        
        // Check for bulleted lists: -, *, +
        if (text.startsWith('- ', i)) {
          tokens.add(MarkdownToken(type: TokenType.bulletList, value: '-', startIndex: i));
          i += 1;
          continue;
        } else if (text.startsWith('* ', i)) {
          tokens.add(MarkdownToken(type: TokenType.bulletList, value: '*', startIndex: i));
          i += 1;
          continue;
        } else if (text.startsWith('+ ', i)) {
          tokens.add(MarkdownToken(type: TokenType.bulletList, value: '+', startIndex: i));
          i += 1;
          continue;
        }
        
        // Check for numbered lists: 1., 2., etc.
        final numberedListMatch = RegExp(r'^(\d+)\. ').firstMatch(text.substring(i));
        if (numberedListMatch != null) {
          final number = numberedListMatch.group(1)!;
          tokens.add(MarkdownToken(
            type: TokenType.numberedList, 
            value: number, 
            startIndex: i
          ));
          i += number.length + 1; // +1 for the dot
          continue;
        }
      }
      
      // Check for link brackets
      if (text[i] == '[') {
        tokens.add(MarkdownToken(type: TokenType.linkOpen, value: '[', startIndex: i));
        i++;
        continue;
      }
      
      if (text[i] == ']') {
        tokens.add(MarkdownToken(type: TokenType.linkClose, value: ']', startIndex: i));
        i++;
        continue;
      }
      
      if (text[i] == '(') {
        tokens.add(MarkdownToken(type: TokenType.urlOpen, value: '(', startIndex: i));
        i++;
        continue;
      }
      
      if (text[i] == ')') {
        tokens.add(MarkdownToken(type: TokenType.urlClose, value: ')', startIndex: i));
        i++;
        continue;
      }
      
      // Check for code blocks (triple backticks)
      if (i < text.length - 2 && text[i] == '`' && text[i + 1] == '`' && text[i + 2] == '`') {
        tokens.add(MarkdownToken(type: TokenType.codeBlock, value: '```', startIndex: i));
        i += 3;
        continue;
      }
      
      // Check for inline code
      if (text[i] == '`') {
        tokens.add(MarkdownToken(type: TokenType.backtick, value: '`', startIndex: i));
        i++;
        continue;
      }
      
      // Check for bold markers
      if (i < text.length - 1 && text[i] == '*' && text[i + 1] == '*') {
        tokens.add(MarkdownToken(type: TokenType.boldMarker, value: '**', startIndex: i));
        i += 2;
        continue;
      }
      
      // Check for italic markers
      if (text[i] == '*') {
        tokens.add(MarkdownToken(type: TokenType.italicMarker, value: '*', startIndex: i));
        i++;
        continue;
      }
      
      // Regular text character
      final textStart = i;
      while (i < text.length && 
             text[i] != '`' && 
             text[i] != '*') {
        i++;
      }
      
      if (i > textStart) {
        tokens.add(MarkdownToken(
          type: TokenType.text,
          value: text.substring(textStart, i),
          startIndex: textStart,
        ));
      }
    }
    
    return tokens;
  }

  /// Parse tokens into a tree of markdown nodes
  static MarkdownNode _parseTokens(List<MarkdownToken> tokens) {
    if (tokens.isEmpty) {
      return MarkdownTextNode(text: '');
    }
    
    // Check for headers first
    if (tokens.isNotEmpty && tokens.first.type == TokenType.header1) {
      return _parseHeader(tokens, 1);
    } else if (tokens.isNotEmpty && tokens.first.type == TokenType.header2) {
      return _parseHeader(tokens, 2);
    } else if (tokens.isNotEmpty && tokens.first.type == TokenType.header3) {
      return _parseHeader(tokens, 3);
    }
    
    // Check for code blocks
    if (tokens.isNotEmpty && tokens.first.type == TokenType.codeBlock) {
      return _parseCodeBlock(tokens);
    }
    
    // Check for blockquotes
    if (tokens.isNotEmpty && tokens.first.type == TokenType.blockquote) {
      return _parseBlockquote(tokens);
    }
    
    // Check for lists
    if (tokens.isNotEmpty && tokens.first.type == TokenType.bulletList) {
      return _parseBulletList(tokens);
    } else if (tokens.isNotEmpty && tokens.first.type == TokenType.numberedList) {
      return _parseNumberedList(tokens);
    }
    
    // Parse body text with inline formatting
    return _parseBodyText(tokens);
  }

  /// Parse header tokens
  static MarkdownNode _parseHeader(List<MarkdownToken> tokens, int level) {
    // Skip the header marker token
    final contentTokens = tokens.sublist(1);
    
    // If there are no content tokens, return empty text
    if (contentTokens.isEmpty) {
      return HeaderNode(level: level, content: MarkdownTextNode(text: ''));
    }
    
    // Parse the content tokens
    final contentNode = _parseInlineElements(contentTokens);
    
    // If the content is a single text node, trim leading spaces
    if (contentNode is MarkdownTextNode) {
      final trimmedText = contentNode.text.trimLeft();
      return HeaderNode(level: level, content: MarkdownTextNode(text: trimmedText));
    }
    
    return HeaderNode(level: level, content: contentNode);
  }

  /// Parse bullet list tokens
  static MarkdownNode _parseBulletList(List<MarkdownToken> tokens) {
    // Skip the bullet marker token
    final contentTokens = tokens.sublist(1);
    
    // If there are no content tokens, return empty text
    if (contentTokens.isEmpty) {
      return BulletListNode(content: MarkdownTextNode(text: ''));
    }
    
    // Parse the content tokens
    final contentNode = _parseInlineElements(contentTokens);
    
    // If the content is a single text node, trim leading spaces
    if (contentNode is MarkdownTextNode) {
      final trimmedText = contentNode.text.trimLeft();
      return BulletListNode(content: MarkdownTextNode(text: trimmedText));
    }
    
    return BulletListNode(content: contentNode);
  }

  /// Parse numbered list tokens
  static MarkdownNode _parseNumberedList(List<MarkdownToken> tokens) {
    // Skip the numbered list marker token
    final contentTokens = tokens.sublist(1);
    
    // If there are no content tokens, return empty text
    if (contentTokens.isEmpty) {
      return NumberedListNode(number: 1, content: MarkdownTextNode(text: ''));
    }
    
    // Parse the content tokens
    final contentNode = _parseInlineElements(contentTokens);
    
    // If the content is a single text node, trim leading spaces
    if (contentNode is MarkdownTextNode) {
      final trimmedText = contentNode.text.trimLeft();
      return NumberedListNode(
        number: int.tryParse(tokens.first.value) ?? 1,
        content: MarkdownTextNode(text: trimmedText)
      );
    }
    
    return NumberedListNode(
      number: int.tryParse(tokens.first.value) ?? 1,
      content: contentNode
    );
  }

  /// Parse blockquote tokens
  static MarkdownNode _parseBlockquote(List<MarkdownToken> tokens) {
    // Skip the blockquote marker token
    final contentTokens = tokens.sublist(1);
    
    // If there are no content tokens, return empty text
    if (contentTokens.isEmpty) {
      return BlockquoteNode(content: MarkdownTextNode(text: ''));
    }
    
    // Parse the content tokens
    final contentNode = _parseInlineElements(contentTokens);
    
    // If the content is a single text node, trim leading spaces
    if (contentNode is MarkdownTextNode) {
      final trimmedText = contentNode.text.trimLeft();
      return BlockquoteNode(content: MarkdownTextNode(text: trimmedText));
    }
    
    return BlockquoteNode(content: contentNode);
  }

  /// Parse code block tokens
  static MarkdownNode _parseCodeBlock(List<MarkdownToken> tokens) {
    // Skip the code block marker token
    final contentTokens = tokens.sublist(1);
    
    // If there are no content tokens, return empty text
    if (contentTokens.isEmpty) {
      return CodeBlockNode(content: MarkdownTextNode(text: ''));
    }
    
    // Parse the content tokens
    final contentNode = _parseInlineElements(contentTokens);
    
    // If the content is a single text node, trim leading spaces
    if (contentNode is MarkdownTextNode) {
      final trimmedText = contentNode.text.trimLeft();
      return CodeBlockNode(content: MarkdownTextNode(text: trimmedText));
    }
    
    return CodeBlockNode(content: contentNode);
  }

  /// Parse link tokens
  static _ParseResult _parseLink(List<MarkdownToken> tokens, int startIndex) {
    final textNodes = <MarkdownNode>[];
    String? url;
    int i = startIndex + 1; // Skip opening [
    
    // Parse link text
    while (i < tokens.length) {
      final token = tokens[i];
      
      if (token.type == TokenType.linkClose) {
        // Found closing ], now look for URL
        i++;
        if (i < tokens.length && tokens[i].type == TokenType.urlOpen) {
          i++; // Skip opening (
          final urlTokens = <MarkdownToken>[];
          while (i < tokens.length) {
            if (tokens[i].type == TokenType.urlClose) {
              // Found closing )
              url = urlTokens.map((t) => t.value).join('');
              return _ParseResult(
                node: LinkNode(
                  text: ContainerNode(children: textNodes),
                  url: url,
                ),
                nextIndex: i + 1,
              );
            } else {
              urlTokens.add(tokens[i]);
              i++;
            }
          }
        }
        // No URL found, treat as regular text
        return _ParseResult(
          node: MarkdownTextNode(text: '['),
          nextIndex: startIndex + 1,
        );
      } else if (token.type == TokenType.text) {
        textNodes.add(MarkdownTextNode(text: token.value));
        i++;
      } else if (token.type == TokenType.boldMarker) {
        final boldNode = _parseBold(tokens, i);
        textNodes.add(boldNode.node);
        i = boldNode.nextIndex;
      } else if (token.type == TokenType.italicMarker) {
        final italicNode = _parseItalic(tokens, i);
        textNodes.add(italicNode.node);
        i = italicNode.nextIndex;
      } else if (token.type == TokenType.backtick) {
        final codeNode = _parseInlineCode(tokens, i);
        textNodes.add(codeNode.node);
        i = codeNode.nextIndex;
      } else {
        // Skip other tokens
        i++;
      }
    }
    
    // No closing ] found, treat as regular text
    return _ParseResult(
      node: MarkdownTextNode(text: '['),
      nextIndex: startIndex + 1,
    );
  }

  /// Parse body text with inline formatting
  static MarkdownNode _parseBodyText(List<MarkdownToken> tokens) {
    final nodes = <MarkdownNode>[];
    int i = 0;
    
    while (i < tokens.length) {
      final token = tokens[i];
      
      if (token.type == TokenType.text) {
        nodes.add(MarkdownTextNode(text: token.value));
        i++;
      } else if (token.type == TokenType.boldMarker) {
        final boldNode = _parseBold(tokens, i);
        nodes.add(boldNode.node);
        i = boldNode.nextIndex;
      } else if (token.type == TokenType.italicMarker) {
        final italicNode = _parseItalic(tokens, i);
        nodes.add(italicNode.node);
        i = italicNode.nextIndex;
      } else if (token.type == TokenType.backtick) {
        final codeNode = _parseInlineCode(tokens, i);
        nodes.add(codeNode.node);
        i = codeNode.nextIndex;
      } else if (token.type == TokenType.linkOpen) {
        final linkNode = _parseLink(tokens, i);
        nodes.add(linkNode.node);
        i = linkNode.nextIndex;
      } else {
        // Skip unknown tokens
        i++;
      }
    }
    
    if (nodes.length == 1) {
      return nodes.first;
    } else {
      return ContainerNode(children: nodes);
    }
  }

  /// Parse bold formatting
  static _ParseResult _parseBold(List<MarkdownToken> tokens, int startIndex) {
    final nodes = <MarkdownNode>[];
    int i = startIndex + 1; // Skip opening **
    
    while (i < tokens.length) {
      final token = tokens[i];
      
      if (token.type == TokenType.boldMarker) {
        // Found closing **
        return _ParseResult(
          node: BoldNode(content: ContainerNode(children: nodes)),
          nextIndex: i + 1,
        );
      } else if (token.type == TokenType.text) {
        nodes.add(MarkdownTextNode(text: token.value));
        i++;
      } else if (token.type == TokenType.italicMarker) {
        final italicNode = _parseItalic(tokens, i);
        nodes.add(italicNode.node);
        i = italicNode.nextIndex;
      } else if (token.type == TokenType.backtick) {
        final codeNode = _parseInlineCode(tokens, i);
        nodes.add(codeNode.node);
        i = codeNode.nextIndex;
      } else {
        // Skip other tokens
        i++;
      }
    }
    
    // No closing ** found, treat as regular text
    return _ParseResult(
      node: MarkdownTextNode(text: '**'),
      nextIndex: startIndex + 1,
    );
  }

  /// Parse italic formatting
  static _ParseResult _parseItalic(List<MarkdownToken> tokens, int startIndex) {
    final nodes = <MarkdownNode>[];
    int i = startIndex + 1; // Skip opening *
    
    while (i < tokens.length) {
      final token = tokens[i];
      
      if (token.type == TokenType.italicMarker) {
        // Found closing *
        return _ParseResult(
          node: ItalicNode(content: ContainerNode(children: nodes)),
          nextIndex: i + 1,
        );
      } else if (token.type == TokenType.text) {
        nodes.add(MarkdownTextNode(text: token.value));
        i++;
      } else if (token.type == TokenType.boldMarker) {
        final boldNode = _parseBold(tokens, i);
        nodes.add(boldNode.node);
        i = boldNode.nextIndex;
      } else if (token.type == TokenType.backtick) {
        final codeNode = _parseInlineCode(tokens, i);
        nodes.add(codeNode.node);
        i = codeNode.nextIndex;
      } else {
        // Skip other tokens
        i++;
      }
    }
    
    // No closing * found, treat as regular text
    return _ParseResult(
      node: MarkdownTextNode(text: '*'),
      nextIndex: startIndex + 1,
    );
  }

  /// Parse inline code
  static _ParseResult _parseInlineCode(List<MarkdownToken> tokens, int startIndex) {
    final nodes = <MarkdownNode>[];
    int i = startIndex + 1; // Skip opening `
    
    while (i < tokens.length) {
      final token = tokens[i];
      
      if (token.type == TokenType.backtick) {
        // Found closing `
        return _ParseResult(
          node: CodeNode(content: ContainerNode(children: nodes)),
          nextIndex: i + 1,
        );
      } else if (token.type == TokenType.text) {
        nodes.add(MarkdownTextNode(text: token.value));
        i++;
      } else {
        // Skip other tokens
        i++;
      }
    }
    
    // No closing ` found, treat as regular text
    return _ParseResult(
      node: MarkdownTextNode(text: '`'),
      nextIndex: startIndex + 1,
    );
  }

  /// Parse inline elements within text
  static MarkdownNode _parseInlineElements(List<MarkdownToken> tokens) {
    return _parseBodyText(tokens);
  }
}

/// Token types for markdown parsing
enum TokenType {
  text,
  header1,
  header2,
  header3,
  boldMarker,
  italicMarker,
  backtick,
  bulletList, // Added for bullet lists
  numberedList, // Added for numbered lists
  blockquote, // Added for blockquotes
  linkOpen, // Added for link parsing
  linkClose, // Added for link parsing
  urlOpen, // Added for link parsing
  urlClose, // Added for link parsing
  codeBlock, // Added for code blocks
}

/// Represents a token in the markdown text
class MarkdownToken {
  final TokenType type;
  final String value;
  final int startIndex;

  const MarkdownToken({
    required this.type,
    required this.value,
    required this.startIndex,
  });
}

/// Base class for all markdown nodes
abstract class MarkdownNode {
  const MarkdownNode();
}

/// Represents plain text
class MarkdownTextNode extends MarkdownNode {
  final String text;
  
  const MarkdownTextNode({required this.text});
}

/// Represents a container that holds multiple nodes
class ContainerNode extends MarkdownNode {
  final List<MarkdownNode> children;
  
  const ContainerNode({required this.children});
}

/// Represents a header (h1, h2, h3)
class HeaderNode extends MarkdownNode {
  final int level;
  final MarkdownNode content;
  
  const HeaderNode({required this.level, required this.content});
}

/// Represents bold text
class BoldNode extends MarkdownNode {
  final MarkdownNode content;
  
  const BoldNode({required this.content});
}

/// Represents italic text
class ItalicNode extends MarkdownNode {
  final MarkdownNode content;
  
  const ItalicNode({required this.content});
}

/// Represents inline code
class CodeNode extends MarkdownNode {
  final MarkdownNode content;
  
  const CodeNode({required this.content});
}

/// Represents a bullet list
class BulletListNode extends MarkdownNode {
  final MarkdownNode content;
  
  const BulletListNode({required this.content});
}

/// Represents a numbered list
class NumberedListNode extends MarkdownNode {
  final int number;
  final MarkdownNode content;
  
  const NumberedListNode({required this.number, required this.content});
}

/// Represents a blockquote
class BlockquoteNode extends MarkdownNode {
  final MarkdownNode content;
  
  const BlockquoteNode({required this.content});
}

/// Represents a link
class LinkNode extends MarkdownNode {
  final MarkdownNode text;
  final String? url;
  
  const LinkNode({required this.text, this.url});
}

/// Represents a code block
class CodeBlockNode extends MarkdownNode {
  final MarkdownNode content;
  
  const CodeBlockNode({required this.content});
}

/// Helper class for parsing results
class _ParseResult {
  final MarkdownNode node;
  final int nextIndex;
  
  const _ParseResult({required this.node, required this.nextIndex});
}

// Legacy classes for backward compatibility
/// Types of markdown elements (legacy)
enum MarkdownElementType {
  h1,
  h2,
  h3,
  body,
}

/// Types of inline elements (legacy)
enum InlineElementType {
  bold,
  italic,
  code,
}

/// Represents a parsed markdown element (legacy)
class MarkdownElement {
  final MarkdownElementType type;
  final String text;
  final String rawText;
  final List<InlineElement> inlineElements;

  const MarkdownElement({
    required this.type,
    required this.text,
    required this.rawText,
    this.inlineElements = const [],
  });
}

/// Represents an inline markdown element (legacy)
class InlineElement {
  final InlineElementType type;
  final String text;
  final int startIndex;
  final int endIndex;

  const InlineElement({
    required this.type,
    required this.text,
    required this.startIndex,
    required this.endIndex,
  });
} 