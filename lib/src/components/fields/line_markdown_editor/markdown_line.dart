import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_meragi_design/flutter_meragi_design.dart';

/// Individual line component that switches between edit and preview modes
class MarkdownLine extends StatefulWidget {
  final String initialText;
  final bool isFocused;
  final Function(String) onTextChanged;
  final Function(int)? onCursorPositionChanged;
  final Function(int)? onGetCursorPosition;
  final VoidCallback onTap;
  final VoidCallback onTapOutside;
  final VoidCallback? onEnterPressed;
  final bool shouldRequestFocus;
  final VoidCallback? onFocused;
  final VoidCallback? onNewLineReady;

  const MarkdownLine({
    super.key,
    required this.initialText,
    required this.isFocused,
    required this.onTextChanged,
    this.onCursorPositionChanged,
    this.onGetCursorPosition,
    required this.onTap,
    required this.onTapOutside,
    this.onEnterPressed,
    this.shouldRequestFocus = false,
    this.onFocused,
    this.onNewLineReady,
  });

  @override
  State<MarkdownLine> createState() => _MarkdownLineState();
}

class _MarkdownLineState extends State<MarkdownLine> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialText);
    _focusNode = FocusNode();
    
    // Set up focus listener
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        widget.onTapOutside();
      } else {
        widget.onFocused?.call();
      }
    });
    
    // Add listener to track cursor position changes
    _controller.addListener(() {
      final position = _controller.selection.baseOffset;
      widget.onCursorPositionChanged?.call(position);
    });
    
    // If this line should be focused, schedule the focus request
    if (widget.isFocused) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (widget.onNewLineReady != null) {
          widget.onNewLineReady?.call();
        }
      });
    }
  }

  @override
  void didUpdateWidget(MarkdownLine oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    // Update controller if initialText changed
    if (oldWidget.initialText != widget.initialText) {
      _controller.text = widget.initialText;
    }
    
    // Handle focus changes - more direct approach
    if (widget.isFocused && !oldWidget.isFocused) {
      // Request focus immediately and also after the frame
      if (!_focusNode.hasFocus) {
        _focusNode.requestFocus();
      }
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && widget.isFocused && !_focusNode.hasFocus) {
          _focusNode.requestFocus();
        }
      });
    } else if (!widget.isFocused && oldWidget.isFocused) {
      _focusNode.unfocus();
    }
    
    // Handle shouldRequestFocus flag
    if (widget.shouldRequestFocus && !oldWidget.shouldRequestFocus) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && widget.shouldRequestFocus) {
          widget.onNewLineReady?.call();
        }
      });
    }
    
    // Report current cursor position when requested
    if (widget.onGetCursorPosition != null) {
      widget.onGetCursorPosition!(_controller.selection.baseOffset);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).markdownEditorTheme;
    final hoverColor = theme.hoverBackgroundColor ?? const Color(0xFFF3E8FF);
    final bgColor = _isHovered ? hoverColor : theme.backgroundColor;
    
    Widget child;
    if (widget.isFocused) {
      child = TextField(
        controller: _controller,
        focusNode: _focusNode,
        onChanged: widget.onTextChanged,
        onSubmitted: (_) => widget.onEnterPressed?.call(),
        onTap: () {
          // Report cursor position when text field is tapped
          final position = _controller.selection.baseOffset;
          widget.onCursorPositionChanged?.call(position);
        },
        enableInteractiveSelection: false,
        style: theme.textStyle ?? const TextStyle(fontSize: 14),
        cursorColor: theme.cursorColor,
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: theme.padding ?? const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        ),
      );
    } else {
      final parsedNode = MarkdownParser.parseLine(widget.initialText);
      final previewWidget = MarkdownRenderer.renderNode(
        parsedNode,
        baseStyle: theme.textStyle,
      );
      
      child = previewWidget;
    }
    
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          color: bgColor,
          padding: theme.padding ?? const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: child,
        ),
      ),
    );
  }
} 