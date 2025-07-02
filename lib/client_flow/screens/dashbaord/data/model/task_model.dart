// To parse this JSON data, do
//
//     final taskModel = taskModelFromJson(jsonString);

import 'dart:convert';

TaskModel taskModelFromJson(String str) => TaskModel.fromJson(json.decode(str));

String taskModelToJson(TaskModel data) => json.encode(data.toJson());

class TaskModel {
    Results results;
    bool success;

    TaskModel({
        required this.results,
        required this.success,
    });

    factory TaskModel.fromJson(Map<String, dynamic> json) => TaskModel(
        results: Results.fromJson(json["results"]),
        success: json["success"],
    );

    Map<String, dynamic> toJson() => {
        "results": results.toJson(),
        "success": success,
    };
}

class Results {
    List<Datum> data;
    int total;

    Results({
        required this.data,
        required this.total,
    });

    factory Results.fromJson(Map<String, dynamic> json) => Results(
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
        total: json["total"],
    );

    Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "total": total,
    };
}

class Datum {
    int id;
    String name;
    String mobile;
    String city;
    String address;
    bool status;
    dynamic email;
    List<TaskTime> taskTimes;
    int total;

    Datum({
        required this.id,
        required this.name,
        required this.mobile,
        required this.city,
        required this.address,
        required this.status,
        required this.email,
        required this.taskTimes,
        required this.total,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        name: json["name"],
        mobile: json["mobile"],
        city: json["city"],
        address: json["address"],
        status: json["status"],
        email: json["email"],
        taskTimes: List<TaskTime>.from(json["task_times"].map((x) => TaskTime.fromJson(x))),
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
        "task_times": List<dynamic>.from(taskTimes.map((x) => x.toJson())),
        "total": total,
    };
}

class TaskTime {
    int taskId;
    DateTime endTime;
    DateTime startTime;
    String facilityName;
    String facilityType;

    TaskTime({
        required this.taskId,
        required this.endTime,
        required this.startTime,
        required this.facilityName,
        required this.facilityType,
    });

    factory TaskTime.fromJson(Map<String, dynamic> json) => TaskTime(
        taskId: json["task_id"],
        endTime: DateTime.parse(json["end_time"]),
        startTime: DateTime.parse(json["start_time"]),
        facilityName: json["facility_name"],
        facilityType: json["facility_type"],
    );

    Map<String, dynamic> toJson() => {
        "task_id": taskId,
        "end_time": endTime.toIso8601String(),
        "start_time": startTime.toIso8601String(),
        "facility_name": facilityName,
        "facility_type": facilityType,
    };
}
