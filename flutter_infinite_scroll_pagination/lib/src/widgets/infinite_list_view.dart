import 'package:flutter/material.dart';

import '../pagination_controller.dart';
import '../pagination_status.dart';
import 'error_indicator.dart';
import 'loading_indicator.dart';

class InfiniteListView<T> extends StatefulWidget {
  final PaginationController<T> controller;
  final Widget Function(BuildContext context, T item, int index)
  itemBuilder;
  final EdgeInsetsGeometry? padding;
  final ScrollPhysics? physics;

  const InfiniteListView({
    super.key,
    required this.controller,
    required this.itemBuilder,
    this.padding,
    this.physics,
  });


  @override
  State<InfiniteListView<T>> createState() => _InfiniteListViewState<T>();
}

class _InfiniteListViewState<T> extends State<InfiniteListView<T>> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.controller.loadInitial();
    });
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;

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

        if (state.items.isEmpty &&
            state.status == PaginationStatus.completed) {
          return RefreshIndicator(
            onRefresh: widget.controller.refresh,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: const [
                SizedBox(height: 120),
                Center(
                  child: Padding(
                    padding: EdgeInsets.all(24),
                    child: Column(
                      children: [
                        Icon(
                          Icons.inbox_outlined,
                          size: 72,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'No items found',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'There is nothing to display right now.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: widget.controller.refresh,
          child: ListView.builder(
            controller: _scrollController,
            padding: widget.padding,
            physics: widget.physics ?? const AlwaysScrollableScrollPhysics(),
            itemCount: state.items.length +
                ((state.status == PaginationStatus.loadingMore ||
                    (state.status == PaginationStatus.failure &&
                        state.items.isNotEmpty))
                    ? 1
                    : 0),
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
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: LoadingIndicator(),
                );
              }

              if (state.status == PaginationStatus.failure &&
                  state.items.isNotEmpty) {
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