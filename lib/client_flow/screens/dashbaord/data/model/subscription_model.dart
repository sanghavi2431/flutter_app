// To parse this JSON data, do
//
//     final subscriptionModel = subscriptionModelFromJson(jsonString);

import 'dart:convert';

SubscriptionModel subscriptionModelFromJson(String str) => SubscriptionModel.fromJson(json.decode(str));

String subscriptionModelToJson(SubscriptionModel data) => json.encode(data.toJson());

class SubscriptionModel {
    Results? results;
    bool? success;

    SubscriptionModel({
         this.results,
         this.success,
    });

    factory SubscriptionModel.fromJson(Map<String, dynamic> json) => SubscriptionModel(
        results: Results.fromJson(json["results"]),
        success: json["success"],
    );

    Map<String, dynamic> toJson() => {
        "results": results!.toJson(),
        "success": success,
    };
}

class Results {
    DateTime? expiryDate;
    dynamic planId;

    Results({
         this.expiryDate,
         this.planId,
    });

    factory Results.fromJson(Map<String, dynamic> json) => Results(
        expiryDate: DateTime.parse(json["expiry_date"]),
        planId: json["plan_id"],
    );

    Map<String, dynamic> toJson() => {
        "expiry_date": expiryDate!.toIso8601String(),
        "plan_id": planId,
    };
}
