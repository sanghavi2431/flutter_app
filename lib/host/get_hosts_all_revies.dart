// To parse this JSON data, do
//
//     final getAllReviewsHost = getAllReviewsHostFromJson(jsonString);

import 'dart:convert';

GetAllReviewsHost getAllReviewsHostFromJson(String str) => GetAllReviewsHost.fromJson(json.decode(str));

String getAllReviewsHostToJson(GetAllReviewsHost data) => json.encode(data.toJson());

class GetAllReviewsHost {
  bool success;
  String message;
  ResultsReview results;

  GetAllReviewsHost({
    required this.success,
    required this.message,
    required this.results,
  });

  factory GetAllReviewsHost.fromJson(Map<String, dynamic> json) =>
      GetAllReviewsHost(
        success: json["success"] == true,
        message: json["message"]?.toString() ?? '',
        results: ResultsReview.fromJson(
          (json["results"] as Map<String, dynamic>?) ?? <String, dynamic>{},
        ),
      );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "results": results.toJson(),
  };
}

/*class ResultsReview {
  int totalReviewCount;
  int reviewCount;
  List<ReviewAllHost> review;

  ResultsReview({
    required this.totalReviewCount,
    required this.reviewCount,
    required this.review,
  });

  factory ResultsReview.fromJson(Map<String, dynamic> json) => ResultsReview(
    totalReviewCount: json["total_review_count"],
    reviewCount: json["review_count"],
    review: List<ReviewAllHost>.from(json["review"].map((x) => ReviewAllHost.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "total_review_count": totalReviewCount,
    "review_count": reviewCount,
    "review": List<dynamic>.from(review.map((x) => x.toJson())),
  };
}*/

class ResultsReview {
  int totalReviewCount;
  int reviewCount;
  List<ReviewAllHost> review;

  ResultsReview({
    required this.totalReviewCount,
    required this.reviewCount,
    required this.review,
  });

  factory ResultsReview.fromJson(Map<String, dynamic> json) => ResultsReview(
    totalReviewCount: json["total_review_count"] ?? 0,
    reviewCount: json["review_count"] ?? 0,
    review: (json["review"] as List<dynamic>?)
        ?.map((x) => ReviewAllHost.fromJson(x))
        .toList() ?? [],
  );

  Map<String, dynamic> toJson() => {
    "total_review_count": totalReviewCount,
    "review_count": reviewCount,
    "review": List<dynamic>.from(review.map((x) => x.toJson())),
  };
}


class ReviewAllHost {
  int id;
  int userId;
  int wolooId;
  int rating;
  dynamic remarks;
  int status;
  DateTime createdAt;
  DateTime updatedAt;
  String ratingOption;
  String? reviewDescription;
  UserDetails userDetails;

  ReviewAllHost({
    required this.id,
    required this.userId,
    required this.wolooId,
    required this.rating,
    required this.remarks,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.ratingOption,
    this.reviewDescription,
    required this.userDetails,
  });

  factory ReviewAllHost.fromJson(Map<String, dynamic> json) => ReviewAllHost(
        id: json["id"] ?? 0,
        userId: json["user_id"] ?? 0,
        wolooId: json["woloo_id"] ?? 0,
        rating: json["rating"] ?? 0,
        remarks: json["remarks"],
        status: json["status"] ?? 0,
        createdAt: DateTime.tryParse(json["created_at"]?.toString() ?? '') ??
            DateTime.now(),
        updatedAt: DateTime.tryParse(json["updated_at"]?.toString() ?? '') ??
            DateTime.now(),
        ratingOption: json["rating_option"]?.toString() ?? '',
        reviewDescription: json["review_description"]?.toString(),
        userDetails: json["user_details"] == null
            ? UserDetails(
                id: 0,
                name: 'Anonymous',
                avatar: '',
                wolooSince: DateTime.now(),
                baseUrl: '',
              )
            : UserDetails.fromJson(json["user_details"]),
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "woloo_id": wolooId,
    "rating": rating,
    "remarks": remarks,
    "status": status,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "rating_option": ratingOption,
    "review_description": reviewDescription,
    "user_details": userDetails.toJson(),
  };
}

class UserDetails {
  int id;
  String? name;
  String avatar;
  DateTime wolooSince;
  String baseUrl;

  UserDetails({
    required this.id,
    this.name,
    required this.avatar,
    required this.wolooSince,
    required this.baseUrl,
  });

  factory UserDetails.fromJson(Map<String, dynamic> json) => UserDetails(
        id: json["id"] ?? 0,
        name: json["name"]?.toString(),
        avatar: json["avatar"]?.toString() ?? '',
        wolooSince: DateTime.tryParse(json["woloo_since"]?.toString() ?? '') ??
            DateTime.now(),
        baseUrl: json["base_url"]?.toString() ?? '',
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "avatar": avatar,
    "woloo_since": wolooSince.toIso8601String(),
    "base_url": baseUrl,
  };
}
