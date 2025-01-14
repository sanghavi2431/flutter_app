


import 'dart:developer';

import 'package:Woloo_Smart_hygiene/screens/assign_screen/data/janitorListModel.dart';
import 'package:dio/dio.dart';

import '../../../core/network/api_constant.dart';
import '../../../core/network/dio_client.dart';
import '../../dashboard/data/model/dashboard_model_class.dart';
import '../../janitor_screen/data/model/Reassign_janitor_model.dart';
// import '../../janitor_screen/data/model/Janitor_list_model.dart';

class AssignService {
  final DioClient dio;
  const AssignService({required this.dio});

  Future<List<DashboardModelClass>> getTasksByJanitorId(int id ,{String? token} ) async {
    try {
        List<DashboardModelClass> output = [];
      var response = await dio.get(
        "${APIConstants.GET_ALL_TASK_TAMPLATES}?janitor_id=$id",
        options:
           token != null ?
            Options(
              headers: {
                "x-woloo-token":  token
              },
            )
            :
        
         Options(extra: {"auth": true}),
      );

    

       print(" janitor task $response");

      for (var item in response['results']) {
        output.add(DashboardModelClass.fromJson(item));
      }
     // JanitorListModel.fromJson(response['results']);

       log("output $output");

      return output;
    } catch (e) {
      rethrow;
    }
  }



 Future<List<JanitorListModel>>  getanitorListByFacilityId( int facilityId,{ String? token} ) async {
    try {
        List<JanitorListModel> output = [];
      var response = await dio.post(
        APIConstants.JANITOR_LIST_FACILITY,
         data: {
         "facility_id": facilityId,
          "role_id": 1
         },
        options:
        token != null ?
            Options(
              headers: {
                "x-woloo-token":  token
              },
            )
            :
         Options(extra: {"auth": true}),
      );
         print("res$response");
    

    // List<JanitorListModel> output = [];
    //   for (var item in response['results']) {
                // print("item$item");
        output.add(JanitorListModel.fromJson(response['results']) );
      // }

       log("output $output");

      return output;
    } catch (e) {
      rethrow;
    }
  }


 

  Future<ReassignJanitorModel> reAssignPendingTaskToJanitor({
    required List<String> id,
    required int janitor_id,
    required bool isRejected,
    required String startTime,
    required String endTime,
    required bool isAssign,
             String? token,
    // required String status
  }) async {
  //  print("Data" + id.toString());
    //   print(" reassign janitor id ${janitor_id}");
          //       print(" reassign ${id }");
    try {
      FormData formData = FormData();

      /// Add image
    
      // status == "Rejected"
      //
      //
          isRejected ?


       formData = FormData.fromMap({
        "id": id.toString(),
        "janitor_id": janitor_id,
        "Reassign":isRejected,
        "start_time":startTime,
        "end_time":endTime,
      })
      :
        formData = FormData.fromMap({
        "id": id.toString(),
        "janitor_id": janitor_id,
        "start_time":startTime,
        "end_time":endTime,
        "Assign":isAssign
      });

      var response = await dio.put(
        APIConstants.RE_ASSIGN_TASK,
        data: formData,
        options:
         token != null ?
            Options(
              headers: {
                "x-woloo-token":  token
              },
            )
            :
         Options(extra: {"auth": true}),
      );
       print(response);
      return ReassignJanitorModel.fromJson(response['results']);
    } catch (e) {
      rethrow;
    }
  }




}
