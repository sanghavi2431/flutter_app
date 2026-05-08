import 'package:get_it/get_it.dart';
import 'package:woloo_smart_hygiene/client_flow/screens/dashbaord/data/model/dashboard_task_model.dart';
import 'package:woloo_smart_hygiene/client_flow/screens/dashbaord/data/network/dashboard_service.dart';
import 'package:woloo_smart_hygiene/client_flow/screens/iot/request_models/generate_summary_request.dart';
import 'package:woloo_smart_hygiene/client_flow/screens/iot/request_models/host_details_request.dart';
import 'package:woloo_smart_hygiene/client_flow/screens/iot/request_models/iot_dashboard_request.dart';
import 'package:woloo_smart_hygiene/client_flow/screens/iot/request_models/review_list_request.dart';
import 'package:woloo_smart_hygiene/client_flow/screens/iot/request_models/task_dashboard_request.dart';
import 'package:woloo_smart_hygiene/client_flow/screens/iot/request_models/update_host_request_wrapper.dart';

import 'package:woloo_smart_hygiene/core/local/global_storage.dart';
import '../../../host/host_details.dart';
import '../../../host/get_hosts_all_revies.dart';
import '../../../host/edit_host_details.dart';

import 'package:flutter/cupertino.dart';
import 'package:woloo_smart_hygiene/core/network/api_constant.dart';
import 'package:woloo_smart_hygiene/core/network/dio_client.dart';

import '../../../host/edit_host_details.dart';
import '../../../host/host_details.dart';
import '../../../host/get_hosts_all_revies.dart';
import '../../../janitorial_services/model/get_task_dashboard_data.dart' hide TaskStatusDistribution;
import '../../../janitorial_services/model/iotdata_model.dart';
import '../../../janitorial_services/model/referral_coins.dart';
import '../../../janitorial_services/screens/network/iot_services.dart';
import '../../../utils/header_helpers.dart';
import 'amonia_usage/iot_reviews_response_model.dart';



class IotRepository {
  final DioClient dioClient;
 // final ClientDashboardService dashboardService;
  final GlobalStorage globalStorage;

  IotRepository({required this.dioClient,
   // required this.dashboardService,
    required this.globalStorage});

  // -------- IOT DASHBOARD --------

  Future<IotDashboardResult> getIotDashboard(
      IotDashboardRequest request,
      GetDashboardTaskRequest taskDashboardRequest,
      int facilityId,
      ) async {

    final iotResponse = await dioClient.post(
      APIConstants.GET_IOT_DASHBOARD_DATA,
      data: request.toJson(),
      options: HeaderOptions.supervisorAuth(),
    );

    final iotDashboard = DashboardData.fromJson(iotResponse);

    final taskResponse = await dioClient.post(
      APIConstants.GET_TASK_DASHBOARD,
      data: taskDashboardRequest.toJson(),
      options: HeaderOptions.authWithFacilityId(facilityId: facilityId),
    );

    final taskDashboard = DashbaordModel.fromJson(taskResponse);

    final reviewResponse = await dioClient.get(
      APIConstants.GET_IOT_REVIEWS,
      queryParameters: {
        "facility_id": facilityId,
        "type": request.type,
      },
      options: HeaderOptions.supervisorAuth(),
    );

    final reviews = IotReviews.fromJson(reviewResponse);

    return IotDashboardResult(
      dashboardData: iotDashboard,
      taskDashboardData: taskDashboard,
      taskStatusDistribution:
      taskDashboard.results?.taskStatusDistribution ?? TaskStatusDistribution(),
      taskMonitoring: taskDashboard.results?.taskMonitoring,
      iotReviews: reviews,
    );
  }

  // -------- UPDATE HOST DETAILS --------
  Future<HostUpdateResponse> updateHostDetails(
      UpdateHostRequestWrapper wrapper) async {
    try {
      final response = await dioClient.patch("${APIConstants.BASE_URL}/api/wolooHost",
        data: wrapper.request.toJson(),
        options: HeaderOptions.supervisorAuthWithToken(wrapper.token),
      );

      return HostUpdateResponse.fromJson(response);
    } catch (e) {
      debugPrint("Error in updateHostDetails: $e");
      rethrow;
    }
  }

  // -------- GET REVIEW LIST --------
  Future<GetAllReviewsHost> getReviewList(ReviewListRequest request) async {
    try {

      final response = await dioClient.get(
        "${APIConstants.BASE_URL}/api/wolooGuest/getReviewList",
        queryParameters: request.toJson(),
        options: HeaderOptions.clientAuthWithToken(request.token),
      );

      return GetAllReviewsHost.fromJson(response);

    } catch (e) {
      rethrow;
    }
  }
  // -------- GET HOST DETAILS --------
  Future<HostDetails> getHostDetails(HostDetailsRequest request) async {
    try {
      final response = await dioClient.get(
        "${APIConstants.BASE_URL}/api/wolooHost/byId?id=${request.wolooId}",
        options: HeaderOptions.supervisorAuth(),
      );

      return HostDetails.fromJson(response);
    } catch (e) {
      debugPrint("Error in getHostDetails: $e");
      rethrow;
    }
  }

  // -------- GET REFERRAL COINS --------
  Future<ReferralCoins> getReferralCoins() async {
    try {
      final response = await dioClient.get(
        APIConstants.GET_REFERRAL_COINS,
        options: HeaderOptions.supervisorAuth(),
      );

      return ReferralCoins.fromJson(response);
    } catch (e) {
      debugPrint("Error in getReferralCoins: $e");
      rethrow;
    }
  }

  // -------- GENERATE SUMMARY --------
  Future<GeneratedAiSummery> generateSummary(
      GenerateSummaryRequest request) async {
    try {
      final response = await dioClient.post(
        APIConstants.GENERATE_SUMMARY,
        data: request.toJson(),
        options: HeaderOptions.supervisorAuth(),
      );

      return GeneratedAiSummery.fromJson(response);
    } catch (e) {
      debugPrint("Error in generateSummary: $e");
      rethrow;
    }
  }
}



class IotDashboardResult {
  final DashboardData dashboardData;
  final DashbaordModel taskDashboardData;
  final TaskStatusDistribution taskStatusDistribution;
  final List<TaskMonitoring>? taskMonitoring;
  final IotReviews? iotReviews;

  IotDashboardResult({
    required this.dashboardData,
    required this.taskDashboardData,
    required this.taskStatusDistribution,
    this.taskMonitoring,
    this.iotReviews,
  });
}