import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';

class CustomerReviews {
  final String? productId;
  final List<Review> reviews;

  CustomerReviews({
    this.productId,
    this.reviews = const [],
  });

  factory CustomerReviews.fromJson(Map<String, dynamic> json) =>
      CustomerReviews(
        productId: json["product_id"],
        reviews: json["reviews"] == null
            ? []
            : List<Review>.from(
                json["reviews"]!.map((x) => Review.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "product_id": productId,
        "reviews": List<dynamic>.from(reviews.map((x) => x.toJson())),
      };

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}

class Review {
  final String? id;
  final int? rating;
  final String? comment;
  final bool? approval;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final dynamic deletedAt;
  final Customer? customer;

  Review({
    this.id,
    this.rating,
    this.comment,
    this.approval,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.customer,
  });

  factory Review.fromJson(Map<String, dynamic> json) => Review(
        id: json["id"],
        rating: json["rating"],
        comment: json["comment"],
        approval: json["approval"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"],
        customer: json["customer"] == null
            ? null
            : Customer.fromJson(json["customer"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "rating": rating,
        "comment": comment,
        "approval": approval,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "deleted_at": deletedAt,
        "customer": customer?.toJson(),
      };

  String get formattedCreatedAt {
    return createdAt != null
        ? DateFormat('dd-MM-yyyy').format(createdAt!)
        : 'Date not available';
  }
}

class Customer {
  final String? id;
  final dynamic companyName;
  final dynamic firstName;
  final dynamic lastName;
  final String? email;
  final dynamic phone;
  final bool? hasAccount;
  final dynamic metadata;
  final dynamic createdBy;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final dynamic deletedAt;

  Customer({
    this.id,
    this.companyName,
    this.firstName,
    this.lastName,
    this.email,
    this.phone,
    this.hasAccount,
    this.metadata,
    this.createdBy,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory Customer.fromJson(Map<String, dynamic> json) => Customer(
        id: json["id"],
        companyName: json["company_name"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        email: json["email"],
        phone: json["phone"],
        hasAccount: json["has_account"],
        metadata: json["metadata"],
        createdBy: json["created_by"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "company_name": companyName,
        "first_name": firstName,
        "last_name": lastName,
        "email": email,
        "phone": phone,
        "has_account": hasAccount,
        "metadata": metadata,
        "created_by": createdBy,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "deleted_at": deletedAt,
      };
}
