/// allocation_id : 94
/// data : [{"task_id":1,"task_name":"task_1","status":1}]

class CreateTaskModel {
  CreateTaskModel({
    this.allocationId,
    this.data,
  });

  CreateTaskModel.fromJson(dynamic json) {
    allocationId = json['allocation_id']?.toString();
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(InternalData.fromJson(v));
      });
    }
  }
  String? allocationId;
  List<InternalData>? data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['allocation_id'] = allocationId;
    if (data != null) {
      map['data'] = data?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

/// task_id : 1
/// task_name : "task_1"
/// status : 1

class InternalData {
  InternalData({
    this.taskId,
    this.taskName,
    this.status,
  });

  InternalData.fromJson(dynamic json) {
    taskId = json['task_id'];
    taskName = json['task_name'];
    status = json['status'];
  }
  String? taskId;
  String? taskName;
  int? status;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['task_id'] = taskId;
    map['task_name'] = taskName;
    map['status'] = status;
    return map;
  }
}
