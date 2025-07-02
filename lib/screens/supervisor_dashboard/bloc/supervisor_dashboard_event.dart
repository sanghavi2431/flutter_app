import 'dart:math';

import 'package:equatable/equatable.dart';

abstract class SupervisorDashboardEvent extends Equatable {
  const SupervisorDashboardEvent();
}

class GetSupervisorDashboardData extends SupervisorDashboardEvent {
  const GetSupervisorDashboardData();

  @override
  List<Object?> get props => [Random().nextInt(100)];
}

class SupervisorUpdateStatus extends SupervisorDashboardEvent {
  final String id;
  final int status;
  const SupervisorUpdateStatus({required this.id, required this.status});

  @override
  List<Object?> get props => [id, status, Random().nextInt(100)];
}

class AssignTask extends SupervisorDashboardEvent {
  final List<String> id;
  final String janitorId;

  const AssignTask({
    required this.id,
    required this.janitorId,
  });

  @override
  List<Object?> get props => [id, janitorId, Random().nextInt(100)];
}
