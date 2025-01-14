import 'package:dio/dio.dart';
import 'package:Woloo_Smart_hygiene/core/network/api_constant.dart';
import 'package:Woloo_Smart_hygiene/core/network/dio_client.dart';
import 'package:Woloo_Smart_hygiene/screens/janitor_screen/data/model/Janitor_list_model.dart';
import 'package:Woloo_Smart_hygiene/screens/janitor_screen/data/model/Reassign_janitor_model.dart';

class JanitorListService {
  final DioClient dio;
  const JanitorListService({required this.dio});

  Future<List<JanitorListModel>> getAllJanitors(
      {required String? clusterId, String? startDate, String? endDate , String? token }) async {
    try {
      var response = await dio.get(
        APIConstants.JANITOR_LIST,
        options:
           token != null ? Options(
            headers: {
              "x-woloo-token":  token
            },
          ) :
       Options(extra: {"auth": true}),
        queryParameters:
         startDate == null ?
           {
          "cluster_id": clusterId,
         
        }
        :
         {
          "cluster_id": clusterId,
          "start_date":startDate,
          "end_date":endDate
        },
      );
      List<JanitorListModel> output = [];
      for (var item in response['results']) {
        output.add(JanitorListModel.fromJson(item));
      }
       print(output);  
      return output;
    } catch (e) {
      rethrow;
    }
  }

  Future<ReassignJanitorModel> reAssignTaskToJanitor({
    required List<String> id,
    required String janitor_id,
    required bool isRejected,
     String? token
  }) async {
    print("Data" + id.toString());
       print(" reassign janitor id ${janitor_id}");
                 print(" reassign ${id }");
    try {
      FormData formData = FormData();

      /// Add image
      formData = FormData.fromMap({
        "id": id.toString(),
        "janitor_id": janitor_id,
        "Reassign":isRejected
      }
      );

      var response = await dio.put(
        APIConstants.RE_ASSIGN_TASK,
        data: formData,
        options: 
         token != null ? Options(
            headers: {
              "x-woloo-token":  token
            },
          ) :
        Options(extra: {"auth": true}),
      );

      return ReassignJanitorModel.fromJson(response['results']);
    } catch (e) {
      rethrow;
    }
  }
}
