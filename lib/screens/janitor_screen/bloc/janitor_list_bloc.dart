import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:woloo_smart_hygiene/screens/janitor_screen/bloc/janitor_list_event.dart';
import 'package:woloo_smart_hygiene/screens/janitor_screen/bloc/janitor_list_state.dart';
import 'package:woloo_smart_hygiene/screens/janitor_screen/data/model/janitor_list_model.dart';
import 'package:woloo_smart_hygiene/screens/janitor_screen/data/netwrok/janitor_list_service.dart';

import '../../../core/network/error_handler.dart';

class JanitorListBloc extends Bloc<JanitorsListEvent, JanitorListState> {
  final JanitorListService janitorListService =
      JanitorListService(dio: GetIt.instance());
  List<JanitorListModel> data = [];
  String? clusterId;
  bool isJanitorRemoved = false;

  JanitorListBloc() : super(JanitorListInitial()) {
    on<JanitorsListEvent>((event, emit) {});
    on<GetAllJanitors>(_mapGetAllJanitorToState);
    on<ReassignTask>(_mapGetReAssignTaskToState);
  }

  FutureOr<void> _mapGetAllJanitorToState(
      GetAllJanitors event, Emitter<JanitorListState> emit) async {
    try {
      emit(JanitorListLoading());
      data =
          await janitorListService.getAllJanitors(clusterId: event.clusterId,
           endDate: event.endDate,
           startDate: event.startDate
          );
      clusterId = event.clusterId!;
      emit(JanitorListSuccess(data: data, fromReassign: false ));
    } catch (e) {
      emit(JanitorListError(error: ErrorHandler.handle(e).failure ));
    }
  }

  FutureOr<void> _mapGetReAssignTaskToState(
      ReassignTask event, Emitter<JanitorListState> emit) async {
    try {
      emit(const ReassignTaskLoading(message: "Loading Please Wait..."));
            debugPrint(" reassign janitor id ${event.janitorId}");
      debugPrint(" reassign ${event.id }");
      await janitorListService.reAssignTaskToJanitor(
          id: event.id, janitorId: event.janitorId , isRejected: event.isRejected!);
      data = await janitorListService.getAllJanitors(clusterId: clusterId);

      data.removeWhere((janitor) => janitor.id == event.janitorId);

      emit( const ReassignTaskSuccessful());
      emit(JanitorListSuccess(data: data, fromReassign: event.fromReassign!));
     
    
    } catch (e) {
      emit(ReassignTaskError(error: ErrorHandler.handle(e).failure  ));
    }
  }
}
