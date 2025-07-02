import 'dart:async';

// import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:woloo_smart_hygiene/screens/choose_facility_screen/bloc/facility_list_event.dart';
import 'package:woloo_smart_hygiene/screens/choose_facility_screen/bloc/facility_list_state.dart';
import 'package:woloo_smart_hygiene/screens/choose_facility_screen/data/network/facility_list_service.dart';

import '../../../core/network/error_handler.dart';


class FacilityListBloc extends Bloc<FacilityListEvent, FacilityListState> {
  final FacilityListService facilityListService =
      FacilityListService(dio: GetIt.instance());

  FacilityListBloc() : super(FacilityListInitial()) {
    on<FacilityListEvent>((event, emit) {});
    on<GetAllFacility>(_mapGetAllFacilityToState);


  }

  FutureOr<void> _mapGetAllFacilityToState(
      GetAllFacility event, Emitter<FacilityListState> emit) async {
    try {
      emit(FacilityListLoading());
      var data =
          await facilityListService.getAllFacility(janitorId: event.janitorId);

      emit(FacilityListSuccess(data: data));
    } catch (e) {
      emit(FacilityListError(error: ErrorHandler.handle(e).failure ));
    }
  }

   // bool selectAll = false;
  // bool isDisabled = false;
  // String  janitorName = "";

 

}
