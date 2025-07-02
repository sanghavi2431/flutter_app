import 'dart:async';

import 'package:woloo_smart_hygiene/screens/supervisor_dashboard/data/network/supervisor_dashboard_service.dart';
import 'package:woloo_smart_hygiene/screens/supervisor_dashboard/model/supervisor_model_dashboard.dart';
import 'package:woloo_smart_hygiene/screens/task_details_screen/bloc/submitted_task_event.dart';
import 'package:woloo_smart_hygiene/screens/task_details_screen/bloc/submitted_task_state.dart';
import 'package:woloo_smart_hygiene/screens/task_details_screen/data/network/submitted_task_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:get_it/get_it.dart';

import '../../../core/network/error_handler.dart';

class SubmittedTaskBloc extends Bloc<SubmittedTaskEvent, SubmittedTaskState> {
  final SubmittedTaskService submittedTaskService =
      SubmittedTaskService(dio: GetIt.instance());
  final SupervisorDashboardService _supervisorDashboardService =
      SupervisorDashboardService(dio: GetIt.instance());
  List<SupervisorModelDashboard> data = [];

  SubmittedTaskBloc() : super(GetSubmittedTasksInitial()) {
    on<SubmittedTaskEvent>((event, emit) {});
    on<GetAllSubmittedTasks>(_mapGetSubmittedTasksToState);
    on<UpdateStatus>(_mapUpdateStatusToState);
  }

  FutureOr<void> _mapGetSubmittedTasksToState(
      GetAllSubmittedTasks event, Emitter<SubmittedTaskState> emit) async {
    try {
      emit(GetSubmittedTasksLoading());
      var data = await submittedTaskService.getAllSubmittedTasks(
          allocationId: event.allocationId);

      emit(GetSubmittedTasksSuccess(data: data));
    } catch (e) {
      emit(GetSubmittedTasksError(error: ErrorHandler.handle(e).failure ));
    }
  }

  FutureOr<void> _mapUpdateStatusToState(
      UpdateStatus event, Emitter<SubmittedTaskState> emit) async {
    try {
      emit(const UpdateStatusLoading(message: "Loading Please Wait..."));

     var res = await _supervisorDashboardService.updateStatus(
          id: event.id, status: event.status);
         data = await _supervisorDashboardService.getSupervisorDashboardData();
         
        res["current_Task_status"];

      //    print("responseeee  ------>>>>>>  ${res["current_Task_status"]} ");
     
      emit(UpdateStatusSuccessful( data: res));
    } catch (e) {
      emit(UpdateStatusError(error: ErrorHandler.handle(e).failure  ));
    }
  }
}
