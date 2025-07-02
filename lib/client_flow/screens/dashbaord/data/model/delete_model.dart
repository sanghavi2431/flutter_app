// To parse this JSON data, do
//
//     final deleteModel = deleteModelFromJson(jsonString);

import 'dart:convert';

DeleteModel deleteModelFromJson(String str) => DeleteModel.fromJson(json.decode(str));

String deleteModelToJson(DeleteModel data) => json.encode(data.toJson());

class DeleteModel {
    Results results;
    bool success;

    DeleteModel({
        required this.results,
        required this.success,
    });

    factory DeleteModel.fromJson(Map<String, dynamic> json) => DeleteModel(
        results: Results.fromJson(json["results"]),
        success: json["success"],
    );

    Map<String, dynamic> toJson() => {
        "results": results.toJson(),
        "success": success,
    };
}

class Results {
    String message;

    Results({
        required this.message,
    });

    factory Results.fromJson(Map<String, dynamic> json) => Results(
        message: json["message"],
    );

    Map<String, dynamic> toJson() => {
        "message": message,
    };
}
