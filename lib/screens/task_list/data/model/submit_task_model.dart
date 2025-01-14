/// allocation_id : 94
/// data : [{"task_id":1,"task_name":"task_1","status":1},{"task_id":2,"task_name":"task_2","status":0},{"task_id":9,"task_name":"task_8","status":1}]

class SubmitTaskModel {
  SubmitTaskModel({
    this.allocationId,
    this.data,
  });

  SubmitTaskModel.fromJson(dynamic json) {
    allocationId = json['allocation_id'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(Data.fromJson(v));
      });
    }
  }
  int? allocationId;
  List<Data>? data;

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

class Data {
  Data({
    this.taskId,
    this.taskName,
    this.status,
  });

  Data.fromJson(dynamic json) {
    taskId = json['task_id'];
    taskName = json['task_name'];
    status = json['status'];
  }
  int? taskId;
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
