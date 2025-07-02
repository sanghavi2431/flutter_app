// To parse this JSON data, do
//
//     final extendExpiryModel = extendExpiryModelFromJson(jsonString);

import 'dart:convert';

ExtendExpiryModel extendExpiryModelFromJson(String str) => ExtendExpiryModel.fromJson(json.decode(str));

String extendExpiryModelToJson(ExtendExpiryModel data) => json.encode(data.toJson());

class ExtendExpiryModel {
    Results? results;
    bool? success;

    ExtendExpiryModel({
        this.results,
        this.success,
    });

    factory ExtendExpiryModel.fromJson(Map<String, dynamic> json) => ExtendExpiryModel(
        results: Results.fromJson(json["results"]),
        success: json["success"],
    );

    Map<String, dynamic> toJson() => {
        "results": results!.toJson(),
        "success": success,
    };
}

class Results {
    int? id;
    DateTime? expiryDate;
    dynamic planId;

    Results({
        this.id,
        this.expiryDate,
        this.planId,
    });

    factory Results.fromJson(Map<String, dynamic> json) => Results(
        id: json["id"],
        expiryDate: DateTime.parse(json["expiry_date"]),
        planId: json["plan_id"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "expiry_date": expiryDate!.toIso8601String(),
        "plan_id": planId,
    };
}
