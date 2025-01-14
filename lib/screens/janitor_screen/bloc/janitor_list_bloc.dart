import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:Woloo_Smart_hygiene/screens/janitor_screen/bloc/janitor_list_event.dart';
import 'package:Woloo_Smart_hygiene/screens/janitor_screen/bloc/janitor_list_state.dart';
import 'package:Woloo_Smart_hygiene/screens/janitor_screen/data/model/Janitor_list_model.dart';
import 'package:Woloo_Smart_hygiene/screens/janitor_screen/data/netwrok/janitor_list_service.dart';

import '../../../core/network/error_handler.dart';

class JanitorListBloc extends Bloc<JanitorsListEvent, JanitorListState> {
  final JanitorListService janitorListService =
      JanitorListService(dio: GetIt.instance());
  List<JanitorListModel> data = [];
  var clusterId;
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
          await janitorListService.getAllJanitors(clusterId: event.cluster_id,
           endDate: event.endDate,
           startDate: event.startDate
          );
      clusterId = event.cluster_id;
      emit(JanitorListSuccess(data: data, fromReassign: false ));
    } catch (e) {
      emit(JanitorListError(error: ErrorHandler.handle(e).failure ));
    }
  }

  FutureOr<void> _mapGetReAssignTaskToState(
      ReassignTask event, Emitter<JanitorListState> emit) async {
    try {
      emit(ReassignTaskLoading(message: "Loading Please Wait..."));
            print(" reassign janitor id ${event.janitor_id}");
                 print(" reassign ${event.id }");
      await janitorListService.reAssignTaskToJanitor(
          id: event.id, janitor_id: event.janitor_id , isRejected: event.isRejected!);
      data = await janitorListService.getAllJanitors(clusterId: clusterId);
         print(" jaintors  id ${event.janitor_id}");

      data.removeWhere((janitor) => janitor.id == event.janitor_id);

      emit(ReassignTaskSuccessful());
      emit(JanitorListSuccess(data: data, fromReassign: event.fromReassign!));
     
    
    } catch (e) {
      emit(ReassignTaskError(error: ErrorHandler.handle(e).failure  ));
    }
  }
}
