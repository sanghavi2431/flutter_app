// To parse this JSON data, do
//
//     final otpModel = otpModelFromJson(jsonString);

import 'dart:convert';

OtpModel otpModelFromJson(String str) => OtpModel.fromJson(json.decode(str));

String otpModelToJson(OtpModel data) => json.encode(data.toJson());

class OtpModel {
    bool? success;
    Results? results;

    OtpModel({
        this.success,
        this.results,
    });

    factory OtpModel.fromJson(Map<String, dynamic> json) => OtpModel(
        success: json["success"],
        results: Results.fromJson(json["results"]),
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "results": results!.toJson(),
    };
}

class Results {
    String? requestId;

    Results({
        this.requestId,
    });

    factory Results.fromJson(Map<String, dynamic> json) => Results(
        requestId: json["request_id"],
    );

    Map<String, dynamic> toJson() => {
        "request_id": requestId,
    };
}
