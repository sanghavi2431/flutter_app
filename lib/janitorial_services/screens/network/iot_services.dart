import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:woloo_smart_hygiene/core/network/api_constant.dart';
import 'package:woloo_smart_hygiene/core/network/dio_client.dart';
import 'package:woloo_smart_hygiene/janitorial_services/model/host_dashboard_screen.dart';
import 'package:woloo_smart_hygiene/janitorial_services/model/iotdata_model.dart';
import 'package:woloo_smart_hygiene/janitorial_services/model/referral_coins.dart';
import 'package:woloo_smart_hygiene/utils/logger.dart';
import '../../../client_flow/screens/iot/amonia_usage/iot_reviews_response_model.dart';
import '../../../host/edit_host_details.dart';
import '../../../host/host_details.dart';
import '../../../host/get_hosts_all_revies.dart';

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
          "facility_id": facilityId,
          // "location_id": 43,
          "type": type,
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

  Future<IotReviews> getIotReviews({
    required int mapping_id,
    required String type,
  }) async {
    try {
      var response = await dio.get(
        APIConstants.GET_IOT_REVIEWS,

        queryParameters: {
          "facility_id": mapping_id,
          "type": type,
        },
        options: Options(extra: {"auth": true, "isSupervisor": true}),
      );

      return IotReviews.fromJson(response);
    } catch (e) {
      logger.w(e);
      debugPrint("Error in IOT service: $e");
      rethrow;
    }
  }

  /*Future<HostDashboardData> gethostDashboardData(
      {required String wolooId}) async {
    try {
      var response = await dio.get(
         "${APIConstants.BASE_URL}/api/wolooHost/hostDashboardData?woloo_id=$wolooId",
        options: Options(extra: {"auth": true, "isSupervisor": true}),
      );

      return HostDashboardData.fromJson(response);
    } catch (e) {
      debugPrint("Error in IOT service: $e");
      rethrow;
    }
  }
*/
  Future<HostUpdateResponse> updatehostDetailsData({
    required String token,
    required UpdateHostRequest request,
  }) async {
    try {
      final response = await dio.patch(
        "${APIConstants.BASE_URL}/api/wolooHost",
        data: request.toJson(),
        options: Options(
          headers: {
            "x-woloo-token": token,
            "Content-Type": "application/json",
            "Accept": "application/json",
          },),);
      return HostUpdateResponse.fromJson(response);
    } catch (e) {
      debugPrint("Error in IOT service: $e");
      rethrow;
    }
  }

  Future<GetAllReviewsHost> getReviewList({
    required String token,
    required int pageNumber,
    required int wolooId,
  }) async {
    try {
      final response = await dio.post(
        "${APIConstants.BASE_URL}/api/wolooGuest/getReviewList",
        data: {
          "pageNumber": pageNumber,
          "woloo_id": wolooId,
        },
        options: Options(
          headers: {
            "x-woloo-token": token,
            "Content-Type": "application/x-www-form-urlencoded",
            "Accept": "application/json",
          }
        ),
      );
      return GetAllReviewsHost.fromJson(response);
    } catch (e) {
      debugPrint("❌ Error getReviewList: $e");
      rethrow;
    }
  }


  Future<HostDetails> gethostDetailsData(
      {required String wolooId}) async {
    try {
      var response = await dio.get(
        "${APIConstants.BASE_URL}/api/wolooHost/byId?id=$wolooId",
        options: Options(extra: {"auth": true, "isSupervisor": true}),
      );

      return HostDetails.fromJson(response);
    } catch (e) {
      debugPrint("Error in IOT service: $e");
      rethrow;
    }
  }

  Future<ReferralCoins> getReferralCoins({required String woloo_id}) async {
    try {
      var response = await dio.get(
        APIConstants.GET_REFERRAL_COINS,
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
