import 'package:flutter/foundation.dart';

import 'pagination_state.dart';
import 'pagination_status.dart';

class PaginationController<T> extends ChangeNotifier {
  PaginationState<T> _state = const PaginationState();

  PaginationState<T> get state => _state;

  final Future<List<T>> Function(int page) onLoadPage;

  PaginationController({
    required this.onLoadPage,
  });

  Future<void> loadInitial() async {
    _state = _state.copyWith(
      status: PaginationStatus.loading,
      currentPage: 1,
      items: [],
      errorMessage: null,
      hasMore: true,
    );
    notifyListeners();

    try {
      List<T> result = await onLoadPage(1);

      if (result.isEmpty) {
        _state = _state.copyWith(
          items: [],
          currentPage: 1,
          hasMore: false,
          status: PaginationStatus.completed,
        );
      } else {
        _state = _state.copyWith(
          items: result,
          currentPage: 1,
          hasMore: true,
          status: PaginationStatus.success,
        );
      }
    } catch (e) {
      _state = _state.copyWith(
        status: PaginationStatus.failure,
        errorMessage: e.toString(),
      );
    }

    notifyListeners();
  }

  Future<void> loadMore() async {
    if (!_state.hasMore ||
        _state.status == PaginationStatus.loading ||
        _state.status == PaginationStatus.loadingMore) {
      return;
    }

    _state = _state.copyWith(
      status: PaginationStatus.loadingMore,
      errorMessage: null,
    );
    notifyListeners();

    try {
      int nextPage = _state.currentPage + 1;

      List<T> result = await onLoadPage(nextPage);

      if (result.isEmpty) {
        _state = _state.copyWith(
          hasMore: false,
          status: PaginationStatus.completed,
        );
      } else {
        _state = _state.copyWith(
          items: [..._state.items, ...result],
          currentPage: nextPage,
          hasMore: true,
          status: PaginationStatus.success,
        );
      }
    } catch (e) {
      _state = _state.copyWith(
        status: PaginationStatus.failure,
        errorMessage: e.toString(),
      );
    }

    notifyListeners();
  }

  Future<void> refresh() async {
    await loadInitial();
  }
}