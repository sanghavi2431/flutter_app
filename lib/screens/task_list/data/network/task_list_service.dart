import 'package:Woloo_Smart_hygiene/core/network/api_constant.dart';
import 'package:Woloo_Smart_hygiene/core/network/dio_client.dart';
import 'package:Woloo_Smart_hygiene/screens/task_list/data/model/create_task_model.dart';
import 'package:Woloo_Smart_hygiene/screens/task_list/data/model/task_list_model.dart';
import 'package:dio/dio.dart';

class TaskListService {
  final DioClient dio;
  const TaskListService({required this.dio});

  Future<TaskListModel> getAllTasks({required int id, String? token}) async {
    try {
      var response = await dio.get(
        APIConstants.GET_ALL_TASKS,
        options: 
        token != null ? 
        Options(
            headers: {
              "x-woloo-token":  token
            },
          ) :
        Options(extra: {"auth": true}),
        queryParameters: {
          "id": id,
        },
      );
      print(response['results']?.toString() == '[]');
      if (response['results']?.toString() == '[]') {
        return TaskListModel(templateId: id.toString(), tasks: []);
      }
      return TaskListModel.fromJson(response['results']);
    } catch (e) {
      rethrow;
    }
  }

  Future<String> submitTask({required CreateTaskModel createTaskModel,  String? token}) async {
    try {
      var response = await dio.post(
        APIConstants.SUBMIT_TASKS,
        options:
         token != null ?

        Options(
            headers: {
              "x-woloo-token":  token
            },
          ) :
         Options(extra: {"auth": true}),
        data: createTaskModel.toJson(),
      );
      return response['results']?.toString() ?? '';
    } catch (e) {
      rethrow;
    }
  }

  Future<String> updateStatus({required String id, required String status, String? token}) async {
    try {
      var response = await dio.post(
        APIConstants.UPDATE_STATUS,
        data: {
          "id": id,
          "status": status,
        },
        options: 
        token != null ?
        Options(
            headers: {
              "x-woloo-token":  token
            },
          ) :
        
        Options(extra: {"auth": true}),
      );

      return response['results']?.toString() ?? '';
    } catch (e) {
      rethrow;
    }
  }
}
