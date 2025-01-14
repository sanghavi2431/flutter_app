import 'dart:math';

import 'package:Woloo_Smart_hygiene/core/network/failure.dart';
import 'package:Woloo_Smart_hygiene/screens/janitor_screen/data/model/Janitor_list_model.dart';
import 'package:Woloo_Smart_hygiene/screens/supervisor_dashboard/model/Supervisor_model_dashboard.dart';
import 'package:equatable/equatable.dart';

abstract class SupervisorDashboardState extends Equatable {
  const SupervisorDashboardState();
}

class SupervisorDashboardInitial extends SupervisorDashboardState {
  @override
  List<Object> get props => [];
}

class SupervisorDashboardLoading extends SupervisorDashboardState {
  @override
  List<Object> get props => [];
}

class GetSupervisorDashboardDataSuccess extends SupervisorDashboardState {
  final List<SupervisorModelDashboard> data;

  const GetSupervisorDashboardDataSuccess({required this.data});

  @override
  List<Object?> get props => [data, Random().nextInt(100)];
}

class SupervisorDashboardError extends SupervisorDashboardState {
  final Failure error;
  const SupervisorDashboardError({required this.error});

  @override
  List<Object> get props => [error];
}

class SupervisorUpdateStatusLoading extends SupervisorDashboardState {
  final String message;
  const SupervisorUpdateStatusLoading({required this.message});

  @override
  List<Object> get props => [Random().nextInt(100)];
}

class SupervisorUpdateStatusSuccessful extends SupervisorDashboardState {
  @override
  List<Object> get props => [];
}

class SupervisorUpdateStatusError extends SupervisorDashboardState {
  final Failure error;
  const SupervisorUpdateStatusError({required this.error});

  @override
  List<Object> get props => [error];
}

class AssignTaskLoading extends SupervisorDashboardState {
  final String message;
  const AssignTaskLoading({required this.message});

  @override
  List<Object> get props => [Random().nextInt(100)];
}

class AssignTaskSuccessful extends SupervisorDashboardState {
  final List<JanitorListModel> data;
  AssignTaskSuccessful({required this.data});
  @override
  List<Object> get props => [data];
}

class AssignTaskError extends SupervisorDashboardState {
  final Failure error;
  const AssignTaskError({required this.error});

  @override
  List<Object> get props => [error];
}
