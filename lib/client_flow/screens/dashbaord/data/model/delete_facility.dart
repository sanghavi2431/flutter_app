// To parse this JSON data, do
//
//     final deleteFacilityModel = deleteFacilityModelFromJson(jsonString);

import 'dart:convert';

DeleteFacilityModel deleteFacilityModelFromJson(String str) => DeleteFacilityModel.fromJson(json.decode(str));

String deleteFacilityModelToJson(DeleteFacilityModel data) => json.encode(data.toJson());

class DeleteFacilityModel {
    List<dynamic> results;
    bool success;

    DeleteFacilityModel({
        required this.results,
        required this.success,
    });

    factory DeleteFacilityModel.fromJson(Map<String, dynamic> json) => DeleteFacilityModel(
        results: List<dynamic>.from(json["results"].map((x) => x)),
        success: json["success"],
    );

    Map<String, dynamic> toJson() => {
        "results": List<dynamic>.from(results.map((x) => x)),
        "success": success,
    };
}
