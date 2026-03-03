// ============================================================
// FILE: lib/shared/models/pagination_meta.dart
// PURPOSE: Pagination metadata returned by list endpoints.
//          { "page": 1, "limit": 20, "total": 100, "pages": 5 }
// ============================================================

class PaginationMeta {
  final int page;
  final int limit;
  final int total;
  final int pages;

  const PaginationMeta({
    required this.page,
    required this.limit,
    required this.total,
    required this.pages,
  });

  factory PaginationMeta.fromJson(Map<String, dynamic> json) => PaginationMeta(
        page: json['page'] as int? ?? 1,
        limit: json['limit'] as int? ?? 20,
        total: json['total'] as int? ?? 0,
        pages: json['pages'] as int? ?? 1,
      );

  bool get hasNextPage => page < pages;
}
