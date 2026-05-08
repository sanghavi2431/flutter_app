import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:woloo_smart_hygiene/core/local/global_storage.dart';
import 'package:woloo_smart_hygiene/screens/dashboard/bloc/dashboard_state.dart'
    hide DashboardState;

import '../../../../core/network/error_handler.dart';

import '../../../../janitorial_services/screens/bloc/iot_event.dart'
    hide GetHostDetailsData;
import '../data/network/dashboard_service.dart';
import 'dashboard_event.dart';
import 'dashboard_state.dart';

class ClientDashBoardBloc extends Bloc<DashboardEvent, DashboardState> {
  final DashboardService dashboardService =
      DashboardService(dio: GetIt.instance());
  var requestId = '';
  late int roleId;
  late int janitorId;
  bool _isSubscriptionLoading = false;
  GlobalStorage globalStorage = GetIt.instance();
  //  List<UpdateTokenModel>? profileList;

  ClientDashBoardBloc() : super(DashboarInitial()) {
    // on<LoginEvent>((event, emit) {});
    on<ClientSetUpEvent>(_mapClientSetupToState);
    on<AddUserEvent>(_mapAddSupervisorState);
    on<GetTaskEvent>(_mapGetTaskState);
    on<GetDashbaordEvent>(_mapDashboardTaskState);
    on<SubcriptionEvent>(_mapSubcriptionState);
    on<AssignTaskEvent>(_mapAssignTaskState);
    on<ClientEvent>(_mapGetClientState);
    on<AddJanitorEvent>(_mapAddJanitorState);
    on<GetAllJanitorEvent>(_mapAllJanitorState);
    on<GetAllFacilityEvent>(_mapAllFacilityState);
    on<CheckTaskEvent>(_mapCheckTaskTimeState);
    on<CheckSupvisorEvent>(_mapCheckSupervisorState);
    on<GetSupvisorListEvent>(_mapSupervisorListState);
    on<DeleteEvent>(_mapDeleteState);
    on<FacilityDeleteEvent>(_mapDeleteFacilityState);
    on<ExpiryEvent>(_mapExtendExpiryState);
    on<PaymentStatusEvent>(_mapPaymentStatusState);
    on<FacilityByJanitorEvent>(_mapFacilityByJanitorState);
    on<FacilityTypeEvent>(_mapFacilityType);
    on<GetLanguagesEvent>(_mapGetLanguagesState);
    on<GetHostDetailsData>(_mappedHostDetailsDatas);
    on<SubmitClientFullSetupEvent>(_onSubmitClientSetup);

    // on<UpdateTokenOnVerifyOTP>(mapUpdateTokenToState);
  }

  FutureOr<void> _mapClientSetupToState(
      ClientSetUpEvent event, Emitter<DashboardState> emit) async {
    try {
      emit(const DashboarLoading(message: "Loading..."));

      print("print locality ${event.locality} ");

      var response = await dashboardService.clientSetup(
          orgName: event.orgName,
          locality: event.locality,
          unitNo: event.locality,
          clientId: event.clientId!,
          pincode: event.pincode,
          address: event.address!,
          city: event.city,
          faciltyType: event.facilityType,
          mobile: event.mobile,
          clusterId: event.clusterId);
      debugPrint("requestId $response");
      // requestId = response;

      // debugPrint("requestId $requestId");
      emit(ClientSetUp(clientSetupModel: response));
    } catch (e) {
      emit(DashboarError(error: e.toString()));
    }
  }

  FutureOr<void> _mapAddSupervisorState(
      AddUserEvent event, Emitter<DashboardState> emit) async {
    try {
      emit(const DashboarLoading(message: "Loading..."));

      // var response =
      await dashboardService.addUser(
          name: event.name,
          mobile: event.mobile,
          roleId: event.roleId,
          clientId: event.clientId!,
          gender: event.gender,
          clusterId: event.clusterId,
          isSelfAssign: event.isSelfAssign);

      // debugPrint("requestId $response");
      // requestId = response;

      // debugPrint("requestId $requestId");
      emit(AddUser());
    } catch (e) {
      emit(DashboarError(error: e.toString()));
    }
  }

  FutureOr<void> _mapAddJanitorState(
      AddJanitorEvent event, Emitter<DashboardState> emit) async {
    try {
      emit(const DashboarLoading(message: "Loading..."));

      var response = await dashboardService.addUser(
        name: event.name,
        mobile: event.mobile,
        roleId: event.roleId,
        clientId: event.clientId!,
        gender: event.gender,
        clusterId: event.clusterId,
        languageCodes: event.languageCodes,
      );

      // debugPrint("requestId $response");
      // requestId = response;

      // debugPrint("requestId $requestId");
      emit(Addjanitor(superVisorModel: response));
    } catch (e) {
      emit(DashboarError(error: e.toString()));
    }
  }

  FutureOr<void> _mapGetTaskState(
      GetTaskEvent event, Emitter<DashboardState> emit) async {
    try {
      emit(const DashboarLoading(message: "Loading..."));

      GlobalStorage globalStorage = GetIt.instance();

      var response = await dashboardService.getTask(
          category: event.category!, clientId: globalStorage.getClientId());
      debugPrint("requestId $response");
      response;

      for (var element in response) {
        // print("dsgfs ${element.requiredTime}");
      }

      emit(GetTask(tasklist: response));
    } catch (e) {
      emit(DashboarError(error: e.toString()));
    }
  }

  FutureOr<void> _mapDashboardTaskState(
      GetDashbaordEvent event, Emitter<DashboardState> emit) async {
    try {
      emit(const DashboarLoading(message: "Loading..."));

      var response = await dashboardService.getTaskDashboard(
          clientId: event.clientId,
          type: event.type,
          facilityId: event.locationId,
          janitorId: event.janitorId);

      debugPrint("requestId $response");
      //  = response;

      emit(DashbaordTask(
        dashbaordModel: response,
      ));
    } catch (e) {
      emit(DashboarError(error: e.toString()));
    }
  }

  FutureOr<void> _mapSubcriptionState(
      SubcriptionEvent event, Emitter<DashboardState> emit) async {
    try {
      if (_isSubscriptionLoading) {
        return;
      }

      _isSubscriptionLoading = true;

      emit(const DashboarLoading(message: "Loading..."));

      var response = await dashboardService.getSubscriptionExpiry(id: event.id);

      GlobalStorage globalStorage = GetIt.instance();

      print("in plamn inr ${response.results!.planId}");

      globalStorage.savePlanId(
          accessPlanId: response.results!.planId == null
              ? "0"
              : response.results!.planId!.toString());

      debugPrint("requestId $response");
      //  = response;

      emit(Subcription(
        subscriptionModel: response,
      ));
    } catch (e) {
      emit(DashboarError(error: e.toString()));
    } finally {
      _isSubscriptionLoading = false;
    }
  }

  FutureOr<void> _mapAssignTaskState(
      AssignTaskEvent event, Emitter<DashboardState> emit) async {
    try {
      emit(const DashboarLoading(message: "Loading..."));

      // New API structure: days, task_ids, and estimated_time are now inside each task_times item
      var response = await dashboardService.assignTask(
          clientId: event.clientId,
          shiftTime: event.shiftTime,
          taskTimes: event.taskTimes,
          janitorId: event.janitorId,
          facilityRef: event.facilityRef,
          facilityId: event.facilityId);

      // debugPrint("requestId $response");
      // requestId = response;

      // debugPrint("requestId $requestId");
      emit(AssignTask());
    } catch (e) {
      emit(DashboarError(error: e.toString()));
    }
  }

  FutureOr<void> _mapAllJanitorState(
      GetAllJanitorEvent event, Emitter<DashboardState> emit) async {
    try {
      emit(const DashboarLoading(message: "Loading..."));

      var response = await dashboardService.getAllJanitor(
        clientId: event.clientId,
        // janitorId: event.janitorId
      );

      print("in bloac inr $response");

      emit(GetAllJanitor(taskModel: response));
    } catch (e) {
      emit(GetAllJanitor(taskModel: null));
    }
  }

  FutureOr<void> _mappedHostDetailsDatas(
      GetHostDetailsData event, Emitter<DashboardState> state) async {
    try {
      // emit(const IotLoading(message: "Loading Host Dashboard data..."));

      String wolooid = globalStorage.getWolooId();

      final hostDetailsData =
          await dashboardService.gethostDetailsData(wolooId: wolooid);
      // debugPrint("requestId $response");

      emit(HostDetailsSuccess(hostDetailsHome: hostDetailsData));
    } catch (e) {
      //emit(DashboardError(error: e.toString()));
    }
  }

  FutureOr<void> _mapAllFacilityState(
      GetAllFacilityEvent event, Emitter<DashboardState> emit) async {
    try {
      emit(const DashboarLoading(message: "Loading..."));

      var response = await dashboardService.getFacility(
        clientId: event.clientId,
        clusterId: event.clusterId,
      );

      print("in bloac inr $response");

      emit(GetAllFacility(facilityModel: response));
    } catch (e) {
      print("object in bloc $e");
      emit(DashboarError(error: e.toString()));
    }
  }

  FutureOr<void> _mapGetClientState(
      ClientEvent event, Emitter<DashboardState> emit) async {
    try {
      emit(const DashboarLoading(message: "Loading..."));

      var response = await dashboardService.getClient(id: event.id);

      GlobalStorage globalStorage = GetIt.instance();
      globalStorage.saveClientId(
          accessClientId: response.results!.client!.value.toString());

      debugPrint("requestId $response");
      //  = response;

      emit(GetClient(client: response
          // subscriptionModel:  response,
          ));
    } catch (e) {
      emit(DashboarError(error: e.toString()));
    }
  }

  FutureOr<void> _mapCheckTaskTimeState(
      CheckTaskEvent event, Emitter<DashboardState> emit) async {
    try {
      emit(const DashboarLoading(message: "Loading..."));

      var response = await dashboardService.checkTaskTime(
        janitorId: event.janitorId,
        endTime: event.endTime,
        startTime: event.startTime,
      );

      // GlobalStorage globalStorage  = GetIt.instance();
      // globalStorage. ( accessClientId: response.results!.client!.value!.toString() );

      debugPrint("requestId $response");
      //  = response;

      emit(CheckTaskTime(
        checkTaskModel: response,
        // subscriptionModel:  response,
      ));
    } catch (e) {
      emit(DashboarError(error: e.toString()));
    }
  }

  FutureOr<void> _mapCheckSupervisorState(
      CheckSupvisorEvent event, Emitter<DashboardState> emit) async {
    try {
      emit(const DashboarLoading(message: "Loading..."));

      var response = await dashboardService.checkSuperVisor(
        id: event.id,
        // janitorId: event.janitorId
      );

      print("in bloac inr $response");

      emit(CheckSupervisor(checkSupervisorModel: response
          // deleteModel: response
          // taskModel: response
          ));
    } catch (e) {
      emit(DashboarError(error: e.toString()));
    }
  }

  FutureOr<void> _mapSupervisorListState(
      GetSupvisorListEvent event, Emitter<DashboardState> emit) async {
    try {
      emit(const DashboarLoading(message: "Loading..."));

      var response = await dashboardService.getSuperVisorList(
        roleId: event.roleId,
      );

      print("aarati in bloac inr $response");

      emit(GetSupervisor(getSupervisorModel: response));
    } catch (e) {
      // emit(DashboarError(error: e.toString()));
      emit(GetSupervisor(getSupervisorModel: null));
    }
  }

  FutureOr<void> _mapDeleteState(
      DeleteEvent event, Emitter<DashboardState> emit) async {
    try {
      emit(const DashboarLoading(message: "Loading..."));

      var response = await dashboardService.deleteTask(
        taskId: event.taskId,
        // janitorId: event.janitorId
      );

      print("in bloac inr $response");

      emit(DeltetTaskTime(deleteModel: response
          // checkSupervisorModel: response
          // taskModel: response
          ));
    } catch (e) {
      emit(DashboarError(error: e.toString()));
    }
  }

  FutureOr<void> _mapDeleteFacilityState(
      FacilityDeleteEvent event, Emitter<DashboardState> emit) async {
    try {
      emit(const DashboarLoading(message: "Loading..."));

      var response = await dashboardService.deleteFacility(
          clusterId: event.clusterId,
          facilityId: event.facilityId,
          locationId: event.locationId
          // janitorId: event.janitorId
          );

      print("in bloac inr $response");

      emit(DeltetFacility(deleteModel: response));
    } catch (e) {
      emit(DashboarError(error: e.toString()));
    }
  }

  FutureOr<void> _mapExtendExpiryState(
      ExpiryEvent event, Emitter<DashboardState> emit) async {
    try {
      emit(const DashboarLoading(message: "Loading...."));
      debugPrint("requestId$requestId");

      var response = await dashboardService.extendExpiry(
          clientId: event.clientId, days: event.days);

      // debugPrint("Namee--------- ${response.roleId}");

      // debugPrint("iddddd${response.id}");

      emit(ExtendExpiry());
    } catch (e) {
      //  print("is dio bloc  exception ${e is DioException}");
      debugPrint("debug print $e");
      emit(DashboarError(error: e.toString()));
    }
  }

  FutureOr<void> _mapPaymentStatusState(
      PaymentStatusEvent event, Emitter<DashboardState> emit) async {
    try {
      emit(const DashboarLoading(message: "Loading...."));
      debugPrint("requestId$requestId");

      var response =
          await dashboardService.paymentStatus(refranceId: event.refId
              // clientId:event.clientId,
              // days: event.days
              );

      // debugPrint("Namee--------- ${response.roleId}");

      // debugPrint("iddddd${response.id}");

      emit(PaymentStatus(paymentStatusModel: response));
    } catch (e) {
      //  print("is dio bloc  exception ${e is DioException}");
      debugPrint("debug print $e");
      emit(DashboarError(error: e.toString()));
    }
  }

  FutureOr<void> _mapFacilityByJanitorState(
      FacilityByJanitorEvent event, Emitter<DashboardState> emit) async {
    try {
      emit(const DashboarLoading(message: "Loading...."));
      debugPrint("requestId$requestId");

      var response = await dashboardService.facilityByJanitor(
          // refranceId: event.refId
          clientId: event.clientId,
          facilityId: event.facilityId
          // clientId:event.clientId,
          // days: event.days
          );

      // debugPrint("Namee--------- ${response.roleId}");

      // debugPrint("iddddd${response.id}");

      emit(FacilityByJanitor(janitorModel: response));
    } catch (e) {
      //  print("is dio bloc  exception ${e is DioException}");
      debugPrint("debug print $e");
      emit(DashboarError(error: e.toString()));
    }
  }

  FutureOr<void> _mapFacilityType(
      FacilityTypeEvent event, Emitter<DashboardState> emit) async {
    try {
      emit(const DashboarLoading(message: "Loading...."));
      debugPrint("requestId$requestId");

      var response = await dashboardService.facilityType(
        clientId: event.clientId,
      );

      emit(FacilityType(facilityTypeModel: response));
    } catch (e) {
      //  print("is dio bloc  exception ${e is DioException}");
      debugPrint("debug print $e");
      emit(DashboarError(error: e.toString()));
    }
  }

  FutureOr<void> _mapGetLanguagesState(
      GetLanguagesEvent event, Emitter<DashboardState> emit) async {
    try {
      emit(const DashboarLoading(message: "Loading...."));

      var response = await dashboardService.getLanguages();

      emit(GetLanguages(languageModel: response));
    } catch (e) {
      debugPrint("debug print $e");
      emit(DashboarError(error: e.toString()));
    }
  }

  Future<void> _onSubmitClientSetup(
    SubmitClientFullSetupEvent event,
    Emitter<DashboardState> emit,
  ) async {
    emit(const DashboarLoading(message: "Loading...."));

    try {
      final response = await dashboardService.clientFullSetup(event.request);
      emit(ClientSetupSuccess(response));
    } catch (e) {
      debugPrint("debug print $e");
      emit(DashboarError(error: e.toString()));
    }
  }
}
