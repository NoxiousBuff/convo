
class PixabayApiResponse {
  int totalHits;
  int total;
  List<dynamic> hits;

  PixabayApiResponse({
    required this.hits,
    required this.total,
    required this.totalHits,
  });

  factory PixabayApiResponse.fromJson(Map<String, dynamic> json) {
    return PixabayApiResponse(
      hits: json['hits'],
      total: json['total'],
      totalHits: json['totalHits'],
    );
  }
}
