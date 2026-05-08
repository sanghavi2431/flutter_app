
class ReviewListRequest {
  final int pageNumber;
  final int wolooId;
  final String token;

  ReviewListRequest({
    required this.pageNumber,
    required this.wolooId,
    required this.token,
  });

  Map<String, dynamic> toJson() {
    return {
      "pageNumber": pageNumber,
      "woloo_id": wolooId,
    };
  }
}
