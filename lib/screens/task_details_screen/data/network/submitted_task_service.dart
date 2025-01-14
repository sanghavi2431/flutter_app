import 'package:Woloo_Smart_hygiene/core/network/api_constant.dart';
import 'package:Woloo_Smart_hygiene/core/network/dio_client.dart';
import 'package:Woloo_Smart_hygiene/screens/task_details_screen/data/model/Submitted_tasks_model.dart';
import 'package:dio/dio.dart';

class SubmittedTaskService {
  final DioClient dio;

  const SubmittedTaskService({required this.dio});

  Future<SubmittedTaskModel> getAllSubmittedTasks({required String allocationId}) async {
    try {
      var response = await dio.get(
        APIConstants.GET_ALL_SUBMITTED_TASK,
        options: Options(extra: {"auth": true}),
        queryParameters: {
          "allocation_id": allocationId,
        },
      );

      return SubmittedTaskModel.fromJson(response['results']);
    } catch (e) {
      rethrow;
    }
  }

  Future<String> updateStatus({required int id, required int status}) async {
    try {
      var response = await dio.post(
        APIConstants.UPDATE_STATUS,
        data: {
          "id": id,
          "status": status,
        },
        options: Options(extra: {"auth": true}),
      );

      return response['results']?.toString() ?? '';
    } catch (e) {
      rethrow;
    }
  }
}
