// To parse this JSON data, do
//
//     final checkTaskModel = checkTaskModelFromJson(jsonString);

// To parse this JSON data, do
//
//     final checkTaskModel = checkTaskModelFromJson(jsonString);

import 'dart:convert';

CheckTaskModel checkTaskModelFromJson(String str) => CheckTaskModel.fromJson(json.decode(str));

String checkTaskModelToJson(CheckTaskModel data) => json.encode(data.toJson());

class CheckTaskModel {
    Results? results;
    bool? success;

    CheckTaskModel({
         this.results,
         this.success,
    });

    factory CheckTaskModel.fromJson(Map<String, dynamic> json) => CheckTaskModel(
        results: Results.fromJson(json["results"]),
        success: json["success"],
    );

    Map<String, dynamic> toJson() => {
        "results": results!.toJson(),
        "success": success,
    };
}

class Results {
    String? message;

    Results({
         this.message,
    });

    factory Results.fromJson(Map<String, dynamic> json) => Results(
        message: json["message"],
    );

    Map<String, dynamic> toJson() => {
        "message": message,
    };
}
