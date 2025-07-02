// To parse this JSON data, do
//
//     final planModel = planModelFromJson(jsonString);

import 'dart:convert';

PlanModel planModelFromJson(String str) => PlanModel.fromJson(json.decode(str));

String planModelToJson(PlanModel data) => json.encode(data.toJson());

class PlanModel {
    Results? results;
    bool? success;

    PlanModel({
         this.results,
         this.success,
    });

    factory PlanModel.fromJson(Map<String, dynamic> json) => PlanModel(
        results: Results.fromJson(json["results"]),
        success: json["success"],
    );

    Map<String, dynamic> toJson() => {
        "results": results!.toJson(),
        "success": success,
    };
}

class Results {
    int? total;
    List<Plan>? plans;

    Results({
        required this.total,
        required this.plans,
    });

    factory Results.fromJson(Map<String, dynamic> json) => Results(
        total: json["total"],
        plans: List<Plan>.from(json["plans"].map((x) => Plan.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "total": total,
        "plans": List<dynamic>.from(plans!.map((x) => x.toJson())),
    };
}

class Plan {
    int? planId;
    String?name;
    int? amount;
    int? noOfLogins;
    int? noOfFacilities;
    int? noOfLocations;
    String? description;
    String?total;

    Plan({
        required this.planId,
        required this.name,
        required this.amount,
        required this.noOfLogins,
        required this.noOfFacilities,
        required this.noOfLocations,
        required this.description,
        required this.total,
    });

    factory Plan.fromJson(Map<String, dynamic> json) => Plan(
        planId: json["plan_id"],
        name: json["name"],
        amount: json["amount"],
        noOfLogins: json["no_of_logins"],
        noOfFacilities: json["no_of_facilities"],
        noOfLocations: json["no_of_locations"],
        description: json["description"],
        total: json["total"],
    );

    Map<String, dynamic> toJson() => {
        "plan_id": planId,
        "name": name,
        "amount": amount,
        "no_of_logins": noOfLogins,
        "no_of_facilities": noOfFacilities,
        "no_of_locations": noOfLocations,
        "description": description,
        "total": total,
    };
}
