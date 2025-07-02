import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:woloo_smart_hygiene/core/network/api_constant.dart';
import 'package:woloo_smart_hygiene/core/network/dio_client.dart';
import 'package:woloo_smart_hygiene/janitorial_services/model/host_dashboard_screen.dart';
import 'package:woloo_smart_hygiene/janitorial_services/model/iotdata_model.dart';
import 'package:woloo_smart_hygiene/janitorial_services/model/referral_coins.dart';
import 'package:woloo_smart_hygiene/utils/logger.dart';

class IotService {
  final DioClient dio;
  const IotService({required this.dio});

  Future<DashboardData> getIotDashBoardData({
    required int facilityId,
    required String type,
  }) async {
    try {
      var response = await dio.post(
        APIConstants.GET_IOT_DASHBOARD_DATA,

        data: {
          // "device_id": "24110012",
          // "facility_id": 0004,
          "location_id": 43,
          "type": "last_7_days",
        },
        // data: {"device_id": "AQI-0004", "type": "last_7_days"},
        options: Options(extra: {"auth": true, "isSupervisor": true}),
      );

      return DashboardData.fromJson(response);
    } catch (e) {
      logger.w(e);
      debugPrint("Error in IOT service: $e");
      rethrow;
    }
  }

  Future<HostDashboardData> gethostDashboardData(
      {required String woloo_id}) async {
    try {
      var response = await dio.get(
        // APIConstants.GET_IOT_DASHBOARD_DATA,
        "https://staging-api.woloo.in/api/wolooHost/hostDashboardData?woloo_id=19108",
        options: Options(extra: {"auth": true, "isSupervisor": true}),
      );

      return HostDashboardData.fromJson(response);
    } catch (e) {
      debugPrint("Error in IOT service: $e");
      rethrow;
    }
  }

  Future<ReferralCoins> getReferralCoins({required String woloo_id}) async {
    try {
      var response = await dio.get(
        // APIConstants.GET_IOT_DASHBOARD_DATA,
        "https://staging-api.woloo.in/api/wolooHost/user_coins",
        options: Options(extra: {"auth": true, "isSupervisor": true}),
      );

      return ReferralCoins.fromJson(response);
    } catch (e) {
      debugPrint("Error in referral Coins : $e");
      rethrow;
    }
  }

  Future<GeneratedAiSummery> generateSummary({
    required dynamic data,
    required String type,
  }) async {
    try {
      var response = await dio.post(
        APIConstants.GENERATE_SUMMARY,
        data: {
          "data": data,
          "type": type,
        },
        options: Options(
          extra: {"auth": true, "isSupervisor": true},
          headers: {
            'accept': 'application/json',
          },
        ),
      );
      logger.w(response);
      return GeneratedAiSummery.fromJson(response);
    } catch (e) {
      logger.w(e);
      debugPrint("Error in generate summary service: $e");
      rethrow;
    }
  }
}

GeneratedAiSummery generatedAiSummeryFromJson(String str) =>
    GeneratedAiSummery.fromJson(json.decode(str));

String generatedAiSummeryToJson(GeneratedAiSummery data) =>
    json.encode(data.toJson());

class GeneratedAiSummery {
  final dynamic results;
  final bool? success;

  GeneratedAiSummery({
    this.results,
    this.success,
  });

  factory GeneratedAiSummery.fromJson(Map<String, dynamic> json) =>
      GeneratedAiSummery(
        results: json["results"] == null ? [] : json["results"],
        success: json["success"],
      );

  Map<String, dynamic> toJson() => {
        "results": results,
        "success": success,
      };
}
