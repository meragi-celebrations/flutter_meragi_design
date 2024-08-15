import 'package:flutter/material.dart';
import 'package:flutter_meragi_design/flutter_meragi_design.dart';

class ListScrollHandler {
  final ScrollController _scrollController = ScrollController();
  final GetListBloc _bloc;

  ListScrollHandler(this._bloc);

  // Getter for the ScrollController (to be used in your widget)
  ScrollController get scrollController => _scrollController;

  // Attach the listener and handle scroll events
  void attachListener() {
    _scrollController.addListener(_handleScroll);
  }

  // Detach the listener when it's no longer needed
  void detachListener() {
    _scrollController.removeListener(_handleScroll);
  }

  void _handleScroll() {
    if (_scrollController.position.extentAfter < 500) {
      if (_bloc.requestState.value == RequestState.done) {
        if (_bloc.currentPage.value < _bloc.totalPages.value) {
          _bloc.nextPage();
        }
      }
    }
  }
}
