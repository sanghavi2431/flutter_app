import 'dart:convert';

IotReviews reviewsDataFromJson(String str) =>
    IotReviews.fromJson(json.decode(str));

String reviewsDataToJson(IotReviews data) =>
    json.encode(data.toJson());

class IotReviews {
  final Results? results;
  final bool? success;

  IotReviews({
    this.results,
    this.success,
  });

  factory IotReviews.fromJson(Map<String, dynamic> json) => IotReviews(
    results:
    json["results"] == null ? null : Results.fromJson(json["results"]),
    success: json["success"],
  );

  Map<String, dynamic> toJson() => {
    "results": results?.toJson(),
    "success": success,
  };
}

class Results {
  final List<GraphDataReview>? graphData;

  Results({
    this.graphData,
  });

  factory Results.fromJson(Map<String, dynamic> json) => Results(
    graphData: json["graphData"] == null
        ? []
        : List<GraphDataReview>.from(
        json["graphData"].map((x) => GraphDataReview.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "graphData": graphData == null
        ? []
        : List<dynamic>.from(graphData!.map((x) => x.toJson())),
  };
}

class GraphDataReview {
  final String? facilityName;
  final List<int>? rating;
  final List<int>? data;
  final List<CommentReview>? comments;
  final double? avgRating;

  GraphDataReview({
    this.facilityName,
    this.rating,
    this.data,
    this.comments,
    this.avgRating,
  });

  factory GraphDataReview.fromJson(Map<String, dynamic> json) => GraphDataReview(
    facilityName: json["facility_name"],
    rating: json["rating"] == null
        ? []
        : List<int>.from(
      json["rating"].map((x) => parseInt(x) ?? 0),
    ),
    data: json["data"] == null
        ? []
        : List<int>.from(json["data"].map((x) => x)),
    comments: json["comments"] == null
        ? []
        : List<CommentReview>.from(
        json["comments"].map((x) => CommentReview.fromJson(x))),
   /* avgRating: json["avg_rating"] == null
        ? null
        : (json["avg_rating"] as num).toDouble(),*/
    avgRating: parseDouble(json["avg_rating"]),
  );

  Map<String, dynamic> toJson() => {
    "facility_name": facilityName,
    "rating": rating == null ? [] : List<dynamic>.from(rating!),
    "data": data == null ? [] : List<dynamic>.from(data!),
    "comments": comments == null
        ? []
        : List<dynamic>.from(comments!.map((x) => x.toJson())),
    "avg_rating": avgRating,
  };
}

class CommentReview {
  final int? id;
  final String? guestName;
  final String? mobile;
  final String? comments;
  final int? rating;
  final int? facilityId;
  final DateTime? createdAt;
  final List<String>? improvementTags;

  CommentReview({
    this.id,
    this.guestName,
    this.mobile,
    this.comments,
    this.rating,
    this.facilityId,
    this.createdAt,
    this.improvementTags,
  });

  factory CommentReview.fromJson(Map<String, dynamic> json) => CommentReview(
    id: json["id"],
    guestName: json["guest_name"],
    mobile: json["mobile"],
    comments: json["comments"],
    rating: json["rating"],
    facilityId: json["facility_id"],
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"]),
    improvementTags: json["improvement_tags"] == null
        ? []
        : List<String>.from(json["improvement_tags"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "guest_name": guestName,
    "mobile": mobile,
    "comments": comments,
    "rating": rating,
    "facility_id": facilityId,
    "created_at": createdAt?.toIso8601String(),
    "improvement_tags": improvementTags == null
        ? []
        : List<dynamic>.from(improvementTags!),
  };
}


int? parseInt(dynamic value) {
  if (value == null) return null;

  if (value is int) return value;
  if (value is double) return value.toInt();
  if (value is String) return int.tryParse(value);

  return null;
}

double? parseDouble(dynamic value) {
  if (value == null) return null;

  if (value is double) return value;
  if (value is int) return value.toDouble();
  if (value is String) return double.tryParse(value);

  return null;
}