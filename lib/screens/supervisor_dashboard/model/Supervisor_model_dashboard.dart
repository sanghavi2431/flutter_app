// task_allocation_id : 131
// date : "07-08-2023"
// janitor_id : 4
// request_type : "Regular"
// start_time : "10:00 AM"
// end_time : "11:00 AM"
// facility_id : 62
// template_id : 47
// template_name : "Toilet Cleaning"
// description : "Cleaning"
// facility_name : "Gents Restroom"
// estimated_time : 60
// total_tasks : 2
// booths : 3
// floor_number : 0
// location : "Sarjapur Road, Bengaluru"
// lat : 12.91527
// lng : 77.684956
// janitor_name : "Adelina"
// block_name : "CMF"
// pending_tasks : "0"
// status : "Request for closure"

class SupervisorModelDashboard {
  SupervisorModelDashboard({
    this.taskAllocationId,
    this.date,
    this.janitorId,
    this.requestType,
    this.startTime,
    this.endTime,
    this.facilityId,
    this.templateId,
    this.templateName,
    this.description,
    this.facilityName,
    this.estimatedTime,
    this.totalTasks,
    this.booths,
    this.floorNumber,
    this.location,
    this.lat,
    this.lng,
    this.janitorName,
    this.blockName,
    this.pendingTasks,
    this.status,
  });

  SupervisorModelDashboard.fromJson(dynamic json) {
    taskAllocationId = json['task_allocation_id'];
    date = json['date'];
    janitorId = json['janitor_id'];
    requestType = json['request_type'];
    startTime = json['start_time'];
    endTime = json['end_time'];
    facilityId = json['facility_id'];
    templateId = json['template_id'];
    templateName = json['template_name'];
    description = json['description'];
    facilityName = json['facility_name'];
    estimatedTime = json['estimated_time'];
    totalTasks = json['total_tasks'];
    booths = json['booths'];
    floorNumber = json['floor_number'];
    location = json['location'];
    lat = json['lat'];
    lng = json['lng'];
    janitorName = json['janitor_name'];
    blockName = json['block_name'];
    pendingTasks = json['pending_tasks'];
    status = json['status'];
  }
  int? taskAllocationId;
  String? date;
  int? janitorId;
  String? requestType;
  String? startTime;
  String? endTime;
  int? facilityId;
  int? templateId;
  String? templateName;
  String? description;
  String? facilityName;
  int? estimatedTime;
  int? totalTasks;
  int? booths;
  int? floorNumber;
  String? location;
  double? lat;
  double? lng;
  String? janitorName;
  String? blockName;
  String? pendingTasks;
  String? status;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['task_allocation_id'] = taskAllocationId;
    map['date'] = date;
    map['janitor_id'] = janitorId;
    map['request_type'] = requestType;
    map['start_time'] = startTime;
    map['end_time'] = endTime;
    map['facility_id'] = facilityId;
    map['template_id'] = templateId;
    map['template_name'] = templateName;
    map['description'] = description;
    map['facility_name'] = facilityName;
    map['estimated_time'] = estimatedTime;
    map['total_tasks'] = totalTasks;
    map['booths'] = booths;
    map['floor_number'] = floorNumber;
    map['location'] = location;
    map['lat'] = lat;
    map['lng'] = lng;
    map['janitor_name'] = janitorName;
    map['block_name'] = blockName;
    map['pending_tasks'] = pendingTasks;
    map['status'] = status;
    return map;
  }
}
