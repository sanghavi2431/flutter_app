import 'package:Woloo_Smart_hygiene/core/network/api_constant.dart';
import 'package:Woloo_Smart_hygiene/core/network/dio_client.dart';
import 'package:Woloo_Smart_hygiene/screens/janitor_screen/data/model/Reassign_janitor_model.dart';
import 'package:Woloo_Smart_hygiene/screens/supervisor_dashboard/model/Supervisor_model_dashboard.dart';
import 'package:dio/dio.dart';

class SupervisorDashboardService {
  final DioClient dio;
  const SupervisorDashboardService({required this.dio});

  Future<List<SupervisorModelDashboard>> getSupervisorDashboardData({ String? token }) async {
    try {
      var response = await dio.get(APIConstants.GET_SUPERVISOR_DASHBOARD_DATA,
          options: 
           token != null ? Options(
            headers: {
              "x-woloo-token":  token
            } )
             :
          Options(
            extra: {"auth": true},
          ));

      List<SupervisorModelDashboard> output = [];
      for (var item in response['results']) {
        output.add(SupervisorModelDashboard.fromJson(item));
      }

      return output;
    } catch (e) {
      rethrow;
    }
  }

  Future<String> updateStatus({required String id, required int status, String? token}) async {
    try {
      var response = await dio.post(
        APIConstants.UPDATE_STATUS,
        data: {
          "id": id,
          "status": status,
        },
        options: 
          token != null ? Options(
            headers: {
              "x-woloo-token":  token
            } )
             :
        Options(extra: {"auth": true}),
      );

      return response['results']?.toString() ?? '';
    } catch (e) {
      rethrow;
    }
  }

  Future<ReassignJanitorModel> reAssignTaskToJanitor({
    required List<String> id,
    required String janitor_id,
  }) async {
    print("Data" + id.toString());
    try {
      var response = await dio.put(
        APIConstants.RE_ASSIGN_TASK,
        data: {
          "id": id,
          "janitor_id": janitor_id,
        },
        options: Options(extra: {"auth": true}),
      );

      return ReassignJanitorModel.fromJson(response['results']);
    } catch (e) {
      rethrow;
    }
  }
}
