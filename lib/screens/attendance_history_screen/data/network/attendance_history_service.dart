import 'package:woloo_smart_hygiene/screens/attendance_history_screen/data/model/attendance_history_model.dart';
import 'package:woloo_smart_hygiene/screens/attendance_history_screen/data/model/month_list_model.dart';
import 'package:dio/dio.dart';
import 'package:woloo_smart_hygiene/core/network/api_constant.dart';
import 'package:woloo_smart_hygiene/core/network/dio_client.dart';

class AttendanceHistoryService {
  final DioClient dio;
  const AttendanceHistoryService({required this.dio});

  Future<List<AttendanceHistoryModel>> getAllHistory(
      {required String month, required String year, String? token}) async {
    try {
      var response = await dio.post(
        APIConstants.ATTENDANCE_HISTORY_LIST,
        data: {
          "month": month,
          "year": year,
        },
        options:
            token != null
                ? Options(
                    headers: {
                      "x-woloo-token": token
                    },
                  )
                :    
        Options(extra: {"auth": true}),
      );
      List<AttendanceHistoryModel> output = [];
      for (var item in response['results']) {
        output.add(AttendanceHistoryModel.fromJson(item));
      }
      return output;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<MonthListModel>> getAllMonths({String? token }) async {
    try {
      var response = await dio.get(
        APIConstants.MONTH_LIST,
        options:
                 token != null
                ? Options(
                    headers: {
                      "x-woloo-token": token
                    },
                  )
                :    
         Options(extra: {"auth": true}),
      );
      List<MonthListModel> output = [];
      for (var item in response['results']) {
        output.add(MonthListModel.fromJson(item));
      }
      return output;
    } catch (e) {
      rethrow;
    }
  }
}
