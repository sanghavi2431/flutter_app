// To parse this JSON data, do
//
//     final facilityModel = facilityModelFromJson(jsonString);

import 'dart:convert';

FacilityModel facilityModelFromJson(String str) => FacilityModel.fromJson(json.decode(str));

String facilityModelToJson(FacilityModel data) => json.encode(data.toJson());

class FacilityModel {
    Results? results;
    bool? success;

    FacilityModel({
        this.results,
        this.success,
    });

    factory FacilityModel.fromJson(Map<String, dynamic> json) => FacilityModel(
        results: json["results"] != null
          ? Results.fromJson(json["results"])
          : Results(facilities: []),
        success: json["success"],
    );

    Map<String, dynamic> toJson() => {
        "results": results!.toJson(),
        "success": success,
    };
}

class Results {
    int? total;
    List<Facility>? facilities;

    Results({
        this.total,
        this.facilities,
    });

    factory Results.fromJson(Map<String, dynamic> json) => Results(
        total: json["total"],
        facilities: List<Facility>.from(json["facilities"].map((x) => Facility.fromJson(x))) ,
    );

    Map<String, dynamic> toJson() => {
        "total": total,
        "facilities": List<dynamic>.from(facilities!.map((x) => x.toJson())),
    };
}

class Facility {
    int? id;
    String? blockName;
    int? blockId;
    String? locationName;
    int? floorNumber;
    dynamic clientName;
    String? facilityName;
    String? facilityType;
    String? description;
    dynamic shiftIds;
    bool? status;
    int? noOfBooths;
    DateTime? createdAt;
    DateTime? updatedAt;
    int? clusterId;
    List<Shift>? shifts;
    String? subscriptionStatus;
    dynamic planId;
    dynamic planName;
    bool isFutureSubscription;
    bool? isFreeTrial;
    String? total;

    Facility({
        this.id,
        this.blockName,
        this.blockId,
        this.locationName,
        this.floorNumber,
        this.clientName,
        this.facilityName,
        this.facilityType,
        this.description,
        this.shiftIds,
        this.status,
        this.noOfBooths,
        this.createdAt,
        this.updatedAt,
        this.clusterId,
        this.shifts,
        this.subscriptionStatus,
        this.planId,
        this.planName,
       required this.isFutureSubscription,
        this.isFreeTrial,
        this.total,
    });

    factory Facility.fromJson(Map<String, dynamic> json) => Facility(
        id: json["id"],
        blockName: json["block_name"],
        blockId: json["block_id"],
        locationName: json["location_name"],
        floorNumber: json["floor_number"],
        clientName: json["client_name"],
        facilityName: json["facility_name"],
        facilityType: json["facility_type"],
        description: json["description"],
        shiftIds: json["shift_ids"],
        status: json["status"],
        noOfBooths: json["no_of_booths"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        clusterId: json["cluster_id"],
        shifts: List<Shift>.from(json["shifts"].map((x) => Shift.fromJson(x))),
        subscriptionStatus: json["subscription_status"],
        planId: json["plan_id"],
        planName: json["plan_name"],
        isFutureSubscription: json["isFutureSubscription"],
        isFreeTrial: json["isFreeTrial"],
        total: json["total"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "block_name": blockName,
        "block_id": blockId,
        "location_name": locationName,
        "floor_number": floorNumber,
        "client_name": clientName,
        "facility_name": facilityName,
        "facility_type": facilityType,
        "description": description,
        "shift_ids": shiftIds,
        "status": status,
        "no_of_booths": noOfBooths,
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
        "cluster_id": clusterId,
        "shifts": List<dynamic>.from(shifts!.map((x) => x.toJson())),
        "subscription_status": subscriptionStatus,
        "plan_id": planId,
        "plan_name": planName,
        "isFutureSubscription": isFutureSubscription,
        "isFreeTrial": isFreeTrial,
        "total": total,
    };
}

class Shift {
    String? endTime;
    int? shiftId;
    String? shiftName;
    String? startTime;

    Shift({
        this.endTime,
        this.shiftId,
        this.shiftName,
        this.startTime,
    });

    factory Shift.fromJson(Map<String, dynamic> json) => Shift(
        endTime: json["end_time"],
        shiftId: json["shift_id"],
        shiftName: json["shift_name"],
        startTime: json["start_time"],
    );

    Map<String, dynamic> toJson() => {
        "end_time": endTime,
        "shift_id": shiftId,
        "shift_name": shiftName,
        "start_time": startTime,
    };
}
