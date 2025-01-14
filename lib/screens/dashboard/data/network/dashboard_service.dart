import 'dart:async';
import 'dart:developer';

import 'package:Woloo_Smart_hygiene/core/model/App_launch_model.dart';
import 'package:dio/dio.dart';
import 'package:Woloo_Smart_hygiene/core/network/api_constant.dart';
import 'package:Woloo_Smart_hygiene/core/network/dio_client.dart';
import 'package:Woloo_Smart_hygiene/screens/dashboard/data/model/Attendance_model.dart';
import 'package:Woloo_Smart_hygiene/screens/dashboard/data/model/dashboard_model_class.dart';

class DashboardService {
  final DioClient dio;
  const DashboardService({required this.dio});

  FutureOr<AttendanceModel> markAttendance({required String type, required List<double> locations, String? token}) async {
    try {

       print("toke $token");
      var response = await dio.post(
        APIConstants.ATTENDANCE,
        data: {
          "type": type,
          "location": locations,
        },
        options:
          token != null ?
        Options(
            headers: {
              "x-woloo-token":  token
            },
          )
        :
       Options(
         sendTimeout: Duration(minutes: 1 ),
       // connectTimeout: 60*1000, // 60 seconds
          receiveTimeout: Duration(minutes: 1 ),
          
         
        extra: {"auth": true}),
      );

      return AttendanceModel.fromJson(response);
    } 
     on  Exception catch (exception) {

      // rethrow;
        throw Exception('Failed to Mark attendace');
      // print(" expetionn $exception");
  // ... // only executed if error is of type Exception
}
    catch (e) {
        throw Exception('Failed to Mark attendace');
    }
  }

  Future<List<DashboardModelClass>> getTasksByJanitorId({  String? token }) async {
    try {
        List<DashboardModelClass> output = [];
      var response = await dio.get(
        APIConstants.GET_ALL_TASK_TAMPLATES,
        options: 
        token != null  ?
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

       log("output $output");

      return output;
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
         token != null  ?
        
          Options(
            headers: {
              "x-woloo-token":  token
            },
          ) :
         Options(extra: {"auth": true}),
      );
       print("update task $response");
      return response['results']?.toString() ?? '';
    } catch (e) {
      rethrow;
    }
  }

  Future<AppLaunchModel> appLaunch({String? token}) async {
    try {
      var response = await dio.post(
        APIConstants.APP_LAUNCH,
        options:
        token != null  ?
         Options(
            headers: {
              "x-woloo-token":  token
            },
          )
        :
        Options(extra: {"auth": true}),
      );
      return AppLaunchModel.fromJson(response['results']);
    } catch (e) {
      throw  Exception('Failed to Mark attendace');
    }
  }
}
