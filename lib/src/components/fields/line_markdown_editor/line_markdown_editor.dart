import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_meragi_design/flutter_meragi_design.dart';
import 'markdown_line.dart';

/// Main widget that manages the overall editor state and contains a list of line widgets
class LineMarkdownEditor extends StatefulWidget {
  final String? initialText;
  final Function(String)? onChanged;
  final double? width;
  final double? height;

  const LineMarkdownEditor({
    super.key,
    this.initialText,
    this.onChanged,
    this.width,
    this.height,
  });

  @override
  State<LineMarkdownEditor> createState() => _LineMarkdownEditorState();
}

class _LineMarkdownEditorState extends State<LineMarkdownEditor> {
  List<String> _lines = [];
  int _focusedLineIndex = -1;
  final Map<int, String> _lineTexts = {};
  final Map<int, int> _cursorPositions = {}; // Track cursor position for each line
  final ScrollController _scrollController = ScrollController();
  int? _pendingFocusIndex;
  int? _newLineReadyIndex;

  @override
  void initState() {
    super.initState();
    _initializeLines();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _initializeLines() {
    if (widget.initialText != null && widget.initialText!.isNotEmpty) {
      _lines = widget.initialText!.split('\n');
    } else {
      _lines = ['']; // Start with one empty line
    }
    for (int i = 0; i < _lines.length; i++) {
      _lineTexts[i] = _lines[i];
    }
  }

  void _onLineTap(int index) {
    setState(() {
      _focusedLineIndex = index;
    });
  }

  void _onTapOutside() {
    setState(() {
      _focusedLineIndex = -1;
    });
  }

  void _onLineTextChanged(int index, String newText) {
    _lineTexts[index] = newText;
    _notifyChange();
  }

  void _onCursorPositionChanged(int index, int position) {
    _cursorPositions[index] = position;
  }

  void _onGetCursorPosition(int index, int position) {
    _cursorPositions[index] = position;
  }

  void _onLineFocused(int index) {
    setState(() {
      _focusedLineIndex = index;
    });
  }

  void _onNewLineReady(int index) {
    setState(() {
      _focusedLineIndex = index;
      _newLineReadyIndex = index;
    });
    
    // Clear the ready flag after a short delay
    Future.delayed(const Duration(milliseconds: 50), () {
      if (mounted) {
        setState(() {
          _newLineReadyIndex = null;
        });
      }
    });
  }

  void _onEnterPressed(int currentLineIndex) {
    final currentText = _lineTexts[currentLineIndex] ?? '';
    final cursorPosition = _getCursorPosition(currentLineIndex);
    
    // Split the current line at cursor position
    final beforeCursor = currentText.substring(0, cursorPosition);
    final afterCursor = currentText.substring(cursorPosition);
    
    // Update current line with text before cursor
    _lineTexts[currentLineIndex] = beforeCursor;
    
    // Insert new line with text after cursor
    final newLineIndex = currentLineIndex + 1;
    _lines.insert(newLineIndex, '');
    
    // Shift all _lineTexts after the new line down by one
    // We need to shift from the end backwards to avoid overwriting data
    for (int i = _lines.length - 1; i > newLineIndex; i--) {
      _lineTexts[i] = _lineTexts[i - 1] ?? '';
    }
    // Set the new line's text
    _lineTexts[newLineIndex] = afterCursor;
    
    // Set pending focus index
    _pendingFocusIndex = newLineIndex;
    
    // Force a rebuild
    setState(() {});
    
    // Clear the pending focus index after a short delay
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) {
        setState(() {
          _pendingFocusIndex = null;
        });
      }
    });
    
    _notifyChange();
  }

  void _onBackspacePressed(int currentLineIndex) {
    final currentText = _lineTexts[currentLineIndex] ?? '';
    final cursorPosition = _getCursorPosition(currentLineIndex);
    
    // If we're on the first line and it's empty, don't do anything
    if (currentLineIndex == 0 && currentText.isEmpty) {
      return;
    }
    
    // If cursor is at the beginning of the line and not the first line
    if (cursorPosition == 0 && currentLineIndex > 0) {
      final previousLineText = _lineTexts[currentLineIndex - 1] ?? '';
      
      // Merge current line with previous line
      _lineTexts[currentLineIndex - 1] = previousLineText + currentText;
      
      // Remove the current line from _lines list
      _lines.removeAt(currentLineIndex);
      
      // Shift all _lineTexts after the removed line up by one
      for (int i = currentLineIndex; i < _lines.length; i++) {
        _lineTexts[i] = _lineTexts[i + 1] ?? '';
      }
      // Remove the last entry that's no longer needed
      _lineTexts.remove(_lines.length);
      
      // Update cursor position for the previous line to be at the end of the merged text
      _cursorPositions[currentLineIndex - 1] = previousLineText.length;
      
      // Set pending focus index to previous line
      _pendingFocusIndex = currentLineIndex - 1;
      
      // Force a rebuild
      setState(() {});
      
      // Clear the pending focus index after a short delay
      Future.delayed(const Duration(milliseconds: 100), () {
        if (mounted) {
          setState(() {
            _pendingFocusIndex = null;
          });
        }
      });
      
      _notifyChange();
    }
    // If the line is empty and not the first line, remove it
    else if (currentText.isEmpty && currentLineIndex > 0) {
      // Remove the current line from _lines list
      _lines.removeAt(currentLineIndex);
      
      // Shift all _lineTexts after the removed line up by one
      for (int i = currentLineIndex; i < _lines.length; i++) {
        _lineTexts[i] = _lineTexts[i + 1] ?? '';
      }
      // Remove the last entry that's no longer needed
      _lineTexts.remove(_lines.length);
      
      // Set pending focus index to previous line
      _pendingFocusIndex = currentLineIndex - 1;
      
      // Force a rebuild
      setState(() {});
      
      // Clear the pending focus index after a short delay
      Future.delayed(const Duration(milliseconds: 100), () {
        if (mounted) {
          setState(() {
            _pendingFocusIndex = null;
          });
        }
      });
      
      _notifyChange();
    }
    // Otherwise, let the TextField handle the backspace normally
  }

  int _getCursorPosition(int lineIndex) {
    // Return tracked cursor position or end of line as fallback
    return _cursorPositions[lineIndex] ?? _lineTexts[lineIndex]?.length ?? 0;
  }

  void _notifyChange() {
    final fullText = _lineTexts.values.join('\n');
    widget.onChanged?.call(fullText);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).markdownEditorTheme;
    
    return Focus(
      autofocus: true,
      onKeyEvent: (node, event) {
        if (event is KeyDownEvent) {
          if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
            _moveFocusUp();
            return KeyEventResult.handled;
          } else if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
            _moveFocusDown();
            return KeyEventResult.handled;
          } else if (event.logicalKey == LogicalKeyboardKey.backspace) {
            if (_focusedLineIndex >= 0) {
              final currentText = _lineTexts[_focusedLineIndex] ?? '';
              
              // Request current cursor position from the focused line
              final cursorPosition = _getCursorPosition(_focusedLineIndex);
              
              // Check if line is empty or cursor is at beginning
              bool shouldHandleBackspace = false;
              if (currentText.isEmpty && _focusedLineIndex > 0) {
                shouldHandleBackspace = true;
              } else if (cursorPosition == 0 && _focusedLineIndex > 0) {
                shouldHandleBackspace = true;
              }
              
              if (shouldHandleBackspace) {
                _onBackspacePressed(_focusedLineIndex);
                return KeyEventResult.handled;
              }
              // Otherwise, let the TextField handle it normally
            }
          }
        }
        return KeyEventResult.ignored;
      },
      child: GestureDetector(
        onTap: _onTapOutside,
        child: Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            color: theme.backgroundColor,
            border: Border.all(
              color: theme.borderColor ?? Colors.grey.shade300,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(theme.borderRadius ?? 4),
          ),
          child: ListView.builder(
            controller: _scrollController,
            padding: theme.padding ?? const EdgeInsets.all(8),
            itemCount: _lines.length,
            itemBuilder: (context, index) {
              final isFocused = index == _focusedLineIndex;
              final shouldRequestFocus = index == _pendingFocusIndex;
              
              return MarkdownLine(
                key: ValueKey('line_$index'),
                initialText: _lineTexts[index] ?? '',
                isFocused: isFocused,
                shouldRequestFocus: shouldRequestFocus,
                onTextChanged: (text) => _onLineTextChanged(index, text),
                onCursorPositionChanged: (position) => _onCursorPositionChanged(index, position),
                onGetCursorPosition: (position) => _onGetCursorPosition(index, position),
                onTap: () => _onLineTap(index),
                onTapOutside: _onTapOutside,
                onEnterPressed: () => _onEnterPressed(index),
                onFocused: () => _onLineFocused(index),
                onNewLineReady: () => _onNewLineReady(index),
              );
            },
          ),
        ),
      ),
    );
  }

  void _moveFocusUp() {
    if (_focusedLineIndex > 0) {
      setState(() {
        _focusedLineIndex = _focusedLineIndex - 1;
      });
    }
  }

  void _moveFocusDown() {
    if (_focusedLineIndex < _lines.length - 1) {
      setState(() {
        _focusedLineIndex = _focusedLineIndex + 1;
      });
    }
  }
} 