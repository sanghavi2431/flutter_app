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

  factory GetAllReviewsHost.fromJson(Map<String, dynamic> json) => GetAllReviewsHost(
    success: json["success"],
    message: json["message"],
    results: ResultsReview.fromJson(json["results"]),
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
    id: json["id"],
    userId: json["user_id"],
    wolooId: json["woloo_id"],
    rating: json["rating"],
    remarks: json["remarks"],
    status: json["status"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    ratingOption: json["rating_option"],
    reviewDescription: json["review_description"],
    userDetails: UserDetails.fromJson(json["user_details"]),
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
    id: json["id"],
    name: json["name"],
    avatar: json["avatar"],
    wolooSince: DateTime.parse(json["woloo_since"]),
    baseUrl: json["base_url"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "avatar": avatar,
    "woloo_since": wolooSince.toIso8601String(),
    "base_url": baseUrl,
  };
}
