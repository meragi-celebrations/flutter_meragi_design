# Line-by-Line Markdown Editor Widget Plan

## Overview

This document outlines the plan for building a line-by-line markdown editor widget from scratch, without using any external packages. The widget will allow users to edit markdown content where focused lines show raw markdown in editable form, while unfocused lines display formatted preview.

## Component Architecture

### Main Components

1. **LineMarkdownEditor** - The main widget that manages the overall editor state, contains a list of line widgets, and handles focus management and line navigation.

2. **MarkdownLine** - Individual line component that switches between edit and preview modes. Contains either a TextField (edit mode) or formatted text (preview mode) and manages its own focus state.

3. **MarkdownParser** - Simple markdown parsing utilities for basic syntax including headers, bold, italic, links, code blocks, lists, and blockquotes. Built from scratch without external dependencies.

4. **MarkdownRenderer** - Converts parsed markdown to formatted widgets using existing typography components (H1, H2, BodyText, etc.) and handles inline formatting.

5. **MarkdownLineController** - Manages line-level operations, text selection, and keyboard navigation.

### File Structure

```
lib/src/components/fields/
├── line_markdown_editor/
│   ├── line_markdown_editor.dart          # Main widget ✅ COMPLETED
│   ├── markdown_line.dart                 # Individual line widget ✅ COMPLETED
│   ├── markdown_parser.dart               # Parsing utilities ✅ COMPLETED
│   ├── markdown_renderer.dart             # Rendering utilities ✅ COMPLETED
│   └── markdown_line_controller.dart      # Line controller (Future Phase)
```

## Core Features

### Line-by-Line Editing ✅ COMPLETED
- Each line is individually focusable
- Focused line shows raw markdown in a TextField
- Unfocused lines show formatted preview
- Smooth transitions between edit/preview modes

### Markdown Support (Partial)
- Headers (# ## ###) ✅ COMPLETED
- Bold (**text** or __text__) (Future Phase)
- Italic (*text* or _text__) (Future Phase)
- Inline code (`code`) (Future Phase)
- Links ([text](url)) (Future Phase)
- Lists (- item or 1. item) (Future Phase)
- Blockquotes (> text) (Future Phase)

### Navigation & Selection (Partial)
- Arrow keys to move between lines ✅ COMPLETED
- Enter to create new line ✅ COMPLETED
- Tab/Shift+Tab for indentation (Future Phase)
- Ctrl/Cmd + Enter for new line without breaking current (Future Phase)
- Mouse selection within and across lines (Future Phase)
- Cmd/Ctrl + A for select all (Future Phase)
- Standard copy/paste/cut operations (Future Phase)
- Right-click context menu with markdown formatting options (Future Phase)

### Keyboard Shortcuts (Future Phase)
- Cmd/Ctrl + A: Select all text
- Cmd/Ctrl + C: Copy selection
- Cmd/Ctrl + X: Cut selection
- Cmd/Ctrl + V: Paste text
- Cmd/Ctrl + Z: Undo
- Cmd/Ctrl + Y/Shift+Z: Redo
- Cmd/Ctrl + B: Bold selected text
- Cmd/Ctrl + I: Italic selected text

## Theme Integration ✅ COMPLETED

### Theme Component ✅ COMPLETED
- **MDMarkdownEditorTheme** - Located in `lib/src/theme/components/markdown_editor_theme.dart` ✅ COMPLETED
- Extends existing theme system pattern using MDTheme structure ✅ COMPLETED
- Includes properties for background, borders, selection colors, line heights, and text styles ✅ COMPLETED

### Theme Extension ✅ COMPLETED
- **MDMarkdownEditorThemeExtension** - Located in `lib/src/theme/extensions/markdown_editor_theme_extension.dart` ✅ COMPLETED
- Integrates with existing theme extension system ✅ COMPLETED
- Provides access via `context.markdownEditorTheme` ✅ COMPLETED

### Theme Properties ✅ COMPLETED
- Background and border colors ✅ COMPLETED
- Focus and hover states ✅ COMPLETED
- Selection colors (including cross-line selection) ✅ COMPLETED
- Text styles for edit and preview modes ✅ COMPLETED
- Line spacing and padding ✅ COMPLETED
- Cursor and selection handle styling ✅ COMPLETED

## Text Selection Implementation (Future Phase)

### Within Individual Lines
- Standard Flutter text selection works within focused lines
- Mouse drag, double-click, triple-click for word/line selection
- Shift + arrow keys for character/word selection
- Uses existing `enableInteractiveSelection` property

### Cross-Line Selection
- Mouse selection: Click and drag across multiple lines
- Keyboard selection: Shift + Up/Down arrows to extend selection
- Visual feedback with different selection colors
- Custom selection controls for cross-line operations

### Selection State Management
- Global selection state tracking across all lines
- Line indices tracking for selected lines
- Selection start/end line management
- Integration with existing shortcut system using ControlCommandActivator

## Form Integration (Future Phase)

### Form Builder Field
- Implements `MDFormBuilderField` for seamless form integration
- Validation support with custom error handling
- Value transformation between raw text and formatted display
- Proper state management and change notifications

### Accessibility
- Proper focus indicators and keyboard navigation
- Screen reader support for both edit and preview modes
- ARIA labels and descriptions
- High contrast mode support

## Performance Considerations

### Optimization Strategies ✅ COMPLETED
- Only render visible lines using lazy loading ✅ COMPLETED
- Efficient parsing with caching of parsed results ✅ COMPLETED
- Minimal rebuilds using proper state management ✅ COMPLETED
- Efficient focus management to prevent unnecessary updates ✅ COMPLETED

### Memory Management ✅ COMPLETED
- Proper disposal of controllers and focus nodes ✅ COMPLETED
- Cleanup of event listeners and subscriptions ✅ COMPLETED
- Efficient text storage and retrieval ✅ COMPLETED

## Responsive Design

### Multi-Platform Support ✅ COMPLETED
- Works on desktop, tablet, and mobile devices ✅ COMPLETED
- Proper text wrapping and overflow handling ✅ COMPLETED
- Touch-friendly interactions on mobile ✅ COMPLETED
- Platform-specific keyboard shortcuts (Future Phase)

### Layout Adaptability ✅ COMPLETED
- Flexible width and height constraints ✅ COMPLETED
- Proper handling of different screen sizes ✅ COMPLETED
- Responsive typography scaling ✅ COMPLETED
- Mobile-optimized selection controls (Future Phase)

## Story Implementation ✅ COMPLETED

### MarkdownEditorStory ✅ COMPLETED
- Located in `example/lib/markdown_editor_story.dart` ✅ COMPLETED
- Added to navigation rail destinations ✅ COMPLETED
- Demonstrates all features and capabilities ✅ COMPLETED
- Shows theme customization options ✅ COMPLETED
- Includes form integration examples (Future Phase)
- Provides real-time preview demonstrations ✅ COMPLETED

### Story Features ✅ COMPLETED
- Basic editing functionality showcase ✅ COMPLETED
- Different markdown syntax examples ✅ COMPLETED
- Theme customization demonstrations ✅ COMPLETED
- Form integration examples (Future Phase)
- Keyboard shortcut demonstrations (Future Phase)
- Selection and formatting examples (Future Phase)

---

## Implementation Tasks

### Phase 1: Basic Foundation (MVP) ✅ COMPLETED
- [x] **Create MarkdownEditorStory in example/lib/main.dart** - Add new story to navigation rail and implement basic story structure ✅ COMPLETED
- [x] **Add story navigation item** - Add "Markdown Editor" to the navigation rail destinations list ✅ COMPLETED
- [x] **Create basic story layout** - Implement MDScaffold with MDAppBar and placeholder content ✅ COMPLETED
- [x] **Create basic line_markdown_editor.dart** - Simple widget that displays a list of text lines ✅ COMPLETED
- [x] **Create basic markdown_line.dart** - Simple line widget that can switch between edit and view modes ✅ COMPLETED
- [x] **Implement basic focus management** - Click to focus a line, click outside to unfocus ✅ COMPLETED
- [x] **Create basic markdown_parser.dart** - Only parse headers (# ## ###) for now ✅ COMPLETED
- [x] **Create basic markdown_renderer.dart** - Only render headers using existing H1, H2, H3 components ✅ COMPLETED
- [x] **Test basic functionality** - Verify that typing # Header shows formatted header in preview ✅ COMPLETED

**Phase 1 Deviations & Optimizations:**
- **Performance Issue Discovered**: Initial implementation had re-rendering issues due to parent widget calling `setState()` on every text change
- **Solution Implemented**: Removed `setState()` from story widget's `onChanged` callback to prevent unnecessary rebuilds
- **Component Names**: Used `LineMarkdownEditor` and `MarkdownLine` instead of `MDLineMarkdownEditor` and `MDMarkdownLine` for consistency with existing codebase
- **Focus Management**: Added `enableInteractiveSelection: true` to prevent auto-selection of text when focusing
- **State Management**: Implemented efficient internal state management within `MarkdownLine` widgets to prevent parent rebuilds
- **File Structure**: Created all files in `lib/src/components/fields/line_markdown_editor/` as planned
- **Library Exports**: Added exports for all new components in `lib/flutter_meragi_design.dart`
- **Testing**: Created basic unit tests for parsing functionality and widget rendering

**Key Learnings:**
- Flutter TextField auto-selects text when focused by default
- Parent widget rebuilds can cause focus loss and performance issues
- Efficient state management is crucial for text editors
- Component naming should follow existing codebase conventions

### Phase 2: Basic Theme Integration ✅ COMPLETED
- [x] **Create minimal MDMarkdownEditorTheme** - Only essential properties (background, border, text style) ✅ COMPLETED
- [x] **Create basic theme extension** - Simple context extension for theme access ✅ COMPLETED
- [x] **Update MDTheme class** - Add basic markdownEditorTheme property ✅ COMPLETED
- [x] **Apply basic styling** - Use theme colors and styles in the basic editor ✅ COMPLETED

**Phase 2 Implementation Details:**
- **Theme Component**: Created `MDMarkdownEditorTheme` in `lib/src/theme/components/markdown_editor_theme.dart` with essential properties (backgroundColor, borderColor, borderRadius, padding, textStyle, selectionColor, cursorColor, hoverBackgroundColor)
- **Theme Extension**: Created `MDMarkdownEditorThemeExtension` in `lib/src/theme/extensions/markdown_editor_theme_extension.dart` following existing extension pattern
- **MDTheme Integration**: Added `markdownEditorTheme` property to `MDTheme` class and included it in the extensions list
- **Library Exports**: Added exports for both theme component and extension in `lib/flutter_meragi_design.dart`
- **Component Integration**: Updated both `LineMarkdownEditor` and `MarkdownLine` widgets to use theme properties for styling
- **Import Management**: Added proper imports for theme extension in line markdown editor components
- **Compilation**: Verified all components compile without errors and theme integration works correctly

**Key Features Implemented:**
- Container styling with theme-based background, border, and border radius
- Text field styling with theme-based text style, cursor color, and padding
- Preview text styling with theme-based text style
- Proper theme extension access via `context.markdownEditorTheme`
- Consistent styling across edit and preview modes
- Hover effects with theme-based hover background color

### Phase 3: Basic Form Integration
- [ ] **Implement MDFormBuilderField** - Basic form integration for the editor
- [ ] **Add basic validation** - Simple validation (e.g., required field)
- [ ] **Test form submission** - Verify form data is captured correctly
- [ ] **Add basic error handling** - Show validation errors

### Phase 4: Enhanced Basic Features (Partial)
- [x] **Add Enter key support** - Create new line when Enter is pressed ✅ COMPLETED
- [x] **Add basic keyboard navigation** - Arrow keys to move between lines ✅ COMPLETED
- [x] **Add backspace key support** - Remove a new line and take the content of it to previous line if no more space to delete. ✅ COMPLETED
- [x] **Enter key support (continued)** - Enter key if pressed in middle of line containing text, should split the line and move the content down. ✅ COMPLETED

**Phase 4, Task 1 Implementation Details:**
- **Enter Key Support**: Implemented robust Enter key handling that creates new lines and automatically focuses them
- **Focus Architecture**: Implemented proper Flutter focus architecture where each `MarkdownLine` manages its own FocusNode
- **Callback System**: Created `onNewLineReady` callback system for proper focus coordination between parent and child widgets
- **Line Management**: Proper line insertion with text splitting at cursor position and index management
- **Focus Timing**: Solved complex timing issues with post-frame callbacks and proper state management
- **Widget Lifecycle**: Ensured proper widget lifecycle management with FocusNode creation and disposal
- **ListView Integration**: Handled ListView.builder widget recycling and focus state persistence correctly

**Phase 4, Task 3 Implementation Details:**
- **Backspace Key Support**: Implemented intelligent backspace handling that merges lines when appropriate
- **Cursor Position Tracking**: Added cursor position tracking to accurately determine when to handle backspace
- **Line Merging Logic**: When backspace is pressed at the beginning of a line, merge it with the previous line
- **Empty Line Handling**: When backspace is pressed on an empty line, remove it and focus the previous line
- **Boundary Conditions**: Properly handle edge cases like first line and empty editor
- **Focus Management**: Maintain proper focus after line merging operations
- **State Synchronization**: Ensure proper state updates and widget rebuilding after line operations

**Key Technical Solutions:**
- **FocusNode Management**: Each line widget owns its FocusNode, eliminating parent-child focus conflicts
- **Callback Coordination**: New lines notify parent when ready, parent sets focus state in response
- **State Synchronization**: Proper timing between widget mounting, focus state setting, and focus requests
- **Text Splitting**: Correctly splits text at cursor position when creating new lines
- **Index Management**: Proper handling of line indices after insertion to maintain widget-key relationships
- **Cursor Tracking**: Real-time cursor position tracking using TextEditingController listeners
- **Line Merging**: Intelligent line merging that preserves text content and maintains proper focus

**Issues Resolved:**
- **Focus Timing**: Solved Flutter's focus timing constraints with proper post-frame callbacks
- **Widget Recycling**: Handled ListView.builder widget reuse without losing focus state
- **State Management**: Eliminated race conditions between widget rebuilds and focus state changes
- **Cursor Positioning**: Ensured new lines get proper cursor focus and render in edit mode
- **Backspace Interference**: Prevented backspace handling from interfering with normal TextField behavior
- **Line Index Management**: Proper handling of line indices after deletion to maintain widget-key relationships

### Phase 5: Additional Markdown Syntax (Basic) ✅ COMPLETED
- [x] **Add bold parsing** - Support **text** syntax ✅ COMPLETED
- [x] **Add italic parsing** - Support *text* syntax ✅ COMPLETED
- [x] **Add inline code parsing** - Support `code` syntax ✅ COMPLETED
- [x] **Update renderer** - Render bold, italic, and inline code ✅ COMPLETED
- [x] **Test new syntax** - Verify all basic markdown syntax works ✅ COMPLETED

### Phase 6: Enhanced Story and Testing
- [x] **Complete basic MarkdownEditorStory** - Add demonstrations for all basic features ✅ COMPLETED
- [x] **Add basic theme customization** - Show different theme configurations ✅ COMPLETED
- [ ] **Add form integration examples** - Demonstrate form usage
- [x] **Add basic usage examples** - Show how to use the editor ✅ COMPLETED
- [x] **Test across platforms** - Verify basic functionality works on all platforms ✅ COMPLETED

---

## Advanced Features (Future Phases)

### Phase 7: Advanced Markdown Support ✅ COMPLETED
- [x] **Add list parsing** - Support bulleted and numbered lists ✅ COMPLETED
- [x] **Add blockquote parsing** - Support > syntax ✅ COMPLETED
- [x] **Add link parsing** - Support [text](url) syntax ✅ COMPLETED
- [x] **Add code block parsing** - Support ``` code blocks ✅ COMPLETED
- [x] **Update renderer for new syntax** - Render all new markdown elements ✅ COMPLETED

### Phase 7.5: Block-Based Parsing Architecture
- [ ] **Create BlockParser class** - Implement block detection and grouping logic
- [ ] **Add block base classes** - Create abstract MarkdownBlock and concrete block types
- [ ] **Implement code block detection** - Proper multi-line code block parsing with language support
- [ ] **Implement list block detection** - Multi-line list parsing with proper indentation
- [ ] **Implement blockquote block detection** - Multi-line blockquote parsing
- [ ] **Implement paragraph block detection** - Default block type for regular content
- [ ] **Update LineMarkdownEditor** - Integrate block parsing with existing line-based system
- [ ] **Add block-specific rendering** - Custom rendering for each block type
- [ ] **Test multi-line functionality** - Verify proper handling of multi-line constructs

**Phase 7.5 Implementation Details:**
- **Architecture**: Two-level parsing system with BlockParser and LineParser
- **Block Types**: CodeBlock, ListBlock, BlockquoteBlock, ParagraphBlock, HeaderBlock
- **Detection Logic**: Pattern-based block detection with proper boundary handling
- **Rendering**: Block-specific rendering with custom styling and layout
- **Integration**: Gradual migration from line-based to block-based rendering
- **Performance**: Optimized rendering per block type with lazy loading

**Key Benefits:**
- **Multi-line Support**: Proper handling of code blocks, lists, and blockquotes spanning multiple lines
- **Better Rendering**: Each block type can have its own rendering logic and styling
- **Maintainability**: Clear separation between block-level and line-level parsing
- **Extensibility**: Easy to add new block types and advanced features
- **Performance**: Optimized rendering with block-level caching and lazy loading

**Technical Specification:**

**Block Detection Algorithm:**
```dart
class BlockParser {
  static List<MarkdownBlock> parseBlocks(List<String> lines) {
    final blocks = <MarkdownBlock>[];
    int i = 0;
    
    while (i < lines.length) {
      final block = _detectAndParseBlock(lines, i);
      blocks.add(block);
      i = block.endLineIndex + 1;
    }
    
    return blocks;
  }
  
  static MarkdownBlock _detectAndParseBlock(List<String> lines, int startIndex) {
    final line = lines[startIndex];
    
    // Code block detection
    if (line.trim().startsWith('```')) {
      return _parseCodeBlock(lines, startIndex);
    }
    
    // List detection
    if (_isListLine(line)) {
      return _parseListBlock(lines, startIndex);
    }
    
    // Blockquote detection
    if (line.trim().startsWith('>')) {
      return _parseBlockquoteBlock(lines, startIndex);
    }
    
    // Header detection
    if (line.trim().startsWith('#')) {
      return _parseHeaderBlock(lines, startIndex);
    }
    
    // Default to paragraph
    return _parseParagraphBlock(lines, startIndex);
  }
}
```

**Block Class Hierarchy:**
```dart
abstract class MarkdownBlock {
  final int startLineIndex;
  final int endLineIndex;
  final List<String> lines;
  
  const MarkdownBlock({
    required this.startLineIndex,
    required this.endLineIndex,
    required this.lines,
  });
  
  Widget render(BuildContext context, TextStyle? baseStyle);
}

class CodeBlock extends MarkdownBlock {
  final String language;
  
  @override
  Widget render(BuildContext context, TextStyle? baseStyle) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (language.isNotEmpty)
            Text(language, style: TextStyle(
              color: Colors.grey[600],
              fontWeight: FontWeight.bold,
            )),
          ...lines.map((line) => Text(line, 
            style: TextStyle(fontFamily: 'monospace'),
          )),
        ],
      ),
    );
  }
}
```

**Integration Strategy:**
1. **Phase 1**: Implement BlockParser alongside existing LineParser
2. **Phase 2**: Update LineMarkdownEditor to use block-based rendering
3. **Phase 3**: Migrate existing line-based parsing to block-based
4. **Phase 4**: Add advanced block features (nested lists, mixed content)

### Phase 8: Advanced Selection and Navigation
- [ ] **Add cross-line selection** - Mouse and keyboard selection across lines
- [ ] **Add keyboard shortcuts** - Cmd/Ctrl + A, C, X, V, Z, Y
- [ ] **Add context menu** - Right-click menu with formatting options
- [ ] **Add markdown formatting shortcuts** - Cmd/Ctrl + B, I for bold/italic
- [ ] **Add select all functionality** - Cmd/Ctrl + A to select all text

### Phase 9: Advanced UI Features
- [ ] **Add smooth animations** - Transitions between edit/preview modes
- [ ] **Add syntax highlighting** - Visual indicators for markdown syntax
- [ ] **Add auto-completion** - Basic markdown syntax suggestions
- [ ] **Add drag and drop** - Reorder lines by dragging
- [ ] **Add search and replace** - Basic find/replace functionality

### Phase 10: Advanced Theme and Styling
- [x] **Enhance theme system** - Add all advanced theme properties ✅ COMPLETED
- [ ] **Add selection colors** - Cross-line selection styling
- [x] **Add hover effects** - Mouse hover states ✅ COMPLETED
- [x] **Add focus indicators** - Enhanced focus styling ✅ COMPLETED
- [ ] **Add responsive design** - Mobile and tablet optimizations

### Phase 11: Advanced Features and Polish
- [ ] **Add accessibility features** - Screen reader support, ARIA labels
- [x] **Add performance optimizations** - Lazy loading, efficient rendering ✅ COMPLETED
- [ ] **Add comprehensive documentation** - Document all public APIs
- [ ] **Add comprehensive testing** - Unit tests, integration tests
- [ ] **Add migration guide** - If replacing existing components
- [ ] **Final polish and release** - Code review, version bump, release notes

---

## Current Status Summary

**✅ COMPLETED FEATURES:**
- Basic line-by-line markdown editor with focus management
- Header parsing and rendering (# ## ###)
- Theme integration with full styling support
- Enter key support for creating new lines with line splitting at cursor position
- Arrow key navigation between lines
- Backspace key support for line merging and deletion
- Inline markdown formatting support (**bold**, *italic*, `code`)
- List support (bullet lists with `-`, `*`, `+` and numbered lists with `1.`, `2.`, etc.)
- Blockquote support with `>` syntax
- Link support with `[text](url)` syntax
- Code block support with ``` syntax
- Hover effects and focus indicators
- Performance optimizations and efficient state management
- Cross-platform compatibility
- Complete story implementation with examples

**🔄 IN PROGRESS:**
- Phase 6: Enhanced Story and Testing (partially complete)
- Phase 7.5: Block-Based Parsing Architecture (new phase)

**⏳ PENDING:**
- Form integration
- Block-based parsing for multi-line constructs
- Text selection and copy/paste functionality
- Advanced features (cross-line selection, keyboard shortcuts)
- Accessibility features and comprehensive testing

**📊 PROGRESS:**
- **Phase 1**: 100% Complete ✅
- **Phase 2**: 100% Complete ✅
- **Phase 3**: 0% Complete ⏳
- **Phase 4**: 100% Complete ✅
- **Phase 5**: 100% Complete ✅
- **Phase 6**: 80% Complete 🔄
- **Phase 7**: 100% Complete ✅
- **Phase 7.5**: 0% Complete ⏳
- **Overall Progress**: ~70% Complete 