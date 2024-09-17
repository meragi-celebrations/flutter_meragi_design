import 'package:flutter/material.dart';
import 'package:flutter_meragi_design/flutter_meragi_design.dart';
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

  const MDList({
    super.key,
    this.listBloc,
    required this.itemBuilder,
    this.separatorBuilder,
    this.scrollController,
    this.requestState,
    this.list,
    this.listenables,
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
          return const Center(
            child: MDLoadingIndicator(
              color: Colors.deepPurple,
            ),
          );
        }

        if (list.isEmpty) {
          return Center(
            child: Icon(
              PhosphorIconsBold.empty,
              size: 300,
              color: Colors.deepPurple.shade100.withOpacity(.2),
            ),
          );
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

        return ListView.separated(
          itemCount: list.length,
          itemBuilder: itemBuilder!,
          separatorBuilder: separatorBuilder ?? (_, __) => const SizedBox(),
        );
      },
    );
  }
}
