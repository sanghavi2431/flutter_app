





import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:woloo_smart_hygiene/core/local/global_storage.dart';


import '../../../../core/network/error_handler.dart';

import '../data/network/dashboard_service.dart';
import 'dashboard_event.dart';
import 'dashboard_state.dart';

class ClientDashBoardBloc extends Bloc<DashboardEvent, DashboardState> {
  final DashboardService dashboardService = DashboardService(dio: GetIt.instance());
  var requestId = '';
  late int roleId;
  late int janitorId;
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
    on<DeleteEvent>(_mapDeleteState);
    on<FacilityDeleteEvent>(_mapDeleteFacilityState);
    on<ExpiryEvent>(_mapExtendExpiryState);
    on<PaymentStatusEvent>(_mapPaymentStatusState);
    on<FacilityByJanitorEvent>(_mapFacilityByJanitorState);

   // on<UpdateTokenOnVerifyOTP>(mapUpdateTokenToState);
  }


  FutureOr<void> _mapClientSetupToState(
      ClientSetUpEvent event, Emitter<DashboardState> emit) async {
    try {
      emit(const DashboarLoading(message: "Loading..."));


       print("print locality ${event.locality} ");
           

      var response =
          await dashboardService.clientSetup(
               orgName: event.orgName,
               locality: event.locality,
               unitNo: event.locality,
               clientId: event.clientId!,
               pincode: event.pincode,
               address: event.address!,
               city: event.city,
               faciltyType: event.facilityType,
               mobile: event.mobile


            );
      debugPrint("requestId $response");
      // requestId = response;


      // debugPrint("requestId $requestId");
      emit(ClientSetUp(
        clientSetupModel: response
       ));
    } catch (e) {
      emit(DashboarError(error:  e.toString() ));
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
          isSelfAssign: event.isSelfAssign
      );

      // debugPrint("requestId $response");
      // requestId = response;


      // debugPrint("requestId $requestId");
      emit(AddUser());
    } catch (e) {
      emit(DashboarError(error:    e.toString()));
    }
  }

    FutureOr<void> _mapAddJanitorState(
      AddJanitorEvent event, Emitter<DashboardState> emit) async {
    try {
      emit(const DashboarLoading(message: "Loading..."));

      var response =
      await dashboardService.addUser(
          name: event.name,
          mobile: event.mobile,
          roleId: event.roleId,
          clientId: event.clientId!,
          gender: event.gender,
          clusterId: event.clusterId,
      );

      // debugPrint("requestId $response");
      // requestId = response;


      // debugPrint("requestId $requestId");
      emit(Addjanitor(
        superVisorModel: response
      ));
    } catch (e) {
      emit(DashboarError(error:   e.toString() ));
    }
  }


  FutureOr<void> _mapGetTaskState(
      GetTaskEvent event, Emitter<DashboardState> emit) async {
    try {
      emit(const DashboarLoading(message: "Loading..."));

      var response =
        await dashboardService.getTask(category: event.category! );
      debugPrint("requestId $response");
      response;


      emit(GetTask(
         tasklist: response
      ));
    } catch (e) {
      emit(DashboarError(error:  e.toString() ));
    }
  }




  
    FutureOr<void> _mapDashboardTaskState(
      GetDashbaordEvent event, Emitter<DashboardState> emit) async {
    try {
      emit(const DashboarLoading(message: "Loading..."));

      var response =
      await dashboardService.getTaskDashboard(
           clientId: event.clientId,
           type: event.type,
           facilityId: event.locationId,
          janitorId:event.janitorId

      );

      debugPrint("requestId $response");
      //  = response;


      emit(DashbaordTask(
       dashbaordModel: response,
      ));

    } catch (e) {
      emit(DashboarError(error:    e.toString()));
    }
  }



  FutureOr<void> _mapSubcriptionState(
      SubcriptionEvent event, Emitter<DashboardState> emit) async {
    try {
      emit(const DashboarLoading(message: "Loading..."));

      var response =
      await dashboardService.getSubscriptionExpiry(
         id: event.id
      );


      GlobalStorage globalStorage  = GetIt.instance();

       print("in plamn inr ${  response.results!.planId}");
       
      globalStorage.savePlanId(  accessPlanId: response.results!.planId == null ?  "0" : response.results!.planId!.toString() );

      debugPrint("requestId $response");
      //  = response;


      emit(Subcription(
        subscriptionModel: response,
      ));

    } catch (e) {
      emit(DashboarError(error:    e.toString() ));
    }
  }




  FutureOr<void> _mapAssignTaskState(
      AssignTaskEvent event, Emitter<DashboardState> emit) async {
    try {
      emit(const DashboarLoading(message: "Loading..."));

      var response =
      await
      dashboardService.assignTask(
       clientId: event.clientId,
        estimatedTime: event.estimatedTime,
        shiftTime: event.shiftTime,
        taskIds: event.taskIds,
        taskTimes: event.taskTimes,
        janitorId: event.janitorId,
         facilityRef: event.facilityRef!,
         facilityId: event.facilityId
      );

      // debugPrint("requestId $response");
      // requestId = response;


      // debugPrint("requestId $requestId");
      emit(AssignTask());
    } catch (e) {
      emit(DashboarError(error:   e.toString() ));
    }
  }


   

  FutureOr<void> _mapAllJanitorState(
      GetAllJanitorEvent event, Emitter<DashboardState> emit) async {
    try {
      emit(const DashboarLoading(message: "Loading..."));

      var response =
      await
      dashboardService.getAllJanitor(
        clientId: event.clientId,
        // janitorId: event.janitorId
      );

       print("in bloac inr $response");
     
      emit(GetAllJanitor(
        taskModel: response
      ));

    } catch (e) {
      emit(DashboarError(error:    e.toString() ));
    }
  }

    FutureOr<void> _mapAllFacilityState(
      GetAllFacilityEvent event, Emitter<DashboardState> emit) async {
    try {
      emit(const DashboarLoading(message: "Loading..."));

      var response =
      await
      dashboardService.getFacility(
        clientId: event.clientId,
        // janitorId: event.janitorId
      );

       print("in bloac inr $response");
     
      emit(GetAllFacility(
         facilityModel: response
      ));

    } catch (e) {
        print("object in bloc $e");
      emit(DashboarError(error:   e.toString() ));
    }
  }




    FutureOr<void> _mapGetClientState(
      ClientEvent event, Emitter<DashboardState> emit) async {
    try {
      emit(const DashboarLoading(message: "Loading..."));

      var response =
      await dashboardService.getClient(
         id: event.id
      );


          GlobalStorage globalStorage  = GetIt.instance();
      globalStorage.saveClientId( accessClientId: response.results!.client!.value.toString() );
          
   

      debugPrint("requestId $response");
      //  = response;


      emit(GetClient(
        client: response
        // subscriptionModel:  response,
      ));

    } catch (e) {
      emit(DashboarError(error:  e.toString() ));
    }
  }


    FutureOr<void> _mapCheckTaskTimeState(
      CheckTaskEvent event, Emitter<DashboardState> emit) async {
    try {
      emit(const DashboarLoading(message: "Loading..."));

      var response =
      await dashboardService.checkTaskTime(
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
      emit(DashboarError(error:    e.toString() ));
    }
  }



   FutureOr<void> _mapCheckSupervisorState(
      CheckSupvisorEvent event, Emitter<DashboardState> emit) async {
    try {
      emit(const DashboarLoading(message: "Loading..."));

      var response =
      await
      dashboardService.checkSuperVisor(
         id: event.id,
        // janitorId: event.janitorId
      );

       print("in bloac inr $response");
     
      emit(
        CheckSupervisor(
          checkSupervisorModel: response
          // deleteModel: response
        // taskModel: response
      )
      );

    } catch (e) {
      emit(DashboarError(error:   e.toString() ));
    }
  }




     FutureOr<void> _mapDeleteState(
      DeleteEvent event, Emitter<DashboardState> emit) async {
    try {
      emit(const DashboarLoading(message: "Loading..."));

      var response =
      await
      dashboardService.deleteTask(
         taskId: event.taskId,
        // janitorId: event.janitorId
      );

       print("in bloac inr $response");
     
      emit(
        DeltetTaskTime(
          deleteModel: response
          // checkSupervisorModel: response
        // taskModel: response
      )
      );

    } catch (e) {
      emit(DashboarError(error:   e.toString() ));
    }
  }


       FutureOr<void> _mapDeleteFacilityState(
      FacilityDeleteEvent event, Emitter<DashboardState> emit) async {
    try {
      emit(const DashboarLoading(message: "Loading..."));

      var response =
      await
      dashboardService.deleteFacility(
          clusterId: event.clusterId,
          facilityId: event.facilityId,
          locationId: event.locationId
        // janitorId: event.janitorId
      );

       print("in bloac inr $response");
     
      emit(
        DeltetFacility(
          deleteModel: response
      )
      );

    } catch (e) {
      emit(DashboarError(error:   e.toString() ));
    }
  }



  FutureOr<void> _mapExtendExpiryState(
      ExpiryEvent event, Emitter<DashboardState> emit) async {
    try {
      emit(const DashboarLoading(message: "Loading...."));
      debugPrint("requestId$requestId");

      var response =  await dashboardService.extendExpiry(   
        clientId:event.clientId,
        days: event.days 
          );
 

           

      // debugPrint("Namee--------- ${response.roleId}");

      // debugPrint("iddddd${response.id}");

      emit(ExtendExpiry());
      
    } catch (e) {
            //  print("is dio bloc  exception ${e is DioException}");
      debugPrint("debug print $e" );
      emit(DashboarError(error: e.toString()));
    }
  }




  FutureOr<void> _mapPaymentStatusState(
      PaymentStatusEvent event, Emitter<DashboardState> emit) async {
    try {
      emit(const DashboarLoading(message: "Loading...."));
      debugPrint("requestId$requestId");

      var response =
          await dashboardService.paymentStatus(   
            refranceId: event.refId
        // clientId:event.clientId,
        // days: event.days 
          );
 

           

      // debugPrint("Namee--------- ${response.roleId}");

      // debugPrint("iddddd${response.id}");

      emit(PaymentStatus(
        paymentStatusModel: response
      ));
    } catch (e) {
            //  print("is dio bloc  exception ${e is DioException}");
      debugPrint("debug print $e" );
      emit(DashboarError(error: e.toString()));
    }
    
  }


    FutureOr<void> _mapFacilityByJanitorState(
      FacilityByJanitorEvent event, Emitter<DashboardState> emit) async {
    try {
      emit(const DashboarLoading(message: "Loading...."));
      debugPrint("requestId$requestId");

      var response =
          await dashboardService.facilityByJanitor(   
            // refranceId: event.refId
            clientId: event.clientId,
            facilityId: event.facilityId
        // clientId:event.clientId,
        // days: event.days 
          );
 

           

      // debugPrint("Namee--------- ${response.roleId}");

      // debugPrint("iddddd${response.id}");

      emit(FacilityByJanitor(
        janitorModel: response
      ));
    } catch (e) {
            //  print("is dio bloc  exception ${e is DioException}");
      debugPrint("debug print $e" );
      emit(DashboarError(error: e.toString()));
    }
  }







}
