// To parse this JSON data, do
//
//     final janitorModel = janitorModelFromJson(jsonString);

import 'dart:convert';

JanitorModel janitorModelFromJson(String str) => JanitorModel.fromJson(json.decode(str));

String janitorModelToJson(JanitorModel data) => json.encode(data.toJson());

class JanitorModel {
    List<Result>? results;
    bool? success;

    JanitorModel({
        this.results,
        this.success,
    });

    factory JanitorModel.fromJson(Map<String, dynamic> json) => JanitorModel(
        results:
            json["results"] == null
                ? []
                :   List<Result>.from(json["results"].map((x) => Result.fromJson(x))),
        success: json["success"],
    );

    Map<String, dynamic> toJson() => {
        "results": List<dynamic>.from(results!.map((x) => x.toJson())),
        "success": success,
    };
}

class Result {
    int? clientId;
    int? facilityId;
    int? janitorId;
    String? janitorName;

    Result({
        this.clientId,
        this.facilityId,
        this.janitorId,
        this.janitorName,
    });

    factory Result.fromJson(Map<String, dynamic> json) => Result(
        clientId: json["client_id"],
        facilityId: json["facility_id"],
        janitorId: json["janitor_id"],
        janitorName: json["janitor_name"],
    );

    Map<String, dynamic> toJson() => {
        "client_id": clientId,
        "facility_id": facilityId,
        "janitor_id": janitorId,
        "janitor_name": janitorName,
    };
}
