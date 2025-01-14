import 'TaskStatus.dart';

/// id : 139
/// facility_name : "Restroom"
/// block_name : "CMF"
/// location_name : "Sarjapur Road, Bengaluru"
/// address : "Sarjapur Road, Bengaluru, Karnataka 560035"
/// description : "Rest room"
/// no_of_booths : 1
/// task_status : [{"status":1,"task_id":"16","task_name":"Doors"},{"status":1,"task_id":"17","task_name":" Toilet Roll"}]
/// estimated_time : 120
/// total_tasks : 2
/// pending_task : 0

class FacilityListModel {
  FacilityListModel({
    this.id,
    this.facilityName,
    this.blockName,
    this.locationName,
    this.address,
    this.description,
    this.noOfBooths,
    this.taskStatus,
    this.estimatedTime,
    this.totalTasks,
    this.pendingTask,
    this.janitorId,
  });

  FacilityListModel.fromJson(dynamic json) {
    id = json['id']?.toString();
    facilityName = json['facility_name']?.toString();
    blockName = json['block_name']?.toString();
    locationName = json['location_name']?.toString();
    address = json['address']?.toString();
    description = json['description']?.toString();
    noOfBooths = json['no_of_booths']?.toString();
    if (json['task_status'] != null) {
      taskStatus = [];
      json['task_status'].forEach((v) {
        taskStatus?.add(TaskStatus.fromJson(v));
      });
    }
    estimatedTime = json['estimated_time']?.toString();
    totalTasks = json['total_tasks']?.toString();
    pendingTask = json['pending_task']?.toString();
    requestType = json['request_type']?.toString();
    startTime = json['start_time']?.toString();
    endTime = json['end_time']?.toString();
    janitorName = json['janitor_name']?.toString();
    janitorId = json['janitor_id']?.toString();
  }
  String? id;
  String? facilityName;
  String? blockName;
  String? locationName;
  String? address;
  String? description;
  String? noOfBooths;
  List<TaskStatus>? taskStatus;
  String? estimatedTime;
  String? totalTasks;
  String? pendingTask;

  String? requestType;
  String? startTime;
  String? endTime;
  String? janitorName;
  String? janitorId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['facility_name'] = facilityName;
    map['block_name'] = blockName;
    map['location_name'] = locationName;
    map['address'] = address;
    map['description'] = description;
    map['no_of_booths'] = noOfBooths;
    if (taskStatus != null) {
      map['task_status'] = taskStatus?.map((v) => v.toJson()).toList();
    }
    map['estimated_time'] = estimatedTime;
    map['total_tasks'] = totalTasks;
    map['pending_task'] = pendingTask;

    map['request_type'] = requestType;
    map['start_time'] = startTime;
    map['end_time'] = endTime;
    map['janitor_name'] = janitorName;
    map['janitor_id'] = janitorId;

    return map;
  }
}
