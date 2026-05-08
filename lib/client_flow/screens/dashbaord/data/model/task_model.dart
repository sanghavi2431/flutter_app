// To parse this JSON data, do
//
//     final taskModel = taskModelFromJson(jsonString);

// To parse this JSON data, do
//
//     final taskModel = taskModelFromJson(jsonString);

import 'dart:convert';

TaskModel taskModelFromJson(String str) => TaskModel.fromJson(json.decode(str));

String taskModelToJson(TaskModel data) => json.encode(data.toJson());

class TaskModel {
  Results? results;
  bool? success;

  TaskModel({
    this.results,
    this.success,
  });

  /// getAllUser / getAllJanitor when the API has no rows (often HTTP 400 + `"No Data Found!"`).
  factory TaskModel.emptyJanitorList() => TaskModel(
        success: true,
        results: Results(data: [], total: 0),
      );

  /// [DioClient.post] throws [Response.data] (string or map) on error, not [DioException].
  static bool looksLikeGetAllUserNoDataEmpty(Object? e) {
    if (e is String) {
      return e.toLowerCase().contains('no data found');
    }
    if (e is Map) {
      final msg = e['message']?.toString().toLowerCase() ?? '';
      final dynamic r = e['result'] ?? e['results'];
      if (msg.contains('no data found')) {
        if (r == null) return true;
        if (r is List && r.isEmpty) return true;
      }
      if (e['success'] == false && r is List && r.isEmpty) {
        return true;
      }
    }
    return false;
  }

  factory TaskModel.fromJson(Map<String, dynamic> json) => TaskModel(
        results: Results.fromJson(json["results"]),
        success: json["success"],
      );

  Map<String, dynamic> toJson() => {
        "results": results!.toJson(),
        "success": success,
      };
}

class Results {
  List<Datum>? data;
  int? total;

  Results({
    this.data,
    this.total,
  });

  factory Results.fromJson(Map<String, dynamic> json) => Results(
        data: json["data"] == null
            ? []
            : List<Datum>.from(
                (json["data"] as List).map((x) => Datum.fromJson(x)),
              ),
        total: json["total"],
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
        "total": total,
      };
}

class Datum {
  int? id;
  String? name;
  String? mobile;
  String? city;
  String? address;
  bool? status;
  dynamic email;
  List<TaskTime>? taskTimes;
  int? total;

  Datum({
    this.id,
    this.name,
    this.mobile,
    this.city,
    this.address,
    this.status,
    this.email,
    this.taskTimes,
    this.total,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        name: json["name"],
        mobile: json["mobile"],
        city: json["city"],
        address: json["address"],
        status: json["status"],
        email: json["email"],
        taskTimes: json["task_times"] == null
            ? []
            : List<TaskTime>.from(
                (json["task_times"] as List).map((x) => TaskTime.fromJson(x)),
              ),
        total: json["total"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "mobile": mobile,
        "city": city,
        "address": address,
        "status": status,
        "email": email,
        "task_times": List<dynamic>.from(taskTimes!.map((x) => x.toJson())),
        "total": total,
      };
}

class TaskTime {
  int? taskId;
  DateTime? endTime;
  DateTime? startTime;
  List<String>? taskNames;
  String? facilityName;
  String? facilityType;
  List<String>? days;

  TaskTime({
    this.taskId,
    this.endTime,
    this.startTime,
    this.taskNames,
    this.facilityName,
    this.facilityType,
    this.days,
  });

  factory TaskTime.fromJson(Map<String, dynamic> json) => TaskTime(
        taskId: json["task_id"],
        endTime: json["end_time"] == null
            ? null
            : DateTime.parse(json["end_time"].toString()),
        startTime: json["start_time"] == null
            ? null
            : DateTime.parse(json["start_time"].toString()),
        taskNames: json["task_names"] == null
            ? []
            : List<String>.from(
                (json["task_names"] as List).map((x) => x.toString()),
              ),
        facilityName: json["facility_name"]?.toString(),
        facilityType: json["facility_type"]?.toString(),
        days: json["days"] == null
            ? []
            : List<String>.from(
                (json["days"] as List).map((x) => x.toString()),
              ),
      );

  Map<String, dynamic> toJson() => {
        "task_id": taskId,
        "end_time": endTime!.toIso8601String(),
        "start_time": startTime!.toIso8601String(),
        "task_names": List<dynamic>.from(taskNames!.map((x) => x)),
        "facility_name": facilityName,
        "facility_type": facilityType,
        "days": List<dynamic>.from(days!.map((x) => x)),
      };
}
