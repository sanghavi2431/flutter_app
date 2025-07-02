import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:woloo_smart_hygiene/screens/report_issue_screen/bloc/report_issue_event.dart';
import 'package:woloo_smart_hygiene/screens/report_issue_screen/bloc/report_issue_state.dart';
import 'package:woloo_smart_hygiene/screens/report_issue_screen/data/network/report_issue_service.dart';

import '../../../core/network/error_handler.dart';

class ReportIssueBloc extends Bloc<ReportIssueEvent, ReportIssueState> {
  final ReportIssueService reportIssueService =
      ReportIssueService(dio: GetIt.instance());

  ReportIssueBloc() : super(ReportIssueInitial()) {
    on<ReportIssueEvent>((event, emit) {});
    on<GetAllClustersDropdown>(_mapGetAllClusterDropdownToState);
    on<GetAllFacilityDropdown>(_mapGetAllFacilityDropdownToState);
    on<GetAllTasksDropdown>(_mapGetAllTaskDropdownToState);
    on<GetAllJanitorsDropdown>(_mapGetAllJanitorsDropdownToState);
    on<GetAllTaskList>(_mapGetAllTasksToState);
    on<ReportIssue>(_mapGetReportIssueToState);
  }

  FutureOr<void> _mapGetAllClusterDropdownToState(
      GetAllClustersDropdown event, Emitter<ReportIssueState> emit) async {
    try {
      emit(GetClustersDropdownLoading());
      var data = await reportIssueService.getClusterDropdownData(

      );

      emit(GetClustersDropdownSuccess(data: data));
    } catch (e) {
      emit(GetClustersDropdownError(error:ErrorHandler.handle(e).failure));
    }
  }

  FutureOr<void> _mapGetAllFacilityDropdownToState(
      GetAllFacilityDropdown event, Emitter<ReportIssueState> emit) async {
    try {
      emit(GetFacilityDropdownLoading());
      var data = await reportIssueService.getFacilitiesDropdownData(
          clusterId: event.clusterId);

      emit(GetFacilityDropdownSuccess(data: data));
    } catch (e) {
      emit(GetFacilityDropdownError(error: ErrorHandler.handle(e).failure ));
    }
  }

  FutureOr<void> _mapGetAllTaskDropdownToState(
      GetAllTasksDropdown event, Emitter<ReportIssueState> emit) async {
    try {
      emit(GetTasksDropdownLoading());
      var data = await reportIssueService.getTasksDropdownData(
        event.clusterId
      );

      emit(GetTasksDropdownSuccess(data: data));
    } catch (e) {
      emit(GetTasksDropdownError(error: ErrorHandler.handle(e).failure));
    }
  }

  FutureOr<void> _mapGetAllJanitorsDropdownToState(
      GetAllJanitorsDropdown event, Emitter<ReportIssueState> emit) async {
    try {
      emit(GetJanitorsDropdownLoading());
      var data = await reportIssueService.getJanitorsDropdownData(
          clusterId: event.clusterId);

      emit(GetJanitorsDropdownSuccess(data: data));
    } catch (e) {
      emit(GetJanitorsDropdownError(error: ErrorHandler.handle(e).failure ));
    }
  }

  FutureOr<void> _mapGetAllTasksToState(
      GetAllTaskList event, Emitter<ReportIssueState> emit) async {
    try {
      emit(GetTasksListLoading());
      var data = await reportIssueService.getAllTasksList(id: event.id);

      emit(GetTasksListSuccess(data: data));
    } catch (e) {
      rethrow;
    }
  }

  FutureOr<void> _mapGetReportIssueToState(
      ReportIssue event, Emitter<ReportIssueState> emit) async {
    try {
      emit(ReportIssueLoading());
      var data = await reportIssueService.reportIssue(
          templateId: event.templateId,
          facilityId: event.facilityId,
          description: event.description,
          taskImages: event.taskImages,
          janitorId: event.janitorId,
          taskList : event.taskList);

      emit(ReportIssueSuccess(data: data));
    } catch (e) {
      emit(ReportIssueError(error:ErrorHandler.handle(e).failure  ));
    }
  }

// FutureOr<void> _mapSubmitTasksToState(SubmitTasks event, Emitter<TaskListState> emit) async {
  //   try {
  //     emit(SubmitTasksLoading());
  //     var data = await taskListService.submitTask(createTaskModel: event.createTaskModel);
  //     await taskListService.updateStatus(id: event.createTaskModel.allocationId!, status: 3);
  //
  //     emit(SubmitTasksSuccess(data: data));
  //   } catch (e) {
  //     emit(SubmitTasksError(error: e.toString()));
  //   }
  // }
}
