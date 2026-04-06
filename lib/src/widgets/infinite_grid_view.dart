import 'package:flutter/material.dart';

import '../pagination_controller.dart';
import '../pagination_status.dart';
import 'error_indicator.dart';
import 'loading_indicator.dart';

class InfiniteGridView<T> extends StatefulWidget {
  final PaginationController<T> controller;
  final Widget Function(BuildContext context, T item, int index)
  itemBuilder;
  final SliverGridDelegate gridDelegate;
  final EdgeInsetsGeometry? padding;
  final ScrollPhysics? physics;

  const InfiniteGridView({
    super.key,
    required this.controller,
    required this.itemBuilder,
    required this.gridDelegate,
    this.padding,
    this.physics,
  });

  @override
  State<InfiniteGridView<T>> createState() => _InfiniteGridViewState<T>();
}

class _InfiniteGridViewState<T> extends State<InfiniteGridView<T>> {
  late ScrollController _scrollController;


  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);

    widget.controller.loadInitial();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      widget.controller.loadMore();
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.controller,
      builder: (context, child) {
        final state = widget.controller.state;

        if (state.status == PaginationStatus.loading &&
            state.items.isEmpty) {
          return const LoadingIndicator();
        }

        if (state.status == PaginationStatus.failure &&
            state.items.isEmpty) {
          return ErrorIndicator(
            message: state.errorMessage ?? 'Something went wrong',
            onRetry: () {
              widget.controller.loadInitial();
            },
          );
        }

        return RefreshIndicator(
          onRefresh: widget.controller.refresh,
          child: GridView.builder(
            controller: _scrollController,
            padding: widget.padding,
            physics: widget.physics ?? const AlwaysScrollableScrollPhysics(),
            gridDelegate: widget.gridDelegate,
            itemCount: state.items.length + 1,
            itemBuilder: (context, index) {
              if (index < state.items.length) {
                return widget.itemBuilder(
                  context,
                  state.items[index],
                  index,
                );
              }

              if (state.status == PaginationStatus.loadingMore) {
                return const Padding(
                  padding: EdgeInsets.all(16),
                  child: LoadingIndicator(),
                );
              }

              if (state.status == PaginationStatus.failure) {
                return ErrorIndicator(
                  message: state.errorMessage ?? 'Failed to load more',
                  onRetry: () {
                    widget.controller.loadMore();
                  },
                );
              }

              return const SizedBox.shrink();
            },
          ),
        );
      },
    );
  }
}
