/// id : 12
/// name : "Snehal"
/// mobile : "9284102357"
/// cluster_id : 20
/// cluster_name : "Accenture"
/// pincode : 454565
/// start_time : "7th Aug, 11:00 AM"
/// end_time : "7th Aug, 12:00 PM"
/// janitor_id : 12
/// total_task_count : "1"
/// pending_task_count : "0"
/// isPresent : true

class JanitorListModel {
  JanitorListModel({
    this.id,
    this.name,
    this.mobile,
    this.clusterId,
    this.clusterName,
    this.pincode,
    this.startTime,
    this.endTime,
    this.totalTaskCount,
    this.pendingTaskCount,
    this.isPresent,
    this.shift,
    this.completedTaskCount,
    this.acceptedTaskCount,
    this.onGoingTaskCount,
    this.rejectsTaskCount,
    this.rfcTaskCount,
    this.baseUrl,
    this.profileImage
  });

  JanitorListModel.fromJson(dynamic json) {
    id = json['id']?.toString();
    name = json['name']?.toString();
    mobile = json['mobile']?.toString();
    clusterId = json['cluster_id']?.toString();
    clusterName = json['cluster_name']?.toString();
    pincode = json['pincode']?.toString();
    startTime = json['start_time']?.toString();
    endTime = json['end_time']?.toString();
    totalTaskCount = json['total']?.toString();
    pendingTaskCount = json['pending']?.toString();
    acceptedTaskCount = json['accepted']?.toString();
    rejectsTaskCount = json['rejects']?.toString();
    rfcTaskCount = json['requestForClosure']?.toString();
    onGoingTaskCount = json['ongoing']?.toString();
    isPresent = json['isPresent'];
    shift = json['shift']?.toString();
    completedTaskCount = json['completed']?.toString();
    baseUrl = json['base_url'];
    profileImage = json['profile_image'] ?? "";
    gender = json['gender'];

  }
  String? id;
  String? name;
  String? mobile;
  String? clusterId;
  String? clusterName;
  String? pincode;
  String? startTime;
  String? endTime;
  String? totalTaskCount;
  String? pendingTaskCount;
  String? onGoingTaskCount;
  String? acceptedTaskCount;
  String? rfcTaskCount;
  String? rejectsTaskCount;
  bool? isPresent;
  String? shift;
  String? completedTaskCount;
  String? profileImage;
  String? baseUrl;
  String? gender;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['mobile'] = mobile;
    map['cluster_id'] = clusterId;
    map['cluster_name'] = clusterName;
    map['pincode'] = pincode;
    map['start_time'] = startTime;
    map['end_time'] = endTime;
    map['total'] = totalTaskCount;
    map['pending'] = pendingTaskCount;
    map['isPresent'] = isPresent;
    map['shift'] = shift;
    map['completed'] = completedTaskCount;
    map['base_url'] = baseUrl;
    map['profile_image'] = profileImage;
    map['gender'] = gender;
    map['requestForClosure'] = rfcTaskCount;
    map['rejects'] = rejectsTaskCount;
    map['accepted'] = acceptedTaskCount;
    map['ongoing'] = onGoingTaskCount;


    return map;
  }
}
