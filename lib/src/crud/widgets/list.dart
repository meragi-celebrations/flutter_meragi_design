import 'package:flutter/material.dart';
import 'package:flutter_meragi_design/flutter_meragi_design.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class MDList<T> extends StatelessWidget {
  final GetListBloc<T> listBloc;
  final Widget Function(BuildContext context, int index) itemBuilder;
  final Widget Function(BuildContext context, int index)? separatorBuilder;

  const MDList({
    super.key,
    required this.listBloc,
    required this.itemBuilder,
    this.separatorBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return MDMultiListenableBuilder(
        listenables: [listBloc.list, listBloc.requestState],
        builder: (context, _) {
          RequestState state = listBloc.requestState.value;

          if (state == RequestState.loading) {
            return const Center(
              child: MDLoadingIndicator(
                color: Colors.deepPurple,
              ),
            );
          }

          if (listBloc.list.value.isEmpty) {
            return Center(
              child: Icon(
                PhosphorIconsBold.empty,
                size: 300,
                color: Colors.deepPurple.shade100.withOpacity(.2),
              ),
            );
          }

          return ListView.separated(
            itemCount: listBloc.list.value.length,
            itemBuilder: itemBuilder,
            separatorBuilder: separatorBuilder ?? (_, __) => const SizedBox(),
          );
        });
  }
}
