import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MDWidget extends StatefulWidget {
  const MDWidget({
    super.key,
    required this.builder,
    this.statesController,
    this.child,
    this.canRequestFocus = true,
    this.autofocus = false,
    this.onFocusChange,
    this.onTap,
    this.onEnter,
    this.onSecondaryTap,
    this.onDoubleTap,
    this.mouseCursor,
    this.focusNode,
  });

  final Widget Function(BuildContext context, Set<WidgetState> states, Widget? child) builder;
  final Widget? child;
  final WidgetStatesController? statesController;
  final bool canRequestFocus;
  final bool autofocus;
  final Function(bool)? onFocusChange;
  final WidgetStateProperty<MouseCursor>? mouseCursor;

  final Function()? onTap;
  final Function()? onEnter;
  final Function()? onSecondaryTap;
  final Function()? onDoubleTap;

  final FocusNode? focusNode;

  @override
  State<MDWidget> createState() => _MDWidgetState();
}

class _MDWidgetState extends State<MDWidget> {
  late WidgetStatesController statesController;

  @override
  void initState() {
    super.initState();
    statesController = widget.statesController ?? WidgetStatesController();

    // print("dhinka chika ${statesController}");

    statesController.addListener(() {
      // print("statesController ${statesController} ${statesController.value}");
    });
  }

  @override
  void dispose() {
    super.dispose();
    statesController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      autofocus: widget.autofocus,
      focusNode: widget.focusNode,
      onFocusChange: (value) {
        statesController.update(WidgetState.focused, value);
        widget.onFocusChange?.call(value);
      },
      onKeyEvent: (node, event) {
        if (event.logicalKey == LogicalKeyboardKey.enter) {
          if (widget.onEnter != null) {
            widget.onEnter!();
            return KeyEventResult.handled;
          }
          return KeyEventResult.ignored;
        }
        return KeyEventResult.ignored;
      },
      canRequestFocus: widget.canRequestFocus,
      child: ValueListenableBuilder(
        valueListenable: statesController,
        builder: (context, states, child) {
          return MouseRegion(
            cursor: widget.mouseCursor?.resolve(statesController.value) ?? MouseCursor.defer,
            onEnter: (event) {
              statesController.update(WidgetState.hovered, true);
              statesController.update(WidgetState.focused, true);
            },
            onExit: (event) {
              statesController.update(WidgetState.hovered, false);
              statesController.update(WidgetState.focused, false);
            },
            child: GestureDetector(
              onTap: () {
                widget.onTap?.call();
              },
              onSecondaryTap: () {
                widget.onSecondaryTap?.call();
              },
              onTapDown: (_) {
                statesController.update(WidgetState.pressed, true);
              },
              onTapUp: (_) {
                statesController.update(WidgetState.pressed, false);
              },
              onTapCancel: () {
                statesController.update(WidgetState.pressed, false);
              },
              onDoubleTap: widget.onDoubleTap,
              child: widget.builder(context, states, child),
            ),
          );
        },
        child: widget.child,
      ),
    );
  }
}
