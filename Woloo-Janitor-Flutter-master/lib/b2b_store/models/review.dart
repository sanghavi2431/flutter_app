// To parse this JSON data, do
//
//     final review = reviewFromJson(jsonString);

import 'dart:convert';

Review reviewFromJson(String str) => Review.fromJson(json.decode(str));

String reviewToJson(Review data) => json.encode(data.toJson());

class Review {
  final ReviewClass review;

  Review({
    required this.review,
  });

  factory Review.fromJson(Map<String, dynamic> json) => Review(
        review: ReviewClass.fromJson(json["review"]),
      );

  Map<String, dynamic> toJson() => {
        "review": review.toJson(),
      };
}

class ReviewClass {
  final String id;
  final int rating;
  final String comment;
  final bool approval;
  final DateTime createdAt;
  final DateTime updatedAt;
  final dynamic deletedAt;

  ReviewClass({
    required this.id,
    required this.rating,
    required this.comment,
    required this.approval,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
  });

  factory ReviewClass.fromJson(Map<String, dynamic> json) => ReviewClass(
        id: json["id"],
        rating: json["rating"],
        comment: json["comment"],
        approval: json["approval"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "rating": rating,
        "comment": comment,
        "approval": approval,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "deleted_at": deletedAt,
      };
}
