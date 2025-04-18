class PaginatedResponse<T> {
  final int currentPage;
  final List<T> data;
  final int lastPage;
  final String? nextPageUrl;
  final String? prevPageUrl;
  final String? firstPageUrl;
  final String? lastPageUrl;
  final int perPage;
  final int total;

  PaginatedResponse({
    required this.currentPage,
    required this.data,
    required this.lastPage,
    this.nextPageUrl,
    this.prevPageUrl,
    this.firstPageUrl,
    this.lastPageUrl,
    required this.perPage,
    required this.total,
  });

  factory PaginatedResponse.fromJson(
      Map<String, dynamic> json,
      T Function(Map<String, dynamic>) fromJsonT,
      ) {
    var dataList = <T>[];
    if (json['data'] != null) {
      dataList = List<Map<String, dynamic>>.from(json['data'])
          .map((item) => fromJsonT(item))
          .toList();
    }

    return PaginatedResponse<T>(
      currentPage: json['current_page'],
      data: dataList,
      lastPage: json['last_page'],
      nextPageUrl: json['next_page_url'],
      prevPageUrl: json['prev_page_url'],
      firstPageUrl: json['first_page_url'],
      lastPageUrl: json['last_page_url'],
      perPage: json['per_page'],
      total: json['total'],
    );
  }
}
