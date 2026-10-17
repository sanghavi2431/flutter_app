import '../../../../../../core/network/api_constant.dart';

class DeleteTaskRequest {
  final int taskId;

  DeleteTaskRequest({required this.taskId});

  String get endpoint => "${APIConstants.DELETE_TASK}?task_id=$taskId";
}
