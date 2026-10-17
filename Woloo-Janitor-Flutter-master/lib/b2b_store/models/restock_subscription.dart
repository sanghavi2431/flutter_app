// To parse this JSON data, do
//
//     final restockSubscriptions = restockSubscriptionsFromJson(jsonString);

import 'dart:convert';

RestockSubscriptions restockSubscriptionsFromJson(String str) =>
    RestockSubscriptions.fromJson(json.decode(str));

String restockSubscriptionsToJson(RestockSubscriptions data) =>
    json.encode(data.toJson());

class RestockSubscriptions {
  List<Result>? result;

  RestockSubscriptions({
    this.result,
  });

  factory RestockSubscriptions.fromJson(Map<String, dynamic> json) =>
      RestockSubscriptions(
        result: json["result"] == null
            ? []
            : List<Result>.from(json["result"]!.map((x) => Result.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "result": result == null
            ? []
            : List<dynamic>.from(result!.map((x) => x.toJson())),
      };
}

class Result {
  String? id;
  String? variantId;
  String? salesChannelId;
  String? phone;
  String? customerId;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic deletedAt;

  Result({
    this.id,
    this.variantId,
    this.salesChannelId,
    this.phone,
    this.customerId,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        id: json["id"],
        variantId: json["variant_id"],
        salesChannelId: json["sales_channel_id"],
        phone: json["phone"],
        customerId: json["customer_id"],
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
        "variant_id": variantId,
        "sales_channel_id": salesChannelId,
        "phone": phone,
        "customer_id": customerId,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "deleted_at": deletedAt,
      };
}
