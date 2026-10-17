/*
// To parse this JSON data, do
//
//     final dashbaordModel = dashbaordModelFromJson(jsonString);

import 'dart:convert';
import 'package:woloo_smart_hygiene/janitorial_services/model/get_task_dashboard_data.dart';

DashbaordModel dashbaordModelFromJson(String str) =>
    DashbaordModel.fromJson(json.decode(str));

String dashbaordModelToJson(DashbaordModel data) => json.encode(data.toJson());

class DashbaordModel {
  Results? results;
  bool? success;

  DashbaordModel({
    this.results,
    this.success,
  });

  factory DashbaordModel.fromJson(Map<String, dynamic> json) => DashbaordModel(
        results: Results.fromJson(json["results"]),
        success: json["success"],
      );

  Map<String, dynamic> toJson() => {
        "results": results!.toJson(),
        "success": success,
      };
}

class Results {
  JanitorEfficiency? janitorEfficiency;
  TaskStatusDistribution? taskStatusDistribution;
  List<TaskMonitoring>? taskMonitoring;
  // TotalRewardsPoints? totalRewardsPoints;

  Results({
    this.janitorEfficiency,
    this.taskStatusDistribution,
    this.taskMonitoring,
    // this.totalRewardsPoints,
  });

  factory Results.fromJson(Map<String, dynamic> json) => Results(
        janitorEfficiency:
            JanitorEfficiency.fromJson(json["Janitor_efficiency"]),
        taskStatusDistribution:
            TaskStatusDistribution.fromJson(json["Task_status_distribution"]),
        taskMonitoring: json["Task_monitoring"] == null
            ? []
            : List<TaskMonitoring>.from(
                json["Task_monitoring"]!.map((x) => TaskMonitoring.fromJson(x))),
        // totalRewardsPoints: TotalRewardsPoints.fromJson(json["total_rewards_points"]),
      );

  Map<String, dynamic> toJson() => {
        "Janitor_efficiency": janitorEfficiency!.toJson(),
        "Task_status_distribution": taskStatusDistribution!.toJson(),
        "Task_monitoring": taskMonitoring == null
            ? []
            : List<dynamic>.from(taskMonitoring!.map((x) => x.toJson())),
        // "total_rewards_points": totalRewardsPoints!.toJson(),
      };
}

class JanitorEfficiency {
  List<String>? totaltask;
  List<String>? category;
  String? unit;
  List<String>? closedtask;

  JanitorEfficiency({
    this.totaltask,
    this.category,
    this.unit,
    this.closedtask,
  });

  factory JanitorEfficiency.fromJson(Map<String, dynamic> json) =>
      JanitorEfficiency(
        totaltask: List<String>.from(json["totaltask"].map((x) => x)),
        category: List<String>.from(json["category"].map((x) => x)),
        unit: json["unit"],
        closedtask: List<String>.from(json["closedtask"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "totaltask": List<dynamic>.from(totaltask!.map((x) => x)),
        "category": List<dynamic>.from(category!.map((x) => x)),
        "unit": unit,
        "closedtask": List<dynamic>.from(closedtask!.map((x) => x)),
      };
}

class TaskStatusDistribution {
  String? facility;
  String? pendingCount;
  String? acceptedCount;
  String? ongoingCount;
  String? completedCount;
  String? closureCount;
  String? rejectedCount;
  String? completedPercentage;
  String? pendingPercentage;
  String? acceptedPercentage;
  String? ongoingPercentage;
  String? closurePercentage;
  String? rejectedPercentage;

  TaskStatusDistribution({
    this.facility,
    this.pendingCount,
    this.acceptedCount,
    this.ongoingCount,
    this.completedCount,
    this.closureCount,
    this.rejectedCount,
    this.completedPercentage,
    this.pendingPercentage,
    this.acceptedPercentage,
    this.ongoingPercentage,
    this.closurePercentage,
    this.rejectedPercentage,
  });

  factory TaskStatusDistribution.fromJson(Map<String, dynamic> json) =>
      TaskStatusDistribution(
        facility: json["facility"],
        pendingCount: json["pending_count"],
        acceptedCount: json["accepted_count"],
        ongoingCount: json["ongoing_count"],
        completedCount: json["completed_count"],
        closureCount: json["closure_count"],
        rejectedCount: json["rejected_count"],
        completedPercentage: json["completed_percentage"],
        pendingPercentage: json["pending_percentage"],
        acceptedPercentage: json["accepted_percentage"],
        ongoingPercentage: json["ongoing_percentage"],
        closurePercentage: json["closure_percentage"],
        rejectedPercentage: json["rejected_percentage"],
      );

  Map<String, dynamic> toJson() => {
        "facility": facility,
        "pending_count": pendingCount,
        "accepted_count": acceptedCount,
        "ongoing_count": ongoingCount,
        "completed_count": completedCount,
        "closure_count": closureCount,
        "rejected_count": rejectedCount,
        "completed_percentage": completedPercentage,
        "pending_percentage": pendingPercentage,
        "accepted_percentage": acceptedPercentage,
        "ongoing_percentage": ongoingPercentage,
        "closure_percentage": closurePercentage,
        "rejected_percentage": rejectedPercentage,
      };
}

class TotalRewardsPoints {
  String? key;
  int? value;

  TotalRewardsPoints({
    this.key,
    this.value,
  });

  factory TotalRewardsPoints.fromJson(Map<String, dynamic> json) =>
      TotalRewardsPoints(
        key: json["key"],
        value: json["value"],
      );

  Map<String, dynamic> toJson() => {
        "key": key,
        "value": value,
      };
}
*/


// To parse this JSON data, do
//
// final dashbaordModel = dashbaordModelFromJson(jsonString);

import 'dart:convert';

import '../../../../../janitorial_services/model/get_task_dashboard_data.dart';

DashbaordModel dashbaordModelFromJson(String str) =>
    DashbaordModel.fromJson(json.decode(str));

String dashbaordModelToJson(DashbaordModel data) =>
    json.encode(data.toJson());

class DashbaordModel {
  Results? results;
  bool? success;

  DashbaordModel({
    this.results,
    this.success,
  });

  factory DashbaordModel.fromJson(Map<String, dynamic> json) =>
      DashbaordModel(
        results: json["results"] == null
            ? null
            : Results.fromJson(json["results"]),
        success: json["success"],
      );

  Map<String, dynamic> toJson() => {
    "results": results?.toJson(),
    "success": success,
  };
}

class Results {
  JanitorEfficiency? janitorEfficiency;
  TaskStatusDistribution? taskStatusDistribution;
  List<TaskMonitoring>? taskMonitoring;
  TotalRewardsPoints? totalRewardsPoints;
  int? taskClosurePending;
  AttendanceMonitoring? attendanceMonitoring;
  String? wahScoreUrl;

  Results({
    this.janitorEfficiency,
    this.taskStatusDistribution,
    this.taskMonitoring,
    this.totalRewardsPoints,
    this.taskClosurePending,
    this.attendanceMonitoring,
    this.wahScoreUrl,
  });

  factory Results.fromJson(Map<String, dynamic> json) => Results(
    janitorEfficiency: json["Janitor_efficiency"] == null
        ? null
        : JanitorEfficiency.fromJson(json["Janitor_efficiency"]),

    taskStatusDistribution: json["Task_status_distribution"] == null
        ? null
        : TaskStatusDistribution.fromJson(
        json["Task_status_distribution"]),

    taskMonitoring: json["Task_monitoring"] == null
        ? []
        : List<TaskMonitoring>.from(
        json["Task_monitoring"]
            .map((x) => TaskMonitoring.fromJson(x))),

    totalRewardsPoints: json["total_rewards_points"] == null
        ? null
        : TotalRewardsPoints.fromJson(json["total_rewards_points"]),

    taskClosurePending: json["task_closure_pending"],

    attendanceMonitoring: json["Attendance_monitoring"] == null
        ? null
        : AttendanceMonitoring.fromJson(
        json["Attendance_monitoring"]),
    wahScoreUrl: json["WAH_SCORE_URL"],
  );

  Map<String, dynamic> toJson() => {
    "Janitor_efficiency": janitorEfficiency?.toJson(),
    "Task_status_distribution": taskStatusDistribution?.toJson(),
    "Task_monitoring": taskMonitoring == null
        ? []
        : List<dynamic>.from(taskMonitoring!.map((x) => x.toJson())),
    "total_rewards_points": totalRewardsPoints?.toJson(),
    "task_closure_pending": taskClosurePending,
    "Attendance_monitoring": attendanceMonitoring?.toJson(),
    "WAH_SCORE_URL": wahScoreUrl,
  };
}

class JanitorEfficiency {
  List<String>? totaltask;
  List<String>? category;
  String? unit;
  List<String>? closedtask;

  JanitorEfficiency({
    this.totaltask,
    this.category,
    this.unit,
    this.closedtask,
  });

  factory JanitorEfficiency.fromJson(Map<String, dynamic> json) =>
      JanitorEfficiency(
        totaltask: json["totaltask"] == null
            ? []
            : List<String>.from(json["totaltask"]),
        category: json["category"] == null
            ? []
            : List<String>.from(json["category"]),
        unit: json["unit"],
        closedtask: json["closedtask"] == null
            ? []
            : List<String>.from(json["closedtask"]),
      );

  Map<String, dynamic> toJson() => {
    "totaltask": totaltask,
    "category": category,
    "unit": unit,
    "closedtask": closedtask,
  };
}

class TaskStatusDistribution {
  String? facility;
  String? pendingCount;
  String? acceptedCount;
  String? ongoingCount;
  String? completedCount;
  String? closureCount;
  String? rejectedCount;
  String? completedPercentage;
  String? pendingPercentage;
  String? acceptedPercentage;
  String? ongoingPercentage;
  String? closurePercentage;
  String? rejectedPercentage;

  TaskStatusDistribution({
    this.facility,
    this.pendingCount,
    this.acceptedCount,
    this.ongoingCount,
    this.completedCount,
    this.closureCount,
    this.rejectedCount,
    this.completedPercentage,
    this.pendingPercentage,
    this.acceptedPercentage,
    this.ongoingPercentage,
    this.closurePercentage,
    this.rejectedPercentage,
  });

  factory TaskStatusDistribution.fromJson(Map<String, dynamic> json) =>
      TaskStatusDistribution(
        facility: json["facility"],
        pendingCount: json["pending_count"],
        acceptedCount: json["accepted_count"],
        ongoingCount: json["ongoing_count"],
        completedCount: json["completed_count"],
        closureCount: json["closure_count"],
        rejectedCount: json["rejected_count"],
        completedPercentage: json["completed_percentage"],
        pendingPercentage: json["pending_percentage"],
        acceptedPercentage: json["accepted_percentage"],
        ongoingPercentage: json["ongoing_percentage"],
        closurePercentage: json["closure_percentage"],
        rejectedPercentage: json["rejected_percentage"],
      );

  Map<String, dynamic> toJson() => {
    "facility": facility,
    "pending_count": pendingCount,
    "accepted_count": acceptedCount,
    "ongoing_count": ongoingCount,
    "completed_count": completedCount,
    "closure_count": closureCount,
    "rejected_count": rejectedCount,
    "completed_percentage": completedPercentage,
    "pending_percentage": pendingPercentage,
    "accepted_percentage": acceptedPercentage,
    "ongoing_percentage": ongoingPercentage,
    "closure_percentage": closurePercentage,
    "rejected_percentage": rejectedPercentage,
  };
}

class TotalRewardsPoints {
  String? key;
  dynamic value;

  TotalRewardsPoints({
    this.key,
    this.value,
  });

  factory TotalRewardsPoints.fromJson(Map<String, dynamic> json) =>
      TotalRewardsPoints(
        key: json["key"],
        value: json["value"],
      );

  Map<String, dynamic> toJson() => {
    "key": key,
    "value": value,
  };
}

class AttendanceMonitoring {
  String? totalJanitors;
  String? presentJanitors;
  String? attendancePercentage;

  AttendanceMonitoring({
    this.totalJanitors,
    this.presentJanitors,
    this.attendancePercentage,
  });

  factory AttendanceMonitoring.fromJson(Map<String, dynamic> json) =>
      AttendanceMonitoring(
        totalJanitors: json["total_janitors"],
        presentJanitors: json["present_janitors"],
        attendancePercentage: json["attendance_percentage"],
      );

  Map<String, dynamic> toJson() => {
    "total_janitors": totalJanitors,
    "present_janitors": presentJanitors,
    "attendance_percentage": attendancePercentage,
  };
}
