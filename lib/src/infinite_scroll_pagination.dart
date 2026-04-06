import 'package:flutter/material.dart';

import 'pagination_controller.dart';

class InfiniteScrollPagination<T> extends StatefulWidget {
  final PaginationController<T> controller;
  final Widget Function(BuildContext context, List<T> items) builder;

  const InfiniteScrollPagination({
    super.key,
    required this.controller,
    required this.builder,
  });

  @override
  State<InfiniteScrollPagination<T>> createState() =>
      _InfiniteScrollPaginationState<T>();
}

class _InfiniteScrollPaginationState<T>
    extends State<InfiniteScrollPagination<T>> {
  @override
  void initState() {
    super.initState();
    widget.controller.loadInitial();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.controller,
      builder: (context, child) {
        return widget.builder(
          context,
          widget.controller.state.items,
        );
      },
    );
  }
}
