/*
import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:woloo_smart_hygiene/client_flow/screens/dashbaord/data/model/dashboard_task_model.dart';
import 'package:woloo_smart_hygiene/client_flow/screens/dashbaord/data/network/dashboard_service.dart';
import 'package:woloo_smart_hygiene/core/local/global_storage.dart';
import 'package:woloo_smart_hygiene/janitorial_services/model/get_task_dashboard_data.dart' hide TaskStatusDistribution;
import 'package:woloo_smart_hygiene/janitorial_services/model/host_dashboard_screen.dart';
import 'package:woloo_smart_hygiene/janitorial_services/model/referral_coins.dart';
import 'package:woloo_smart_hygiene/utils/logger.dart';
import '../helper/hash_helper.dart';
import '../network/iot_services.dart';
import 'iot_event.dart';
import 'iot_state.dart';

class IotBloc extends Bloc<IotEvent, IotState> {
  final IotService iotService = IotService(dio: GetIt.instance());

  final DashboardService dashboardService = DashboardService(dio: GetIt.instance());
  var requestId = '';
  late int roleId;
  late int janitorId;
  GlobalStorage globalStorage = GetIt.instance();
  Timer? _timer;
  bool _isFetching = false;
  String? _lastHash;

  IotBloc() : super(IotInitial()) {
    on<GetIot>(_mapGetIotToState);
    // on<GetHostDashboardData>(_mappedReferralCoins);
    on<GetHostDetailsData>(_mappedHostDetailsDatas);
    on<GenerateSummary>(_mapGenerateSummaryToState);
    on<UpdateHostDetailsEvent>(_updateHost);
    on<GetReviewListEvent>(_mapGetReviewList);
  }

  */
/*FutureOr<void> _mapGetIotToState(GetIot event, Emitter<IotState> emit) async {
    try {
      emit(const IotLoading(message: "Loading IOT data..."));

      var response = await iotService.getIotDashBoardData(
          facilityId: event.facilityId, type: event.type);
      debugPrint("requestId $response");
      final data = await dashboardService.getTaskDashboard(
          clientId: event.clientId,
          type: event.type,
          facilityId: event.facilityId,
          janitorId: "all");
      TaskStatusDistribution taskStatusDistribution =
          data.results?.taskStatusDistribution ?? TaskStatusDistribution();
      emit(IotSuccess(
          taskStatusDistribution: taskStatusDistribution,
          dashboardData: response));
    } catch (e) {
      emit(IotError(error: e.toString()));
    }
  }*//*



  /// Included auto refresh

  FutureOr<void> _mapGetIotToState(
      GetIot event,
      Emitter<IotState> emit,) async {

    /// Prevent overlapping API calls
    if (_isFetching) return;
    _isFetching = true;

    try {

      emit(const IotLoading(message: "Loading IOT data..."));


      final response = await iotService.getIotDashBoardData(
        facilityId: event.facilityId,
        type: event.type,
      );

      final data = await dashboardService.getTaskDashboard(
        clientId: event.clientId,
        type: event.type,
        facilityId: event.facilityId,
        janitorId: "all",
      );

      final reviews = await iotService.getIotReviews(mapping_id: event.facilityId, type: event.type);

      TaskStatusDistribution taskStatusDistribution = data.results?.taskStatusDistribution ?? TaskStatusDistribution();
      final List<TaskMonitoring>? taskMonitoring = data.results?.taskMonitoring;
      ///  Create hash from BOTH responses
      final newHash = generateHash({
        "iot": response,
        "task": taskStatusDistribution,
      });

      ///  Emit ONLY if data changed
      if (_lastHash != newHash) {

        _lastHash = newHash;
        emit(IotSuccess(
          taskStatusDistribution: taskStatusDistribution,
          dashboardData: response,
          taskMonitoring: taskMonitoring,
          taskDashboardData: data,
          iotReviews: reviews,
        ));
      }

    } catch (e) {
      /// Only show error if first load fails
      emit(IotError(error: e.toString()));
    }

    _isFetching = false;
  }




  Future<void> _updateHost(
      UpdateHostDetailsEvent event,
      Emitter<IotState> emit,
      ) async {
    emit(const IotLoading(message: "Updating host details..."));

    try {
      final token = globalStorage.getClientToken();

      final response = await iotService.updatehostDetailsData(
        token: token,
        request: event.request,
      );

      if (response.success == true) {
        emit(const IotUpdateSuccess(message: "Host updated successfully"));
      } else {
        emit(const IotError(error: "Update failed"));
      }
    } catch (e) {
      emit(IotError(error: e.toString()));
    }
  }


  Future<void> _mapGetReviewList(
      GetReviewListEvent event, Emitter<IotState> emit) async {

    try {
      final  token = globalStorage.getClientToken();
      debugPrint("UPDATE HOST TOKEN review ---> $token");


      String wolooid = globalStorage.getWolooId();
      final response = await iotService.getReviewList(
        token: token,
        pageNumber: event.pageNumber,
        wolooId: int.parse(wolooid),
      );

      emit(GetReviewListSuccess(response));

    } catch (e) {
      emit(GetReviewListError(e.toString()));
    }
  }


  FutureOr<void> _mappedHostDetailsDatas(
      GetHostDetailsData event, Emitter<IotState> state) async {
    try {
      emit(const IotLoading(message: "Loading Host Dashboard data..."));

      String wolooid = globalStorage.getWolooId();

      final hostDetailsData =
      await iotService.gethostDetailsData(wolooId: wolooid);
      // debugPrint("requestId $response");

      emit(HostDetailsSuccess(hostDetailsHome: hostDetailsData));
    } catch (e) {
      emit(IotError(error: e.toString()));
    }
  }

  FutureOr<void> _mapGenerateSummaryToState(
      GenerateSummary event, Emitter<IotState> emit) async {
    try {
      emit(const IotLoading(message: "Generating summary..."));

      final response = await iotService.generateSummary(
        data: event.data,
        type: event.type,
      );

      emit(GenerateSummarySuccess(summaryData: response));
    } catch (e) {
      logger.e(e);
      emit(IotError(error: e.toString()));
    }
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }

}

class HostDashboardHome {
  final ReferralCoins coins;
  final HostDashboardData dashboardData;
  const HostDashboardHome({required this.coins, required this.dashboardData});
}
*/


import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:woloo_smart_hygiene/client_flow/screens/dashbaord/model/facility_model.dart';
import 'package:woloo_smart_hygiene/core/local/global_storage.dart';
import 'package:woloo_smart_hygiene/utils/logger.dart';
import '../../../client_flow/screens/dashbaord/data/model/dashboard_task_model.dart';
import '../../../client_flow/screens/dashbaord/data/network/dashboard_service.dart';
import '../../../client_flow/screens/iot/amonia_usage/iot_reviews_response_model.dart';
import '../../../client_flow/screens/iot/client_dasboard_repository.dart';
import '../../../client_flow/screens/iot/iot_repository.dart';
import '../../../client_flow/screens/iot/request_models/generate_summary_request.dart';
import '../../../client_flow/screens/iot/request_models/host_details_request.dart';
import '../../../client_flow/screens/iot/request_models/iot_dashboard_request.dart';
import '../../../client_flow/screens/iot/request_models/review_list_request.dart';
import '../../../client_flow/screens/iot/request_models/task_dashboard_request.dart';
import '../../../client_flow/screens/iot/request_models/update_host_request_wrapper.dart';
import '../../../host/host_details.dart';
import '../../../injection_container.dart';



import '../../model/get_task_dashboard_data.dart' hide TaskStatusDistribution;
import '../../model/iotdata_model.dart';
import '../../model/referral_coins.dart';
import '../helper/hash_helper.dart';
import 'iot_event.dart';
import 'iot_state.dart';


class IotBloc extends Bloc<IotEvent, IotState> {
  IotRepository repository = sl<IotRepository>();
  GlobalStorage globalStorage = GetIt.instance<GlobalStorage>();
  final ClientDashboardRepository clientDashboardRepository = sl<ClientDashboardRepository>();

  bool _isFetching = false;
  String? _lastHash;

  IotBloc() : super(IotInitial()) {
    on<GetIot>(_mapGetIotToState);
    on<GetHostDetailsData>(_mappedHostDetailsDatas);
    on<GenerateSummary>(_mapGenerateSummaryToState);
    on<UpdateHostDetailsEvent>(_updateHost);
    on<GetReviewListEvent>(_mapGetReviewList);
  }

  // -------- GET IOT DASHBOARD --------
  /*FutureOr<void> _mapGetIotToState(
      GetIot event, Emitter<IotState> emit) async {
    try {
      emit(const IotLoading(message: "Loading IOT data..."));

      final dashboard = await repository.getIotDashboard(
        IotDashboardRequest(
          facilityId: event.facilityId,
          type: event.type,
        ),
        GetDashboardTaskRequest(
          clientId: event.clientId,
          type: event.type,
          facilityId: event.facilityId,
          janitorId: "all",
        ), event.facilityId,
      );

      emit(IotSuccess(
        taskStatusDistribution: dashboard.taskStatusDistribution,
        dashboardData: dashboard.dashboardData,
      ));
    } catch (e) {
      emit(IotError(error: e.toString()));
    }
  }*/

  FutureOr<void> _mapGetIotToState(
      GetIot event,
      Emitter<IotState> emit,
      ) async {

    /// Prevent overlapping API calls
    if (_isFetching) return;
    _isFetching = true;

    try {

      emit(const IotLoading(message: "Loading IOT data..."));

      final dashboard = await repository.getIotDashboard(
        IotDashboardRequest(
          facilityId: event.facilityId,
          type: event.type,
        ),
        GetDashboardTaskRequest(
          clientId: event.clientId,
          type: event.type,
          facilityId: event.facilityId,
          janitorId: "all",
        ),
        event.facilityId,
      );

      /// Extract responses
      final DashboardData dashboardData = dashboard.dashboardData;
      final DashbaordModel? taskDashboardData = dashboard.taskDashboardData;
      final IotReviews? reviews = dashboard.iotReviews;

      final TaskStatusDistribution taskStatusDistribution =
          dashboard.taskStatusDistribution ?? TaskStatusDistribution();

      final List<TaskMonitoring>? taskMonitoring =
          taskDashboardData?.results?.taskMonitoring;

      /// Create hash to avoid unnecessary UI rebuild
      final newHash = generateHash({
        "iot": dashboardData,
        "task": taskStatusDistribution,
      });

      if (_lastHash != newHash) {
        _lastHash = newHash;

        emit(IotSuccess(
          dashboardData: dashboardData,
          taskDashboardData: taskDashboardData,
          taskStatusDistribution: taskStatusDistribution,
          taskMonitoring: taskMonitoring,
          iotReviews: reviews,
        ));
      }

    } catch (e) {

      emit(IotError(error: e.toString()));

    }

    _isFetching = false;
  }

  // -------- UPDATE HOST DETAILS --------
  Future<void> _updateHost(
      UpdateHostDetailsEvent event,
      Emitter<IotState> emit) async {
    emit(const IotLoading(message: "Updating host details..."));

    try {
      final token = await globalStorage.getToken();

      final response = await repository.updateHostDetails(
        UpdateHostRequestWrapper(
          request: event.request,
          token: token,
        ),
      );

      if (response.success == true) {
        emit(const IotUpdateSuccess(message: "Host updated successfully"));
      } else {
        emit(const IotError(error: "Update failed"));
      }
    } catch (e) {
      emit(IotError(error: e.toString()));
    }
  }

  // -------- GET REVIEW LIST --------
  Future<void> _mapGetReviewList(
      GetReviewListEvent event,
      Emitter<IotState> emit,
      ) async {

    try {

      final token = globalStorage.getClientToken();
      final wolooId = globalStorage.getWolooId();

      final response = await repository.getReviewList(
        ReviewListRequest(
          pageNumber: event.pageNumber,
          wolooId: int.parse(wolooId),
          token: token,
        ),
      );

      emit(GetReviewListSuccess(response));

    } catch (e) {

      emit(GetReviewListError(e.toString()));

    }
  }

  // -------- GET HOST DETAILS --------
  FutureOr<void> _mappedHostDetailsDatas(
      GetHostDetailsData event,
      Emitter<IotState> emit) async {
    try {
      emit(const IotLoading(message: "Loading Host Dashboard data..."));

      final wolooId = await globalStorage.getWolooId();

      final hostDetailsData = await repository.getHostDetails(
        HostDetailsRequest(wolooId: wolooId.toString()),
      );

      emit(HostDetailsSuccess(hostDetailsHome: hostDetailsData));
    } catch (e) {
      emit(IotError(error: e.toString()));
    }
  }

  // -------- GENERATE SUMMARY --------
  FutureOr<void> _mapGenerateSummaryToState(
      GenerateSummary event,
      Emitter<IotState> emit) async {
    try {
      emit(const IotLoading(message: "Generating summary..."));

      final response = await repository.generateSummary(
        GenerateSummaryRequest(
          data: event.data,
          type: event.type,
        ),
      );

      emit(GenerateSummarySuccess(summaryData: response));
    } catch (e) {
      logger.e(e);
      emit(IotError(error: e.toString()));
    }
  }
}

class HostDashboardHome {
  final ReferralCoins coins;
  final HostDashboardData dashboardData;
  const HostDashboardHome({
    required this.coins,
    required this.dashboardData,
  });
}

