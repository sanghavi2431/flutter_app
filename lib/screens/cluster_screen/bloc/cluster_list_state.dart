
import 'package:woloo_smart_hygiene/core/network/failure.dart';
import 'package:equatable/equatable.dart';
import 'package:woloo_smart_hygiene/screens/cluster_screen/data/model/cluster_model.dart';

abstract class ClusterListState extends Equatable {
  const ClusterListState();
}

class ClusterListInitial extends ClusterListState {
  @override
  List<Object> get props => [];
}

class ClusterListLoading extends ClusterListState {
  @override
  List<Object> get props => [];
}

class ClusterListSuccess extends ClusterListState {
  final List<ClusterModel> data;

  const ClusterListSuccess({required this.data});

  @override
  List<Object?> get props => [data];
}

class ClusterListError extends ClusterListState {
  final Failure error;
  const ClusterListError({required this.error});

  @override
  List<Object> get props => [error];
}
