import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:Woloo_Smart_hygiene/screens/cluster_screen/bloc/cluster_list_event.dart';
import 'package:Woloo_Smart_hygiene/screens/cluster_screen/bloc/cluster_list_state.dart';
import 'package:Woloo_Smart_hygiene/screens/cluster_screen/data/network/cluster_list_service.dart';

import '../../../core/network/error_handler.dart';

class ClusterListBloc extends Bloc<ClusterListEvent, ClusterListState> {
  final ClusterListService clusterListService =
      ClusterListService(dio: GetIt.instance());

  ClusterListBloc() : super(ClusterListInitial()) {
    on<ClusterListEvent>((event, emit) {});
    on<GetAllClusters>(_mapGetAllClusterToState);
  }

  FutureOr<void> _mapGetAllClusterToState(
      GetAllClusters event, Emitter<ClusterListState> emit) async {
    try {
      emit(ClusterListLoading());
      var data = await clusterListService.getAllCluster();

       print("sds $data");
      emit(ClusterListSuccess(data: data));
    } catch (e) {
      emit(ClusterListError(error: ErrorHandler.handle(e).failure   ));
    }
  }
}
