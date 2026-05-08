
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:woloo_smart_hygiene/client_flow/screens/dashbaord/data/model/check_task_model.dart';
import 'package:woloo_smart_hygiene/client_flow/screens/dashbaord/data/model/client_model.dart';
import 'package:woloo_smart_hygiene/client_flow/screens/dashbaord/data/model/facility_model.dart';
import 'package:woloo_smart_hygiene/client_flow/screens/dashbaord/data/model/supervisor_model.dart';
import 'package:woloo_smart_hygiene/client_flow/screens/dashbaord/data/model/tasklist_model.dart';
import 'package:woloo_smart_hygiene/client_flow/screens/dashbaord/model/facility_type_model.dart';
import 'package:woloo_smart_hygiene/client_flow/screens/iot/request_models/add_supervisor_request.dart';
import 'package:woloo_smart_hygiene/client_flow/screens/iot/request_models/assign_task_request.dart';
import 'package:woloo_smart_hygiene/client_flow/screens/iot/request_models/check_supervisor_request.dart';
import 'package:woloo_smart_hygiene/client_flow/screens/iot/request_models/check_task_time_request.dart';
import 'package:woloo_smart_hygiene/client_flow/screens/iot/request_models/client_setup_request.dart';
import 'package:woloo_smart_hygiene/client_flow/screens/iot/request_models/delete_facility_request.dart';
import 'package:woloo_smart_hygiene/client_flow/screens/iot/request_models/delete_task_request.dart';
import 'package:woloo_smart_hygiene/client_flow/screens/iot/request_models/extend_expiry_request.dart';
import 'package:woloo_smart_hygiene/client_flow/screens/iot/request_models/facility_by_janitor.dart';
import 'package:woloo_smart_hygiene/client_flow/screens/iot/request_models/facility_type_request.dart';
import 'package:woloo_smart_hygiene/client_flow/screens/iot/request_models/get_all_janitors_request.dart';
import 'package:woloo_smart_hygiene/client_flow/screens/iot/request_models/get_client_request.dart';
import 'package:woloo_smart_hygiene/client_flow/screens/iot/request_models/get_facility_request.dart';
import 'package:woloo_smart_hygiene/client_flow/screens/iot/request_models/get_task_request.dart';
import 'package:woloo_smart_hygiene/client_flow/screens/iot/request_models/payment_success_request.dart';
import 'package:woloo_smart_hygiene/client_flow/screens/iot/request_models/task_dashboard_request.dart';
import '../../../../../core/network/api_constant.dart';
import '../../../../../core/network/dio_client.dart';
import '../../../../utils/header_helpers.dart';
import '../dashbaord/data/model/task_model.dart';
import '../dashbaord/data/model/check_supervisor.dart';
import '../dashbaord/data/model/client_setup_model.dart';
import '../dashbaord/data/model/dashboard_task_model.dart';
import '../dashbaord/data/model/delete_facility.dart';
import '../dashbaord/data/model/delete_model.dart';
import '../dashbaord/data/model/extend_expiry.dart';
import '../dashbaord/data/model/janitor_model.dart';
import '../dashbaord/data/model/language_model.dart';
import '../dashbaord/data/model/payment_status.dart';
import '../dashbaord/data/model/subscription_model.dart';



class ClientDashboardRepository {
 // final ClientDashboardService service;

  final DioClient dioClient;

  ClientDashboardRepository({
    //required this.service,
    required this.dioClient});

  Future<ClientSetupModel> clientSetup(ClientSetupRequest request) async {
    debugPrint("DioClient in Client setup");
    try {

      final response = await dioClient.post(
        APIConstants.CLIENT_SETUP,
        data: request.toJson(),
        options: HeaderOptions.supervisorAuth(),
      );

      return ClientSetupModel.fromJson(response);
    } catch (e) {
      debugPrint("Error in client setup: $e");
      rethrow;
    }
  }


  Future<SuperVisorModel> addUser(AddSupervisorRequest request) async {
    debugPrint("DioClient in Add user");
    try {

      final response = await dioClient.post(
        APIConstants.ADD_USER,
        data: request.toFormData(),
        options: HeaderOptions.supervisorAuth(),
      );

      return SuperVisorModel.fromJson(response);
    } catch (e) {
      debugPrint("Error adding supervisor: $e");
      rethrow;
    }
  }

  Future<List<TaskDropdownModel>> getTask(GetTaskRequest request,
      ) async {
    try {
      final response = await dioClient.post(
        APIConstants.GET_TASK,
        data: request.toJson(),
        options: HeaderOptions.supervisorAuth(),
      );

      final List list = response['results'] ?? [];
      return list.map((item) => TaskDropdownModel.fromJson(item)).toList();

    } catch (e) {
      throw Exception("Failed to fetch tasks: $e");
    }
  }


  Future<DashbaordModel> getTaskDashboard(
      GetDashboardTaskRequest request) async {
    try {

      final response = await dioClient.post(
        APIConstants.GET_TASK_DASHBOARD,
        data: request.toJson(),
        options: HeaderOptions.authWithFacilityId(facilityId: request.facilityId),
      );

      return DashbaordModel.fromJson(response);
    } catch (e) {
      debugPrint("Error fetching dashboard task: $e");
      rethrow;
    }
  }


  Future<TaskModel> getAllJanitor(GetAllJanitorRequest request) async {
    try {

      final response = await dioClient.post(
        APIConstants.GET_ALL_USER,
        data: request.toJson(),
        options: HeaderOptions.supervisorAuth(),
      );

      return TaskModel.fromJson(response);
    } catch (e) {
      if (TaskModel.looksLikeGetAllUserNoDataEmpty(e)) {
        return TaskModel.emptyJanitorList();
      }
      debugPrint("Error fetching all janitors: $e");
      rethrow;
    }
  }


  // Future<SubscriptionModel> getSubscriptionExpiry({
  //   required int id,
  // }) {
  //   return service.getSubscriptionExpiry(id: id);
  // }

  /// ---------- SUBSCRIPTION EXPIRY ----------
  Future<SubscriptionModel> getSubscriptionExpiry({
    required int id,
  }) async {
    final response = await dioClient.get(
      "${APIConstants.SubscriptionExpiry}?id=$id",
      options: HeaderOptions.supervisorAuth(),
    );

    return SubscriptionModel.fromJson(response);
  }



  Future<bool> assignTask(AssignTaskRequest request) async {
    try {

      final response = await dioClient.post(
        APIConstants.ASSIGN_TASK,
        data: request.toJson(),
        options: HeaderOptions.supervisorAuth(),
      );

      return response["results"] as bool;
    } catch (e) {
      debugPrint("Error assigning task: $e");
      rethrow;
    }
  }


  Future<ClientModel> getClient(GetClientRequest request) async {
    try {
      final response = await dioClient.get(
        request.endpoint,
        options: HeaderOptions.supervisorAuth(),
      );

      return ClientModel.fromJson(response);
    } catch (e) {
      debugPrint("Error fetching client: $e");
      rethrow;
    }
  }


  Future<CheckSupervisorModel> checkSuperVisor(
      CheckSupervisorRequest request) async {
    try {
      final response = await dioClient.get(
        request.endpoint,
        options: HeaderOptions.supervisorAuth(),
      );

      return CheckSupervisorModel.fromJson(response);
    } catch (e) {
      debugPrint("Error checking supervisor: $e");
      rethrow;
    }
  }


  Future<FacilityModel> getFacility(GetAllFacilityRequest request) async {
    try {

      final response = await dioClient.post(
        APIConstants.GET_ALL_FACILITY,
        data: request.toJson(),
        options: HeaderOptions.supervisorAuth(),
      );

      return FacilityModel.fromJson(response);
    } catch (e) {
      /// Check error handling by emit state
      debugPrint("Error fetching facilities: $e");
      rethrow;
    }
  }


  Future<CheckTaskModel> checkTaskTime(
      CheckTaskTimeRequest request) async {
    try {

      final response = await dioClient.post(
        APIConstants.CHECK_TASK_TIME,
        data: request.toJson(),
        options: HeaderOptions.supervisorAuth(),
      );

      return CheckTaskModel.fromJson(response);
    } catch (e) {
      debugPrint("Error checking task time: $e");
      rethrow;
    }
  }

  Future<DeleteModel> deleteTask(DeleteTaskRequest request) async {
    try {
      final response = await dioClient.delete(
        request.endpoint,
        options: HeaderOptions.supervisorAuth(),
      );

      return DeleteModel.fromJson(response);
    } catch (e) {
      debugPrint("Error deleting task: $e");
      rethrow;
    }
  }


  Future<DeleteFacilityModel> deleteFacility(
      DeleteFacilityRequest request) async {
    try {
      final response = await dioClient.delete(
        APIConstants.DELETE_FACILITY,
        data: request.toJson(),
        options: HeaderOptions.supervisorAuth(),
      );

      return DeleteFacilityModel.fromJson(response);
    } catch (e) {
      debugPrint("Error deleting facility: $e");
      rethrow;
    }
  }


  Future<ExtendExpiryModel> extendExpiry(
      ExtendExpiryRequest request) async {
    try {
      final response = await dioClient.post(
        APIConstants.EXTEND_EXPIRY,
        data: request.toJson(),
        options: HeaderOptions.supervisorAuth(),
      );

      return ExtendExpiryModel.fromJson(response);
    } catch (e) {
      debugPrint("Error extending expiry: $e");
      rethrow;
    }
  }


  Future<PaymentStatusModel> paymentStatus(
      PaymentStatusRequest request) async {
    try {
      final response = await dioClient.get(
        request.endpoint,
        options: HeaderOptions.supervisorAuth(),
      );

      return PaymentStatusModel.fromJson(response);
    } catch (e) {
      debugPrint("Error checking payment status: $e");
      rethrow;
    }
  }


  Future<JanitorModel> facilityByJanitor(
      FacilityByJanitorRequest request) async {
    try {
      final response = await dioClient.get(
        request.endpoint,
        options: HeaderOptions.supervisorAuth(),
      );

      return JanitorModel.fromJson(response);
    } catch (e) {
      debugPrint("Error fetching facility by janitor: $e");
      rethrow;
    }
  }


  Future<FacilityTypeModel> facilityType(
      FacilityTypeRequest request) async {
    try {
      final response = await dioClient.get(
        request.endpoint,
        options: HeaderOptions.supervisorAuth(),
      );

      return FacilityTypeModel.fromJson(response);
    } catch (e) {
      debugPrint("Error fetching facility types: $e");
      rethrow;
    }
  }

  Future<LanguageModel> getLanguages() async {
    try {
      final response = await dioClient.get(
        APIConstants.GET_LANGUAGES,
        options: HeaderOptions.supervisorAuth(),
      );

      return LanguageModel.fromJson(response);
    } catch (e) {
      debugPrint("Error fetching languages: $e");
      rethrow;
    }
  }

}