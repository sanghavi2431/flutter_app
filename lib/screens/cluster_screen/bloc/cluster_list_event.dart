
import 'package:equatable/equatable.dart';

abstract class ClusterListEvent extends Equatable {
  const ClusterListEvent();
}

class GetAllClusters extends ClusterListEvent {
  const GetAllClusters();

  @override
  List<Object?> get props => [];
}
