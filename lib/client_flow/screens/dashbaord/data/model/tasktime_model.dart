import 'package:flutter/material.dart';

class TaskTimeModel {
  int taskId;
  TimeOfDay endTime;
  TimeOfDay startTime;
  String facilityName;
  String facilityType;
  List<String>? taskName;
  List<int>? taskIds;
  List<String>? days; // Days for this task (e.g., ["Sunday", "Monday", "Friday"])

  /// When set, sent as `janitor_id` on this row in [ASSIGN_TASK] `task_times`.
  /// If null, the assign call uses the event-level janitor id for that row.
  int? janitorId;

  TaskTimeModel(
    {
    required this.taskId,
    required this.endTime,
    required this.startTime,
    required this.facilityName,
    required this.facilityType,
    this.taskName,
    this.taskIds,
    this.days,
    this.janitorId,
  }
  );

  // factory TaskTimeModel.fromJson(Map<String, dynamic> json) => TaskTimeModel(
  //     taskId: json["task_id"],
  //     endTime: DateTime.parse(json["end_time"]),
  //     startTime: DateTime.parse(json["start_time"]),
  //     facilityName: json["facility_name"],
  //     facilityType: json["facility_type"],
  // );

  // Map<String, dynamic> toJson() => {
  //     "task_id": taskId,
  //     "end_time": endTime.toIso8601String(),
  //     "start_time": startTime.toIso8601String(),
  //     "facility_name": facilityName,
  //     "facility_type": facilityType,
  // };
}
