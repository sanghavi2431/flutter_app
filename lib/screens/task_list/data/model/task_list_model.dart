// template_id : "18"
// tasks : [{"task_id":"16","task_name":"Doors"},{"task_id":"17","task_name":" Toilet Roll"}]

class TaskListModel {
  TaskListModel({
    this.templateId,
    this.tasks,
  });

  TaskListModel.fromJson(dynamic json) {
    templateId = json['template_id']?.toString();
    if (json['tasks'] != null) {
      tasks = [];
      json['tasks'].forEach((v) {
        tasks?.add(Tasks.fromJson(v));
      });
    }
  }
  String? templateId;
  List<Tasks>? tasks;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['template_id'] = templateId;
    if (tasks != null) {
      map['tasks'] = tasks?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

/// task_id : "16"
/// task_name : "Doors"

class Tasks {
  Tasks({this.id, this.taskId, this.taskName, this.status});

  Tasks.fromJson(dynamic json) {
    id = json['id']?.toString();
    taskId = json['task_id']?.toString();
    taskName = json['task_name']?.toString();
    status = json['status']?.toString();
  }
  String? id;
  String? taskId;
  String? taskName;
  String? status;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['task_id'] = taskId;
    map['task_name'] = taskName;
    map['status'] = status;

    return map;
  }
}
