class Pagination {

  Pagination({
    this.total = 0,
    this.skip = 0,
    this.limit = 0,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      total: json['total'] as int? ?? 0,
      skip: json['skip'] as int? ?? 0,
      limit: json['limit'] as int? ?? 0,
    );
  }
  final int total;
  final int skip;
  final int limit;

  Map<String, dynamic> toJson() {
    return {
      'total': total,
      'skip': skip,
      'limit': limit,
    };
  }

  int get currentPage => (skip / limit).floor() + 1;
  int get lastPage => (total / limit).ceil();
  bool get canLoadMore => currentPage < lastPage;
}
