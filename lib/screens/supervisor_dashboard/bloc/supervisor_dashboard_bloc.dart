import 'dart:async';

import 'package:woloo_smart_hygiene/core/local/global_storage.dart';
import 'package:woloo_smart_hygiene/screens/supervisor_dashboard/bloc/supervisor_dashboard_event.dart';
import 'package:woloo_smart_hygiene/screens/supervisor_dashboard/bloc/supervisor_dashboard_state.dart';
import 'package:woloo_smart_hygiene/screens/supervisor_dashboard/data/network/supervisor_dashboard_service.dart';
import 'package:woloo_smart_hygiene/screens/supervisor_dashboard/model/supervisor_model_dashboard.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:get_it/get_it.dart';

import '../../../core/network/error_handler.dart';

class SupervisorDashboardBloc
    extends Bloc<SupervisorDashboardEvent, SupervisorDashboardState> {
  final SupervisorDashboardService _supervisorDashboardService =
      SupervisorDashboardService(dio: GetIt.instance());
  final GlobalStorage globalStorage = GetIt.instance<GlobalStorage>();
  List<SupervisorModelDashboard> data = [];
  late int supervisorId;

  SupervisorDashboardBloc() : super(SupervisorDashboardInitial()) {
    on<SupervisorDashboardEvent>((event, emit) {});
    on<GetSupervisorDashboardData>(_mapGetSupervisorDashboardToState);
    on<SupervisorUpdateStatus>(_mapUpdateStatusToState);
    on<AssignTask>(_mapGetReAssignTaskToState);
  }

  FutureOr<void> _mapGetSupervisorDashboardToState(
      GetSupervisorDashboardData event,
      Emitter<SupervisorDashboardState> emit) async {
    try {
      emit(SupervisorDashboardLoading());
      data = await _supervisorDashboardService.getSupervisorDashboardData();

      emit(GetSupervisorDashboardDataSuccess(data: data));
    } catch (e) {
      emit(SupervisorDashboardError(error: ErrorHandler.handle(e).failure ));
    }
  }

  FutureOr<void> _mapUpdateStatusToState(SupervisorUpdateStatus event,
      Emitter<SupervisorDashboardState> emit) async {
    try {
      emit(const SupervisorUpdateStatusLoading(
          message: "Loading Please Wait..."));

      await _supervisorDashboardService.updateStatus(
          id: event.id, status: event.status);
      data = await _supervisorDashboardService.getSupervisorDashboardData();

      emit(GetSupervisorDashboardDataSuccess(data: data));
    } catch (e) {
      emit(SupervisorUpdateStatusError(error: ErrorHandler.handle(e).failure ));
    }
  }

  FutureOr<void> _mapGetReAssignTaskToState(
      AssignTask event, Emitter<SupervisorDashboardState> emit) async {
    try {
      emit(const AssignTaskLoading(message: "Loading Please Wait..."));
      await _supervisorDashboardService.reAssignTaskToJanitor(
          id: event.id, janitorId: event.janitorId);
      data = await _supervisorDashboardService.getSupervisorDashboardData();
      emit(GetSupervisorDashboardDataSuccess(data: data));
    } catch (e) {
      emit(AssignTaskError(error: ErrorHandler.handle(e).failure  ));
    }
  }
}
