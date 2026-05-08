// To parse this JSON data, do
//
//     final getTaskDashboard = getTaskDashboardFromJson(jsonString);

import 'dart:convert';

GetTaskDashboard getTaskDashboardFromJson(String str) =>
    GetTaskDashboard.fromJson(json.decode(str));

String getTaskDashboardToJson(GetTaskDashboard data) =>
    json.encode(data.toJson());

class GetTaskDashboard {
  final Results? results;
  final bool? success;

  GetTaskDashboard({
    this.results,
    this.success,
  });

  factory GetTaskDashboard.fromJson(Map<String, dynamic> json) =>
      GetTaskDashboard(
        results:
            json["results"] == null ? null : Results.fromJson(json["results"]),
        success: json["success"],
      );

  Map<String, dynamic> toJson() => {
        "results": results?.toJson(),
        "success": success,
      };
}

class Results {
  final JanitorEfficiency? janitorEfficiency;
  final TaskStatusDistribution? taskStatusDistribution;
  final TotalRewardsPoints? totalRewardsPoints;
  final List<TaskMonitoring>? taskMonitoring;
  final int? taskClosurePending;
  final AttendanceMonitoring? attendanceMonitoring;

  Results({
    this.janitorEfficiency,
    this.taskStatusDistribution,
    this.totalRewardsPoints,
    this.taskMonitoring,
    this.taskClosurePending,
    this.attendanceMonitoring,
  });

  factory Results.fromJson(Map<String, dynamic> json) => Results(
        janitorEfficiency: json["Janitor_efficiency"] == null
            ? null
            : JanitorEfficiency.fromJson(json["Janitor_efficiency"]),
        taskStatusDistribution: json["Task_status_distribution"] == null
            ? null
            : TaskStatusDistribution.fromJson(json["Task_status_distribution"]),
        totalRewardsPoints: json["total_rewards_points"] == null
            ? null
            : TotalRewardsPoints.fromJson(json["total_rewards_points"]),
        taskMonitoring: json["Task_monitoring"] == null
            ? []
            : List<TaskMonitoring>.from(json["Task_monitoring"]!
                .map((x) => TaskMonitoring.fromJson(x))),
        taskClosurePending: json["task_closure_pending"],
        attendanceMonitoring: json["Attendance_monitoring"] == null
            ? null
            : AttendanceMonitoring.fromJson(json["Attendance_monitoring"]),
      );

  Map<String, dynamic> toJson() => {
        "Janitor_efficiency": janitorEfficiency?.toJson(),
        "Task_status_distribution": taskStatusDistribution?.toJson(),
        "total_rewards_points": totalRewardsPoints?.toJson(),
        "Task_monitoring": taskMonitoring == null
            ? []
            : List<dynamic>.from(taskMonitoring!.map((x) => x.toJson())),
        "task_closure_pending": taskClosurePending,
        "Attendance_monitoring": attendanceMonitoring?.toJson(),
      };
}

class JanitorEfficiency {
  final List<String>? totaltask;
  final List<String>? category;
  final String? unit;
  final List<String>? closedtask;

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
            : List<String>.from(json["totaltask"]!.map((x) => x)),
        category: json["category"] == null
            ? []
            : List<String>.from(json["category"]!.map((x) => x)),
        unit: json["unit"],
        closedtask: json["closedtask"] == null
            ? []
            : List<String>.from(json["closedtask"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "totaltask": totaltask == null
            ? []
            : List<dynamic>.from(totaltask!.map((x) => x)),
        "category":
            category == null ? [] : List<dynamic>.from(category!.map((x) => x)),
        "unit": unit,
        "closedtask": closedtask == null
            ? []
            : List<dynamic>.from(closedtask!.map((x) => x)),
      };
}

class TaskStatusDistribution {
  final String? facility;
  final String? pendingCount;
  final String? acceptedCount;
  final String? ongoingCount;
  final String? completedCount;
  final String? closureCount;
  final String? rejectedCount;
  final String? completedPercentage;
  final String? pendingPercentage;
  final String? acceptedPercentage;
  final String? ongoingPercentage;
  final String? closurePercentage;
  final String? rejectedPercentage;

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
  final String? key;

  TotalRewardsPoints({
    this.key,
  });

  factory TotalRewardsPoints.fromJson(Map<String, dynamic> json) =>
      TotalRewardsPoints(
        key: json["key"],
      );

  Map<String, dynamic> toJson() => {
        "key": key,
      };
}

class TaskMonitoring {
  final int? allocationId;
  final int? templateId;
  final String? janitorName;
  final String? status;
  final List<String>? taskNames;
  final String? taskTemplateName;
  final DateTime? startTime;

  TaskMonitoring({
    this.allocationId,
    this.templateId,
    this.janitorName,
    this.status,
    this.taskNames,
    this.taskTemplateName,
    this.startTime,
  });

  factory TaskMonitoring.fromJson(Map<String, dynamic> json) => TaskMonitoring(
        allocationId: json["allocation_id"],
        templateId: json["template_id"],
        janitorName: json["janitor_name"],
        status: json["status"],
        taskNames: json["task_names"] == null
            ? []
            : List<String>.from(json["task_names"]!.map((x) => x)),
        taskTemplateName: json["task_template_name"],
    startTime: json["start_time"] == null
        ? null
        : DateTime.tryParse(json["start_time"]),
      );

  Map<String, dynamic> toJson() => {
        "allocation_id": allocationId,
        "template_id": templateId,
        "janitor_name": janitorName,
        "status": status,
        "task_names": taskNames == null
            ? []
            : List<dynamic>.from(taskNames!.map((x) => x)),
        "task_template_name": taskTemplateName,
    "start_time": startTime?.toIso8601String(),
      };
}

class AttendanceMonitoring {
  final String? totalJanitors;
  final String? presentJanitors;
  final String? attendancePercentage;

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
