// To parse this JSON data, do
//
//     final paymentStatusModel = paymentStatusModelFromJson(jsonString);

import 'dart:convert';

PaymentStatusModel paymentStatusModelFromJson(String str) => PaymentStatusModel.fromJson(json.decode(str));

String paymentStatusModelToJson(PaymentStatusModel data) => json.encode(data.toJson());

class PaymentStatusModel {
    Results? results;
    bool? success;

    PaymentStatusModel({
        this.results,
        this.success,
    });

    factory PaymentStatusModel.fromJson(Map<String, dynamic> json) => PaymentStatusModel(
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
    int? planId;
    dynamic facilityId;
    String? facilityRef;

    Results({
        this.id,
        this.planId,
        this.facilityId,
        this.facilityRef,
    });

    factory Results.fromJson(Map<String, dynamic> json) => Results(
        id: json["id"],
        planId: json["plan_id"],
        facilityId: json["facility_id"],
        facilityRef: json["facility_ref"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "plan_id": planId,
        "facility_id": facilityId,
        "facility_ref": facilityRef,
    };
}
