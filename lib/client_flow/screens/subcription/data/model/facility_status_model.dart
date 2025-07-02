// To parse this JSON data, do
//
//     final facilityStatusModel = facilityStatusModelFromJson(jsonString);

import 'dart:convert';

FacilityStatusModel facilityStatusModelFromJson(String str) => FacilityStatusModel.fromJson(json.decode(str));

String facilityStatusModelToJson(FacilityStatusModel data) => json.encode(data.toJson());

class FacilityStatusModel {
    List<Result>? results;
    bool? success;

    FacilityStatusModel({
        this.results,
        this.success,
    });

    factory FacilityStatusModel.fromJson(Map<String, dynamic> json) => FacilityStatusModel(
        results: List<Result>.from(json["results"].map((x) => Result.fromJson(x))),
        success: json["success"],
    );

    Map<String, dynamic> toJson() => {
        "results": List<dynamic>.from(results!.map((x) => x.toJson())),
        "success": success,
    };
}

class Result {
    int? facilityId;
    String? facilityName;
    int? planId;
    String? planName;
    int? planPrice;
    int? clientId;
    DateTime? startDate;
    DateTime? endDate;
    String? subscriptionStatus;

    Result({
        this.facilityId,
        this.facilityName,
        this.planId,
        this.planName,
        this.planPrice,
        this.clientId,
        this.startDate,
        this.endDate,
        this.subscriptionStatus,
    });

    factory Result.fromJson(Map<String, dynamic> json) => Result(
        facilityId: json["facility_id"],
        facilityName: json["facility_name"],
        planId: json["plan_id"],
        planName: json["plan_name"],
        planPrice: json["plan_price"],
        clientId: json["client_id"],
        startDate: DateTime.parse(json["start_date"]),
        endDate: DateTime.parse(json["end_date"]),
        subscriptionStatus: json["subscription_status"],
    );

    Map<String, dynamic> toJson() => {
        "facility_id": facilityId,
        "facility_name": facilityName,
        "plan_id": planId,
        "plan_name": planName,
        "plan_price": planPrice,
        "client_id": clientId,
        "start_date": startDate!.toIso8601String(),
        "end_date": endDate!.toIso8601String(),
        "subscription_status": subscriptionStatus,
    };
}
