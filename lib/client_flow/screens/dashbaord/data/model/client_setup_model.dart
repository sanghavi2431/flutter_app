// To parse this JSON data, do
//
//     final clientSetupModel = clientSetupModelFromJson(jsonString);

import 'dart:convert';

ClientSetupModel clientSetupModelFromJson(String str) => ClientSetupModel.fromJson(json.decode(str));

String clientSetupModelToJson(ClientSetupModel data) => json.encode(data.toJson());

class ClientSetupModel {
    Results results;
    bool success;

    ClientSetupModel({
        required this.results,
        required this.success,
    });

    factory ClientSetupModel.fromJson(Map<String, dynamic> json) => ClientSetupModel(
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
    Data data;

    Results({
        required this.message,
        required this.data,
    });

    factory Results.fromJson(Map<String, dynamic> json) => Results(
        message: json["Message"],
        data: Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "Message": message,
        "data": data.toJson(),
    };
}

class Data {
    int locationId;
    int clusterId;
    int facilityId;

    Data({
        required this.locationId,
        required this.clusterId,
        required this.facilityId,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        locationId: json["location_id"],
        clusterId: json["cluster_id"],
        facilityId: json["facility_id"],
    );

    Map<String, dynamic> toJson() => {
        "location_id": locationId,
        "cluster_id": clusterId,
        "facility_id": facilityId,
    };
}
