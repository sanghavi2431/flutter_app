// To parse this JSON data, do
//
//     final statusModel = statusModelFromJson(jsonString);

// import 'dart:convert';

// StatusModel statusModelFromJson(String str) => StatusModel.fromJson(json.decode(str));

// String statusModelToJson(StatusModel data) => json.encode(data.toJson());

// class StatusModel {
//     Results? results;
//     bool? success;

//     StatusModel({
//         this.results,
//         this.success,
//     });

//     factory StatusModel.fromJson(Map<String, dynamic> json) => StatusModel(
//         results: Results.fromJson(json["results"]),
//         success: json["success"],
//     );

//     Map<String, dynamic> toJson() => {
//         "results": results!.toJson(),
//         "success": success,
//     };
// }

// class Results {
//     int? currentTaskStatus;

//     Results({
//         this.currentTaskStatus,
//     });

//     factory Results.fromJson(Map<String, dynamic> json) => Results(
//         currentTaskStatus: json["current_Task_status"],
//     );

//     Map<String, dynamic> toJson() => {
//         "current_Task_status": currentTaskStatus,
//     };
// }
