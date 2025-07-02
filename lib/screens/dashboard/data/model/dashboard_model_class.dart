//  task_allocation_id : 137
//  date : "07-08-2023"
//  janitor_id : 14
//  request_type : "Regular"
//  start_time : "01:00 PM"
//  end_time : "02:00 PM"
//  facility_id : 62
//  template_id : 18
//  template_name : "Toilet Cleaning"
//  description : "Clean properly"
//  facility_name : "Gents Restroom"
//  estimated_time : 60
//  total_tasks : 2
//  booths : 3
//  floor_number : 0
//  location : "Sarjapur Road, Bengaluru"
//  lat : 12.91527
//  lng : 77.684956
//  block_name : "CMF"
//  pending_tasks : "0"
//  status : "Request for closure"

class DashboardModelClass {
  DashboardModelClass({
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
    this.issueDescription,
    this.facilityName,
    this.estimatedTime,
    this.totalTasks,
    this.booths,
    this.floorNumber,
    this.location,
    this.lat,
    this.lng,
    this.blockName,
    this.pendingTasks,
    this.status,
  });

  DashboardModelClass.fromJson(dynamic json) {
    taskAllocationId = json['task_allocation_id']?.toString();
    date = json['date']?.toString();
    janitorId = json['janitor_id']?.toString();
    requestType = json['request_type']?.toString();
    startTime = json['start_time']?.toString();
    endTime = json['end_time']?.toString();
    facilityId = json['facility_id']?.toString();
    templateId = json['template_id'];
    templateName = json['template_name']?.toString();
    description = json['task_description']?.toString()  ?? "-"  ;
    issueDescription = json['issue_description']?.toString();
    facilityName = json['facility_name']?.toString();
    estimatedTime = json['estimated_time']?.toString();
    totalTasks = json['total_tasks']?.toString();
    booths = json['booths']?.toString();
    floorNumber = json['floor_number']?.toString();
    location = json['location']?.toString();
    lat = json['lat'];
    lng = json['lng'];
    blockName = json['block_name']?.toString();
    pendingTasks = json['pending_tasks']?.toString();
    status = json['status']?.toString();
  }
  String? taskAllocationId;
  String? date;
  String? janitorId;
  String? requestType;
  String? startTime;
  String? endTime;
  String? facilityId;
  int? templateId;
  String? templateName;
  String? description;
  String? issueDescription;
  String? facilityName;
  String? estimatedTime;
  String? totalTasks;
  String? booths;
  String? floorNumber;
  String? location;
  double? lat;
  double? lng;
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
    map['block_name'] = blockName;
    map['pending_tasks'] = pendingTasks;
    map['status'] = status;
    return map;
  }
}
