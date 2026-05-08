import 'task_status.dart';

/// task_status : [{"status":1,"task_id":"16","task_name":"Doors"},{"status":1,"task_id":"17","task_name":" Toilet Roll"}]
/// task_images : ["Images/Tasks/scaled_f6150d17-0b92-4759-9a44-abad439011aa4996797350491502834.jpg"]

class SubmittedTaskModel {
  SubmittedTaskModel({
    this.taskStatus,
    this.taskImages,
  });

  SubmittedTaskModel.fromJson(dynamic json) {
    if (json['task_status'] != null) {
      taskStatus = [];
      json['task_status'].forEach((v) {
        taskStatus?.add(TaskStatus.fromJson(v));
      });
    }
    taskImages =
        json['task_images'] != null ? json['task_images'].cast<String>() : [];
  }
  List<TaskStatus>? taskStatus;
  List<String>? taskImages;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (taskStatus != null) {
      map['task_status'] = taskStatus?.map((v) => v.toJson()).toList();
    }
    map['task_images'] = taskImages;
    return map;
  }
}
