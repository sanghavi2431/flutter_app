import 'package:Woloo_Smart_hygiene/screens/attendance_history_screen/data/model/Attendance_history_model.dart';
import 'package:Woloo_Smart_hygiene/screens/attendance_history_screen/data/model/Month_list_model.dart';
import 'package:dio/dio.dart';
import 'package:Woloo_Smart_hygiene/core/network/api_constant.dart';
import 'package:Woloo_Smart_hygiene/core/network/dio_client.dart';

class JanitorAttendanceService {
  final DioClient dio;
  const JanitorAttendanceService({required this.dio});

  Future<List<AttendanceHistoryModel>> getAllHistory({required String month, required String year, required int janiId, String? token }) async {
    try {
      var response = await dio.post(
        APIConstants.ATTENDANCE_HISTORY_LIST_SUP,
        data: {
          "janitor_id": janiId,
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

  Future<List<MonthListModel>> getAllMonths(int janiId ,{ String? token }) async {
    try {
      var response = await dio.get(
        APIConstants.MONTH_LIST_SUP,
        queryParameters: {
          "janitor_id": janiId,
        },
        options:
         token != null ? Options(
            headers: {
              "x-woloo-token":  token
            },
          ) :
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
