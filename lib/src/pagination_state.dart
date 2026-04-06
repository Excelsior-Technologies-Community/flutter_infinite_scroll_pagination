import 'pagination_status.dart';

class PaginationState<T> {
  final List<T> items;
  final PaginationStatus status;
  final bool hasMore;
  final String? errorMessage;
  final int currentPage;

  const PaginationState({
    this.items = const [],
    this.status = PaginationStatus.initial,
    this.hasMore = true,
    this.errorMessage,
    this.currentPage = 1,
  });

  PaginationState<T> copyWith({
    List<T>? items,
    PaginationStatus? status,
    bool? hasMore,
    String? errorMessage,
    int? currentPage,
  }) {
    return PaginationState<T>(
      items: items ?? this.items,
      status: status ?? this.status,
      hasMore: hasMore ?? this.hasMore,
      errorMessage: errorMessage ?? this.errorMessage,
      currentPage: currentPage ?? this.currentPage,
    );
  }
}
