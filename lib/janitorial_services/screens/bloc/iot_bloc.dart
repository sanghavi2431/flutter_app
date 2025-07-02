import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:woloo_smart_hygiene/client_flow/screens/dashbaord/data/model/dashboard_task_model.dart';
import 'package:woloo_smart_hygiene/client_flow/screens/dashbaord/data/network/dashboard_service.dart';
import 'package:woloo_smart_hygiene/janitorial_services/model/host_dashboard_screen.dart';
import 'package:woloo_smart_hygiene/janitorial_services/model/referral_coins.dart';
import 'package:woloo_smart_hygiene/utils/logger.dart';

import '../network/iot_services.dart';
import 'iot_event.dart';
import 'iot_state.dart';

class IotBloc extends Bloc<IotEvent, IotState> {
  final IotService iotService = IotService(dio: GetIt.instance());

  final DashboardService dashboardService =
      DashboardService(dio: GetIt.instance());
  var requestId = '';
  late int roleId;
  late int janitorId;

  IotBloc() : super(IotInitial()) {
    on<GetIot>(_mapGetIotToState);
    on<GetHostDashboardData>(_mappedReferralCoins);
    on<GenerateSummary>(_mapGenerateSummaryToState);
  }

  FutureOr<void> _mapGetIotToState(GetIot event, Emitter<IotState> emit) async {
    try {
      emit(const IotLoading(message: "Loading IOT data..."));

      var response = await iotService.getIotDashBoardData(
          facilityId: event.facilityId, type: event.type);
      debugPrint("requestId $response");
      final data = await dashboardService.getTaskDashboard(
          clientId: event.clientId,
          type: event.type,
          facilityId: event.facilityId,
          janitorId: event.janitorId.toString());
      TaskStatusDistribution taskStatusDistribution =
          data.results?.taskStatusDistribution ?? TaskStatusDistribution();
      emit(IotSuccess(
          taskStatusDistribution: taskStatusDistribution,
          dashboardData: response));
    } catch (e) {
      emit(IotError(error: e.toString()));
    }
  }

  // FutureOr<void> _mapgetHostDashboardData(
  //     GetHostDashboardData event, Emitter<IotState> emit) async {
  //   try {
  //     emit(const IotLoading(message: "Loading Host Dashboard data..."));

  //     var response = await iotService.gethostDashboardData(woloo_id: "");
  //     debugPrint("requestId $response");

  //     emit(HostDashboardSuccess(dashboardData: response));
  //   } catch (e) {
  //     emit(IotError(error: e.toString()));
  //   }
  // }

  FutureOr<void> _mappedReferralCoins(
      GetHostDashboardData event, Emitter<IotState> state) async {
    try {
      emit(const IotLoading(message: "Loading Host Dashboard data..."));

      final coins = await iotService.getReferralCoins(woloo_id: "");
      final dashboardData = await iotService.gethostDashboardData(woloo_id: "");
      // debugPrint("requestId $response");

      emit(HostDashboardSuccess(
          hostDashboardHome:
              HostDashboardHome(coins: coins, dashboardData: dashboardData)));
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
}

class HostDashboardHome {
  final ReferralCoins coins;
  final HostDashboardData dashboardData;
  const HostDashboardHome({required this.coins, required this.dashboardData});
}
