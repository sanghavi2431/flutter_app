import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:woloo_smart_hygiene/core/local/global_storage.dart';
import 'package:woloo_smart_hygiene/screens/dashboard/bloc/dashboard_event.dart';
import 'package:woloo_smart_hygiene/screens/dashboard/bloc/dashboard_state.dart';
import 'package:woloo_smart_hygiene/screens/dashboard/data/model/dashboard_model_class.dart';
import 'package:woloo_smart_hygiene/screens/dashboard/data/network/dashboard_service.dart';

import '../../../core/network/error_handler.dart';
import '../controller/dash_controller.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final DashboardService dashboardService =
      DashboardService(dio: GetIt.instance());
      DashController dashController = Get.put(DashController());
  final GlobalStorage globalStorage = GetIt.instance<GlobalStorage>();
  List<DashboardModelClass> data = [];
  late int janitorId;
  String? message;

  DashboardBloc() : super(ClockInInitial()) {
    on<DashboardEvent>((event, emit) {});
    on<MarkAttendance>(_mapMarkAttendanceToState );
    on<GetTaskTamplates>(_mapGetDashboardToState ,);
    on<UpdateStatus>(_mapUpdateStatusToState);
    on<CheckAttendance>(_mapAppLaunchToState);
  }

  FutureOr<void> _mapMarkAttendanceToState(
      MarkAttendance event, Emitter<DashboardState> emit) async {
    try {
      emit(const ClockInLoading(message: "Loading Please Wait..."));

      var response = await dashboardService.markAttendance(
          type: event.type, locations: event.locations);

      if (event.type == "check_in") {
        globalStorage.saveCheckIn(isCheckedIn: true);
        emit(ClockInSuccessful(attendanceModel: response));
      }

      if (event.type == "check_out") {
        globalStorage.saveCheckIn(isCheckedIn: false);

        emit(ClockOutSuccessful(attendanceModel: response));
        return;
      }
      message = response.results!.message;
      debugPrint("responseeee  ------>>>>>>  $response");
    } catch (e) {
      if (event.type == "check_in") {
        emit(ClockInError(error: ErrorHandler.handle(e).failure , message: message));
      }
      if (event.type == "check_out") {
        emit(ClockOutError(error: ErrorHandler.handle(e).failure, message: message));
      }
    }
  }

  FutureOr<void> _mapGetDashboardToState(
      GetTaskTamplates event, Emitter<DashboardState> emit) async {
    try {
      emit(DashboardLoading());
      dashController.mapGetDashboardToState();
     // await  dashboardService.getTasksByJanitorId();
      emit(GetDashboardDataSuccess(data: data));
    } catch (e) {
      emit(DashboardError(error: ErrorHandler.handle(e).failure ));
    }
  }

  FutureOr<void> _mapUpdateStatusToState(
      UpdateStatus event, Emitter<DashboardState> emit) async {
    try {
      emit(const UpdateStatusLoading(message: "Loading Please Wait..."));
         
      await dashboardService.updateStatus(id: event.id, status: event.status);
        await dashController.mapGetDashboardToState();
      // data = await dashboardService.getTasksByJanitorId();

      emit(GetDashboardDataSuccess(data: data));
    } catch (e) {
      emit(UpdateStatusError(error: ErrorHandler.handle(e).failure  ));
    }
  }

  FutureOr<void> _mapAppLaunchToState(
      CheckAttendance event, Emitter<DashboardState> emit) async {
    try {
      emit(const AppLaunchLoading(message: "Launching App.."));

      var response = await dashboardService.appLaunch();
      if (response.lastAttendance == "check_in") {
        globalStorage.saveCheckIn(isCheckedIn: true);
      }
      if (response.lastAttendance == "check_out") {
        globalStorage.saveCheckIn(isCheckedIn: false);
      }
      debugPrint("appLaunchResponse  ------  ${response.toJson()}");
      emit(AppLaunchSuccess(data: response));
    } catch (e) {
      emit(AppLaunchError(error: ErrorHandler.handle(e).failure  ));
    }
  }
}


// class FirebaseAuthBloc extends Bloc<DashboardEvent, DashboardState> {
//
//   final DashboardService dashboardService =
//   DashboardService(dio: GetIt.instance());
//   final GlobalStorage globalStorage = GetIt.instance<GlobalStorage>();
//   List<DashboardModelClass> data = [];
//   late int janitorId;
//   var message;
//
//  FirebaseAuthBloc() : super(ClockInInitial());
//
//   @override
//   Stream<DashboardState> mapEventToState(DashboardEvent event) async* {
//     if (event is MarkAttendance) {
//       yield FirebaseAuthFailedState();
//     } else if (event is FirebaseAuthCompleting) {
//       AuthUser? userServerData = await repository.getFirebaseAuthUser(
//         uid: event.uid,
//         email: event.email,
//         phone: event.phone,
//       );
//       yield FirebaseAuthStateCompleted(userServerData);
//     } else if (event is FirebaseAuthNotStarted) {
//       yield FirebaseAuthIsNotStartState();
//     } else if (event is FirebaseAuthStarted) {
//       yield FirebaseAuthStartedState();
//     }
//   }
// }

