// status : 1
// task_id : "16"
// task_name : "Doors"

class TaskStatus {
  TaskStatus({
    this.status,
    this.taskId,
    this.taskName,
  });

  TaskStatus.fromJson(dynamic json) {
    status = json['status']?.toString();
    taskId = json['task_id']?.toString();
    taskName = json['task_name']?.toString();
  }
  String? status;
  String? taskId;
  String? taskName;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['task_id'] = taskId;
    map['task_name'] = taskName;
    return map;
  }
}
