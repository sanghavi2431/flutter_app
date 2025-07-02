// To parse this JSON data, do
//
//     final checkSupervisor = checkSupervisorFromJson(jsonString);

import 'dart:convert';

CheckSupervisorModel checkSupervisorFromJson(String str) => CheckSupervisorModel.fromJson(json.decode(str));

String checkSupervisorToJson(CheckSupervisorModel data) => json.encode(data.toJson());

class CheckSupervisorModel {
    Results? results;
    bool? success;

    CheckSupervisorModel({
       this.results,
       this.success,
    });

    factory CheckSupervisorModel.fromJson(Map<String, dynamic> json) => CheckSupervisorModel(
        results: Results.fromJson(json["results"]),
        success: json["success"],
    );

    Map<String, dynamic> toJson() => {
        "results": results!.toJson(),
        "success": success,
    };
}

class Results {
    bool? isClientSupervisor;

    Results({
       this.isClientSupervisor,
    });

    factory Results.fromJson(Map<String, dynamic> json) => Results(
        isClientSupervisor: json["isClientSupervisor"],
    );

    Map<String, dynamic> toJson() => {
        "isClientSupervisor": isClientSupervisor,
    };
}
