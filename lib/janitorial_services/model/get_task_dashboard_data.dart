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

  Results({
    this.janitorEfficiency,
    this.taskStatusDistribution,
  });

  factory Results.fromJson(Map<String, dynamic> json) => Results(
        janitorEfficiency: json["Janitor_efficiency"] == null
            ? null
            : JanitorEfficiency.fromJson(json["Janitor_efficiency"]),
        taskStatusDistribution: json["Task_status_distribution"] == null
            ? null
            : TaskStatusDistribution.fromJson(json["Task_status_distribution"]),
      );

  Map<String, dynamic> toJson() => {
        "Janitor_efficiency": janitorEfficiency?.toJson(),
        "Task_status_distribution": taskStatusDistribution?.toJson(),
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
  final String? completedPercentage;
  final String? pendingPercentage;
  final String? acceptedPercentage;
  final String? ongoingPercentage;

  TaskStatusDistribution({
    this.facility,
    this.pendingCount,
    this.acceptedCount,
    this.ongoingCount,
    this.completedCount,
    this.completedPercentage,
    this.pendingPercentage,
    this.acceptedPercentage,
    this.ongoingPercentage,
  });

  factory TaskStatusDistribution.fromJson(Map<String, dynamic> json) =>
      TaskStatusDistribution(
        facility: json["facility"],
        pendingCount: json["pending_count"],
        acceptedCount: json["accepted_count"],
        ongoingCount: json["ongoing_count"],
        completedCount: json["completed_count"],
        completedPercentage: json["completed_percentage"],
        pendingPercentage: json["pending_percentage"],
        acceptedPercentage: json["accepted_percentage"],
        ongoingPercentage: json["ongoing_percentage"],
      );

  Map<String, dynamic> toJson() => {
        "facility": facility,
        "pending_count": pendingCount,
        "accepted_count": acceptedCount,
        "ongoing_count": ongoingCount,
        "completed_count": completedCount,
        "completed_percentage": completedPercentage,
        "pending_percentage": pendingPercentage,
        "accepted_percentage": acceptedPercentage,
        "ongoing_percentage": ongoingPercentage,
      };
}
