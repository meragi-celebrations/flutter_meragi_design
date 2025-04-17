import 'package:flutter/material.dart';
import 'package:flutter_meragi_design/flutter_meragi_design.dart';
import 'package:flutter_meragi_design/src/extensions/box_decoration.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:timelines_plus/timelines_plus.dart';

class MDList<T> extends StatelessWidget {
  final GetListBloc<T>? listBloc;
  final Widget Function(BuildContext context, int index)? itemBuilder;
  final Widget Function(BuildContext context, int index)? separatorBuilder;
  final ScrollController? scrollController;
  final List<Listenable>? listenables;
  final RequestState? requestState;
  final List<T>? list;
  final bool isSliver;

  const MDList({
    super.key,
    this.listBloc,
    required this.itemBuilder,
    this.separatorBuilder,
    this.scrollController,
    this.requestState,
    this.list,
    this.listenables,
    this.isSliver = false,
  })  : assert(listBloc != null || (requestState != null && list != null && listenables != null)),
        tileBuilder = null,
        timelineTheme = null;

  final TimelineTileBuilder? tileBuilder;

  const MDList.timeline({
    super.key,
    this.listBloc,
    required this.tileBuilder,
    this.timelineTheme,
    this.scrollController,
    this.requestState,
    this.list,
    this.listenables,
  })  : assert(listBloc != null || (requestState != null && list != null && listenables != null)),
        itemBuilder = null,
        isSliver = false,
        separatorBuilder = null;

  bool get isTimeline => tileBuilder != null;

  final TimelineThemeData? timelineTheme;

  @override
  Widget build(BuildContext context) {
    return MDMultiListenableBuilder(
      listenables: listenables ?? [listBloc!.list, listBloc!.requestState],
      builder: (context, _) {
        final list = this.list ?? listBloc!.list.value;
        RequestState state = this.requestState ?? listBloc!.requestState.value;

        if (state == RequestState.loading) {
          Widget loadingIndicator = const Center(
            child: MDLoadingIndicator(),
          );
          if (isSliver) {
            return SliverFillRemaining(
              child: loadingIndicator,
            );
          } else {
            return loadingIndicator;
          }
        }

        if (list.isEmpty) {
          Widget emptyWidget = Center(
            child: Icon(
              PhosphorIconsBold.empty,
              size: 300,
              color: Colors.deepPurple.shade100.withOpacity(.2),
            ),
          );
          if (isSliver) {
            return SliverFillRemaining(
              child: emptyWidget,
            );
          } else {
            return emptyWidget;
          }
        }

        if (isTimeline) {
          double connectorSize = 35;
          double nodePosition = 0.2;
          return Timeline.tileBuilder(
            controller: scrollController,
            theme: timelineTheme ??
                TimelineThemeData(
                  nodePosition: nodePosition,
                  connectorTheme: ConnectorThemeData(
                    thickness: 2.0,
                    color: const Color(0xffd3d3d3),
                    space: connectorSize,
                  ),
                  indicatorTheme: const IndicatorThemeData(
                    size: 15.0,
                    position: 0,
                  ),
                ),
            builder: tileBuilder!,
          );
        }

        return isSliver
            ? SliverList.separated(
                itemCount: list.length,
                itemBuilder: itemBuilder!,
                separatorBuilder: separatorBuilder ?? (_, __) => const SizedBox())
            : ListView.separated(
                itemCount: list.length,
                itemBuilder: itemBuilder!,
                separatorBuilder: separatorBuilder ?? (_, __) => const SizedBox(),
              );
      },
    );
  }
}

class MDListTile extends StatefulWidget {
  const MDListTile({
    super.key,
    required this.child,
    this.focusNode,
    this.onFocusChange,
    this.onTap,
    this.onSecondaryTap,
    this.onDoubleTap,
    this.onEnter,
    this.decoration,
    this.statesController,
    this.isSelected = false,
  });

  final Widget child;
  final FocusNode? focusNode;
  final ValueChanged<bool>? onFocusChange;
  final VoidCallback? onTap;
  final VoidCallback? onSecondaryTap;
  final VoidCallback? onDoubleTap;
  final VoidCallback? onEnter;
  final WidgetStateProperty<BoxDecoration>? decoration;
  final WidgetStatesController? statesController;
  final bool isSelected;

  @override
  State<MDListTile> createState() => _MDListTileState();
}

class _MDListTileState extends State<MDListTile> {
  late WidgetStatesController _statesController;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _statesController = widget.statesController ?? WidgetStatesController();
    _focusNode = widget.focusNode ?? FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    const padding = EdgeInsets.all(12);
    final borderRadius = BorderRadius.circular(10);

    _statesController.update(WidgetState.selected, widget.isSelected);

    BoxDecoration baseDecoration = BoxDecoration(
      borderRadius: borderRadius,
      color: Colors.white,
      border: Border.all(color: Colors.white),
    );

    WidgetStateProperty<BoxDecoration> stateDecoration = widget.decoration ??
        MDWidgetStateResolver<BoxDecoration>({
          // WidgetState.hovered: BoxDecoration(
          //   color: Colors.deepPurple.shade100.withOpacity(.05),
          // ),
          WidgetState.focused: BoxDecoration(
              color: Colors.deepPurple.shade100.withOpacity(.05),
              border: Border.all(
                color: Colors.deepPurple.shade100,
              )),
          WidgetState.selected: BoxDecoration(
              color: Colors.deepPurple.shade100.withOpacity(.2),
              border: Border.all(
                color: Colors.deepPurple.shade100,
              )),
          "default": baseDecoration,
        }).resolveWith();

    return MDWidget(
      focusNode: _focusNode,
      onFocusChange: widget.onFocusChange,
      statesController: _statesController,
      onTap: () {
        _focusNode.requestFocus();
        widget.onTap?.call();
      },
      onSecondaryTap: widget.onSecondaryTap,
      onDoubleTap: () {
        _focusNode.requestFocus();
        widget.onDoubleTap?.call();
      },
      onEnter: widget.onEnter ?? widget.onTap,
      mouseCursor: MDWidgetStateResolver<MouseCursor>({
        WidgetState.hovered: (widget.onTap != null) ? SystemMouseCursors.click : SystemMouseCursors.basic,
        "default": SystemMouseCursors.basic
      }).resolveWith(),
      builder: (context, states, child) {
        return Container(
          padding: padding,
          decoration: baseDecoration.merge(stateDecoration.resolve(states)),
          child: AnimatedSize(
            duration: const Duration(milliseconds: 300),
            child: child,
          ),
        );
      },
      child: widget.child,
    );
  }
}
