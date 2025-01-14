

import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../../core/network/error_handler.dart';
import '../network/assign_services.dart';
import 'assign_event.dart';
import 'assign_state.dart';

class AssignBloc extends Bloc<AssignEvent, AssignState> {
  final AssignService assignService =
      AssignService(dio: GetIt.instance());
    //  DashController dashController = Get.put(DashController());
  // final GlobalStorage globalStorage = GetIt.instance<GlobalStorage>();
  // List<DashboardModelClass> data = [];
  late int janitorId;
  var message;

  AssignBloc() : super( JanitorTaskInitial()) {
    // on<DashboardEvent>((event, emit) {});
    // on<MarkAttendance>(_mapMarkAttendanceToState );
    on<GetJanitorTask>(_mapGetDashboardToState,);
    on<GetJanitorList>(_mapGetJanitorListState );
    on<AssignTask>(_mapAssignTaskToJanitorState);
  }



  FutureOr<void> _mapGetDashboardToState(
      GetJanitorTask event, Emitter<AssignState> emit) async {
    try {
      emit(JanitorTaskLoading());
     // dashController.mapGetDashboardToState();
         var data =    await  assignService.getTasksByJanitorId(event.id!);
      emit(GetJanitorTaskDataSuccess(data: data));
    } catch (e) {
      emit(GetJanitorTaskError(error: ErrorHandler.handle(e).failure ));
    }
  }


    FutureOr<void> _mapGetJanitorListState(
      GetJanitorList event, Emitter<AssignState> emit) async {
    try {
       print(event.facilityId);
      emit(JanitorListLoading());
     // dashController.mapGetDashboardToState();
         var data =    await  assignService.getanitorListByFacilityId(event.facilityId);


      emit(GetJanitorListDataSuccess(data: data));
    } catch (e) {
      emit(GetJanitorListError(error: ErrorHandler.handle(e).failure ));
    }
  }


  FutureOr<void> _mapAssignTaskToJanitorState(
      AssignTask event, Emitter<AssignState> emit) async {
    try {
      print(event.facilityId);
      emit(AssignTaskLoading());
      // dashController.mapGetDashboardToState();
      var data =    await  assignService.reAssignPendingTaskToJanitor(
        id: event.facilityId,
        endTime: event.endTime,
        startTime: event.startTime,
        isAssign: event.isAssing,
        janitor_id: event.janitorId,
        isRejected:  event.status == "Rejected" ?  true :false,
        // status: event.status

      ) ;


      emit(AssignTaskDataSuccess(data: data));
    } catch (e) {
      emit(AssignTaskError(error: ErrorHandler.handle(e).failure ));
    }
  }


}